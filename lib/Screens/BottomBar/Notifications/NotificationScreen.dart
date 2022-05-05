import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Components/LiveDot.dart';
import 'package:oneflix/Constants.dart';
import 'package:oneflix/Screens/BottomBar/Home/PostContentScreen.dart';
import 'package:oneflix/Screens/BottomBar/Profile/UserViewScreen.dart';
import 'package:oneflix/Screens/BottomBar/Profile/VisitorViewScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../MainHomeScreen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _loading = false;
  List notificationList = [];
  String? userToken;

  @override
  void initState() {
    requestLocationPermission();
    getToken();
    super.initState();
  }

  String getTimezone(String date) {
    var dates = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
    return timeago.format(dates);
  }

  getToken() async {
    setState(() {
      _loading = true;
    });
    var user_token = await readData('user_token');

    setState(() {
      userToken = user_token;
    });
    await _getNotifications();
  }

  _getNotifications() async {
    var jsonData;
    try {
      var response = await Dio().post(
        GET_NOTIFICATIONS,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
      );
      print(response);
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            notificationList = jsonData['data'];
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

  _updateNotification(int notifyId) async {
    var jsonData;

    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        UPDATE_NOTIFICATION,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'notification_id': notifyId},
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          _getNotifications();
          setState(() {
            notificationCount = notificationCount - 1;
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

  _followUser(int followId) async {
    var jsonData;

    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        FOLLOW_USER,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'follow_to': followId},
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          _getNotifications();
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

  follow(var notificationBy) async {
    await _followUser(notificationBy);
    await _updateNotification(notificationBy);
  }

  bool pushNotificationPermission = false;
  Map<Permission, PermissionStatus>? statuses;
  Future<void> requestLocationPermission() async {
    pushNotificationPermission = await Permission.notification.isGranted;
    setState(() {});
    print(pushNotificationPermission);
    print('pushNotificationPermission');
    statuses = await [Permission.notification].request();
    print(statuses);
    print('statuses');
    setState(() {
      if (statuses![Permission.notification]!.isGranted) {
        pushNotificationPermission = true;
      } else if (statuses![Permission.notification]!.isDenied) {
        pushNotificationPermission = false;
      } else if (statuses![Permission.notification]!.isPermanentlyDenied) {
        pushNotificationPermission = false;
        // openAppSettings();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      progressIndicator: SizedBox(width: 20, height: 20, child: kProgressIndicator),
      opacity: 0,
      child: Scaffold(
        backgroundColor: Color(0xff011138),
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Color(0xff011138),
          title: Text(
            'NOTIFICATIONS',
            style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
          ),
        ),
        body: notificationList.isEmpty && _loading == false
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: AppText(
                        'You don’t have any new notifications yet',
                        color: Color(0xff494949),
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        pushNotificationPermission == false
                            ? GestureDetector(
                                onTap: () {
                                  openAppSettings();
                                },
                                child: Container(
                                    width: MediaQuery.of(context).size.width - 60,
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 0.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 0.0),
                                              child: Image.asset('assets/icons/Backup Notification.png', fit: BoxFit.cover),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                              )
                            : Container(),
                        SizedBox(height: 15),
                        ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: notificationList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              children: [
                                Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (notificationList[index]['notification_to'] != notificationList[index]['notification_by']) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => VisitorViewScreen(userID: notificationList[index]['notification_by']),
                                                    ),
                                                  );
                                                } else {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => UserViewScreen(userId: notificationList[index]['notification_by']),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(40),
                                                child: CachedImage(
                                                    imageUrl: "$BASE_URL/${notificationList[index]['profile_pic']}", isUserProfilePic: true, height: 60, width: 60, loaderSize: 10),
                                              ),
                                            ),
                                            SizedBox(width: 10.0),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 6),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: '${notificationList[index]['full_name'].toString()} ',
                                                                style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                                                recognizer: TapGestureRecognizer()
                                                                  ..onTap = () {
                                                                    if (notificationList[index]['notification_to'] != notificationList[index]['notification_by']) {
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) => VisitorViewScreen(userID: notificationList[index]['notification_by']),
                                                                        ),
                                                                      );
                                                                    } else {
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) => UserViewScreen(userId: notificationList[index]['notification_by']),
                                                                        ),
                                                                      );
                                                                    }
                                                                  },
                                                              ),
                                                              TextSpan(
                                                                text: '${notificationList[index]['notification_text'].toString()} ',
                                                                style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors.black,
                                                                  fontFamily: 'Roboto',
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: notificationList[index]['content_title'] == null ? '' : notificationList[index]['content_title'].toString(),
                                                                style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                                              ),
                                                              TextSpan(
                                                                text: notificationList[index]['notification_type'] == 6 ? ' to you' : '',
                                                                style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: 'Roboto'),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      // SizedBox(width: 5),
                                                      // Expanded(
                                                      //   child: Text(
                                                      //     notificationList[index]['notification_text'].toString(),
                                                      //     style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: 'Roboto'),
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text((getTimezone(notificationList[index]['created_at'])), style: TextStyle(fontSize: 10, color: Colors.black, fontFamily: 'Roboto')),

                                          // Text(
                                          //   DateFormat('KK:mm a').format(DateTime.parse(notificationList[index]['created_at']).toLocal()),
                                          //   style: TextStyle(fontSize: 13, color: Colors.white, fontFamily: 'OpenSans'),
                                          // ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                _updateNotification(notificationList[index]['notification_id']);
                                              },
                                              child: Container(
                                                color: Color(0xffeaeef7),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                                  child: AppText(
                                                    'Clear',
                                                    textAlign: TextAlign.center,
                                                    fontSize: 16,
                                                    color: Color(0xff4a4a4a),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () async {
                                                // notification_types>>>>>> 1=follow, 2=comment tagged, 3=signup, 4=reacted, 5=comment, 6=recommended
                                                if (notificationList[index]['notification_type'] == 1 || notificationList[index]['notification_type'] == 3) {
                                                  await _followUser(notificationList[index]['notification_by']);
                                                  await _updateNotification(notificationList[index]['notification_id']);
                                                } else if (notificationList[index]['notification_type'] == 2 ||
                                                    notificationList[index]['notification_type'] == 4 ||
                                                    notificationList[index]['notification_type'] == 5 ||
                                                    notificationList[index]['notification_type'] == 6) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => PostContentScreen(
                                                        contentID: notificationList[index]['content_id'],
                                                        contentTPId: notificationList[index]['content_third_party_id'],
                                                        contentType: notificationList[index]['content_type'],
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(color: Color(0xff34adf9)),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                                  child: AppText(
                                                    notificationList[index]['notification_type'] == 1 && notificationList[index]['is_follow'] == 0
                                                        ? "Follow Back"
                                                        : notificationList[index]['notification_type'] == 1 && notificationList[index]['is_follow'] == 1
                                                            ? "Following"
                                                            : notificationList[index]['notification_type'] == 3
                                                                ? 'Follow'
                                                                : 'View',
                                                    textAlign: TextAlign.center,
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                notificationList[index]['notification_type'] == 3 || notificationList[index]['notification_type'] == 1
                                    ? Positioned(
                                        right: 10,
                                        top: 35,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Image.asset(
                                              'assets/icons/Congratulations Icon.png',
                                              fit: BoxFit.cover,
                                              height: 40,
                                              width: 40,
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 14);
                          },
                        ),
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
      ),
    );
  }
}
