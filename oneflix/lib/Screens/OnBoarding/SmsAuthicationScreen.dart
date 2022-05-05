import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Constants.dart';
import 'LoginSmsAuthicationScreen.dart';
import 'OtpVerifyScreen.dart';

class SmsAuthenticationScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String username;
  const SmsAuthenticationScreen({Key? key, required this.firstName, required this.username, required this.lastName}) : super(key: key);

  @override
  _SmsAuthenticationScreenState createState() => _SmsAuthenticationScreenState();
}

class _SmsAuthenticationScreenState extends State<SmsAuthenticationScreen> {
  final TextEditingController phoneNumber = TextEditingController();
  String initialCountry = 'US';
  PhoneNumber number = PhoneNumber(isoCode: 'US');
  String? fullNumber;
  String? onlyNumber;
  bool isValid = false;

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

  bool dummyUser = false;
  bool _loading = false;

  _checkDummyUser() async {
    var jsonData;
    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        DUMMY_CHECK_NUMBER,
        data: {
          'phone_number': phoneNumber.text,
        },
      );
      print(response);
      if (response.statusCode == 200) {
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            dummyUser = true;
          });
        } else {}
      } else {}
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double mHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        progressIndicator: SizedBox(height: 20, width: 20, child: kProgressIndicator),
        opacity: 0,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: mHeight * 0.56,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: mHeight * 0.10), child: Center(child: AppText('FINAL STEP', fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold))),
                    Container(
                      width: MediaQuery.of(context).size.width - 50,
                      child: AppText(
                        'To ensure a safe (spam-free) environment for all users (including you), please quickly verify that you\'re real. We\'re going to text you a code.',
                        maxLines: 8,
                        fontSize: 13,
                        color: Colors.white,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 1),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 15),
                          height: 50,
                          width: MediaQuery.of(context).size.width - 50,
                          color: Colors.white,
                          child: Theme(
                            data: ThemeData.light(),
                            child: InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                setState(() {
                                  fullNumber = number.phoneNumber;
                                  onlyNumber = phoneNumber.text;
                                  print(number.phoneNumber);
                                });
                              },
                              onInputValidated: (bool value) {
                                isValid = value;
                                print(isValid);
                              },
                              selectorConfig: SelectorConfig(selectorType: PhoneInputSelectorType.BOTTOM_SHEET, setSelectorButtonAsPrefixIcon: true),
                              ignoreBlank: false,
                              autoValidateMode: AutovalidateMode.disabled,
                              selectorTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              initialValue: number,
                              textFieldController: phoneNumber,
                              formatInput: true,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                              inputBorder: InputBorder.none,
                              hintText: 'Enter phone number',
                              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'OpenSans'),
                              onSaved: (PhoneNumber number) {
                                print('On Saved: $number');
                              },
                            ),
                          ),
                        ),
                        AppText(
                          'By entering your phone number,you are agreeing to our',
                          fontSize: 11,
                          color: Colors.white,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.bold,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _launchInBrowser('https://oneflix.app/terms-of-service/');
                              },
                              child: AppText(
                                'terms of service   ',
                                fontSize: 11,
                                color: Colors.white,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.bold,
                                textDecoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                                decorationThickness: 4.0,
                              ),
                            ),
                            AppText('and', fontSize: 11, color: Colors.white, textAlign: TextAlign.center, fontWeight: FontWeight.bold),
                            SizedBox(width: 3),
                            GestureDetector(
                              onTap: () {
                                _launchInBrowser('https://oneflix.app/privacy-policy/');
                              },
                              child: AppText(
                                'privacy policy',
                                fontSize: 11,
                                color: Colors.white,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.bold,
                                textDecoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                                decorationThickness: 4.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20)
                      ],
                    ),
                    SizedBox(height: 1),
                  ],
                ),
              ),
              Container(
                height: mHeight * 0.42,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      title: 'Next',
                      onPressed: () async {
                        if (validate(phone: phoneNumber.text, isValid: isValid)) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpVerifyScreen(
                                username: widget.username,
                                firstName: widget.firstName,
                                lastName: widget.lastName,
                                phoneNumber: fullNumber!,
                                onlyNumber: onlyNumber!,
                                dummyOrNot: false,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    Row(
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
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool validate({required String phone, required bool isValid}) {
    if (phone.isEmpty) {
      Toasty.showtoast('Please Enter Your Phone Number');
      return false;
    } else if (isValid == false) {
      Toasty.showtoast('Please Enter Valid Phone Number');
      return false;
    } else {
      return true;
    }
  }
}
