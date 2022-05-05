import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Screens/BottomBar/MainHomeScreen.dart';
import 'package:oneflix/Screens/OnBoarding/NameScreen.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import '../../Constants.dart';
import '../../InitialData.dart';

class LoginOtpVerifyScreen extends StatefulWidget {
  final String phoneNumber;
  final String onlyNumber;
  final bool dummyOrNot;
  final flag;
  const LoginOtpVerifyScreen({Key? key, required this.phoneNumber, required this.onlyNumber, required this.dummyOrNot, this.flag}) : super(key: key);

  @override
  _LoginOtpVerifyScreenState createState() => _LoginOtpVerifyScreenState();
}

class _LoginOtpVerifyScreenState extends State<LoginOtpVerifyScreen> {
  var otp;

  FirebaseAuth _auth = FirebaseAuth.instance;
  String? verificationCode;

  firebaseOTPValidation(String phone, BuildContext context) async {
    setState(() {
      _loading = true;
    });
    try {
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
        codeAutoRetrievalTimeout: print,
      );
    } catch (e) {
      print('AUTH EXCEPTION: $e');
    }
  }

  @override
  void initState() {
    print(widget.dummyOrNot);
    firebaseOTPValidation(widget.phoneNumber, context);
    getPublicIP();
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Center(child: AppText('VERIFY CODE', fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
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
                          style: TextStyle(fontSize: 14, letterSpacing: 0, color: Colors.black),
                          onCompleted: (pin) {
                            setState(() {
                              otp = pin;
                              print(otp);
                            });
                          },
                          onChanged: (pin) {
                            print(pin);
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
                          print(otp);

                          if (widget.dummyOrNot == true) {
                            print('utsav');
                            if (validate()) {
                              _login();
                            }
                          } else {
                            AuthCredential credential;
                            if (validate()) {
                              if (verificationCode != null) {
                                setState(() {
                                  _loading = true;
                                });
                                credential = PhoneAuthProvider.credential(verificationId: verificationCode!, smsCode: otp);
                                UserCredential result = await _auth.signInWithCredential(credential);
                                User? user = result.user;
                                if (user != null) {
                                  await _login();
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
                  height: mHeight * 0.35,
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText('New to Oneflix?', fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                      SizedBox(width: 3),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                              return NameScreen();
                            }), (route) => false);
                          },
                          child: AppText('Signup here', fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
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
    InitialData deviceInfo = InitialData();
    await deviceInfo.getDeviceTypeId();
    deviceID = deviceInfo.deviceID!;
    deviceType = deviceInfo.deviceType!;

    await deviceInfo.getFirebaseToken();
    deviceToken = deviceInfo.deviceToken!;
    print(deviceToken);
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

  _login() async {
    print('deviceToken: ${widget.onlyNumber}');
    var jsonData;
    setState(() {
      _loading = true;
    });

    try {
      var response = await Dio().post(
        LOGIN,
        data: {
          'phone_number': widget.flag == 1 ? widget.onlyNumber : widget.onlyNumber.replaceAll(RegExp(r'[^\w\s]+'), "").replaceAll(' ', ''),
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
          await writeData('isSignUp', 'false');
          await FirebaseAnalytics.instance.logEvent(name: 'login', parameters: {'status': 'Login successful'});
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainHomeScreen()), (route) => false);
        } else {
          await FirebaseAnalytics.instance.logEvent(name: 'login', parameters: {'status': 'Login failed'});
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        await FirebaseAnalytics.instance.logEvent(name: 'login', parameters: {'status': 'Login failed'});
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      await FirebaseAnalytics.instance.logEvent(name: 'login', parameters: {'status': 'Login failed'});
      print(e.response.toString());
      print(e.response);
      print(e.message);
    }
  }

  bool validate() {
    print(otp);
    print('otp');
    if (otp == 'null' || otp == null) {
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
