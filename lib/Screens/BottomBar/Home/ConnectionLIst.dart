import 'package:flutter/material.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Components/LiveDot.dart';

import '../../../Constants.dart';

class ConnectionList extends StatefulWidget {
  final followList;
  const ConnectionList({this.followList});

  @override
  _ConnectionListState createState() => _ConnectionListState();
}

class _ConnectionListState extends State<ConnectionList> {
  @override
  Widget build(BuildContext context) {
    double mHeight = MediaQuery.of(context).size.height;
    double mWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor2,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded, size: 38),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText('FOLLOWED BY', fontSize: 22, fontWeight: FontWeight.w900),
                ],
              ),
              SizedBox(height: 36),
              Divider(color: Colors.white),
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.followList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: CachedImage(imageUrl: "$BASE_URL/${widget.followList[index]['profile_pic']}", isUserProfilePic: true, height: 45, width: 45, loaderSize: 10)),
                        SizedBox(width: mWidth * 0.12),
                        AppText('${widget.followList[index]['full_name']}', color: Colors.white, textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(color: Colors.white);
                },
              ),
              Divider(color: Colors.white),
            ],
          ),
          Positioned(
            bottom: 1,
            right: 1,
            child: Container(
              height: 50,
              width: 165,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Color(0xff004AAD),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    '${activeUserCount ?? '0'} Users Online',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 17),
                    child: BlinkingPoint(
                      xCoor: 12,
                      yCoor: -16,
                      pointSize: 12,
                      pointColor: Color(0xff7ED957),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
