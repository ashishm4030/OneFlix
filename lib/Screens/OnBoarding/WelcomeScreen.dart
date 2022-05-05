import 'package:flutter/material.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Screens/BottomBar/MainHomeScreen.dart';
import '../../Constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: 110,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: AppText(
                  'WELCOME',
                  fontSize: 26,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Column(
            children: [
              AppText(
                'PLEASE READ THIS',
                fontSize: 23,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
              SizedBox(height: 30),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppText(
                            'INTERNATIONAL USERS',
                            color: Colors.black,
                            fontFamily: 'Roboto',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3, left: 5),
                            child: Image.asset('assets/icons/Canada.jpeg', scale: 5),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3, left: 5),
                            child: Image.asset('assets/icons/Africa.png', scale: 5),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3, left: 5),
                            child: Image.asset('assets/icons/United Kingdom.png', scale: 5),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3, left: 5),
                            child: Image.asset('assets/icons/Europe.png', scale: 5),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      AppText(
                        // TODO: Change text
                        'For users outside of the United States, some streaming services and content may not be available in your location. This is not a limitation of Oneflix. This is a limitation of those streaming services.',
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppText(
                            'YOUR FRIENDS',
                            color: Colors.black,
                            fontFamily: 'Roboto',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3, left: 5),
                            child: Image.asset('assets/images/1.png', scale: 24),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3, left: 5),
                            child: Image.asset('assets/images/2.png', scale: 24),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3, left: 5),
                            child: Image.asset('assets/images/3.png', scale: 24),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      AppText(
                        // TODO: Change text
                        'Oneflix allows you to discover what your friends are streaming, recommend streaming content with each other, and much more. In order to connect you to your friends already here, we are going to request access to your Contacts.',
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                      // SizedBox(height: 10),
                      // Row(
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.only(top: 20),
                      //       child: AppText(
                      //         'YOUR LOCATION',
                      //         color: Colors.black,
                      //         fontSize: 18,
                      //         fontFamily: 'Roboto',
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.only(top: 20),
                      //       child: Image.asset('assets/icons/locator.png', scale: 24),
                      //     ),
                      //   ],
                      // ),
                      // AppText(
                      //   'Oneflix uses satellite-based GPS signals to allow you to discover what people in your location, city, or town are streaming and talking about. In order to display this data to you, we\'re going to request access to your location. ',
                      //   color: Colors.black,
                      //   fontFamily: 'Roboto',
                      //   fontSize: 12,
                      // ),
                      // SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                  return MainHomeScreen();
                }), (route) => false);
              },
              child: Container(
                height: 75,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: AppText(
                    'OKAY, LET\'S GO',
                    fontSize: 26,
                    color: Colors.black,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            /*CustomButton1(
              height: 75,
              width: MediaQuery.of(context).size.width,
              title: 'OKAY, LET\'S GO',
              fontFamily: 'Roboto',
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                  return MainHomeScreen();
                }), (route) => false);
              },
            ),*/
          ),
        ],
      ),
    );
  }
}
