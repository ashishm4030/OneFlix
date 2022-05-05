import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feed_reaction/flutter_feed_reaction.dart';
import 'package:flutter_feed_reaction/models/feed_reaction_model.dart';
import 'package:intl/intl.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Components/LiveDot.dart';
import 'package:oneflix/Constants.dart';
import 'package:oneflix/InitialData.dart';
import 'package:oneflix/Screens/BottomBar/Home/ConnectionLIst.dart';
import 'package:oneflix/Screens/BottomBar/Profile/UserViewScreen.dart';
import 'package:oneflix/Screens/BottomBar/Profile/VisitorViewScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'PeopleSearchScreen.dart';
import 'PostContentScreen.dart';
import 'PostContentUserListScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 1;
  List allCommentView = [];
  List friendsCommentView = [];
  int reaction = 1;
  TextEditingController commentController = TextEditingController();

  List focusList = [];
  List streamingTrendingIDs = [];
  List controllerList = [];
  List contacts = [];
  List contactList = [];
  var commentId;
  bool viewReply = false;
  int _page = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  bool _loading = false;
  List postList = [];
  bool isPlayerMute = false;
  List pymkList = [];
  List piyaList = [];
  List followByPymkList = [];
  List followByPiyaList = [];
  var userID;
  var profilePic;
  String city = '';
  String state = '';
  String country = '';
  bool locationPermission = false;
  bool contactsPermission = false;
  bool notificationsPermission = false;
  Map<Permission, PermissionStatus>? statuses;
  String? userToken;
  String? isSignUp;
  ScrollController? _controller;
  late YoutubePlayerController _yTController;
  bool play = false;
  bool isPosterVisible = true;
  int get count => postList.length;
  List videoControllers = [];

  @override
  void initState() {
    getToken();
    Timer.periodic(Duration(seconds: 5), (Timer t) async => _getActiveUserCount());
    _controller = new ScrollController()..addListener(_loadMore);
    super.initState();
  }

  getToken() async {
    var usertoken = await readData('user_token');
    var signUpCheck = await readData('isSignUp');
    setState(() {
      userToken = usertoken;
      isSignUp = signUpCheck;
    });
    _updateProfile(0);
    _getPeopleKnow();
    requestContactPermission();
    await _firstLoad();
  }

  Future<void> _getActiveUserCount() async {
    print("czxkgsdjvs");
    var jsonData;
    try {
      var response = await Dio().post(
        GET_ACTIVE_USER_COUNT,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
      );
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            activeUserCount = jsonData['data'];
          });
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

  Future<void> requestContactPermission() async {
    contactsPermission = await Permission.contacts.isGranted;
    setState(() {});
    print(contactsPermission);
    statuses = await [Permission.contacts].request();
    setState(() {
      if (statuses![Permission.contacts]!.isGranted) {
        contactsPermission = true;
      } else if (statuses![Permission.contacts]!.isDenied) {
        contactsPermission = false;
      } else if (statuses![Permission.contacts]!.isPermanentlyDenied) {
        contactsPermission = false;
        // openAppSettings();
      }
    });
    if (contactsPermission == true) {
      await _getContacts();
      await updateContacts();
    }
  }

  updateLocationEveryMonth() async {
    final String formatted = DateFormat('dd').format(DateTime.now());
    if (formatted == '1' || formatted == '01' || isSignUp == 'true') {
      print('FIRST IMPRESSION: $isSignUp');
      await _updateProfile(1);
      await writeData('isSignUp', 'false');
    }
  }

  _getContacts() async {
    List<Contact> _contacts = (await ContactsService.getContacts(withThumbnails: false)).toList();
    setState(() {
      contacts.addAll(_contacts);
      for (var i = 0; i < contacts.length; i++) {
        contacts[i].phones.forEach((phone) {
          setState(() {
            contactList.add({
              'phone_number': phone.value.replaceAll(RegExp(r'[^\w\s]+'), "").replaceAll(' ', ''),
              'contact_name': contacts[i].displayName,
            });
          });
        });
      }
      print(jsonEncode(contactList));
    });
  }

  bool isLiked = false;

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 1));
    postList.clear();
    await _firstLoad();
  }

  @override
  void dispose() {
    _controller!.removeListener(_loadMore);
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xff011138),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        title: AppText('Oneflix', fontSize: 22, fontWeight: FontWeight.bold),
        actions: [
          Container(
            width: 64,
            margin: EdgeInsets.only(top: 11, bottom: 11, right: 8, left: 4),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedImage(imageUrl: "$BASE_URL/$profilePic", isUserProfilePic: true, height: 23, width: 23, loaderSize: 10),
                  ),
                  constraints: BoxConstraints(),
                  onPressed: () {
                    if (userID != null && _loading == false) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserViewScreen(userId: userID))).then((value) {
                        _updateProfile(0);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isFirstLoadRunning
          ? Center(child: SizedBox(height: 20, width: 20, child: kProgressIndicator))
          : Stack(
              children: [
                RefreshIndicator(
                  color: kPrimaryColor,
                  backgroundColor: Colors.white.withOpacity(0.8),
                  onRefresh: _refresh,
                  child: postList.isEmpty && _loading == false
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: AppText(
                                'You don\'t have any streaming recommendations or activity on your newsfeed because you\'re not following anyone. Invite your friends to join you on Oneflix to see their streaming activity and get recommendations.',
                                color: Color(0xff494949),
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.center,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: ListView(
                                controller: _controller,
                                children: [
                                  follow == 0
                                      ? Container()
                                      : GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => PeopleSearchScreen()));
                                          },
                                          child: Container(
                                            height: 50,
                                            margin: EdgeInsets.only(top: 11, bottom: 11, right: 10, left: 10),
                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  SizedBox(width: 16),
                                                  AppText('Find your friends', color: Color(0xff4a4a4a), fontSize: 18, fontWeight: FontWeight.bold),
                                                  Image.asset('$ICON_URL/Discover.png', height: 17, width: 17),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0, bottom: 8, left: 20, right: 20),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                'This is your newsfeed. To provide you with the best experience on Oneflix, the algorithm will automatically personalize your newsfeed based on what your friends are streaming. ',
                                            style: TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'OpenSans'),
                                          ),
                                          TextSpan(
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () => showDialog(
                                                    barrierDismissible: false,
                                                    barrierColor: Colors.black.withOpacity(0.9),
                                                    context: context,
                                                    builder: (context) {
                                                      return StatefulBuilder(
                                                        builder: (context, setState) {
                                                          return Stack(
                                                            alignment: Alignment.center,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 10, right: 10),
                                                                child: AppText(
                                                                  'To ensure that you have the best experience on Oneflix, the algorithm will automatically personalize the content displayed in your newsfeed based on what your friends are streaming, and content you may be interested in. To get more relevant content and recommendations in your newsfeed, invite and connect with more friends on Oneflix.',
                                                                  color: Colors.white,
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.bold,
                                                                  textAlign: TextAlign.left,
                                                                ),
                                                              ),
                                                              Positioned(
                                                                top: 0,
                                                                right: 0,
                                                                child: GestureDetector(
                                                                  onTap: () => Navigator.pop(context),
                                                                  child: Icon(Icons.close, color: Colors.white, size: 30),
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                            text: 'Read more',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              fontFamily: 'OpenSans',
                                              decoration: TextDecoration.underline,
                                              decorationThickness: 4,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  ListView.separated(
                                    // controller: _controller,
                                    shrinkWrap: true,
                                    itemCount: postList.length,
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return YoutubePlayerControllerProvider(
                                        controller: videoControllers[index],
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 6.0, bottom: 6.0),
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(0)),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                // SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    InkWell(
                                                      child: Icon(Icons.more_horiz_rounded, size: 28, color: Colors.black),
                                                      onTap: () {
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
                                                                        height: 141,
                                                                        width: MediaQuery.of(context).size.width - 30,
                                                                        alignment: Alignment.center,
                                                                        decoration: BoxDecoration(color: Color(0xff4a4a4a), borderRadius: BorderRadius.circular(14)),
                                                                        child: Column(
                                                                          children: [
                                                                            Material(
                                                                              child: InkWell(
                                                                                onTap: () {
                                                                                  reportPost(int.parse(postList[index]['content_third_party_id']));
                                                                                },
                                                                                child: Container(
                                                                                  alignment: Alignment.center,
                                                                                  width: MediaQuery.of(context).size.width,
                                                                                  height: 70,
                                                                                  child: AppText('Report Inappropriate',
                                                                                      color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700, textAlign: TextAlign.center),
                                                                                ),
                                                                              ),
                                                                              color: Colors.transparent,
                                                                            ),
                                                                            Divider(height: 0.4, color: Colors.grey),
                                                                            Material(
                                                                              child: InkWell(
                                                                                onTap: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Container(
                                                                                  alignment: Alignment.center,
                                                                                  width: MediaQuery.of(context).size.width,
                                                                                  height: 70,
                                                                                  child: AppText('Cancel',
                                                                                      color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700, textAlign: TextAlign.center),
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
                                                    SizedBox(width: 6),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (userID != postList[index]['activity_by']) {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(builder: (context) => VisitorViewScreen(userID: postList[index]['activity_by'])),
                                                            ).then((_) async {
                                                              await Future.delayed(Duration(seconds: 0, milliseconds: 1));
                                                              postList.clear();
                                                              await _firstLoad();
                                                            });
                                                          } else {
                                                            Navigator.push(
                                                                context, MaterialPageRoute(builder: (context) => UserViewScreen(userId: postList[index]['activity_by'])));
                                                          }
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(20),
                                                          child: CachedImage(
                                                            imageUrl: "$BASE_URL/${postList[index]['profile_pic']}",
                                                            isUserProfilePic: true,
                                                            height: 22,
                                                            width: 22,
                                                            loaderSize: 10,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 3),
                                                      Expanded(
                                                        child: RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: postList[index]['first_rec_user_name'] == null ? '' : postList[index]['first_rec_user_name'],
                                                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13, fontFamily: 'OpenSans'),
                                                                recognizer: TapGestureRecognizer()
                                                                  ..onTap = () {
                                                                    if (userID != postList[index]['another_id']) {
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(builder: (context) => VisitorViewScreen(userID: postList[index]['another_id'])),
                                                                      );
                                                                    } else {
                                                                      Navigator.push(
                                                                          context, MaterialPageRoute(builder: (context) => UserViewScreen(userId: postList[index]['another_id'])));
                                                                    }
                                                                  },
                                                              ),
                                                              TextSpan(
                                                                text: (postList[index]['actions_on_content'] == "Recommended" && postList[index]['count_recommended'] - 1 != 0) ||
                                                                        (postList[index]['actions_on_content'] == "Reacted" && postList[index]['over_all_like'] - 1 != 0) ||
                                                                        (postList[index]['actions_on_content'] == "Commented" && postList[index]['comment_count_top'] - 1 != 0)
                                                                    ? ' and'
                                                                    : '',
                                                                style: TextStyle(color: Colors.black, fontSize: 13, fontFamily: 'OpenSans'),
                                                              ),
                                                              TextSpan(
                                                                text: postList[index]['actions_on_content'] == "Recommended"
                                                                    ? postList[index]['count_recommended'] - 1 == 1
                                                                        ? ' ${postList[index]['count_recommended'] - 1} other'
                                                                        : postList[index]['count_recommended'] - 1 > 1
                                                                            ? ' ${postList[index]['count_recommended'] - 1} others'
                                                                            : ''
                                                                    : postList[index]['actions_on_content'] == "Reacted"
                                                                        ? postList[index]['over_all_like'] - 1 == 1
                                                                            ? ' ${postList[index]['over_all_like'] - 1} other'
                                                                            : postList[index]['over_all_like'] - 1 > 1
                                                                                ? ' ${postList[index]['over_all_like'] - 1} others'
                                                                                : ''
                                                                        : postList[index]['actions_on_content'] == "Commented"
                                                                            ? postList[index]['comment_count_top'] - 1 == 1
                                                                                ? ' ${postList[index]['comment_count_top'] - 1} other'
                                                                                : postList[index]['comment_count_top'] - 1 > 1
                                                                                    ? ' ${postList[index]['comment_count_top'] - 1} others'
                                                                                    : ''
                                                                            : '',
                                                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13, fontFamily: 'OpenSans'),
                                                                recognizer: TapGestureRecognizer()
                                                                  ..onTap = () {
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) => PostContentUserListScreen(
                                                                          loginUserId: userID,
                                                                          contentThirdPartyId: postList[index]['content_third_party_id'],
                                                                          title: postList[index]['actions_on_content'],
                                                                          activityType: postList[index]['actions_on_content'] == "Recommended"
                                                                              ? 1
                                                                              : postList[index]['actions_on_content'] == "Reacted"
                                                                                  ? 2
                                                                                  : 3,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                              ),
                                                              TextSpan(
                                                                text: ' ${postList[index]['actions_on_content'].toString().toLowerCase()}',
                                                                style: TextStyle(color: Colors.black, fontSize: 13, fontFamily: 'OpenSans'),
                                                              ),
                                                              TextSpan(
                                                                text: postList[index]['actions_on_content'] == "Recommended"
                                                                    ? ' ${postList[index]['content_title']}'
                                                                    : ' on ${postList[index]['content_title']}',
                                                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13, fontFamily: 'OpenSans'),
                                                              ),
                                                            ],
                                                          ),
                                                          maxLines: 2,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                                                  child: Stack(
                                                    // clipBehavior: Clip.none,
                                                    // alignment: Alignment.center,
                                                    children: [
                                                      // FittedBox(fit: BoxFit.cover, child: SizedBox(height: 200, width: mWidth, child: YoutubePlayerIFrame())),
                                                      YoutubeValueBuilder(
                                                        builder: (context, value) {
                                                          return /* value.playerState == PlayerState.playing
                                                        ? Container()
                                                        : */
                                                              Stack(
                                                            alignment: Alignment.center,
                                                            children: [
                                                              AbsorbPointer(
                                                                child: Container(
                                                                  color: Colors.white,
                                                                  child: CachedImage(
                                                                    imageUrl: 'https://image.tmdb.org/t/p/original/${postList[index]['content_cover_photo']}',
                                                                    width: mWidth,
                                                                    height: 200,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              // GestureDetector(
                                                              //   child: Icon(
                                                              //     value.playerState == PlayerState.playing ? Icons.pause : Icons.play_arrow_rounded,
                                                              //     size: 80,
                                                              //     color: Colors.white,
                                                              //   ),
                                                              //   onTapUp: (details) {
                                                              //     print('CLICk');
                                                              //     context.ytController.play();
                                                              //   },
                                                              // ),
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
                                                                      top: 10,
                                                                      left: 10,
                                                                      child: Image.asset(
                                                                        '$TRENDING_URL/${streamingTrendingIDs[index] == 203 ? 'NetflixNew' : streamingTrendingIDs[index] == 26 ? 'AmazonPrime' : streamingTrendingIDs[index] == 372 ? 'Disney' : streamingTrendingIDs[index] == 157 ? 'Hulu' : streamingTrendingIDs[index] == 387 ? 'HBOMax' : streamingTrendingIDs[index] == 444 ? 'Paramount' : streamingTrendingIDs[index] == 388 || streamingTrendingIDs[index] == 389 ? 'Peacock' : streamingTrendingIDs[index] == 371 ? 'AppleTV' : streamingTrendingIDs[index] == 445 ? 'DiscoveryPlus' : streamingTrendingIDs[index] == 248 ? 'Showtime' : streamingTrendingIDs[index] == 232 ? 'Starz' : streamingTrendingIDs[index] == 296 ? 'Tubi' : streamingTrendingIDs[index] == 391 ? 'Pluto' : ' '}.png',
                                                                        height: 40,
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                              // postList[index]['is_added_on_top_10'] == 0
                                                              //     ? Container()
                                                              //     : Positioned(
                                                              //         top: 0,
                                                              //         right: 0,
                                                              //         child: Image.asset('assets/icons/Top10.png', height: 40),
                                                              //       ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  showDialog(
                                                                    barrierDismissible: true,
                                                                    barrierColor: Colors.black.withOpacity(0.9),
                                                                    context: context,
                                                                    builder: (context) {
                                                                      return StatefulBuilder(
                                                                        builder: (context, setState) {
                                                                          return Stack(
                                                                            alignment: Alignment.center,
                                                                            children: [
                                                                              postList[index]['trailer_url'] != null
                                                                                  ? SizedBox(height: 20, width: 20, child: kProgressIndicator)
                                                                                  : Container(),
                                                                              postList[index]['trailer_url'] != null
                                                                                  ? YoutubePlayerIFrame(
                                                                                      controller: YoutubePlayerController(
                                                                                        initialVideoId: postList[index]['trailer_url'],
                                                                                        params: YoutubePlayerParams(
                                                                                          startAt: Duration(seconds: 1),
                                                                                          showControls: true,
                                                                                          mute: isPlayerMute,
                                                                                          loop: true,
                                                                                          showFullscreenButton: true,
                                                                                          autoPlay: true,
                                                                                          showVideoAnnotations: false,
                                                                                        ),
                                                                                      )..play(),
                                                                                    )
                                                                                  : Container(
                                                                                      margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 40),
                                                                                      child: AppText('Trailer is not available currently.', textAlign: TextAlign.center),
                                                                                      alignment: Alignment.center,
                                                                                    ),
                                                                              Positioned(
                                                                                top: 0,
                                                                                right: 0,
                                                                                child: GestureDetector(
                                                                                  onTap: () => Navigator.pop(context),
                                                                                  child: Icon(Icons.close, color: Colors.white, size: 30),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child: Icon(
                                                                  value.playerState == PlayerState.playing ? Icons.pause : Icons.play_arrow_rounded,
                                                                  size: 80,
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: postList[index]['content_third_party_id'],
                                                          contentID: postList[index]['content_id'],
                                                          action: postList[index]['actions_on_content'],
                                                          activityBy: postList[index]['content_id'],
                                                          contentType: postList[index]['content_type'],
                                                        ),
                                                      ),
                                                    ).then((_) => updatePost(postList[index]['page_no']));
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Image.asset('$ICON_URL/Like Icon.png', height: 20, width: 20),
                                                            SizedBox(width: 5),
                                                            AppText(postList[index]['normal_like'].toString(), fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10),
                                                          ],
                                                        ),
                                                        SizedBox(width: 8.0),
                                                        Row(
                                                          children: [
                                                            Image.asset('$ICON_URL/laugh.png', height: 20, width: 20),
                                                            SizedBox(width: 5),
                                                            AppText(postList[index]['haha_like'].toString(), fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10),
                                                          ],
                                                        ),
                                                        SizedBox(width: 8.0),
                                                        Row(
                                                          children: [
                                                            Image.asset('$ICON_URL/wow.png', height: 20, width: 20),
                                                            SizedBox(width: 5),
                                                            AppText(postList[index]['cry_like'].toString(), fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10),
                                                          ],
                                                        ),
                                                        SizedBox(width: 8.0),
                                                        Row(
                                                          children: [
                                                            Image.asset('$ICON_URL/angry.png', height: 20, width: 20),
                                                            SizedBox(width: 5),
                                                            AppText(postList[index]['angry_like'].toString(), fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10),
                                                          ],
                                                        ),
                                                        SizedBox(width: 8.0),
                                                        Row(
                                                          children: [
                                                            Image.asset('$ICON_URL/heart.png', height: 20, width: 20),
                                                            SizedBox(width: 5),
                                                            AppText(postList[index]['love_like'].toString(), fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10),
                                                          ],
                                                        ),
                                                        SizedBox(width: 8.0),
                                                        Row(
                                                          children: [
                                                            Image.asset('$ICON_URL/cry.png', height: 20, width: 20),
                                                            SizedBox(width: 5),
                                                            AppText(postList[index]['sad_like'].toString(), fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      FlutterFeedReaction(
                                                        reactions: [
                                                          FeedReaction(name: "Like", reaction: ReactButton(icon: 'likes')),
                                                          FeedReaction(name: "Laugh", reaction: ReactButton(icon: 'laugh')),
                                                          FeedReaction(name: "Wow", reaction: ReactButton(icon: 'wow')),
                                                          FeedReaction(name: "Angry", reaction: ReactButton(icon: 'angry')),
                                                          FeedReaction(name: "Heart", reaction: ReactButton(icon: 'heart')),
                                                          FeedReaction(name: "Cry", reaction: ReactButton(icon: 'cry')),
                                                        ],
                                                        spacing: 0,
                                                        dragSpace: 40.0,
                                                        onReactionSelected: (val) {
                                                          print(postList[index]['content_id']);
                                                          print(postList[index]['content_third_party_id']);
                                                          print('PAGE NO: ${postList[index]['page_no']}');
                                                          _addLikeOnPost(
                                                            pageNo: postList[index]['page_no'],
                                                            contentId: postList[index]['content_id'],
                                                            contentThirdPartyId: postList[index]['content_third_party_id'],
                                                            reactType: val.name == "Like"
                                                                ? 1
                                                                : val.name == "Laugh"
                                                                    ? 2
                                                                    : val.name == "Wow"
                                                                        ? 3
                                                                        : val.name == "Angry"
                                                                            ? 4
                                                                            : val.name == "Heart"
                                                                                ? 5
                                                                                : 6,
                                                          );
                                                          print(val.name);
                                                        },
                                                        onPressed: () {
                                                          print(postList[index]['content_id']);
                                                          print(postList[index]['content_third_party_id']);
                                                          print('PAGE NO: ${postList[index]['page_no']}');
                                                          _addLikeOnPost(
                                                            pageNo: postList[index]['page_no'],
                                                            contentId: postList[index]['content_id'],
                                                            contentThirdPartyId: postList[index]['content_third_party_id'],
                                                            reactType: 1,
                                                          );
                                                        },
                                                        prefix: postList[index]['is_like_me'] == 0
                                                            ? Image.asset('$ICON_URL/thumb.png', width: 26.0, height: 26.0)
                                                            : Image.asset('$ICON_URL/Like Icon.png', width: 24.0, height: 24.0),
                                                        suffix: AppText(postList[index]['is_like_me'] == 0 ? "Like" : "Liked", color: Colors.black, fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 14),
                                                postList[index]['highest_voted_comment'] == null
                                                    ? Container()
                                                    : GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => PostContentScreen(
                                                                contentTPId: postList[index]['content_third_party_id'],
                                                                contentID: postList[index]['content_id'],
                                                                action: postList[index]['actions_on_content'],
                                                                activityBy: postList[index]['content_id'],
                                                                contentType: postList[index]['content_type'],
                                                              ),
                                                            ),
                                                          ).then((_) => updatePost(postList[index]['page_no']));
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                                                                child: Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                                      child: ClipRRect(
                                                                        borderRadius: BorderRadius.circular(20),
                                                                        child: CachedImage(
                                                                          imageUrl: "$BASE_URL/${postList[index]['highest_voted_comment']['profile_pic']}",
                                                                          isUserProfilePic: true,
                                                                          height: 42,
                                                                          width: 42,
                                                                          loaderSize: 10,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width - 80,
                                                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Color(0xffebedf0)),
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              AppText(postList[index]['highest_voted_comment']['full_name'] ?? 'User',
                                                                                  fontStyle: FontStyle.normal,
                                                                                  fontFamily: 'Roboto',
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: 13,
                                                                                  color: Colors.black),
                                                                              AppText(postList[index]['highest_voted_comment']['comment_text'],
                                                                                  maxLines: 16,
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontFamily: 'Roboto',
                                                                                  color: Colors.black),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: MediaQuery.of(context).size.width - 80,
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                            children: [
                                                                              postList[index]['highest_voted_comment']['count_likes'] == 0
                                                                                  ? Container()
                                                                                  : Row(
                                                                                      children: [
                                                                                        Image.asset('$ICON_URL/Like Icon.png', height: 18, width: 18),
                                                                                        AppText(
                                                                                          ' ${postList[index]['highest_voted_comment']['count_likes']}',
                                                                                          fontWeight: FontWeight.bold,
                                                                                          color: Colors.black,
                                                                                          fontSize: 10,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 10)
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: postList[index]['content_third_party_id'],
                                                          contentID: postList[index]['content_id'],
                                                          action: postList[index]['actions_on_content'],
                                                          activityBy: postList[index]['content_id'],
                                                          contentType: postList[index]['content_type'],
                                                        ),
                                                      ),
                                                    ).then((_) => updatePost(postList[index]['page_no']));
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                                        decoration: BoxDecoration(color: Color(0xffeaeef7), borderRadius: BorderRadius.circular(10)),
                                                        child: Center(
                                                          child: Text(
                                                            'Where to Watch'.toUpperCase(),
                                                            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'OpenSans', fontSize: 14, color: Color(0xff4960f6)),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                                        decoration: BoxDecoration(color: Color(0xffeaeef7), borderRadius: BorderRadius.circular(10)),
                                                        child: Center(
                                                          child: Row(
                                                            children: [
                                                              Image.asset('$ICON_URL/Comment.png', height: 18, width: 18),
                                                              SizedBox(width: 10),
                                                              Text(
                                                                'Comment'.toUpperCase(),
                                                                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'OpenSans', fontSize: 14, color: Color(0xff4960f6)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: postList[index]['content_third_party_id'],
                                                          contentID: postList[index]['content_id'],
                                                          action: postList[index]['actions_on_content'],
                                                          activityBy: postList[index]['content_id'],
                                                          contentType: postList[index]['content_type'],
                                                        ),
                                                      ),
                                                    ).then((_) => updatePost(postList[index]['page_no']));
                                                  },
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 14),
                                                      postList[index]['comment_count'] == 0 || postList[index]['comment_count'] == 1
                                                          ? Container()
                                                          : AppText(
                                                              'View all ${postList[index]['comment_count']} comments',
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(0xff494949),
                                                              fontSize: 15,
                                                            ),
                                                      SizedBox(height: 10),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return index == 1
                                          ? contactsPermission == false
                                              ? AlertBox(
                                                  buttonText: 'FIND YOUR FRIENDS',
                                                  description: 'Oneflix is better with your friends. Enable your phone Contacts to find your friends already on Oneflix.',
                                                  descFontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  onTap: () async {
                                                    await requestContactPermission();
                                                    if (contactsPermission == false) {
                                                      openAppSettings();
                                                    }
                                                  },
                                                  child: Image.asset('assets/images/Oneflix GPS.png', fit: BoxFit.cover),
                                                )
                                              : AlertBox(
                                                  buttonText: 'INVITE YOUR FRIENDS',
                                                  description:
                                                      'Oneflix is better with your friends. Invite your friends to Oneflix so you can discover what they\'re streaming and recommend content to each other.',
                                                  descFontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  onTap: () {
                                                    Share.share('Join me on Oneflix to share and discuss the best content on streaming. https://oneflix.app/');
                                                  },
                                                  child: Image.asset('assets/images/Oneflix Social.png', fit: BoxFit.cover),
                                                )
                                          : index == 3
                                              ? pymkList.length == 0
                                                  ? Container()
                                                  : Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 3.0, vertical: 6),
                                                      padding: EdgeInsets.only(
                                                          top: pymkList.length == 0 && piyaList.length == 0 ? 0 : 14,
                                                          bottom: pymkList.length == 0 && piyaList.length == 0 ? 0 : 14),
                                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                      child: Column(
                                                        children: [
                                                          pymkList.length == 0 /*&& piyaList.length == 0*/
                                                              ? Container()
                                                              : AppText(
                                                                  /* pymkList.length != 0 ?*/ 'PEOPLE YOU MAY KNOW' /*: 'PEOPLE IN YOUR AREA'*/,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w900,
                                                                  fontSize: 18,
                                                                ),
                                                          ListView.separated(
                                                            physics: NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount: /* pymkList.length != 0 ?*/ pymkList.length /* : piyaList.length*/,
                                                            itemBuilder: (context, index) {
                                                              return Padding(
                                                                  padding: const EdgeInsets.only(top: 12.0),
                                                                  child: /*pymkList.length != 0
                                                                ?*/
                                                                      Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap: () {
                                                                          Navigator.push(
                                                                              context, MaterialPageRoute(builder: (context) => VisitorViewScreen(userID: pymkList[index]['id'])));
                                                                        },
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  ClipRRect(
                                                                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                                                    child: CachedImage(
                                                                                      height: 42.0,
                                                                                      width: 42.0,
                                                                                      imageUrl: '$BASE_URL/${pymkList[index]['profile_pic']}',
                                                                                      isUserProfilePic: true,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 8),
                                                                                  AppText(
                                                                                    pymkList[index]['full_name'] ?? 'User',
                                                                                    color: Colors.black,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    textAlign: TextAlign.center,
                                                                                    fontSize: 16,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.push(context,
                                                                                      MaterialPageRoute(builder: (context) => VisitorViewScreen(userID: pymkList[index]['id'])));
                                                                                },
                                                                                child: Container(
                                                                                  width: 90,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Color(0xff4c7ff7),
                                                                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 7.0, bottom: 7.0),
                                                                                    child: Center(
                                                                                      child: AppText(
                                                                                        'Follow',
                                                                                        fontSize: 14.0,
                                                                                        fontWeight: FontWeight.w500,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      pymkList[index]['follow_by_list'].length != 0
                                                                          ? GestureDetector(
                                                                              onTap: () {
                                                                                Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => ConnectionList(followList: pymkList[index]['follow_by_list']),
                                                                                  ),
                                                                                ).then((_) {
                                                                                  _getPeopleKnow();
                                                                                  setState(() {});
                                                                                });
                                                                              },
                                                                              child: Container(
                                                                                width: MediaQuery.of(context).size.width * 0.8,
                                                                                child: AppText(
                                                                                  pymkList[index]['follow_by_list'].length == 1
                                                                                      ? 'Followed by ${pymkList[index]['follow_by_list'][0]['full_name']}'
                                                                                      : 'Followed by ${pymkList[index]['follow_by_list'][0]['full_name']} and ${pymkList[index]['follow_by_list'].length - 1} others',
                                                                                  color: Colors.black,
                                                                                  fontSize: 12,
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : Container(),
                                                                      // SizedBox(height: 10.0),
                                                                      // Divider(height: 1.0, color: Colors.black)
                                                                    ],
                                                                  )
                                                                  /*   : GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) => VisitorViewScreen(userID: piyaList[index]['id']),
                                                                        ),
                                                                      ).then((_) {
                                                                        _getPeopleKnow();
                                                                        setState(() {});
                                                                      });
                                                                    },
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              ClipRRect(
                                                                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                                                child: CachedImage(
                                                                                  height: 42.0,
                                                                                  width: 42.0,
                                                                                  imageUrl: '$BASE_URL/${piyaList[index]['profile_pic']}',
                                                                                  isUserProfilePic: true,
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: 8),
                                                                              AppText(
                                                                                piyaList[index]['full_name'] ?? '',
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold,
                                                                                textAlign: TextAlign.center,
                                                                                fontSize: 18,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Container(
                                                                            width: 90,
                                                                            decoration: BoxDecoration(
                                                                              color: Color(0xff4c7ff7),
                                                                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                                            ),
                                                                            child: Padding(
                                                                              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 7.0, bottom: 7.0),
                                                                              child: Center(child: AppText('Follow', fontSize: 14.0, fontWeight: FontWeight.w500)),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),*/
                                                                  );
                                                            },
                                                            separatorBuilder: (context, index) {
                                                              return Divider(
                                                                color: Colors.black,
                                                                height: 20,
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                              : Container();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            if (_isLoadMoreRunning == true)
                              Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: Center(child: SizedBox(height: 20, width: 20, child: kProgressIndicator)),
                              ),
                          ],
                        ),
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
                )
              ],
            ),
    );
  }

  reportPost(int id) async {
    var jsonData;

    try {
      var response = await Dio().post(
        REPORT_POST,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'content_thirdparty_id': id},
      );
      print(response);
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          jsonData = jsonDecode(response.toString());
          Navigator.pop(context);
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
                        'Thank you for reporting this post. We will review it within 24 hours and remove it immediately if we find it to be in violation of our community guidelines. We\'ll also take further action against the post author if necessary.',
                  );
                },
              );
            },
          );
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

  var follow;

  _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    var jsonData;

    print(userToken);
    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        HOME_DATA,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'page_no': 1},
      );
      // log(response.toString());
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          print('SUCCESS FIRST PAGE LOAD');
          setState(() {
            follow = jsonData['count_following'];
            postList.addAll(jsonData['data']);
            for (int i = 0; i < jsonData['data'].length; i++) {
              focusList.add(FocusNode());
              controllerList.add(TextEditingController());
              friendsCommentView.add(1);
              allCommentView.add(1);
              // print(postList[i]['content_title']);
              videoControllers.add(
                YoutubePlayerController(
                  initialVideoId: jsonData['data'][i]['trailer_url'],
                  params: YoutubePlayerParams(
                    startAt: Duration(seconds: 1),
                    showControls: true,
                    mute: isPlayerMute,
                    loop: true,
                    showFullscreenButton: true,
                    autoPlay: false,
                    showVideoAnnotations: false,
                  ),
                ),
              );
            }
          });
          for (int i = 0; i < postList.length; i++) {
            if (postList[i]['watch_mode_json'] == [] || postList[i]['watch_mode_json'] == '[]' || postList[i]['watch_mode_json'] == null) {
              streamingTrendingIDs.insert(i, 0);
            } else {
              List temp = jsonDecode(postList[i]['watch_mode_json']);

              for (int j = 0; j < temp.length; j++) {
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
        } else {
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  _loadMore() async {
    var jsonData;
    if (_hasNextPage == true && _isFirstLoadRunning == false && _isLoadMoreRunning == false && _controller!.offset >= _controller!.position.maxScrollExtent) {
      setState(() {
        _isLoadMoreRunning = true;
        _page++;
      });
      print('_page: $_page');
      try {
        var response = await Dio().post(
          HOME_DATA,
          options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
          data: {'page_no': _page},
        );
        // log(response.toString());
        if (response.statusCode == 200) {
          if (!mounted) return;
          setState(() {
            _loading = false;
            jsonData = jsonDecode(response.toString());
          });
          if (jsonData['status'] == 1) {
            if (jsonData['data'].length > 0) {
              setState(() {
                postList.addAll(jsonData['data']);
                for (int i = 0; i < jsonData['data'].length; i++) {
                  focusList.add(FocusNode());
                  controllerList.add(TextEditingController());
                  friendsCommentView.add(1);
                  allCommentView.add(1);
                  print(postList[i]['content_title']);
                  videoControllers.add(
                    YoutubePlayerController(
                      initialVideoId: jsonData['data'][i]['trailer_url'],
                      params: YoutubePlayerParams(
                        startAt: Duration(seconds: 1),
                        showControls: true,
                        mute: isPlayerMute,
                        loop: true,
                        showFullscreenButton: true,
                        autoPlay: false,
                        showVideoAnnotations: false,
                      ),
                    ),
                  );
                }
              });
              for (int i = 0; i < postList.length; i++) {
                if (postList[i]['watch_mode_json'] == [] || postList[i]['watch_mode_json'] == null) {
                  streamingTrendingIDs.insert(i, 0);
                } else {
                  List temp = jsonDecode(postList[i]['watch_mode_json']);

                  for (int j = 0; j < temp.length; j++) {
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
            } else {
              setState(() {
                _hasNextPage = false;
              });
            }
          } else {
            Toasty.showtoast(jsonData['message']);
          }
        } else {
          Toasty.showtoast('Something Went Wrong');
        }
      } on DioError catch (e) {
        print(e.response.toString());
      }
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  _addLikeOnPost({var contentThirdPartyId, var contentId, var reactType, var pageNo}) async {
    var jsonData;

    try {
      var response = await Dio().post(
        ADD_LIKE_ON_POST,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'content_third_party_id': contentThirdPartyId, 'content_id': contentId, 'reacted_type': reactType},
      );
      print(response);
      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          await updatePost(pageNo);
        }
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }

  List updatedPost = [];

  updatePost(int pageNo) async {
    var jsonData;

    try {
      var response = await Dio().post(
        HOME_DATA,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'page_no': pageNo},
      );
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            updatedPost.clear();
            updatedPost.addAll(jsonData['data']);
          });

          var j = 0;
          for (int i = (pageNo - 1) * 10; i < ((pageNo - 1) * 10) + updatedPost.length; i++) {
            setState(() {
              postList[i] = updatedPost[j];
              j++;
            });
          }
          for (int i = 0; i < postList.length; i++) {
            if (postList[i]['watch_mode_json'] == [] || postList[i]['watch_mode_json'] == null) {
              streamingTrendingIDs.insert(i, 0);
            } else {
              List temp = jsonDecode(postList[i]['watch_mode_json']);

              for (int j = 0; j < temp.length; j++) {
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

  getAddressFromLatLng({double? lat, double? lng, String? mapApiKey}) async {
    String _host = 'https://maps.google.com/maps/api/geocode/json';
    final url = '$_host?key=$mapApiKey&language=en&latlng=$lat,$lng';
    if (lat != null && lng != null) {
      var response = await Dio().getUri((Uri.parse(url)));
      if (response.statusCode == 200) {
        String _formattedAddress;
        if (!mounted) return;
        setState(() {
          Map data = jsonDecode(response.toString());
          _formattedAddress = data["results"][0]["formatted_address"];
          var split = _formattedAddress.split(',');
          city = split[split.length - 3].trimLeft();
          country = split[split.length - 1].trimLeft();
          List<String> strings = split[split.length - 2].split(" ");
          var res = strings.where((element) => element != strings.first);
          state = res.elementAt(0);
        });
      } else
        return null;
    } else
      return null;
  }

  _updateProfile(int type) async {
    var jsonData;
    InitialData getLocation = InitialData();
    setState(() {
      _loading = true;
    });
    if (type == 1) {
      await getLocation.getCurrentLocation();
      await getAddressFromLatLng(lat: getLocation.latitude, lng: getLocation.longitude, mapApiKey: 'AIzaSyCp4l1LbSEK9pyTaq-GbIlNY_Pkqpt0uus');
    }

    try {
      var response = await Dio().post(
        UPDATE_PROFILE,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: type == 1
            ? {
                'lattitude': getLocation.latitude!,
                'longitude': getLocation.longitude!,
                'country': country,
                'state': state,
                'city': city,
              }
            : {},
      );
      print(response);
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData != null) {
          if (!mounted) return;
          setState(() {
            userID = jsonData['data']['id'];
            profilePic = jsonData['data']['profile_pic'];
            _loading = false;
          });
        }
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }

  Future<void> _getPeopleKnow() async {
    var jsonData;
    print(userToken);
    if (!mounted) return;
    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        GET_PEOPLE_YOU_MAY_KNOW,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
      );
      log(response.toString());
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            pymkList = jsonData['PYMK'];
            print(pymkList);
            print('pymkList');
            piyaList = jsonData['PIYA'];
            if (pymkList.length != 0) {
              for (int i = 0; i < pymkList.length; i++) {
                followByPymkList.add(pymkList[i]['follow_by_list']);
              }
            }
          });
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

  updateContacts() async {
    try {
      var response = await Dio().post(
        ADD_CONTACT,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'contact_diary': jsonEncode(contactList)},
      );
      print(response);
      if (response.statusCode == 200) {
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }
}

class ReactButton extends StatelessWidget {
  final String icon;
  const ReactButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Image.asset('$ICON_URL/$icon.png', height: 26, width: 26);
  }
}
