import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Screens/BottomBar/Trending/TrendingScreen.dart';
import 'package:oneflix/Screens/BottomBar/WatchList/WatchlistScreen.dart';

import '../../Constants.dart';
import '../../InitialData.dart';
import '../SplashScreen.dart';
import 'Discover/DiscoverScreen.dart';
import 'Home/HomeScreen.dart';
import 'Notifications/NotificationScreen.dart';
import 'Profile/UserViewScreen.dart';

int notificationCount = 0;

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 1;
  bool _loading = false;
  static const List<Widget> body = [
    HomeScreen(),
    Trending(),
    DiscoverScreen(),
    WatchlistScreen(),
    NotificationScreen(),
  ];

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    await getToken();
    await _getNotification();
    if (DeviceToken == 'null') {
      await _getDeviceToken();
    }
  }

  updateCount() async {
    socket?.emit('live_active_count');
  }

  @override
  void initState() {
    getActiveUserCount();
    Timer.periodic(Duration(seconds: 5), (Timer t) => updateCount());
    getToken();
    getDeviceData();

    super.initState();
  }

  var jsonData;
  int? userID;
  String? userToken;
  String? DeviceToken;
  getToken() async {
    var user_token = await readData('user_token');
    var user_id = await readData('user_id');
    var device_token = await readData('device_token');

    setState(() {
      userToken = user_token;
      userID = user_id;
      DeviceToken = device_token;
    });
    print(DeviceToken);
    print('DeviceToken');
    await _getNotification();
    if (DeviceToken == null) {
      await _getDeviceToken();
    }
  }

  String deviceID = '';
  String deviceToken = '';
  int? deviceType;

  getDeviceData() async {
    InitialData deviceInfo = InitialData();
    await deviceInfo.getDeviceTypeId();
    deviceID = deviceInfo.deviceID!;
    deviceType = deviceInfo.deviceType!;

    await deviceInfo.getFirebaseToken();
    deviceToken = deviceInfo.deviceToken!;
    print(deviceToken);
  }

  Future<void> _getNotification() async {
    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        GET_NOTIFICATION_COUNT,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
      );
      // log(response.toString());
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            notificationCount = jsonData['data'];
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

  Future<void> getActiveUserCount() async {
    var jsonData;
    try {
      var response = await Dio().post(
        GET_ACTIVE_USER_COUNT,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
      );
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          activeUserCount = jsonData['data'];
          setState(() {});
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

  Future<void> _getDeviceToken() async {
    print('utsav');
    print('utsav');
    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(UPDATE_DEVICE_TOKEN, options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}), data: {
        'user_id': userID,
        'device_token': deviceToken,
        'device_type': deviceType,
        'device_id': deviceID,
      });
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            writeData('device_token', jsonData['response_p']['device_token']);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body.elementAt(_selectedIndex),
      bottomNavigationBar: Theme(
        data: ThemeData.light(),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(icon: BottomIcon(icon: 'Home'), label: 'Home', activeIcon: BottomIcon(icon: 'Home1')),
            BottomNavigationBarItem(icon: BottomIcon(icon: 'Trending'), label: 'Trending', activeIcon: BottomIcon(icon: 'Trending1')),
            BottomNavigationBarItem(icon: BottomIcon(icon: 'Discover'), label: 'Discover', activeIcon: BottomIcon(icon: 'Discover1')),
            BottomNavigationBarItem(
                icon: Image.asset('$ICON_URL/Watchlist.png', height: 20, width: 20, color: Colors.grey), label: 'Watchlist', activeIcon: BottomIcon(icon: 'Watchlist1')),
            BottomNavigationBarItem(
              icon: Stack(
                alignment: Alignment.center,
                children: [
                  Container(alignment: Alignment.bottomLeft, height: 23, width: 28, child: BottomIcon(icon: 'notification-g', iconSize: 23)),
                  jsonData == null
                      ? Container()
                      : notificationCount != 0
                          ? Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                height: 18,
                                width: 18,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: Color(0xffFF1616), shape: BoxShape.circle),
                                child: AppText(
                                  notificationCount.toString(),
                                  // fontWeight: FontWeight.w500,
                                  fontSize: 11.0,
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Container(),
                ],
              ),
              label: 'Notifications',
              activeIcon: Stack(
                alignment: Alignment.center,
                children: [
                  Container(alignment: Alignment.bottomLeft, height: 23, width: 28, child: BottomIcon(icon: 'notification', iconSize: 23)),
                  jsonData == null
                      ? Container()
                      : notificationCount != 0
                          ? Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                height: 18,
                                width: 18,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: Color(0xffFF1616), shape: BoxShape.circle),
                                child: AppText(
                                  notificationCount.toString(),
                                  // fontWeight: FontWeight.w500,
                                  fontSize: 11.0,
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Container(),
                ],
              ),
            ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          elevation: 5,
          fixedColor: Colors.blue,
          selectedFontSize: 10,
          unselectedFontSize: 10,
        ),
      ),
    );
  }
}

class BottomIcon extends StatelessWidget {
  final String icon;
  final double iconSize;

  BottomIcon({this.icon = '', this.iconSize = 20});

  @override
  Widget build(BuildContext context) {
    return Image.asset('$ICON_URL/$icon.png', height: iconSize, width: iconSize);
  }
}
