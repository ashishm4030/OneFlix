import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:oneflix/Components/CustomWidgets.dart';

import '../../Constants.dart';
import 'LoginSmsAuthicationScreen.dart';
import 'SmsAuthicationScreen.dart';

class UserNameScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  const UserNameScreen({required this.firstName, required this.lastName});

  @override
  _UserNameScreenState createState() => _UserNameScreenState();
}

class _UserNameScreenState extends State<UserNameScreen> {
  TextEditingController username = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double mHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        progressIndicator: SizedBox(height: 20, width: 20, child: kProgressIndicator),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: mHeight * 0.60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: mHeight * 0.10),
                      child: Center(child: AppText('ALMOST DONE', fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    Center(child: AppText('Choose your username', fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 46.0),
                      child: CustomTextField(
                        onSubmit: (value) {
                          if (validate(username: username.text)) {
                            validateUsername();
                          }
                        },
                        hintText: 'Enter username',
                        controller: username,
                        contentPadding: 36,
                        input: TextInputType.text,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(14),
                          FilteringTextInputFormatter.allow(RegExp("^[a-z0-9_]+\$")),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: AppText(
                        'A username must be lowercase, less than 15 characters, and can contain only letters, numbers, and underscores. ',
                        maxLines: 5,
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    CustomButton(
                      title: 'Next',
                      onPressed: () {
                        if (validate(username: username.text)) {
                          validateUsername();
                        }
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: mHeight * 0.38,
                child: Align(
                  alignment: Alignment.bottomCenter,
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _loading = false;
  validateUsername() async {
    var jsonData;
    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(CHECK_USERNAME, data: {'username': username.text});
      print(response);
      if (response.statusCode == 200) {
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SmsAuthenticationScreen(firstName: widget.firstName, lastName: widget.lastName, username: username.text)));
        } else {
          showDialog(
            barrierDismissible: false,
            barrierColor: Colors.transparent,
            context: context,
            builder: (context) {
              Future.delayed(Duration(seconds: 4), () {
                Navigator.of(context).pop(true);
              });
              return StatefulBuilder(
                builder: (context, setState) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.30),
                        height: 40,
                        width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(14)),
                        child: Center(
                          child: AppText(
                            jsonData['message'],
                            color: Colors.white,
                            fontSize: 14,
                            // fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
          // Toasty.showtoast(jsonData['message'], second: 4);
        }
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }

  bool validate({required String username}) {
    if (username.isEmpty) {
      Toasty.showtoast('Please enter your username');
      return false;
    } else {
      return true;
    }
  }
}
