import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Components/LiveDot.dart';
import 'package:oneflix/Constants.dart';
import 'package:oneflix/Screens/BottomBar/Profile/FollowListScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'MoreSettingsScreen.dart';

class UserViewScreen extends StatefulWidget {
  final int userId;

  UserViewScreen({required this.userId});
  @override
  _UserViewScreenState createState() => _UserViewScreenState();
}

class _UserViewScreenState extends State<UserViewScreen> {
  @override
  void initState() {
    getToken();
    // requestNotificationPermission();
    super.initState();
  }

  bool notificationPermission = false;
  Map<Permission, PermissionStatus>? statuses;

  Future<void> requestNotificationPermission() async {
    notificationPermission = await Permission.notification.isGranted;
    setState(() {});
    print(notificationPermission);
    statuses = await [Permission.notification].request();
    setState(() {
      if (statuses![Permission.notification]!.isGranted) {
        notificationPermission = true;
      } else if (statuses![Permission.notification]!.isDenied) {
        notificationPermission = false;
      } else if (statuses![Permission.notification]!.isPermanentlyDenied) {
        notificationPermission = false;
      }
    });
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff011138),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        opacity: 0,
        color: Color(0xf011138),
        progressIndicator: SizedBox(width: 20, height: 20, child: kProgressIndicator),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: userData != null
                  ? Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              // margin: EdgeInsets.symmetric(horizontal: 10),
                              width: MediaQuery.of(context).size.width,
                              color: kPrimaryColor,
                              child: Column(
                                children: [
                                  SizedBox(height: 40),
                                  Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Container(
                                        height: 126,
                                        width: 110,
                                        alignment: Alignment.topCenter,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(80),
                                          child: CachedImage(
                                              imageUrl: "$BASE_URL/${userData['profile_pic']}", isUserProfilePic: true, height: 110, width: 110, placeHolderColor: Colors.white),
                                        ),
                                      ),
                                      GestureDetector(
                                        child: Image.asset('assets/icons/camera.png', height: 40, width: 40),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MoreSettingsScreen(
                                                firstName: userData['first_name'] ?? '',
                                                lastName: userData['last_name'] ?? '',
                                                profilePic: "$BASE_URL/${userData['profile_pic']}",
                                                bio: userData['bio'] ?? '',
                                              ),
                                            ),
                                          ).then((_) {
                                            _userDetails();
                                            setState(() {});
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  AppText('${userData['first_name'] ?? ''} ${userData['last_name'] ?? ' '}', fontWeight: FontWeight.bold, fontSize: 22),
                                  AppText('@${userData['username']}', fontSize: 16),
                                  SizedBox(height: 15),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          child: AppText(
                                              '${userData['count_followers']} ${userData['count_followers'] == 1 || userData['count_followers'] == 0 ? 'Follower' : 'Followers'}',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => FollowListScreen(
                                                          title: 'Followers',
                                                          userid: userData["id"],
                                                          flag: 1,
                                                        )));
                                          },
                                        ),
                                        GestureDetector(
                                          child: AppText('${userData['count_following']} Following', fontWeight: FontWeight.bold, fontSize: 16),
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => FollowListScreen(title: 'Following', userid: userData["id"], flag: 0)));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 20,
                              left: 4,
                              child: IconButton(
                                icon: Icon(Icons.chevron_left_rounded, size: 38, color: Colors.white),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 30),
                        SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            if (userData['bio'] == null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MoreSettingsScreen(
                                    firstName: userData['first_name'] ?? '',
                                    lastName: userData['last_name'] ?? '',
                                    profilePic: "$BASE_URL/${userData['profile_pic']}",
                                    bio: userData['bio'] ?? '',
                                  ),
                                ),
                              ).then((_) {
                                _userDetails();
                                setState(() {});
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Align(
                                alignment: Alignment.centerLeft, child: AppText(userData['bio'] == null ? 'Add a bio' : userData['bio'], textAlign: TextAlign.left, fontSize: 12)),
                          ),
                        ),
                        SizedBox(height: 20),
                        Divider(color: Colors.white38),
                        SizedBox(height: 30),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            _launchInBrowser('https://oneflix.app/terms-of-service/');
                          },
                          child: AppText('Terms of Service'.toUpperCase(), fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            _launchInBrowser('https://oneflix.app/privacy-policy/');
                          },
                          child: AppText('privacy policy'.toUpperCase(), fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            _launchInBrowser('https://oneflix.app/contact/');
                          },
                          child: AppText('Contact Us'.toUpperCase(), fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton2(
                              title: 'MORE SETTINGS',
                              fontWeight: FontWeight.w900,
                              height: 50,
                              borderRadius: 10,
                              horizontalPadding: 40,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MoreSettingsScreen(
                                      firstName: userData['first_name'] ?? '',
                                      lastName: userData['last_name'] ?? '',
                                      profilePic: "$BASE_URL/${userData['profile_pic']}",
                                      bio: userData['bio'] ?? '',
                                    ),
                                  ),
                                ).then((_) {
                                  _userDetails();
                                  setState(() {});
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 18),
                      ],
                    )
                  : Container(),
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

  var userData;
  bool _loading = false;
  String? userToken;

  getToken() async {
    var user_token = await readData('user_token');
    setState(() {
      userToken = user_token;
    });
    await _userDetails();
  }

  _userDetails() async {
    var jsonData;
    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        GET_USER_PROFILE,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'user_id': widget.userId},
      );
      print(response);

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData != null) {
          if (!mounted) return;
          setState(() {
            userData = jsonData['data'];
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

class AlertBox extends StatelessWidget {
  final String description;
  final String buttonText;
  final double descFontSize;
  final FontWeight fontWeight;
  final Widget child;
  final onTap;
  final bool border;
  AlertBox({this.description = '', this.buttonText = '', required this.child, this.onTap, this.descFontSize = 16, this.fontWeight = FontWeight.w900, this.border = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(height: 8),
          Container(
            // padding: EdgeInsets.all(10),
            width: !border ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width - 6,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(color: kPrimaryColor, borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            buttonText,
                            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'OpenSans', fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      description,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: fontWeight, fontFamily: 'OpenSans', fontSize: descFontSize, color: Colors.black54, height: 1.2),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: child,
                    ),
                  )
                ],
              ),
            ),
          ),
          if (border) SizedBox(height: 8),
        ],
      ),
    );
  }
}
