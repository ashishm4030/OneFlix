import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:new_version/new_version.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Screens/BottomBar/Home/PostContentScreen.dart';
import 'package:oneflix/Screens/BottomBar/MainHomeScreen.dart';
import 'package:oneflix/Screens/BottomBar/Profile/VisitorViewScreen.dart';
import 'package:oneflix/main.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constants.dart';
import '../InitialData.dart';
import 'OnBoarding/NameScreen.dart';

Socket? socket;
String? socketID;

class SplashScreen extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  const SplashScreen({Key? key, required this.analytics, required this.observer}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var userToken;

  Future startTimer() async {
    var duration = Duration(seconds: 3);
    return Timer(duration, route);
  }

  var userID;

  Future getUserToken() async {
    var token = await readData('user_token');
    var userId = await readData('user_id');
    setState(() {
      userToken = token;
      userID = userId;
    });
  }

  Future showDialogSuccess(BuildContext context) async {
    await showAnimatedDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 30, right: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryColor,
                      offset: Offset(1, 2),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: AppText('Update Available', fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: AppText(
                        'A new version of Oneflix is available with new features and better performance.',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black87,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.shade400,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => userToken == null || userToken == 'null' || userToken == '' ? NameScreen() : MainHomeScreen()),
                                (Route<dynamic> route) => false);
                          },
                          child: Container(
                            height: 56,
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.36,
                            child: AppText(
                              'Not Now',
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 56,
                          child: VerticalDivider(
                            thickness: 1,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _launchInBrowser(status.appStoreLink);
                          },
                          child: Container(
                              height: 56,
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.36,
                              child: AppText(
                                'Update',
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.blue,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },

      animationType: DialogTransitionType.fadeScale,
      curve: Curves.easeInExpo,
      //duration: Duration(seconds: 1),
    );
  }

  bool _flexibleUpdateAvailable = false;

  AppUpdateInfo? _updateInfo;
  androidDialog() {
    return _updateInfo?.updateAvailability == UpdateAvailability.updateAvailable
        ? InAppUpdate.startFlexibleUpdate().then((value) {
            setState(() {
              _flexibleUpdateAvailable = true;
            });
          }).catchError((e) {
            print('utsav');
          })
        : null;
  }

  route() {
    if (status == null) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => userToken == null || userToken == 'null' || userToken == '' ? NameScreen() : MainHomeScreen()),
          (Route<dynamic> route) => false);
    } else {
      isVersionGreaterThan(storeVersion, localVersion) == true
          ? Platform.isAndroid
              ? androidDialog()
              : showDialogSuccess(context)
          : Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => userToken == null || userToken == 'null' || userToken == '' ? NameScreen() : MainHomeScreen()),
              (Route<dynamic> route) => false);
    }
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  String messageTitle = "Empty";
  String notificationAlert = "alert";
  final notifications = FlutterLocalNotificationsPlugin();
  late AndroidNotificationChannel channel;
  getToken() async {
    String? token = await messaging.getToken(vapidKey: "KP5PSBMSCF");
    print(token);
  }

  var action;
  var notificationType;
  var notificationData;
  var userId;
  var contentId;
  var contentThirdPartyId;
  final newVersion = NewVersion(
    iOSId: 'com.oneflix.streaming.guide',
    androidId: 'com.oneflix.streaming.guide',
  );

  var status;
  var localVersion, storeVersion;
  advancedStatusCheck(NewVersion newVersion) async {
    status = await newVersion.getVersionStatus();
    if (status != null) {
      print(status.appStoreLink);
      localVersion = status.localVersion;
      storeVersion = status.storeVersion;
    }
    print(localVersion);
    print(storeVersion);
    isVersionGreaterThan(storeVersion, localVersion);
    print(isVersionGreaterThan(storeVersion, localVersion));
  }

  bool isVersionGreaterThan(String newVersion, String currentVersion) {
    List<String> currentV = currentVersion.split(".");
    List<String> newV = newVersion.split(".");
    bool a = false;
    for (var i = 0; i <= 2; i++) {
      a = int.parse(newV[i]) > int.parse(currentV[i]);
      if (int.parse(newV[i]) != int.parse(currentV[i])) break;
    }
    return a;
  }

  connectSocket() async {
    print('utsav satani');
    socket = io(
      'http://oneflixapp.com:8000',
      <String, dynamic>{
        'transports': ['websocket'],
      },
    );
    socket?.on(
        'connect',
        (data) => {
              socket?.emit('socket_register', {'user_id': userID}),
              socketID = socket?.id,
              print('Socket Register ========> $socketID'),
              print('ONCE: ${socket?.connected}'),
            });
  }

  @override
  void initState() {
    super.initState();
    getData();
    getToken();

    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(iOS: initializationSettingsIOS, android: initializationSettingsAndroid);
    notifications.initialize(initializationSettings, onSelectNotification: onSelectNotification);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;

      action = await message.data['type'];
      notificationType = await message.data['notification_type'];
      userId = await message.data['user_id'];
      contentId = await message.data['content_id'];
      print(contentId);
      print('contentId');
      contentThirdPartyId = await message.data['content_third_party_id'];
      print(contentThirdPartyId);
      print('contentThirdPartyId');

      AppleNotification? ios = message.notification?.apple;
      if (notification != null && ios != null) {
        notifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(iOS: IOSNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true)),
          payload: action,
        );
        NotificationSettings settings = await messaging.requestPermission(alert: true, badge: true, provisional: true, sound: true);

        print('NOTIFICATION INIT IOS');
      }
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        print(notification.body);
        notifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails('1', 'User Activity', icon: 'app_icon'),
            iOS: IOSNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
          ),
          payload: action,
        );
        print('NOTIFICATION INIT ANDROID');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print(message.data);
      print('onMessageOpenedApp event was published!');
      action = await message.data['type'];
      notificationType = await message.data['notification_type'];
      userId = await message.data['user_id'];
      contentId = await message.data['content_id'];
      contentThirdPartyId = await message.data['content_third_party_id'];

      print('notificationType : $notificationType');
      // notification_types>>>>>> 1=follow, 2=comment tagged, 3=signup, 4=reacted, 5=comment, 6=recommended
      // await notifications.cancelAll();
      if (notificationType.toString() == '1' || notificationType.toString() == '3') {
        await navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => VisitorViewScreen(userID: int.parse(userId))));
      } else if (notificationType.toString() == '2' || notificationType.toString() == '4' || notificationType.toString() == '5' || notificationType.toString() == '6') {
        await navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => PostContentScreen(contentID: contentId, contentTPId: contentThirdPartyId)));
      }
    });
    print(FirebaseMessaging.onMessageOpenedApp);

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async {
      if (message != null) {
        print(message.data);
        print('getInitialMessage event was published!');
        action = await message.data['type'];
        notificationType = await message.data['notification_type'];
        userId = await message.data['user_id'];
        contentId = await message.data['content_id'];
        contentThirdPartyId = await message.data['content_third_party_id'];

        print('notificationType : $notificationType');
        // notification_types>>>>>> 1=follow, 2=comment tagged, 3=signup, 4=reacted, 5=comment, 6=recommended
        // await notifications.cancelAll();
        if (notificationType.toString() == '1' || notificationType.toString() == '3') {
          print('TYPE 1,3');
          await navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => VisitorViewScreen(userID: int.parse(userId))));
        } else if (notificationType.toString() == '2' || notificationType.toString() == '4' || notificationType.toString() == '5' || notificationType.toString() == '6') {
          print('TYPE 2,4,5,6');
          await navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => PostContentScreen(contentID: contentId, contentTPId: contentThirdPartyId)));
        }
      }
    });
  }

  Future<dynamic> onSelectNotification(payload) async {
    if (notificationType.toString() == '1' || notificationType.toString() == '3') {
      print('TYPE 1,3');
      await navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => VisitorViewScreen(userID: int.parse(userId))));
    } else if (notificationType.toString() == '2' || notificationType.toString() == '4' || notificationType.toString() == '5' || notificationType.toString() == '6') {
      print('TYPE 2,4,5,6');
      await navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => PostContentScreen(contentID: contentId, contentTPId: contentThirdPartyId)));
    }
  }

  void onDidReceiveLocalNotification(int? id, String? title, String? body, String? payload) async {
    print(id);
    print(title);
    print(body);
    print(payload);
    return;
  }

  getData() async {
    print(userId);
    print('userId');
    await getUserToken();
    await advancedStatusCheck(newVersion);
    await startTimer();
    if (userID != null) {
      await connectSocket();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.45,
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [AppText('Oneflix', color: Colors.white, fontSize: 50, fontWeight: FontWeight.w900)],
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Image.asset('$ICON_URL/logo.png', height: 160, width: 160),
          ),
        ],
      ),
    );
  }

  _launchInBrowser(String url) async {
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
}

// class SuccessPopUp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }
