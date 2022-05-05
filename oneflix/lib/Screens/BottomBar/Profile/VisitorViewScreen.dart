import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Components/LiveDot.dart';
import 'package:oneflix/Screens/BottomBar/Home/PostContentScreen.dart';
import '../../../Constants.dart';
import 'FollowListScreen.dart';

class VisitorViewScreen extends StatefulWidget {
  final int userID;
  VisitorViewScreen({required this.userID});

  @override
  _VisitorViewScreenState createState() => _VisitorViewScreenState();
}

class _VisitorViewScreenState extends State<VisitorViewScreen> {
  bool followed = false;
  bool followBack = false;

  List tvList = [];
  List streamingTopForYouIDs = [];
  List streamingTrendingIDs = [];

  @override
  void initState() {
    print(widget.userID);
    getToken();
    super.initState();
  }

  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      opacity: 0,
      progressIndicator: SizedBox(width: 20, height: 20, child: kProgressIndicator),
      child: Scaffold(
        backgroundColor: Color(0xff2C3142),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: userData != null
                  ? Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              color: kPrimaryColor,
                              child: Column(
                                children: [
                                  SizedBox(height: 40),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(80),
                                    child: CachedImage(imageUrl: "$BASE_URL/${userData['profile_pic']}", isUserProfilePic: true, height: 110, width: 110, loaderSize: 10),
                                  ),
                                  SizedBox(height: 20),
                                  AppText(userData['full_name'], fontWeight: FontWeight.bold, fontSize: 22),
                                  AppText('@${userData['username']}', fontSize: 16),
                                  SizedBox(height: 15),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          child: AppText(
                                            '${userData['count_followers']} ${userData['count_followers'] == 1 || userData['count_followers'] == 0 ? 'Follower' : 'Followers'}',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => FollowListScreen(title: 'Followers', userid: userData["id"], flag: 1),
                                              ),
                                            );
                                          },
                                        ),
                                        AppText(
                                          followBack == true ? 'Follows you' : '',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16,
                                        ),
                                        GestureDetector(
                                          child: AppText('${userData['count_following']} Following', fontWeight: FontWeight.bold, fontSize: 16),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => FollowListScreen(title: 'Following', userid: userData["id"], flag: 0),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomButton2(
                                        title: followed == false ? 'Follow' : 'Following',
                                        fontWeight: FontWeight.w900,
                                        height: 50,
                                        borderRadius: 10,
                                        horizontalPadding: 40,
                                        fontColor: followed == false ? Colors.black : Colors.white,
                                        bgColor: followed == false ? Colors.white : Colors.blue,
                                        onPressed: () {
                                          _followUser();
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 7),
                                  followByList.length == 0
                                      ? Container()
                                      : AppText(
                                          followByList.length == 1
                                              ? 'Followed by ${followByList[0]['full_name']}'
                                              : 'Followed by ${followByList[0]['full_name']} and ${followByList.length - 1} other friends',
                                          color: Colors.black,
                                          // fontWeight: FontWeight.w900,
                                          fontSize: 13,
                                          textAlign: TextAlign.center,
                                        ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 20,
                              left: 4,
                              child: IconButton(
                                icon: Icon(Icons.chevron_left_rounded, size: 38, color: Colors.white),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Positioned(
                              top: 24,
                              right: 4,
                              child: IconButton(
                                icon: Icon(Icons.more_horiz_rounded, size: 38, color: Colors.white),
                                onPressed: () {
                                  showDialog(
                                    barrierDismissible: true,
                                    barrierColor: Colors.transparent,
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(14),
                                                child: Container(
                                                  height: 272,
                                                  width: MediaQuery.of(context).size.width - 30,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(color: Color(0xff4a4a4a), borderRadius: BorderRadius.circular(14)),
                                                  child: Column(
                                                    children: [
                                                      Button(
                                                        title: 'Report User',
                                                        desc: 'Report this user to Oneflix for violating community guidelines or abusive behavior',
                                                        onTap: () {
                                                          actionOnUser(widget.userID, 2);
                                                        },
                                                      ),
                                                      Button(
                                                        title: 'Block User',
                                                        desc: 'Block all posts and activities from this user so they\'re no longer displayed to you',
                                                        onTap: () {
                                                          actionOnUser(widget.userID, 1);
                                                        },
                                                      ),
                                                      Material(
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            width: MediaQuery.of(context).size.width,
                                                            height: 70,
                                                            child: AppText('Cancel', color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700, textAlign: TextAlign.center),
                                                          ),
                                                        ),
                                                        color: Colors.transparent,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 1)
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            SizedBox(width: 16),
                            Expanded(child: AppText(userData['bio'] == null ? '' : userData['bio'], textAlign: TextAlign.left)),
                            SizedBox(width: 16),
                          ],
                        ),
                        SizedBox(height: 20),
                        Divider(color: Colors.white38),
                        tvList.length == 0
                            ? Container()
                            : AppText(
                                '${userData['full_name'].toUpperCase()}\'S RECOMMENDATIONS',
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                textAlign: TextAlign.center,
                              ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 2 / 3,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: tvList.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return GestureDetector(
                              onTap: () {
                                print(tvList[index]['content_third_party_id']);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostContentScreen(
                                      contentTPId: tvList[index]['content_third_party_id'],
                                      contentID: tvList[index]['content_id'],
                                      contentType: tvList[index]['content_type'],
                                    ),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    height: 180,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: CachedImage(
                                        imageUrl: 'https://image.tmdb.org/t/p/original/${tvList[index]['content_photo']}',
                                        height: 140,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  streamingTrendingIDs[index] == 203 ||
                                          streamingTrendingIDs[index] == 26 ||
                                          streamingTrendingIDs[index] == 372 ||
                                          streamingTrendingIDs[index] == 157 ||
                                          streamingTrendingIDs[index] == 387 ||
                                          streamingTrendingIDs[index] == 444 ||
                                          streamingTrendingIDs[index] == 388 ||
                                          streamingTrendingIDs[index] == 389 ||
                                          streamingTrendingIDs[index] == 371 ||
                                          streamingTrendingIDs[index] == 445 ||
                                          streamingTrendingIDs[index] == 248 ||
                                          streamingTrendingIDs[index] == 232 ||
                                          streamingTrendingIDs[index] == 296 ||
                                          streamingTrendingIDs[index] == 391
                                      ? Positioned(
                                          top: 7,
                                          left: 7,
                                          child: Image.asset(
                                            '$TRENDING_URL/${streamingTrendingIDs[index] == 203 ? 'NetflixNew' : streamingTrendingIDs[index] == 26 ? 'AmazonPrime' : streamingTrendingIDs[index] == 372 ? 'Disney' : streamingTrendingIDs[index] == 157 ? 'Hulu' : streamingTrendingIDs[index] == 387 ? 'HBOMax' : streamingTrendingIDs[index] == 444 ? 'Paramount' : streamingTrendingIDs[index] == 388 || streamingTrendingIDs[index] == 389 ? 'Peacock' : streamingTrendingIDs[index] == 371 ? 'AppleTV' : streamingTrendingIDs[index] == 445 ? 'DiscoveryPlus' : streamingTrendingIDs[index] == 248 ? 'Showtime' : streamingTrendingIDs[index] == 232 ? 'Starz' : streamingTrendingIDs[index] == 296 ? 'Tubi' : streamingTrendingIDs[index] == 391 ? 'Pluto' : ' '}.png',
                                            height: 25,
                                          ),
                                        )
                                      : Positioned(top: 7, left: 7, child: Container()),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : Container(),
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
      ),
    );
  }

  String? userToken;
  getToken() async {
    var token = await readData('user_token');
    setState(() {
      userToken = token;
    });
    _userDetails();
  }

  var userData;
  List userDataList = [];
  List<dynamic> followByList = [];
  _userDetails() async {
    var jsonData;
    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        GET_USER_PROFILE,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'user_id': widget.userID},
      );
      print('RESPONSE: $response');
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          // if (!mounted) return;
          setState(() {
            userData = jsonData['data'];
            if (userData['is_follow_back'] == 0) {
              followBack = false;
            } else if (userData['is_follow_back'] == 1) {
              followBack = true;
            }
            followByList = [];
            for (int i = 0; i < userData['follow_by_list'].length; i++) {
              followByList.add(userData['follow_by_list'][i]);
            }
            followed = jsonData['data']['is_follow'] == 0 ? false : true;
            tvList = jsonData['User_recommended'];
            for (int i = 0; i < tvList.length; i++) {
              if (tvList[i]['watch_mode_json'] == [] || tvList[i]['watch_mode_json'] == '[]' || tvList[i]['watch_mode_json'] == null) {
                streamingTrendingIDs.insert(i, 0);
              } else {
                List temp = jsonDecode(tvList[i]['watch_mode_json']);

                for (int j = 0; j < temp.length; j++) {
                  // print(j);
                  if (temp[j]['region'].toString() == "US" &&
                      (temp[j]['type'].toString().toLowerCase() == "sub" || temp[j]['type'].toString().toLowerCase() == "free") &&
                      (temp[j]['source_id'] == 203 ||
                          temp[j]['source_id'] == 26 ||
                          temp[j]['source_id'] == 372 ||
                          temp[j]['source_id'] == 157 ||
                          temp[j]['source_id'] == 387 ||
                          temp[j]['source_id'] == 444 ||
                          temp[j]['source_id'] == 388 ||
                          temp[j]['source_id'] == 389 ||
                          temp[j]['source_id'] == 371 ||
                          temp[j]['source_id'] == 445 ||
                          temp[j]['source_id'] == 248 ||
                          temp[j]['source_id'] == 232 ||
                          temp[j]['source_id'] == 296 ||
                          temp[j]['source_id'] == 391)) {
                    streamingTrendingIDs.insert(i, temp[j]['source_id']);
                    if (streamingTrendingIDs[i] != null) {
                      break;
                    }
                  } else {
                    streamingTrendingIDs.insert(i, 0);
                    if (streamingTrendingIDs[i] != null) {
                      break;
                    }
                  }
                }
              }
            }
          });
        }
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }

  Future<void> _followUser() async {
    var jsonData;
    print(userToken);
    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        FOLLOW_USER,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'follow_to': widget.userID},
      );
      print(response);
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          print('FOLLOW USER');
          setState(() {
            if (jsonData['is_follow'] == 0) {
              followed = false;
            } else if (jsonData['is_follow'] == 1) {
              followed = true;
            }
          });
          _userDetails();
        } else {
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }

  actionOnUser(int id, int status) async {
    var jsonData;

    try {
      var response = await Dio().post(
        ACTION_ON_USER,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'block_to': id, 'status': status},
      );
      print(response);
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          jsonData = jsonDecode(response.toString());
          Navigator.pop(context);
          if (status == 1) {
            showDialog(
              barrierDismissible: false,
              barrierColor: Colors.transparent,
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 5), () {
                  Navigator.of(context).pop(true);
                });
                return StatefulBuilder(
                  builder: (context, setState) {
                    return TextAlertDialog(
                      warningText: 'You will no longer see any posts or activities from this user in your newsfeed.',
                    );
                  },
                );
              },
            );
          } else if (status == 2) {
            showDialog(
              barrierDismissible: false,
              barrierColor: Colors.transparent,
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 8), () {
                  Navigator.of(context).pop(true);
                });
                return StatefulBuilder(
                  builder: (context, setState) {
                    return TextAlertDialog(
                      warningText:
                          'Thank you for reporting this user. We will review this user\'s account within 24 hours and if we find it to be in violation of our Terms of Service or Privacy Policy, it will be permanently suspended from Oneflix.',
                    );
                  },
                );
              },
            );
          }
        });
        Toasty.showtoast(jsonData['message']);
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      Toasty.showtoast('Something Went Wrong');
      print(e.response.toString());
    }
  }

  List movieList = [];
}

class Button extends StatelessWidget {
  final String title;
  final String desc;
  final onTap;
  const Button({Key? key, this.title = '', this.desc = '', this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          child: InkWell(
            onTap: onTap,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width - 30,
              height: 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(title, color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700, textAlign: TextAlign.center),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: AppText(desc, color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, textAlign: TextAlign.left),
                  ),
                ],
              ),
            ),
          ),
          color: Colors.transparent,
        ),
        Divider(height: 0.4, color: Colors.grey),
      ],
    );
  }
}

class TextAlertDialog extends StatelessWidget {
  final String warningText;
  const TextAlertDialog({this.warningText = ''});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 190,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                height: 170,
                width: MediaQuery.of(context).size.width - 50,
                decoration: BoxDecoration(color: Color(0xff4a4a4a), borderRadius: BorderRadius.circular(14)),
                child: Center(
                  child: AppText(
                    warningText,
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0 /*MediaQuery.of(context).size.height * 0.60*/,
              right: 18,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Icon(Icons.close, color: Colors.black, size: 28),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 1)
      ],
    );
  }
}
