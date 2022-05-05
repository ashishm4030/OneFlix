import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';

class InitialData {
  double? latitude, longitude;
  String? deviceToken;
  int? deviceType;
  var deviceID;
  String? deviceName;

  Future<void> getDeviceTypeId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      deviceType = 1;
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceID = androidDeviceInfo.androidId;
      deviceName = androidDeviceInfo.model;
      // androidDeviceInfo.i
    } else {
      deviceType = 2;
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceID = iosDeviceInfo.identifierForVendor;
      deviceName = iosDeviceInfo.model;
    }
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude;
    longitude = position.longitude;
  }

  Future<void> getFirebaseToken() async {
    deviceToken = await FirebaseMessaging.instance.getToken();
  }
}
