import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Components/LiveDot.dart';
import 'package:oneflix/Screens/BottomBar/Profile/UserViewScreen.dart';
import 'package:oneflix/Screens/BottomBar/Profile/VisitorViewScreen.dart';
import '../../../Constants.dart';

class PostContentUserListScreen extends StatefulWidget {
  final contentThirdPartyId;
  final title;
  final loginUserId;
  final activityType;
  const PostContentUserListScreen({Key? key, this.contentThirdPartyId, this.title, this.activityType, this.loginUserId}) : super(key: key);

  @override
  _PostContentUserListScreenState createState() => _PostContentUserListScreenState();
}

class _PostContentUserListScreenState extends State<PostContentUserListScreen> {
  String? userToken;
  getToken() async {
    var user_token = await readData('user_token');
    setState(() {
      userToken = user_token;
    });
    await _getContentUserList();
  }

  @override
  void initState() {
    print(widget.contentThirdPartyId);
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mHeight = MediaQuery.of(context).size.height;
    double mWidth = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: _loading,
      opacity: 0,
      progressIndicator: SizedBox(height: 20, width: 20, child: kProgressIndicator),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor2,
          leading: IconButton(
            icon: Icon(Icons.chevron_left_rounded, size: 38),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText('${widget.title} by', fontSize: 22, fontWeight: FontWeight.w900),
                  ],
                ),
                SizedBox(height: 36),
                userList.isEmpty ? Container() : Divider(color: Colors.white),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          if (widget.loginUserId == userList[index]['activity_by']) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserViewScreen(userId: userList[index]['activity_by']),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VisitorViewScreen(userID: userList[index]['activity_by']),
                              ),
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(28.0)),
                              child: CachedImage(
                                imageUrl: '$BASE_URL/${userList[index]['profile_pic'].toString()}',
                                height: 45.0,
                                width: 45.0,
                                isUserProfilePic: true,
                              ),
                            ),
                            SizedBox(width: mWidth * 0.12),
                            AppText(userList[index]['full_name'].toString(), color: Colors.white, textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(color: Colors.white);
                  },
                ),
                userList.isEmpty ? Container() : Divider(color: Colors.white),
              ],
            ),
            Positioned(
              bottom: 1,
              right: 1,
              child: Container(
                height: 50,
                width: 165,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Color(0xff004AAD),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      '${activeUserCount ?? '0'} Users Online',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 17),
                      child: BlinkingPoint(
                        xCoor: 12,
                        yCoor: -16,
                        pointSize: 12,
                        pointColor: Color(0xff7ED957),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _loading = false;
  List userList = [];
  Future<void> _getContentUserList() async {
    var jsonData;
    print(userToken);
    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(CONTENT_RECOMMENDED_USER_LIST,
          options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
          data: {'content_third_party_id': widget.contentThirdPartyId, 'activity_type': widget.activityType});
      log(response.toString());
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            userList = jsonData['data'];
          });
        } else {
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }
}
