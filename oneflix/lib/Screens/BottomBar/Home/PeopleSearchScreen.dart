import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Components/LiveDot.dart';
import 'package:oneflix/Screens/BottomBar/Profile/UserViewScreen.dart';
import 'package:oneflix/Screens/BottomBar/Profile/VisitorViewScreen.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Constants.dart';

class PeopleSearchScreen extends StatefulWidget {
  const PeopleSearchScreen({Key? key}) : super(key: key);

  @override
  _PeopleSearchScreenState createState() => _PeopleSearchScreenState();
}

class _PeopleSearchScreenState extends State<PeopleSearchScreen> {
  TextEditingController search = new TextEditingController();

  @override
  void initState() {
    getToken();
    search.addListener(_onPeopleSearch);
    super.initState();
  }

  @override
  void dispose() {
    search.removeListener(_onPeopleSearch);
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2C3142),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.pop(context);
          },
          child: Icon(Icons.chevron_left, color: Colors.white, size: 45),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  color: Color(0xff2C3142),
                  child: CustomTextField1(
                    textAlign: TextAlign.center,
                    hintText: 'Find your friends',
                    controller: search,
                    hintStyle: TextStyle(color: Color(0xff494949), fontFamily: 'OpenSans', fontSize: 17, fontWeight: FontWeight.bold),
                    input: TextInputType.text,
                  ),
                ),
                userList.isNotEmpty
                    ? Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            SizedBox(height: 10),
                            ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: userList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VisitorViewScreen(userID: userList[index]['id']),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(40),
                                          child:
                                              CachedImage(imageUrl: "$BASE_URL/${userList[index]['profile_pic']}", isUserProfilePic: true, height: 46, width: 46, loaderSize: 10),
                                        ),
                                        Column(
                                          children: [
                                            AppText(userList[index]['full_name'], color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16, textAlign: TextAlign.center),
                                            AppText('@${userList[index]['username']}', color: Colors.black, fontSize: 16, textAlign: TextAlign.center),
                                          ],
                                        ),
                                        SizedBox(width: 40),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Divider(color: Colors.black);
                              },
                            ),
                            userList.isNotEmpty ? Divider(color: Colors.black) : Container(),
                          ],
                        ),
                      )
                    : (userList.isEmpty && search.text.length != 0)
                        ? Expanded(
                            child: ListView(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                AppText(
                                  'No results found. Invite more friends to join you on Oneflix.',
                                  color: Color(0xff494949),
                                  fontWeight: FontWeight.bold,
                                  textAlign: TextAlign.center,
                                  fontSize: 18,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 2), borderRadius: BorderRadius.circular(12)),
                                  child: AlertBox(
                                    buttonText: 'INVITE YOUR FRIENDS',
                                    description:
                                        'Oneflix is better with your friends. Invite your friends to Oneflix so you can discover what they\'re streaming and recommend content to each other.',
                                    descFontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    onTap: () {
                                      Share.share('Join me on Oneflix to share and discuss the best content on streaming. https://oneflix.app/');
                                    },
                                    child: Image.asset('assets/images/Oneflix Social.png', fit: BoxFit.cover),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/Discover.png',
                                  scale: 5,
                                ),
                                SizedBox(height: 30),
                                AppText(
                                  'Find Your friends on Oneflix so you can can discover what they\'re streaming and recommend content to each other ',
                                  color: Color(0xff494949),
                                  fontWeight: FontWeight.bold,
                                  textAlign: TextAlign.center,
                                  fontSize: 18,
                                ),
                              ],
                            ),
                          )
              ],
            ),
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
    );
  }

  _onPeopleSearch() {
    Timer? _debounce;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (search.text.length != 0) {
        await _peopleSearch(search.text.replaceAll(" ", "%20"));
      }
    });
  }

  String? userToken;
  getToken() async {
    var token = await readData('user_token');
    setState(() {
      userToken = token;
    });
  }

  List userList = [];
  _peopleSearch(String searchText) async {
    var jsonData;

    try {
      var response = await Dio().post(
        USER_SEARCH,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'username': searchText},
      );
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData != null) {
          if (!mounted) return;
          setState(() {
            userList = [];
            userList = jsonData['data'];
          });
        }
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }
}
