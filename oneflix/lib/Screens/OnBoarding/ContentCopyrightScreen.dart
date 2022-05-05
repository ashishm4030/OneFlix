import 'package:flutter/material.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Screens/OnBoarding/WelcomeScreen.dart';

import '../../Constants.dart';

class ContentCopyRightScreen extends StatefulWidget {
  const ContentCopyRightScreen({Key? key}) : super(key: key);

  @override
  _ContentCopyRightScreenState createState() => _ContentCopyRightScreenState();
}

class _ContentCopyRightScreenState extends State<ContentCopyRightScreen> {
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
                  'IMPORTANT MESSAGE',
                  fontSize: 26,
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      AppText(
                        'Oneflix is a streaming aggregator. (It is not a streaming service!). This means that while you can use Oneflix to unify your streaming services and browse through content across all the major streaming services, when you click “play” to watch a content, you will be taken to the destination of that content on another streaming app.\n \n We are required to link to the content (instead of making you watch it within Oneflix) in order to comply with international film copyright laws.',
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      SizedBox(height: 30),
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
                  return WelcomeScreen();
                }), (route) => false);
              },
              child: Container(
                height: 75,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: AppText(
                    'NEXT',
                    fontSize: 26,
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
