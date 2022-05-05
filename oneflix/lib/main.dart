import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:oneflix/Screens/OnBoarding/ContentCopyrightScreen.dart';
import 'package:oneflix/Screens/OnBoarding/LoginOtpVerifyScreen.dart';
import 'package:oneflix/Screens/OnBoarding/WelcomeScreen.dart';
import 'Constants.dart';
import 'Screens/OnBoarding/OtpVerifyScreen.dart';
import 'Screens/OnBoarding/UserNameScreen.dart';
import 'Screens/SplashScreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Oneflix',
      navigatorKey: navigatorKey,
      navigatorObservers: <NavigatorObserver>[observer],
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kPrimaryColor2,
      ),
      home: SplashScreen(analytics: analytics, observer: observer),
    );
  }
}
