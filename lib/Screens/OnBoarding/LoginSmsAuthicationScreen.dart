import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Screens/OnBoarding/NameScreen.dart';
import '../../Constants.dart';
import 'LoginOtpVerifyScreen.dart';

class LoginSmsAuthenticationScreen extends StatefulWidget {
  const LoginSmsAuthenticationScreen({Key? key}) : super(key: key);

  @override
  _LoginSmsAuthenticationScreenState createState() => _LoginSmsAuthenticationScreenState();
}

class _LoginSmsAuthenticationScreenState extends State<LoginSmsAuthenticationScreen> {
  final TextEditingController phoneNumber = TextEditingController();
  String initialCountry = 'US';
  PhoneNumber number = PhoneNumber(isoCode: 'US');
  String? fullNumber;
  String? onlyNumber;
  bool isValid = false;
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
                    Padding(padding: EdgeInsets.only(top: mHeight * 0.10), child: Center(child: AppText('LOGIN', fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold))),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width - 50,
                        child: AppText(
                          'Enter the phone number you used when you registered.we\'re going to text you a code.',
                          maxLines: 4,
                          fontSize: 14,
                          color: Colors.white,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
                          selectorConfig: SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            setSelectorButtonAsPrefixIcon: true,
                          ),
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
                    CustomButton(
                      title: 'Next',
                      onPressed: () async {
                        await _checkDummyUser();
                        if (dummyUser == true) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginOtpVerifyScreen(
                                        phoneNumber: fullNumber!,
                                        onlyNumber: onlyNumber!,
                                        dummyOrNot: dummyUser,
                                        flag: 1,
                                      )));
                        } else {
                          if (validate(phone: phoneNumber.text, isValid: isValid)) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginOtpVerifyScreen(
                                          phoneNumber: fullNumber!,
                                          onlyNumber: onlyNumber!,
                                          dummyOrNot: false,
                                        )));
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: mHeight * 0.42,
                child: Align(
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
                        child: AppText('Signup here', fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
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

class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      print(text.length);
      if (nonZeroIndex <= 5) {
        print("non");
        print(nonZeroIndex);
        if (nonZeroIndex % 5 == 0 && nonZeroIndex != text.length) {
          buffer.write('-'); // Add double spaces.
        }
      } else {
        if (nonZeroIndex % 12 == 0 && nonZeroIndex != text.length) {
          buffer.write('-'); // Add double spaces.
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: new TextSelection.collapsed(offset: string.length));
  }
}
