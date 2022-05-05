import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Screens/OnBoarding/ContentCopyrightScreen.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Constants.dart';
import '../../InitialData.dart';
import 'LoginSmsAuthicationScreen.dart';
import 'UserNameScreen.dart';
import 'WelcomeScreen.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String username;
  final String phoneNumber;
  final String onlyNumber;
  final bool dummyOrNot;
  const OtpVerifyScreen(
      {Key? key, required this.firstName, required this.username, required this.phoneNumber, required this.onlyNumber, required this.lastName, required this.dummyOrNot})
      : super(key: key);

  @override
  _OtpVerifyScreenState createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  String otp = '';

  FirebaseAuth _auth = FirebaseAuth.instance;
  String? verificationCode;

  firebaseOTPValidation(String phone, BuildContext context) async {
    setState(() {
      _loading = true;
    });
    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        print('SUCCESSFUL');
      },
      verificationFailed: (exception) {
        setState(() {
          _loading = false;
        });
        print('AUTH EXCEPTION:>>> ${exception.message}');
        if (exception.message == 'We have blocked all requests from this device due to unusual activity. Try again later.') {
          Toasty.showtoast(exception.message.toString());
        }
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        setState(() {
          verificationCode = verificationId;
          _loading = false;
        });
        print('verificationCode: $verificationCode');
      },
      codeAutoRetrievalTimeout: (val) {
        print(val);
      },
    );
  }

  @override
  void initState() {
    firebaseOTPValidation(widget.phoneNumber, context);
    getDeviceData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mHeight = MediaQuery.of(context).size.height;
    return ModalProgressHUD(
      inAsyncCall: _loading,
      progressIndicator: SizedBox(height: 20, width: 20, child: kProgressIndicator),
      opacity: 0,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(children: [
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.chevron_left_rounded, size: 30),
                  ),
                  // SizedBox(width: 6),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: AppText('Back', fontSize: 16, height: 1.2, color: Colors.white, fontWeight: FontWeight.bold))
                ]),
                Container(
                  height: mHeight * 0.52,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Center(child: AppText('VERIFY CODE', fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 1),
                      Center(child: AppText('Please enter the code we just texted you.', fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                      SizedBox(height: 1),
                      Theme(
                        data: ThemeData.light(),
                        child: OTPTextField(
                          otpFieldStyle: OtpFieldStyle(
                              backgroundColor: Colors.white, borderColor: Colors.transparent, enabledBorderColor: Colors.transparent, focusBorderColor: Colors.transparent),
                          length: 6,
                          width: MediaQuery.of(context).size.width - 50,
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          fieldWidth: 50,
                          margin: EdgeInsets.zero,
                          fieldStyle: FieldStyle.box,
                          outlineBorderRadius: 0,
                          style: TextStyle(fontSize: 14, letterSpacing: 0),
                          onCompleted: (pin) {
                            setState(() {
                              otp = pin;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: AppText(
                          'If you didn\'t receive the code, swipe back and make sure you entered the correct number.',
                          maxLines: 5,
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      CustomButton(
                        title: 'Verify',
                        onPressed: () async {
                          AuthCredential credential;
                          if (widget.dummyOrNot == true) {
                            if (validate(otp: otp)) {
                              _signUp();
                            }
                          } else {
                            if (validate(otp: otp)) {
                              if (verificationCode != null) {
                                credential = PhoneAuthProvider.credential(verificationId: verificationCode!, smsCode: otp);
                                UserCredential result = await _auth.signInWithCredential(credential);
                                User? user = result.user;
                                if (user != null) {
                                  await _signUp();
                                } else {
                                  print("Error");
                                }
                              }
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  height: mHeight * 0.35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText('Already on Oneflix?', fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                      SizedBox(width: 3),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginSmsAuthenticationScreen()));
                        },
                        child: AppText('Login here', fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _loading = false;
  String deviceID = '';
  String deviceToken = '';
  int? deviceType;
  String? ip;
  double? latitude, longitude;

  getDeviceData() async {
    await getPublicIP();
    InitialData deviceInfo = InitialData();
    await deviceInfo.getDeviceTypeId();
    deviceID = deviceInfo.deviceID!;
    deviceType = deviceInfo.deviceType!;

    await deviceInfo.getFirebaseToken();
    deviceToken = deviceInfo.deviceToken!;

    // await _getContacts();
  }

  getPublicIP() async {
    var response = await Dio().get('https://api.ipify.org');
    if (response.statusCode == 200) {
      setState(() {
        ip = response.data;
      });
      print(ip);
    }
  }

  _signUp() async {
    var jsonData;
    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        SIGNUP,
        data: {
          'first_name': widget.firstName,
          'last_name': widget.lastName,
          'full_name': '${widget.firstName} ${widget.lastName}',
          'username': widget.username,
          'phone_number': widget.onlyNumber.replaceAll(RegExp(r'[^\w\s]+'), "").replaceAll(' ', ''),
          'lattitude': '0.00',
          'longitude': '0.00',
          'device_token': deviceToken == 'null' ? 'null' : deviceToken,
          'device_id': deviceID,
          'device_type': deviceType,
          'device_ip': ip ?? '0.0.0.0',
        },
      );
      print(response);
      if (response.statusCode == 200) {
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          await writeData('user_token', jsonData['data']['user_token']);
          await writeData('user_id', jsonData['data']['user_id']);
          await writeData('first_name', jsonData['data']['first_name']);
          await writeData('device_token', jsonData['data']['device_token']);
          await writeData('isSignUp', 'true');
          await FirebaseAnalytics.instance.logEvent(name: 'sign_up', parameters: {'status': 'Sign up successfully'});
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ContentCopyRightScreen()), (route) => false);
        } else {
          await FirebaseAnalytics.instance.logEvent(name: 'sign_up', parameters: {'status': 'Sign up failed'});
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        await FirebaseAnalytics.instance.logEvent(name: 'sign_up', parameters: {'status': 'Sign up failed'});
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      await FirebaseAnalytics.instance.logEvent(name: 'sign_up', parameters: {'status': 'Sign up failed'});
      print(e.response.toString());
    }
  }

  bool validate({required String otp}) {
    if (otp == 'null' || otp == 'null') {
      Toasty.showtoast('Please enter your OTP');
      return false;
    } else if (otp.length < 6) {
      Toasty.showtoast('OTP must contains 6 digits');
      return false;
    } else {
      return true;
    }
  }
}
