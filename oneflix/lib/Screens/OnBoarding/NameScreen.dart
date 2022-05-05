import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Screens/OnBoarding/UserNameScreen.dart';
import '../../Constants.dart';
import 'LoginSmsAuthicationScreen.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({Key? key}) : super(key: key);

  @override
  _NameScreenState createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double mHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: mHeight * 0.75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(padding: EdgeInsets.only(top: mHeight * 0.10), child: Center(child: AppText('WELCOME', fontSize: 30, color: Colors.white, fontWeight: FontWeight.w700))),
                  AppText('Let\'s get you inside ', fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, left: 14, right: 14),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 4,
                          child: CustomTextField(
                            fieldHeight: 54,
                            hintText: 'First name',
                            hintFontSize: 16,
                            controller: firstName,
                            input: TextInputType.name,
                          ),
                        ),
                        SizedBox(width: 18),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 4,
                          child: CustomTextField(
                            fieldHeight: 54,
                            hintText: 'Last name',
                            hintFontSize: 16,
                            controller: lastName,
                            input: TextInputType.name,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    title: 'Next',
                    onPressed: () {
                      if (validate(firstName: firstName.text, lastName: lastName.text)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserNameScreen(firstName: firstName.text, lastName: lastName.text)),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  AppText('Oneflix is 100% Free', fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                ],
              ),
            ),
            Container(
              height: mHeight * 0.24,
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
    );
  }

  bool validate({required String firstName, required String lastName}) {
    if (firstName.isEmpty) {
      Toasty.showtoast('Please enter your first name');
      return false;
    } else if (lastName.isEmpty) {
      Toasty.showtoast('Please enter your last name');
      return false;
    } else {
      return true;
    }
  }
}
