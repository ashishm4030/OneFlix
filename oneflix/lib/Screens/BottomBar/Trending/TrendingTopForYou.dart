import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import '../../../Constants.dart';

class TopForYouTile extends StatelessWidget {
  final name;
  final profile;
  final onTap;

  TopForYouTile({this.profile, this.name, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        width: 270,
        height: 70,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.center,
                    softWrap: true,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Recommended by ",
                          style: TextStyle(color: Colors.black, fontSize: 13, fontFamily: 'OpenSans'),
                        ),
                        WidgetSpan(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedImage(imageUrl: "$BASE_URL/$profile", isUserProfilePic: true, height: 18, width: 18, loaderSize: 10),
                          ),
                        ),
                        TextSpan(
                          text: " $name",
                          style: TextStyle(color: Colors.black, fontSize: 13, fontFamily: 'OpenSans'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
