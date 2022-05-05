import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Components/LiveDot.dart';
import 'package:oneflix/Constants.dart';
import 'VisitorViewScreen.dart';

class FollowListScreen extends StatefulWidget {
  final String title;
  final userid;
  final flag;
  const FollowListScreen({Key? key, this.title = '', this.userid, this.flag}) : super(key: key);

  @override
  _FollowListScreenState createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen> {
  var followerlist = [];
  bool _loading = false;
  _Followerlist() async {
    await getToken();
    var jsonData;
    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        GET_FOLLOW_USER_LIST,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {
          'user_id': widget.userid,
          'type': widget.flag,
        },
      );
      print(response);

      if (response.statusCode == 200) {
        setState(() {
          _loading = false;
        });
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            followerlist = jsonData['data'];
          });
          print("followerlist $followerlist");
        } else {}
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }

  var userToken;

  getToken() async {
    var user_token = await readData('user_token');
    setState(() {
      userToken = user_token;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.userid);
    print("widget.userid");
    _Followerlist();
  }

  @override
  Widget build(BuildContext context) {
    double mHeight = MediaQuery.of(context).size.height;
    double mWidth = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: _loading,
      progressIndicator: SizedBox(height: 20, width: 20, child: kProgressIndicator),
      opacity: 0,
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
                    AppText(widget.title.toUpperCase(), fontSize: 22, fontWeight: FontWeight.w900),
                  ],
                ),
                SizedBox(height: 36),
                followerlist.isEmpty ? Container() : Divider(color: Colors.white),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: followerlist.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => VisitorViewScreen(userID: followerlist[index]['id'])),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: CachedImage(imageUrl: "$BASE_URL/${followerlist[index]['profile_pic']}", isUserProfilePic: true, height: 45, width: 45, loaderSize: 10)),
                            SizedBox(width: mWidth * 0.10),
                            Align(alignment: Alignment.centerLeft, child: AppText('${followerlist[index]['full_name']}', color: Colors.white, textAlign: TextAlign.left)),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(color: Colors.white);
                  },
                ),
                followerlist.isEmpty ? Container() : Divider(color: Colors.white),
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
}
