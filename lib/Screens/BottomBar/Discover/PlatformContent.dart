import 'dart:convert';
import 'dart:developer';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feed_reaction/flutter_feed_reaction.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Components/LiveDot.dart';
import 'package:oneflix/Screens/BottomBar/Home/HomeScreen.dart';
import 'package:oneflix/Screens/BottomBar/Home/PostContentUserListScreen.dart';
import 'package:oneflix/Screens/BottomBar/Profile/UserViewScreen.dart';
import 'package:oneflix/Screens/BottomBar/Profile/VisitorViewScreen.dart';
import 'package:oneflix/Screens/BottomBar/Trending/TrendingScreen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../Constants.dart';
import '../../SplashScreen.dart';

class PlatformContent extends StatefulWidget {
  final int id;
  final int contentType;
  final trailerUrl;
  const PlatformContent({Key? key, required this.id, required this.contentType, this.trailerUrl}) : super(key: key);

  @override
  _PlatformContentState createState() => _PlatformContentState();
}

class _PlatformContentState extends State<PlatformContent> {
  int selectedIndex = 1;
  bool recommended = false;
  bool addedToWatchList = false;
  bool buttonVisible = false;
  var content;
  var watchData;
  var postDetails;
  var trailerKey;
  int? watchModeId;
  var commentId;
  var contentId;
  var commentIndex;
  var contentThirdPartyId;
  String userName = '';
  int commentType = 0; // 1=friends, 2=others
  var activityOnPageNo;
  List streamData = [];
  late YoutubePlayerController _controller;
  bool isShowEdit = false;
  bool isExpanded = false;
  List sourceID = [];

  var _editFocus = FocusNode();
  var _replyFocus = FocusNode();
  var focusNode = FocusNode();
  TextEditingController commentController = TextEditingController();
  TextEditingController replyController = TextEditingController();
  TextEditingController editController = TextEditingController();

  var updatedLikeOnCommentData;

  ///OTHER COMMENTS
  int otherCommentsView = 5;
  int othersPageNo = 1;
  String otherCommentText = 'View more Comments';
  bool otherCommentsLoadMore = true;
  List otherCommentsList = [];
  List othersReplyVisibility = [];
  List updatedOtherCommentList = [];
  bool _isOtherCommentListLoading = false;

  ///FRIENDS COMMENTS
  int friendsCommentView = 5;
  int friendsPageNo = 1;
  String friendsCommentText = 'View more Comments';
  bool friendsCommentsLoadMore = true;
  List friendsCommentsList = [];
  List friendsReplyVisibility = [];
  List updatedFriendsCommentList = [];
  bool _isFriendsCommentListLoading = false;
  bool isPlayerMute = false;

  bool isShow = false;
  @override
  void initState() {
    getToken();
    print(widget.id);
    print(widget.contentType);
    super.initState();
  }

  _launchInBrowser(String url) async {
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

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    double mHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Color(0xff011138),
          body: content == null
              ? Center(child: SizedBox(height: 20, width: 20, child: kProgressIndicator))
              : ModalProgressHUD(
                  opacity: 0,
                  inAsyncCall: _loading,
                  progressIndicator: SizedBox(height: 20, width: 20, child: kProgressIndicator),
                  child: content == null /*|| postDetails == null*/
                      ? Container()
                      : Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            ListView(
                              shrinkWrap: true,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          CachedImage(
                                            imageUrl: 'https://image.tmdb.org/t/p/original/${content['backdrop_path']}',
                                            width: mWidth,
                                            height: 240,
                                          ),
                                          Positioned(
                                            right: 20,
                                            bottom: 30,
                                            child: Container(
                                              // width: mWidth * 0.4,
                                              alignment: Alignment.center,
                                              child: Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _addToWatchList(contentThirdPartyId: widget.id, contentType: widget.contentType);
                                                    },
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      height: 40,
                                                      width: 90,
                                                      color: addedToWatchList == false ? Colors.black : Colors.green,
                                                      padding: EdgeInsets.symmetric(horizontal: 6),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          addedToWatchList == false
                                                              ? Icon(Icons.add, size: 20, color: Colors.white)
                                                              : Icon(Icons.done, size: 20, color: Colors.white),
                                                          AppText(
                                                            addedToWatchList == false ? 'My List'.toUpperCase() : 'Added',
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 14,
                                            left: 4,
                                            child: IconButton(
                                              splashRadius: 30,
                                              icon: Icon(Icons.chevron_left_rounded, size: 38, color: Colors.white),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      trailerKey != null
                                          ? YoutubePlayerIFrame(
                                              controller: YoutubePlayerController(
                                                initialVideoId: trailerKey,
                                                params: YoutubePlayerParams(
                                                  startAt: Duration(seconds: 5),
                                                  showControls: true,
                                                  mute: isPlayerMute,
                                                  loop: true,
                                                  showFullscreenButton: true,
                                                  autoPlay: true,
                                                  showVideoAnnotations: false,
                                                ),
                                              )..play(),
                                            )
                                          : Container(),
                                      Container(
                                        color: Color(0xff011138),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        AppText(content['title'] ?? content['name'], fontSize: 13, color: Colors.blueGrey.shade300, fontWeight: FontWeight.w900),
                                                        GestureDetector(
                                                          // onTap: () {
                                                          //   setState(() {
                                                          //     isExpanded = !isExpanded;
                                                          //   });
                                                          // },
                                                          child: AppText(
                                                            content['overview'],
                                                            fontSize: 11,
                                                            color: Colors.blueGrey.shade300,
                                                            maxLines: /*isExpanded ? 100 : 2*/ 100,
                                                          ),
                                                        ),
                                                        SizedBox(height: 6),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 6),
                                                                child: Row(
                                                                  children: [
                                                                    CircularPercentIndicator(
                                                                      radius: 42.0,
                                                                      lineWidth: 2.0,
                                                                      percent: content['vote_average'] / 10,
                                                                      center: AppText((content['vote_average'] * 10).toInt().toString() + "%",
                                                                          color: Colors.blueGrey.shade300, fontWeight: FontWeight.w900, fontSize: 12),
                                                                      progressColor: Colors.greenAccent,
                                                                      backgroundColor: Colors.green.shade900,
                                                                      circularStrokeCap: CircularStrokeCap.round,
                                                                    ),
                                                                    SizedBox(width: 6),
                                                                    AppText("People like this", color: Colors.blueGrey.shade300, fontSize: 13),
                                                                  ],
                                                                ),
                                                              ),
                                                              AppText(
                                                                widget.contentType == 0
                                                                    ? content['release_date'] == null || content['release_date'] == ''
                                                                        ? ''
                                                                        : formatDate(DateTime.parse(content['release_date']))
                                                                    : content['first_air_date'] == null || content['first_air_date'] == ''
                                                                        ? ''
                                                                        : formatDate(DateTime.parse(content['first_air_date'])),
                                                                color: Colors.blueGrey.shade300,
                                                                fontSize: 12,
                                                              ),
                                                              // for (var genre in content['genres']) BorderedTag(tag: genre['name']),
                                                              // for (int i = 0; i < (content['genres'].length < 3 ? content['genres'].length : 3); i++) BorderedTag(tag: content['genres'][i]['name']),
                                                              content['runtime'] == null && (content['episode_run_time'] as List).isEmpty
                                                                  ? AppText("0 min", color: Colors.blueGrey.shade300, fontSize: 12)
                                                                  : AppText("${content['runtime'] ?? content['episode_run_time'][0]} min",
                                                                      color: Colors.blueGrey.shade300, fontSize: 12),
                                                              // GestureDetector(
                                                              //   onTap: () {
                                                              //     print('CONTENT DETAILS');
                                                              //     showDialog(
                                                              //       barrierDismissible: false,
                                                              //       barrierColor: Colors.black.withOpacity(0.9),
                                                              //       context: context,
                                                              //       builder: (context) {
                                                              //         return StatefulBuilder(
                                                              //           builder: (context, setState) {
                                                              //             return Stack(
                                                              //               alignment: Alignment.center,
                                                              //               children: [
                                                              //                 trailerKey != null ? SizedBox(height: 20, width: 20, child: kProgressIndicator) : Container(),
                                                              //                 trailerKey != null
                                                              //                     ? YoutubePlayerIFrame(controller: _controller)
                                                              //                     : Container(
                                                              //                         margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 40),
                                                              //                         child: AppText('Trailer is not available currently.', textAlign: TextAlign.center),
                                                              //                         alignment: Alignment.center,
                                                              //                       ),
                                                              //                 Positioned(
                                                              //                   top: 0,
                                                              //                   right: 0,
                                                              //                   child: GestureDetector(
                                                              //                     onTap: () => Navigator.pop(context),
                                                              //                     child: Icon(Icons.close, color: Colors.white, size: 30),
                                                              //                   ),
                                                              //                 )
                                                              //               ],
                                                              //             );
                                                              //           },
                                                              //         );
                                                              //       },
                                                              //     );
                                                              //   },
                                                              //   child: Container(
                                                              //     padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 7),
                                                              //     decoration: BoxDecoration(color: Colors.blueGrey.shade300, borderRadius: BorderRadius.circular(4)),
                                                              //     child: AppText('WATCH TRAILER', fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                                              //   ),
                                                              // )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(color: Colors.grey, height: 0, thickness: 0.2),
                                            Container(
                                              alignment: Alignment.center,
                                              color: Color(0xff011138),
                                              padding: EdgeInsets.symmetric(horizontal: 6),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      AppText('Where to watch'.toUpperCase(), color: Colors.blueGrey.shade300, fontWeight: FontWeight.bold, fontSize: 16),
                                                    ],
                                                  ),
                                                  streamData == [] || streamData.isEmpty || streamData.length == 0
                                                      ? Container(
                                                          margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
                                                          child: AppText(
                                                            'This content is not currently available on any streaming providers. Add it to your watchlist and we\'ll notify you later when it becomes available on streaming.',
                                                            textAlign: TextAlign.start,
                                                            fontSize: 13,
                                                            color: Colors.white60,
                                                          ),
                                                          alignment: Alignment.center,
                                                        )
                                                      : Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
                                                          child: ListView.separated(
                                                            shrinkWrap: true,
                                                            itemCount: streamData.length,
                                                            physics: BouncingScrollPhysics(),
                                                            itemBuilder: (context, index) {
                                                              return GestureDetector(
                                                                onTap: () async {
                                                                  await streamData[index]['source_id'];
                                                                  showDialog(
                                                                    barrierDismissible: false,
                                                                    barrierColor: Colors.black.withOpacity(0.9),
                                                                    context: context,
                                                                    builder: (context) {
                                                                      return StatefulBuilder(
                                                                        builder: (context, setState) {
                                                                          return Stack(
                                                                            alignment: Alignment.center,
                                                                            children: [
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: MediaQuery.of(context).size.height * 0.15,
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                                    child: AppText(
                                                                                        "For users outside of the United States, some streaming content may not be available in your country due to different streaming copyrights for different countries.",
                                                                                        color: Colors.white,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        textAlign: TextAlign.center,
                                                                                        fontSize: 16),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: MediaQuery.of(context).size.height * 0.15,
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 40),
                                                                                    child: GestureDetector(
                                                                                      onTap: () async {
                                                                                        print('web Url: ${streamData[index]['web_url']}');
                                                                                        var url;
                                                                                        setState(() {
                                                                                          url = streamData[index]['web_url'];
                                                                                          // print(url);
                                                                                        });

                                                                                        _launchInBrowser(url);
                                                                                        _updateSourceImpressions(contentThirdPartyId: widget.id);
                                                                                      },
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        decoration: BoxDecoration(color: Colors.black),
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              Image.asset(
                                                                                                '$PROVIDER_URL/${streamData[index]['source_id'] == 203 ? 'Netflix.jpeg' : streamData[index]['source_id'] == 26 ? 'Amazon.jpeg' : streamData[index]['source_id'] == 372 ? 'Disney.jpeg' : streamData[index]['source_id'] == 157 ? 'Hulu.jpeg' : streamData[index]['source_id'] == 387 ? 'HBO Max.jpeg' : streamData[index]['source_id'] == 444 ? 'Paramount Plus.jpeg' : streamData[index]['source_id'] == 388 || streamData[index]['source_id'] == 389 ? 'Peacock.jpeg' : streamData[index]['source_id'] == 371 ? 'Apple TV.png' : streamData[index]['source_id'] == 445 ? 'Discovery.jpeg' : streamData[index]['source_id'] == 248 ? 'Showtime.jpeg' : streamData[index]['source_id'] == 232 ? 'Starz.png' : streamData[index]['source_id'] == 296 ? 'Tubi.jpeg' : streamData[index]['source_id'] == 391 ? 'Pluto.png' : 'Web.png'}',
                                                                                                height: 44,
                                                                                                fit: BoxFit.cover,
                                                                                              ),
                                                                                              AppText(
                                                                                                streamData[index]['type'] == 'sub' ? 'SUBSCRIPTION' : 'FREE',
                                                                                                color: Colors.white,
                                                                                                fontWeight: FontWeight.bold,
                                                                                                fontSize: 14,
                                                                                              ),
                                                                                              Icon(Icons.chevron_right, size: 36, color: Colors.white)
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: MediaQuery.of(context).size.height * 0.15,
                                                                                  ),
                                                                                ],
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
                                                                child: Container(
                                                                  width: double.infinity,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Image.asset(
                                                                          '$PROVIDER_URL/${streamData[index]['source_id'] == 203 ? 'Netflix.jpeg' : streamData[index]['source_id'] == 26 ? 'Amazon.jpeg' : streamData[index]['source_id'] == 372 ? 'Disney.jpeg' : streamData[index]['source_id'] == 157 ? 'Hulu.jpeg' : streamData[index]['source_id'] == 387 ? 'HBO Max.jpeg' : streamData[index]['source_id'] == 444 ? 'Paramount Plus.jpeg' : streamData[index]['source_id'] == 388 || streamData[index]['source_id'] == 389 ? 'Peacock.jpeg' : streamData[index]['source_id'] == 371 ? 'Apple TV.png' : streamData[index]['source_id'] == 445 ? 'Discovery.jpeg' : streamData[index]['source_id'] == 248 ? 'Showtime.jpeg' : streamData[index]['source_id'] == 232 ? 'Starz.png' : streamData[index]['source_id'] == 296 ? 'Tubi.jpeg' : streamData[index]['source_id'] == 391 ? 'Pluto.png' : 'Web.png'}',
                                                                          height: 44,
                                                                          fit: BoxFit.cover,
                                                                        ),
                                                                        AppText(
                                                                          streamData[index]['type'] == 'sub' ? 'SUBSCRIPTION' : 'FREE',
                                                                          color: Colors.white,
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: 14,
                                                                        ),
                                                                        Icon(Icons.chevron_right, size: 36, color: Colors.white)
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            separatorBuilder: (context, index) {
                                                              return Divider(color: Colors.white30);
                                                            },
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ),
                                            // clipList.length == 0 ? Container() : Divider(color: Colors.grey, height: 1, thickness: 1),
                                            // clipList.length == 0
                                            //     ? Container()
                                            //     : Padding(
                                            //         padding: const EdgeInsets.only(top: 20),
                                            //         child: Container(
                                            //           alignment: Alignment.centerLeft,
                                            //           margin: EdgeInsets.symmetric(horizontal: 20),
                                            //           height: 175,
                                            //           child: Column(
                                            //             crossAxisAlignment: CrossAxisAlignment.start,
                                            //             mainAxisAlignment: MainAxisAlignment.start,
                                            //             children: [
                                            //               AppText(
                                            //                 'Content Clips',
                                            //                 color: Colors.white,
                                            //                 fontSize: 16,
                                            //                 fontWeight: FontWeight.bold,
                                            //                 fontFamily: "OpenSans",
                                            //               ),
                                            //               Expanded(
                                            //                 child: ListView.builder(
                                            //                   shrinkWrap: true,
                                            //                   scrollDirection: Axis.horizontal,
                                            //                   itemCount: clipList.length,
                                            //                   itemBuilder: (context, index1) {
                                            //                     return Padding(
                                            //                       padding: const EdgeInsets.only(right: 20, bottom: 20),
                                            //                       child: Stack(
                                            //                         alignment: Alignment.center,
                                            //                         children: [
                                            //                           Container(
                                            //                             decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white)),
                                            //                             child: CachedImage(
                                            //                               imageUrl: 'https://img.youtube.com/vi/${clipList[index1]['key']}/maxresdefault.jpg',
                                            //                               width: MediaQuery.of(context).size.width * 0.42,
                                            //                               height: 120,
                                            //                               radius: 6,
                                            //                               colors: Colors.white,
                                            //                               thikness: 0.5,
                                            //                               fit: BoxFit.cover,
                                            //                             ),
                                            //                           ),
                                            //                           GestureDetector(
                                            //                             onTap: () {
                                            //                               showDialog(
                                            //                                 barrierDismissible: true,
                                            //                                 barrierColor: Colors.black.withOpacity(0.9),
                                            //                                 context: context,
                                            //                                 builder: (context) {
                                            //                                   return StatefulBuilder(
                                            //                                     builder: (context, setState) {
                                            //                                       return Stack(
                                            //                                         alignment: Alignment.center,
                                            //                                         children: [
                                            //                                           clipList[index1]['key'] != null
                                            //                                               ? SizedBox(height: 20, width: 20, child: kProgressIndicator)
                                            //                                               : Container(),
                                            //                                           clipList[index1]['key'] != null
                                            //                                               ? YoutubePlayerIFrame(
                                            //                                                   controller: YoutubePlayerController(
                                            //                                                     initialVideoId: clipList[index1]['key'],
                                            //                                                     params: YoutubePlayerParams(
                                            //                                                       startAt: Duration(seconds: 1),
                                            //                                                       showControls: true,
                                            //                                                       mute: false,
                                            //                                                       loop: true,
                                            //                                                       showFullscreenButton: true,
                                            //                                                       autoPlay: true,
                                            //                                                       showVideoAnnotations: false,
                                            //                                                     ),
                                            //                                                   )..play(),
                                            //                                                 )
                                            //                                               : Container(
                                            //                                                   margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 40),
                                            //                                                   child: AppText('Trailer is not available currently.', textAlign: TextAlign.center),
                                            //                                                   alignment: Alignment.center,
                                            //                                                 ),
                                            //                                           Positioned(
                                            //                                             top: 0,
                                            //                                             right: 0,
                                            //                                             child: GestureDetector(
                                            //                                               onTap: () => Navigator.pop(context),
                                            //                                               child: Icon(Icons.close, color: Colors.white, size: 30),
                                            //                                             ),
                                            //                                           )
                                            //                                         ],
                                            //                                       );
                                            //                                     },
                                            //                                   );
                                            //                                 },
                                            //                               );
                                            //                             },
                                            //                             child: Icon(
                                            //                               /*  value.playerState == PlayerState.playing ? Icons.pause :*/ Icons.play_arrow_rounded,
                                            //                               size: 50,
                                            //                               color: Colors.white,
                                            //                             ),
                                            //                           ),
                                            //                           // Positioned(
                                            //                           //   top: 10,
                                            //                           //   left: 20,
                                            //                           //   child: Image.asset(
                                            //                           //     '$TRENDING_URL/${comingSoonData[index1]['title'] == 'Netflix' ? 'NetflixNew' : comingSoonData[index1]['title'] == 'Amazon' ? 'AmazonPrime' : comingSoonData[index1]['title'] == 'Disney' ? 'Disney' : comingSoonData[index1]['title'] == 'Hulu' ? 'Hulu' : comingSoonData[index1]['title'] == 'HBO Max' ? 'HBOMax' : comingSoonData[index1]['title'] == 'Paramount' ? 'Paramount' : comingSoonData[index1]['title'] == 'Peacock' ? 'Peacock' : comingSoonData[index1]['title'] == 'Apple TV' ? 'AppleTV' : comingSoonData[index1]['title'] == 445 ? 'DiscoveryPlus' : comingSoonData[index1]['title'] == 248 ? 'Showtime' : comingSoonData[index1]['title'] == 232 ? 'Starz' : comingSoonData[index1]['title'] == 296 ? 'Tubi' : comingSoonData[index1]['title'] == 391 ? 'Pluto' : ' '}.png',
                                            //                           //     height: 70,
                                            //                           //     width: 70,
                                            //                           //   ),
                                            //                           // ),
                                            //                         ],
                                            //                       ),
                                            //                     );
                                            //                   },
                                            //                 ),
                                            //               ),
                                            //             ],
                                            //           ),
                                            //         ),
                                            //       ),
                                            Divider(color: Colors.grey, height: 1, thickness: 0.2),
                                            Padding(
                                              padding: const EdgeInsets.all(14.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  _addToRecommended(
                                                    contentType: widget.contentType,
                                                    votes: content['vote_average'],
                                                    contentThirdPartyId: widget.id,
                                                    contentDescription: content['overview'],
                                                    title: content['title'] ?? content['name'],
                                                    posterPath: content['poster_path'],
                                                    coverPhotoPath: content['backdrop_path'],
                                                    runningTime: content['runtime'] == null && (content['episode_run_time'] as List).isEmpty
                                                        ? 0
                                                        : widget.contentType == 0
                                                            ? content['runtime']
                                                            : content['episode_run_time'][0],
                                                    releaseYear: widget.contentType == 0 ? content['release_date'] : content['first_air_date'],
                                                    trailerUrl: trailerKey == null || trailerKey == 'null' || trailerKey == '' ? 'null' : trailerKey,
                                                    tags: jsonEncode(content['genres']),
                                                    watchModeId: watchModeId!,
                                                    streamingProvider: jsonEncode(streamData),
                                                  );
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 60,
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: recommended == false ? kPrimaryColor : Colors.green),
                                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                                  child: AppText(
                                                    recommended == false ? 'Recommend this to Friends'.toUpperCase() : 'You\'ve recommended it'.toUpperCase(),
                                                    color: recommended == false ? Colors.white : Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      postDetails == null ||
                                              postDetails['count_recommended'] == 0 ||
                                              (postDetails['first_rec_user_name'] == null && postDetails['first_null_user_name'] == null)
                                          ? Container()
                                          : Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          WidgetSpan(
                                                            child: Text(
                                                              'Recommended by ',
                                                              style: TextStyle(color: Colors.black, fontSize: 13, fontFamily: 'OpenSans'),
                                                            ),
                                                          ),
                                                          WidgetSpan(
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(20),
                                                              child: CachedImage(
                                                                  imageUrl:
                                                                      "$BASE_URL/${postDetails['first_rec_user_name'] == null ? postDetails['first_null_profile_pic'] : postDetails['profile_pic']}",
                                                                  isUserProfilePic: true,
                                                                  height: 18,
                                                                  width: 18,
                                                                  loaderSize: 10),
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: postDetails['first_rec_user_name'] == null || postDetails['first_rec_user_name'] == 'null'
                                                                ? ' ${postDetails['first_null_user_name']}'
                                                                : ' ${postDetails['first_rec_user_name']}',
                                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13, fontFamily: 'OpenSans'),
                                                            recognizer: TapGestureRecognizer()
                                                              ..onTap = () {
                                                                if (postDetails['login_user_id'] == postDetails['activity_by']) {
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) => UserViewScreen(userId: postDetails['activity_by']),
                                                                    ),
                                                                  );
                                                                } else {
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) => VisitorViewScreen(
                                                                          userID: postDetails['first_rec_user_name'] == null
                                                                              ? postDetails['first_null_activity_by']
                                                                              : postDetails['activity_by']),
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                          ),
                                                          TextSpan(
                                                            text: (postDetails['count_recommended'] - 1 != 0) ? ' and' : '',
                                                            style: TextStyle(color: Colors.black, fontSize: 13, fontFamily: 'OpenSans'),
                                                          ),
                                                          TextSpan(
                                                            text: postDetails['count_recommended'] - 1 == 1
                                                                ? ' ${postDetails['count_recommended'] - 1} other'
                                                                : postDetails['count_recommended'] - 1 > 1
                                                                    ? ' ${postDetails['count_recommended'] - 1} others'
                                                                    : '',
                                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13, fontFamily: 'OpenSans'),
                                                            recognizer: TapGestureRecognizer()
                                                              ..onTap = () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => PostContentUserListScreen(
                                                                      loginUserId: postDetails['login_user_id'],
                                                                      contentThirdPartyId: postDetails['content_third_party_id'],
                                                                      activityType: 1,
                                                                      title: 'Recommended',
                                                                    ),
                                                                  ),
                                                                );
                                                              },
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
                                      postDetails == null || postDetails['count_recommended'] == 0 || postDetails['first_rec_user_name'] == null
                                          ? Container()
                                          : Divider(color: Colors.black),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset('$ICON_URL/Like Icon.png', height: 20, width: 20),
                                                SizedBox(width: 5),
                                                AppText(postDetails == null ? '0' : postDetails['normal_like'].toString(),
                                                    fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10),
                                              ],
                                            ),
                                            SizedBox(width: 10.0),
                                            Row(
                                              children: [
                                                Image.asset('$ICON_URL/laugh.png', height: 20, width: 20),
                                                SizedBox(width: 5),
                                                AppText(postDetails == null ? '0' : postDetails['haha_like'].toString(),
                                                    fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10),
                                              ],
                                            ),
                                            SizedBox(width: 10.0),
                                            Row(
                                              children: [
                                                Image.asset('$ICON_URL/wow.png', height: 20, width: 20),
                                                SizedBox(width: 5),
                                                AppText(postDetails == null ? '0' : postDetails['cry_like'].toString(),
                                                    fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10),
                                              ],
                                            ),
                                            SizedBox(width: 10.0),
                                            Row(
                                              children: [
                                                Image.asset('$ICON_URL/angry.png', height: 20, width: 20),
                                                SizedBox(width: 5),
                                                AppText(postDetails == null ? '0' : postDetails['angry_like'].toString(),
                                                    fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10),
                                              ],
                                            ),
                                            SizedBox(width: 10.0),
                                            Row(
                                              children: [
                                                Image.asset('$ICON_URL/heart.png', height: 20, width: 20),
                                                SizedBox(width: 5),
                                                AppText(postDetails == null ? '0' : postDetails['love_like'].toString(),
                                                    fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10),
                                              ],
                                            ),
                                            SizedBox(width: 10.0),
                                            Row(
                                              children: [
                                                Image.asset('$ICON_URL/cry.png', height: 20, width: 20),
                                                SizedBox(width: 5),
                                                AppText(postDetails == null ? '0' : postDetails['sad_like'].toString(),
                                                    fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10),
                                              ],
                                            ),
                                          ],
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
                                                _addLikeOnPost(
                                                  contentId: postDetails['content_id'] ?? 0,
                                                  contentThirdPartyId: postDetails['content_third_party_id'],
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
                                                print(postDetails['content_id']);
                                                print(postDetails['content_third_party_id']);
                                                _addLikeOnPost(
                                                  contentId: postDetails['content_id'] ?? 0,
                                                  contentThirdPartyId: postDetails['content_third_party_id'],
                                                  reactType: 1,
                                                );
                                              },
                                              prefix: postDetails == null || postDetails['is_like_me'] == 0
                                                  ? Image.asset('$ICON_URL/thumb.png', width: 26.0, height: 26.0)
                                                  : Image.asset('$ICON_URL/Like Icon.png', width: 24.0, height: 24.0),
                                              suffix: AppText(postDetails == null || postDetails['is_like_me'] == 0 ? "Like" : "Liked", color: Colors.black, fontSize: 12),
                                            ),
                                            postDetails == null || postDetails['comment_count'] == 0
                                                ? Container()
                                                : AppText('${postDetails['comment_count']} ${postDetails['comment_count'] == 1 ? "Comment" : "Comments"} ',
                                                    color: Colors.black, fontSize: 13),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      friendsCommentsList.length == 0 && otherCommentsList.length == 0
                                          ? Visibility(
                                              visible: buttonVisible == true ? false : true,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    buttonVisible = true;
                                                  });
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: MediaQuery.of(context).size.width * 0.60,
                                                  // padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                                  decoration: BoxDecoration(color: Color(0xffeaeef7), borderRadius: BorderRadius.circular(10)),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Image.asset('$ICON_URL/Comment.png', height: 20, width: 20),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          'make a comment'.toUpperCase(),
                                                          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'OpenSans', fontSize: 16, color: Color(0xff4960f6)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      buttonVisible == true || friendsCommentsList.length != 0 || otherCommentsList.length != 0
                                          ? Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                              child: CommentField(
                                                focusNode: focusNode,
                                                controller: commentController,
                                                hintText: 'Write a comment...',
                                                input: TextInputType.multiline,
                                                onSend: () {
                                                  _addCommentOnPost(
                                                    commentId: 0,
                                                    commentType: 0,
                                                    contentThirdPartyId: widget.id,
                                                    contentId: content['content_id'],
                                                    commentText: commentController.text,
                                                    controller: commentController,
                                                  );
                                                  FocusScope.of(context).requestFocus(new FocusNode());
                                                },
                                              ),
                                            )
                                          : Container(),
                                      friendsCommentsList.length == 0 || otherCommentsList.length == 0
                                          ? Container()
                                          : Column(
                                              children: [
                                                AppText("Friends Comments".toUpperCase(), fontWeight: FontWeight.w900, color: Colors.black, fontSize: 13),
                                                SizedBox(height: 6),
                                              ],
                                            ),
                                      friendsCommentsList.length == 0
                                          ? Container()
                                          : Row(
                                              children: [
                                                Expanded(
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemCount: friendsCommentsList.length < 5 ? friendsCommentsList.length : friendsCommentView,
                                                    itemBuilder: (BuildContext context, int index1) {
                                                      return Column(
                                                        children: [
                                                          CommentFrame(
                                                            isSubEditComment: true,
                                                            userID: friendsCommentsList[index1]['user_id'],
                                                            name: friendsCommentsList[index1]['full_name'] == null ? 'Deleted User' : friendsCommentsList[index1]['full_name'],
                                                            profile: "$BASE_URL/${friendsCommentsList[index1]['profile_pic']}",
                                                            comment: friendsCommentsList[index1]['comment_text'],
                                                            likeCounts: '  ${friendsCommentsList[index1]['count_likes']}  ',
                                                            totalLikeCount: friendsCommentsList[index1]['count_likes'],
                                                            isLiked: friendsCommentsList[index1]['is_like_me'] == 0 ? false : true,
                                                            onLike: () {
                                                              _addLikeOnComment(
                                                                commentType: 1,
                                                                index: index1,
                                                                pageNo: friendsCommentsList[index1]['page_no'],
                                                                commentId: friendsCommentsList[index1]['comment_id'],
                                                              );
                                                              setState(() {
                                                                commentIndex = index1;
                                                              });
                                                            },
                                                            onComment: () {
                                                              setState(() {
                                                                isShow = true;
                                                                commentIndex = index1;
                                                                commentType = 1;
                                                                userName = friendsCommentsList[index1]['full_name'];
                                                                commentId = friendsCommentsList[index1]['comment_id'];
                                                                activityOnPageNo = friendsCommentsList[index1]['page_no'];
                                                                contentId = friendsCommentsList[index1]['content_id'] ?? 0;
                                                                contentThirdPartyId = friendsCommentsList[index1]['content_thirdparty_id'];
                                                              });
                                                              _replyFocus.requestFocus();
                                                            },
                                                            onEdit: () {
                                                              print(friendsCommentsList[index1]['comment_text']);
                                                              setState(() {
                                                                isShowEdit = true;
                                                                commentIndex = index1;
                                                                commentType = 1;
                                                                activityOnPageNo = friendsCommentsList[index1]['page_no'];
                                                                commentId = friendsCommentsList[index1]['comment_id'];
                                                                contentId = friendsCommentsList[index1]['content_id'] ?? 0;
                                                                contentThirdPartyId = friendsCommentsList[index1]['content_thirdparty_id'];
                                                                editController = TextEditingController(text: friendsCommentsList[index1]['comment_text']);
                                                              });
                                                              _editFocus.requestFocus();
                                                            },
                                                            countReply: friendsReplyVisibility[index1] == true
                                                                ? 1
                                                                : friendsCommentsList[index1]['is_comments'] == 1
                                                                    ? 0
                                                                    : 1,
                                                            viewReply: () {
                                                              setState(() {
                                                                if (friendsCommentsList[index1]['count_replys'] > 0) {
                                                                  friendsCommentsList[index1]['count_replys'] = 0;
                                                                  friendsCommentsList[index1]['is_comments'] = 1;
                                                                  friendsReplyVisibility[index1] = false;
                                                                } else {
                                                                  friendsCommentsList[index1]['count_replys'] = (friendsCommentsList[index1]['reply_data'] as List).length;
                                                                  friendsCommentsList[index1]['is_comments'] = 0;
                                                                  friendsReplyVisibility[index1] = true;
                                                                }
                                                                print(friendsReplyVisibility);
                                                              });
                                                            },
                                                            lengthReply: (friendsCommentsList[index1]['reply_data'] as List).length,
                                                            onTap: () {
                                                              if (postDetails['login_user_id'] == friendsCommentsList[index1]['user_id']) {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => UserViewScreen(userId: friendsCommentsList[index1]['user_id']),
                                                                  ),
                                                                );
                                                              } else {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => VisitorViewScreen(userID: friendsCommentsList[index1]['user_id']),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                            onMoreMenu: () {
                                                              reportComment(
                                                                friendsCommentsList[index1]['content_thirdparty_id'],
                                                                friendsCommentsList[index1]['comment_id'],
                                                              );
                                                            },
                                                          ),
                                                          (friendsCommentsList[index1]['reply_data'] as List).length == 0
                                                              ? Container()
                                                              : ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  itemCount: friendsReplyVisibility[index1] == true
                                                                      ? friendsCommentsList[index1]['count_replys']
                                                                      : friendsCommentsList[index1]['is_comments'] == 1
                                                                          ? 0
                                                                          : friendsCommentsList[index1]['count_replys'],
                                                                  itemBuilder: (context, index2) {
                                                                    return CommentFrame(
                                                                      isSubEditComment: true,
                                                                      userID: friendsCommentsList[index1]['reply_data'][index2]['user_id'],
                                                                      isSubComment: true,
                                                                      name: friendsCommentsList[index1]['reply_data'][index2]['full_name'] == null
                                                                          ? 'Deleted User'
                                                                          : friendsCommentsList[index1]['reply_data'][index2]['full_name'],
                                                                      profile: "$BASE_URL/${friendsCommentsList[index1]['reply_data'][index2]['profile_pic']}",
                                                                      comment: friendsCommentsList[index1]['reply_data'][index2]['comment_text'],
                                                                      likeCounts: '  ${friendsCommentsList[index1]['reply_data'][index2]['count_likes']}  ',
                                                                      totalLikeCount: friendsCommentsList[index1]['reply_data'][index2]['count_likes'],
                                                                      isLiked: friendsCommentsList[index1]['reply_data'][index2]['is_like_me'] == 0 ? false : true,
                                                                      onMoreMenu: () {
                                                                        reportComment(
                                                                          friendsCommentsList[index1]['content_thirdparty_id'],
                                                                          friendsCommentsList[index1]['reply_data'][index2]['comment_id'],
                                                                        );
                                                                      },
                                                                      onLike: () {
                                                                        _addLikeOnComment(
                                                                          commentType: 1,
                                                                          isSubComment: true,
                                                                          index: index1,
                                                                          pageNo: friendsCommentsList[index1]['page_no'],
                                                                          commentId: friendsCommentsList[index1]['reply_data'][index2]['comment_id'],
                                                                        );
                                                                        setState(() {
                                                                          commentIndex = index1;
                                                                        });
                                                                      },
                                                                      onEdit: () {
                                                                        setState(() {
                                                                          isShowEdit = true;
                                                                          commentIndex = index1;
                                                                          commentType = 1;
                                                                          commentId = friendsCommentsList[index1]['reply_data'][index2]['comment_id'];
                                                                          contentId = friendsCommentsList[index1]['reply_data'][index2]['content_id'] ?? 0;
                                                                          activityOnPageNo = friendsCommentsList[index1]['page_no'];
                                                                          contentThirdPartyId = friendsCommentsList[index1]['reply_data'][index2]['content_thirdparty_id'];
                                                                          editController =
                                                                              TextEditingController(text: friendsCommentsList[index1]['reply_data'][index2]['comment_text']);
                                                                        });
                                                                        _editFocus.requestFocus();
                                                                      },
                                                                      onTap: () {
                                                                        if (postDetails['login_user_id'] == friendsCommentsList[index1]['reply_data'][index2]['user_id']) {
                                                                          Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) => UserViewScreen(
                                                                                userId: friendsCommentsList[index1]['reply_data'][index2]['user_id'],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        } else {
                                                                          Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) => VisitorViewScreen(
                                                                                userID: friendsCommentsList[index1]['reply_data'][index2]['user_id'],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                          // : Container(),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                      friendsCommentsList.length <= 5
                                          ? Container()
                                          : Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    _isFriendsCommentListLoading == true
                                                        ? SizedBox(width: 20, height: 20, child: kProgressIndicator)
                                                        : GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                if (friendsCommentView == 5) {
                                                                  friendsCommentView = friendsCommentsList.length;
                                                                  if (friendsCommentsLoadMore == false) {
                                                                    friendsCommentText = 'Hide all Comments';
                                                                  }
                                                                  print('friendsCommentsLoadMore: $friendsCommentsLoadMore');
                                                                } else if (friendsCommentView >= 10) {
                                                                  if (friendsCommentView % 10 == 0) {
                                                                    print('friendsCommentsLoadMore % 10 == 0 : $friendsCommentsLoadMore');
                                                                    if (friendsCommentsLoadMore == true) {
                                                                      setState(() {
                                                                        friendsPageNo++;
                                                                      });
                                                                      print('FRIENDS PAGE NO: $friendsPageNo');
                                                                      friendsCommentsListAPI(pageNo: friendsPageNo);
                                                                    } else {
                                                                      friendsCommentView = 5;
                                                                      friendsCommentText = 'View more Comments';
                                                                    }
                                                                  } else {
                                                                    friendsCommentView = 5;
                                                                    friendsCommentText = 'View more Comments';
                                                                    print('friendsCommentView % 10 != 0');
                                                                  }
                                                                  print('FRIENDS MORE THAN or EQUAL TO 10');
                                                                } else {
                                                                  print('FRIENDS LESS THAN 10');
                                                                  friendsCommentView = 5;
                                                                  friendsCommentText = 'View more Comments';
                                                                }
                                                              });
                                                              // print(friendsCommentView);
                                                            },
                                                            child: AppText(
                                                              friendsCommentText,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                                SizedBox(height: 14),
                                              ],
                                            ),
                                      otherCommentsList.length == 0 || friendsCommentsList.length == 0 /*|| otherCommentsList.length == 1*/
                                          ? Container()
                                          : Column(
                                              children: [
                                                AppText("All Comments".toUpperCase(), fontWeight: FontWeight.w900, color: Colors.black, fontSize: 13),
                                                SizedBox(height: 6),
                                              ],
                                            ),
                                      otherCommentsList.length == 0 /*|| otherCommentsList.length == 1*/
                                          ? Container()
                                          : Row(
                                              children: [
                                                Expanded(
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemCount: otherCommentsList.length < 5 ? otherCommentsList.length : otherCommentsView,
                                                    itemBuilder: (BuildContext context, int index1) {
                                                      return ListView(
                                                        shrinkWrap: true,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        children: [
                                                          CommentFrame(
                                                            isSubEditComment: true,
                                                            userID: otherCommentsList[index1]['user_id'],
                                                            name: otherCommentsList[index1]['full_name'] == null ? 'Deleted user' : otherCommentsList[index1]['full_name'],
                                                            profile: "$BASE_URL/${otherCommentsList[index1]['profile_pic']}",
                                                            comment: otherCommentsList[index1]['comment_text'],
                                                            likeCounts: '  ${otherCommentsList[index1]['count_likes']}  ',
                                                            totalLikeCount: otherCommentsList[index1]['count_likes'],
                                                            isLiked: otherCommentsList[index1]['is_like_me'] == 0 ? false : true,
                                                            onMoreMenu: () {
                                                              reportComment(
                                                                otherCommentsList[index1]['content_thirdparty_id'],
                                                                otherCommentsList[index1]['comment_id'],
                                                              );
                                                            },
                                                            onLike: () {
                                                              _addLikeOnComment(
                                                                commentType: 2,
                                                                index: index1,
                                                                pageNo: otherCommentsList[index1]['page_no'],
                                                                commentId: otherCommentsList[index1]['comment_id'],
                                                              );
                                                              setState(() {
                                                                commentIndex = index1;
                                                              });
                                                            },
                                                            onComment: () {
                                                              // print(otherCommentsList[index1]['comment_id']);
                                                              // print(otherCommentsList[index1]['content_thirdparty_id']);
                                                              // print(otherCommentsList[index1]['content_id']);
                                                              setState(() {
                                                                isShow = true;
                                                                commentIndex = index1;
                                                                commentType = 2;
                                                                userName = otherCommentsList[index1]['full_name'];
                                                                commentId = otherCommentsList[index1]['comment_id'];
                                                                activityOnPageNo = otherCommentsList[index1]['page_no'];
                                                                contentId = otherCommentsList[index1]['content_id'] ?? 0;
                                                                contentThirdPartyId = otherCommentsList[index1]['content_thirdparty_id'];
                                                              });
                                                              _replyFocus.requestFocus();
                                                            },
                                                            onEdit: () {
                                                              print(otherCommentsList[index1]['comment_text']);
                                                              setState(() {
                                                                isShowEdit = true;
                                                                commentIndex = index1;
                                                                commentType = 2;
                                                                commentId = otherCommentsList[index1]['comment_id'];
                                                                activityOnPageNo = otherCommentsList[index1]['page_no'];
                                                                editController = TextEditingController(text: otherCommentsList[index1]['comment_text']);
                                                                contentId = otherCommentsList[index1]['content_id'] ?? 0;
                                                                contentThirdPartyId = otherCommentsList[index1]['content_thirdparty_id'];
                                                              });
                                                              _editFocus.requestFocus();
                                                            },
                                                            countReply: othersReplyVisibility[index1] == true
                                                                ? 1
                                                                : otherCommentsList[index1]['is_comments'] == 1
                                                                    ? 0
                                                                    : 1,
                                                            viewReply: () {
                                                              setState(() {
                                                                if (otherCommentsList[index1]['count_replys'] > 0) {
                                                                  otherCommentsList[index1]['count_replys'] = 0;
                                                                  otherCommentsList[index1]['is_comments'] = 1;
                                                                  othersReplyVisibility[index1] = false;
                                                                } else {
                                                                  otherCommentsList[index1]['count_replys'] = (otherCommentsList[index1]['reply_data'] as List).length;
                                                                  otherCommentsList[index1]['is_comments'] = 0;
                                                                  othersReplyVisibility[index1] = true;
                                                                }
                                                              });
                                                            },
                                                            lengthReply: (otherCommentsList[index1]['reply_data'] as List).length,
                                                            onTap: () {
                                                              if (postDetails['login_user_id'] == otherCommentsList[index1]['user_id']) {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => UserViewScreen(userId: otherCommentsList[index1]['user_id']),
                                                                  ),
                                                                );
                                                              } else {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => VisitorViewScreen(userID: otherCommentsList[index1]['user_id']),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                          (otherCommentsList[index1]['reply_data'] as List).length == 0
                                                              ? Container()
                                                              : ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  itemCount: othersReplyVisibility[index1] == true
                                                                      ? otherCommentsList[index1]['count_replys']
                                                                      : otherCommentsList[index1]['is_comments'] == 1
                                                                          ? 0
                                                                          : otherCommentsList[index1]['count_replys'],
                                                                  itemBuilder: (context, index2) {
                                                                    return CommentFrame(
                                                                      userID: otherCommentsList[index1]['reply_data'][index2]['user_id'],
                                                                      isSubComment: true,
                                                                      isSubEditComment: true,
                                                                      name: otherCommentsList[index1]['reply_data'][index2]['full_name'] == null
                                                                          ? 'Deleted user'
                                                                          : otherCommentsList[index1]['reply_data'][index2]['full_name'],
                                                                      profile: "$BASE_URL/${otherCommentsList[index1]['reply_data'][index2]['profile_pic']}",
                                                                      comment: otherCommentsList[index1]['reply_data'][index2]['comment_text'],
                                                                      likeCounts: '  ${otherCommentsList[index1]['reply_data'][index2]['count_likes']}  ',
                                                                      totalLikeCount: otherCommentsList[index1]['reply_data'][index2]['count_likes'],
                                                                      isLiked: otherCommentsList[index1]['reply_data'][index2]['is_like_me'] == 0 ? false : true,
                                                                      onMoreMenu: () {
                                                                        reportComment(
                                                                          otherCommentsList[index1]['content_thirdparty_id'],
                                                                          otherCommentsList[index1]['reply_data'][index2]['comment_id'],
                                                                        );
                                                                      },
                                                                      onLike: () {
                                                                        _addLikeOnComment(
                                                                          commentType: 2,
                                                                          isSubComment: true,
                                                                          index: index1,
                                                                          pageNo: otherCommentsList[index1]['page_no'],
                                                                          commentId: otherCommentsList[index1]['reply_data'][index2]['comment_id'],
                                                                        );
                                                                        setState(() {
                                                                          commentIndex = index1;
                                                                        });
                                                                      },
                                                                      onEdit: () {
                                                                        setState(() {
                                                                          commentIndex = index1;
                                                                          isShowEdit = true;
                                                                          commentType = 2;
                                                                          commentId = otherCommentsList[index1]['reply_data'][index2]['comment_id'];
                                                                          activityOnPageNo = otherCommentsList[index1]['page_no'];
                                                                          editController =
                                                                              TextEditingController(text: otherCommentsList[index1]['reply_data'][index2]['comment_text']);
                                                                          contentId = otherCommentsList[index1]['reply_data'][index2]['content_id'] ?? 0;
                                                                          contentThirdPartyId = otherCommentsList[index1]['reply_data'][index2]['content_thirdparty_id'];
                                                                        });
                                                                        _editFocus.requestFocus();
                                                                      },
                                                                      onTap: () {
                                                                        if (postDetails['login_user_id'] == otherCommentsList[index1]['reply_data'][index2]['user_id']) {
                                                                          Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) => UserViewScreen(
                                                                                userId: otherCommentsList[index1]['reply_data'][index2]['user_id'],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        } else {
                                                                          Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) => VisitorViewScreen(
                                                                                userID: otherCommentsList[index1]['reply_data'][index2]['user_id'],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                      otherCommentsList.length <= 5
                                          ? Container()
                                          : Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    _isOtherCommentListLoading == true
                                                        ? SizedBox(width: 20, height: 20, child: kProgressIndicator)
                                                        : GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                if (otherCommentsView == 5) {
                                                                  otherCommentsView = otherCommentsList.length;
                                                                  if (otherCommentsLoadMore == false) {
                                                                    otherCommentText = 'Hide all Comments';
                                                                  }
                                                                  print('otherCommentsLoadMore: $otherCommentsLoadMore');
                                                                } else if (otherCommentsView >= 10) {
                                                                  if (otherCommentsView % 10 == 0) {
                                                                    print('otherCommentsLoadMore inside >= 10 : $otherCommentsLoadMore');
                                                                    if (otherCommentsLoadMore == true) {
                                                                      setState(() {
                                                                        othersPageNo++;
                                                                      });
                                                                      print('OTHERS PAGE NO: $othersPageNo');
                                                                      otherCommentListAPI(pageNo: othersPageNo);
                                                                    } else {
                                                                      otherCommentsView = 5;
                                                                      otherCommentText = 'View more Comments';
                                                                    }
                                                                  } else {
                                                                    otherCommentsView = 5;
                                                                    otherCommentText = 'View more Comments';
                                                                    print('otherCommentView % 10 != 0');
                                                                  }
                                                                  print('OTHERS MORE THAN or EQUAL TO 10');
                                                                } else {
                                                                  print('OTHERS LESS THAN 10');
                                                                  otherCommentsView = 5;
                                                                  otherCommentText = 'View more Comments';
                                                                }
                                                              });
                                                            },
                                                            child: AppText(
                                                              otherCommentText,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                                SizedBox(height: 14),
                                              ],
                                            ),
                                      SizedBox(height: 14),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            _loading1 == true
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          child: kProgressIndicator,
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            Visibility(
                              visible: isShow ? true : false,
                              child: Container(
                                constraints: BoxConstraints(minHeight: 170),
                                color: Colors.white,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(color: Color(0xffebedf0)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Center(
                                              child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: 'Replying to ',
                                                        style: TextStyle(color: Colors.grey, fontFamily: 'OpenSans', fontSize: 15, fontWeight: FontWeight.w900)),
                                                    TextSpan(
                                                        text: userName, style: TextStyle(color: Colors.black, fontFamily: 'OpenSans', fontSize: 15, fontWeight: FontWeight.w900)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                FocusScope.of(context).requestFocus(new FocusNode());
                                                setState(() {
                                                  isShow = false;
                                                });
                                              },
                                              child: Center(child: Icon(Icons.clear, size: 30, color: Colors.grey)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(minHeight: 100),
                                      child: AutoSizeTextField(
                                        maxFontSize: 13,
                                        minFontSize: 13,
                                        controller: replyController,
                                        maxLines: null,
                                        focusNode: _replyFocus,
                                        textAlign: TextAlign.left,
                                        cursorColor: Colors.black,
                                        style: TextStyle(color: Colors.black, fontFamily: 'OpenSans', fontSize: 13),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                          hintText: 'Write a comment',
                                          hintStyle: TextStyle(color: Colors.grey, fontFamily: 'OpenSans', fontSize: 15),
                                          border: kCommentFiledBorder1,
                                          focusedBorder: kCommentFiledBorder1,
                                          enabledBorder: kCommentFiledBorder1,
                                          errorBorder: kCommentFiledBorder1,
                                          focusedErrorBorder: kCommentFiledBorder1,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isShow = false;
                                                });
                                                _addCommentOnPost(
                                                  index: commentIndex,
                                                  commentType: commentType,
                                                  pageNo: activityOnPageNo,
                                                  commentId: commentId,
                                                  contentThirdPartyId: widget.id,
                                                  contentId: contentId ?? 0,
                                                  commentText: replyController.text,
                                                  controller: replyController,
                                                );
                                                FocusScope.of(context).requestFocus(new FocusNode());
                                              },
                                              child: Text('Post Reply',
                                                  style: TextStyle(color: Color(0xff38b6ff), fontFamily: 'OpenSans', fontSize: 15, fontWeight: FontWeight.w700))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: isShowEdit ? true : false,
                              child: Container(
                                constraints: BoxConstraints(minHeight: 170),
                                color: Colors.white,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(color: Color(0xffebedf0)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Center(
                                              child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  children: [
                                                    //TextSpan(text: '', style: TextStyle(color: Colors.grey, fontFamily: 'OpenSans', fontSize: 15, fontWeight: FontWeight.w900)),
                                                    TextSpan(
                                                        text: 'Update your comment',
                                                        style: TextStyle(color: Colors.black, fontFamily: 'OpenSans', fontSize: 15, fontWeight: FontWeight.w900)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                FocusScope.of(context).requestFocus(new FocusNode());
                                                setState(() {
                                                  isShowEdit = false;
                                                });
                                              },
                                              child: Center(child: Icon(Icons.clear, size: 30, color: Colors.grey)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(minHeight: 100),
                                      child: AutoSizeTextField(
                                        maxFontSize: 13,
                                        minFontSize: 13,
                                        controller: editController,
                                        maxLines: null,
                                        focusNode: _editFocus,
                                        textAlign: TextAlign.left,
                                        cursorColor: Colors.black,
                                        style: TextStyle(color: Colors.black, fontFamily: 'OpenSans', fontSize: 13),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                          hintText: 'Write a comment',
                                          hintStyle: TextStyle(color: Colors.grey, fontFamily: 'OpenSans', fontSize: 15),
                                          border: kCommentFiledBorder1,
                                          focusedBorder: kCommentFiledBorder1,
                                          enabledBorder: kCommentFiledBorder1,
                                          errorBorder: kCommentFiledBorder1,
                                          focusedErrorBorder: kCommentFiledBorder1,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isShowEdit = false;
                                                });
                                                _editCommentOnPost(
                                                  index: commentIndex,
                                                  pageNo: activityOnPageNo,
                                                  commentType: commentType,
                                                  commentId: commentId,
                                                  contentThirdPartyId: contentThirdPartyId,
                                                  contentId: contentId ?? 0,
                                                  commentText: editController.text,
                                                );
                                                FocusScope.of(context).requestFocus(new FocusNode());
                                              },
                                              child: Text('Post update',
                                                  style: TextStyle(color: Color(0xff38b6ff), fontFamily: 'OpenSans', fontSize: 15, fontWeight: FontWeight.w700))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
    );
  }

  String? userToken;
  bool _loading = false;
  bool _loading1 = false;
  var userID;
  String? firstName;
  var geners;
  List generIdList = [];
  int? id;

  getToken() async {
    var token = await readData('user_token');
    var userId = await readData('user_id');

    setState(() {
      userToken = token;
      userID = userId;
    });
    await _getMoviesTvDetails();
    await addToViewed();
    friendsCommentsListAPI(pageNo: friendsPageNo);
    otherCommentListAPI(pageNo: othersPageNo);
  }

  List clipList = [];
  List type = [];
  _getMoviesTvDetails() async {
    print(widget.id);
    print(widget.contentType);
    print('Utsav ID');
    var jsonData;
    List temp = [];

    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        GET_MOVIES_TV_DETAILS,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'id': widget.id, 'content_type': widget.contentType},
      );
      if (response.statusCode == 200) {
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });

        if (jsonData != null) {
          setState(() {
            firstName = jsonData['first_name'];
            if (jsonData['is_rec_me'] == 0) {
              recommended = false;
            } else if (jsonData['is_rec_me'] == 1) {
              recommended = true;
            }

            if (jsonData['added_to_watchlist'] == 0) {
              addedToWatchList = false;
            } else if (jsonData['added_to_watchlist'] == 1) {
              addedToWatchList = true;
            }

            watchModeId = jsonData['watch_mode_id'];
            content = jsonData['details'];

            geners = jsonData['details']['genres'];
            watchData = jsonData['watch_data']['results'];
            postDetails = jsonData['content_data'];
            setState(() {});

            setState(() {
              for (int i = 0; i < geners.length; i++) {
                generIdList.add(geners[i]['id']);
              }
              for (int i = 0; i < watchData.length; i++) {
                if ((watchData[i]['type'] == "Trailer" && (watchData[i]['official'] == true || watchData[i]['official'] == 'true')) && trailerKey == null) {
                  trailerKey = watchData[i]['key'];
                  print('Official TRUE: https://www.youtube.com/watch?v=${watchData[i]['key']}');
                  print(trailerKey);
                  _controller = YoutubePlayerController(
                    initialVideoId: watchData[i]['key'],
                    params: YoutubePlayerParams(startAt: Duration(seconds: 0), showControls: true, showFullscreenButton: true, autoPlay: true),
                  );
                } else if (watchData[i]['type'] == "Trailer" && trailerKey == null) {
                  trailerKey = watchData[i]['key'];
                  print('Official FALSE: https://www.youtube.com/watch?v=${watchData[i]['key']}');
                  print(trailerKey);
                  _controller = YoutubePlayerController(
                    initialVideoId: watchData[i]['key'],
                    params: YoutubePlayerParams(startAt: Duration(seconds: 0), showControls: true, showFullscreenButton: true, autoPlay: true),
                  );
                }
                clipList.add(watchData[i]);
              }
              print(clipList);
              print('clipList');
            });
            if (jsonData['strem_data'].runtimeType.toString() == '_InternalLinkedHashMap<String, dynamic>') {
              print('Oops!: ${jsonData['strem_data']}');
              streamData = [];
            } else {
              if (jsonData['strem_data'].length == 0 || jsonData['strem_data'] == [] || jsonData['strem_data'].isEmpty) {
                streamData = [];
              } else if (jsonData['strem_data'].length != 0 || jsonData['strem_data'] != [] || jsonData['strem_data'].isNotEmpty || jsonData['strem_data'].length > 0) {
                temp = jsonData['strem_data'];
                print(temp.length);
                log(temp.length.toString());
                for (int i = 0; i < temp.length; i++) {
                  if (temp[i]['region'] == "US" && (temp[i]['type'].toString().toLowerCase() == "sub" || temp[i]['type'].toString().toLowerCase() == "free")) {
                    if (temp[i]['source_id'] == 203 ||
                        temp[i]['source_id'] == 26 ||
                        temp[i]['source_id'] == 372 ||
                        temp[i]['source_id'] == 157 ||
                        temp[i]['source_id'] == 387 ||
                        temp[i]['source_id'] == 444 ||
                        temp[i]['source_id'] == 388 ||
                        temp[i]['source_id'] == 389 ||
                        temp[i]['source_id'] == 371 ||
                        temp[i]['source_id'] == 445 ||
                        temp[i]['source_id'] == 248 ||
                        temp[i]['source_id'] == 232 ||
                        temp[i]['source_id'] == 296 ||
                        temp[i]['source_id'] == 391) {
                      streamData.add(temp[i]);
                    }
                  }
                }

                for (int i = 0; i < streamData.length; i++) {
                  print(streamData[i]['type']);
                  print('streamData');
                  sourceID.add(streamData[i]['source_id']);
                  type.add(streamData[i]['type']);
                }
                print(type);
                print('sourceID');
                if (streamData.isNotEmpty) {
                  id = streamData[0]['source_id'];
                }
                var resArr = [];
                streamData.forEach((item) {
                  var i = resArr.indexWhere((x) => x["source_id"] == item["source_id"]);
                  if (i <= -1) {
                    resArr.add(item);
                  }
                });
                streamData = resArr;
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

  _updateSourceImpressions({var contentThirdPartyId}) async {
    try {
      var response = await Dio().post(
        UPDATE_SOURCE_IMPRESSIONS,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'content_third_party_id': contentThirdPartyId},
      );
      print(response);
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }

  _addLikeOnPost({var contentThirdPartyId, var contentId, var reactType}) async {
    var jsonData;

    try {
      var response = await Dio().post(
        ADD_LIKE_ON_POST,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'content_third_party_id': contentThirdPartyId, 'content_id': contentId ?? 0, 'reacted_type': reactType},
      );
      print(response);
      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          await _getMoviesTvDetails();
        } else {}
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }

  _addLikeOnComment({var isSubComment = false, var index, var commentType, var commentId, var pageNo}) async {
    ///commentType >> 1-Friends, 2-Others
    var jsonData;

    try {
      var response = await Dio().post(
        ADD_LIKE_ON_COMMENT,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'comment_id': commentId},
      );
      print(response);
      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          if (isSubComment == false) {
            setState(() {
              var likedCommentData = jsonData['data'][0];
              print(likedCommentData.toString());
              updatedLikeOnCommentData = {
                "page_no": pageNo,
                "comment_id": likedCommentData['comment_id'],
                "comment_parent_id": likedCommentData['comment_parent_id'],
                "content_id": likedCommentData['content_id'],
                "activity_id": likedCommentData['activity_id'],
                "comment_type": likedCommentData['comment_type'],
                "user_id": likedCommentData['user_id'],
                "comment_text": likedCommentData['comment_text'],
                "content_thirdparty_id": likedCommentData['content_thirdparty_id'],
                "created_at": likedCommentData['created_at'],
                "username": likedCommentData['username'],
                "profile_pic": likedCommentData['profile_pic'],
                "full_name": likedCommentData['full_name'],
                "count_likes": likedCommentData['count_likes'],
                "is_comments": likedCommentData['is_comments'],
                "count_replys": likedCommentData['count_replys'],
                "is_follow": likedCommentData['is_follow'],
                "is_like_me": likedCommentData['is_like_me'],
                "comment_by_me": likedCommentData['comment_by_me'],
                "reply_data": likedCommentData['reply_data'],
              };
              print('updatedLikeOnCommentData: $updatedLikeOnCommentData');
            });
            if (commentType == 1) {
              print('FRIENDS');
              await friendsCommentsListAPI(index: index, pageNo: pageNo, isActivity: true, activityType: 1);
            } else {
              await otherCommentListAPI(index: index, pageNo: pageNo, isActivity: true, activityType: 1);
            }
          } else {
            if (commentType == 1) {
              print('FRIENDS inside else');
              await friendsCommentsListAPI(index: index, pageNo: pageNo, isActivity: true);
            } else {
              await otherCommentListAPI(index: index, pageNo: pageNo, isActivity: true);
            }
          }
        }
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }

  _addCommentOnPost({var index, var commentType = 0, var contentThirdPartyId, var contentId, var commentText, var commentId, var controller, var pageNo}) async {
    // commentType>> 1=friends, 2=others
    print(contentThirdPartyId);
    print('contentThirdPartyId');
    var jsonData;
    setState(() {
      _loading1 = true;
    });
    try {
      var response = await Dio().post(
        ADD_COMMENT_ON_POST,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {
          'content_third_party_id': contentThirdPartyId,
          'comment_text': commentText,
          'content_id': contentId ?? 0,
          'comment_id': commentId,
        },
      );
      print(response);
      if (response.statusCode == 200) {
        setState(() {
          _loading1 = false;
          jsonData = jsonDecode(response.toString());
          (controller as TextEditingController).clear();
          replyController.clear();
        });
        if (jsonData['status'] == 1) {
          if (commentType == 0) {
            setState(() {
              otherCommentsList.insert(0, jsonData['data']);
              othersReplyVisibility.insert(0, false);
              if (postDetails != null) {
                postDetails['comment_count']++;
                print(postDetails['comment_count']);
              }
            });
            print(response);
            print('response utsav');
          } else if (commentType == 1) {
            friendsCommentsListAPI(index: index, pageNo: pageNo, isActivity: true);
          } else if (commentType == 2) {
            otherCommentListAPI(index: index, pageNo: pageNo, isActivity: true);
          }
        }
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }

  _editCommentOnPost({var index, var commentType = 0, var contentThirdPartyId, var contentId, var commentText, var commentId, var pageNo}) async {
    // commentType>> 1=friends, 2=others
    var jsonData;

    try {
      var response = await Dio().post(
        EDIT_COMMENT,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'content_third_party_id': contentThirdPartyId, 'comment_text': editController.text, 'content_id': contentId ?? 0, 'comment_id': commentId},
      );
      print(response);
      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          if (commentType == 1) {
            friendsCommentsListAPI(index: index, pageNo: pageNo, isActivity: true);
          } else if (commentType == 2) {
            otherCommentListAPI(index: index, pageNo: pageNo, isActivity: true);
          }
        }
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }

  friendsCommentsListAPI({var index, var pageNo, var isActivity = false, var activityType = 0}) async {
    // isActivity>> true= like, reply, edit etc., false= none
    // activityType>> 0= none, 1= likeOnComment, 2= reply
    // commentType>> 1= friends, 2= others
    var jsonData;
    if (isActivity == false) {
      setState(() {
        _isFriendsCommentListLoading = true;
      });
    }
    try {
      var response = await Dio().post(
        FRIENDS_COMMENTS_LIST,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'page_no': pageNo, 'content_thirdparty_id': widget.id},
      );
      print(response);
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          jsonData = jsonDecode(response.toString());
          if (jsonData['status'] == 1) {
            if (isActivity == false) {
              _isFriendsCommentListLoading = false;
              friendsCommentsList.addAll(jsonData['data']);
              for (int i = 0; i < friendsCommentsList.length; i++) {
                friendsReplyVisibility.add(true);
              }
              if (friendsCommentsLoadMore == true) {
                if (friendsPageNo != 1) {
                  friendsCommentView = friendsCommentsList.length;
                  if (jsonData['data'].length < 10 || friendsCommentsList.length % 10 != 0) {
                    friendsCommentsLoadMore = false;
                    friendsCommentText = 'Hide all Comments';
                  }
                } else {
                  if (jsonData['data'].length < 10 || friendsCommentsList.length % 10 != 0) {
                    friendsCommentsLoadMore = false;
                  }
                }
              } else {
                friendsCommentText = 'Hide all Comments';
              }
            } else {
              if (activityType == 0) {
                friendsReplyVisibility[index] = true;
                print(friendsReplyVisibility);
                updatedFriendsCommentList.clear();
                updatedFriendsCommentList.addAll(jsonData['data']);
                var j = 0;
                for (int i = (pageNo - 1) * 10; i < ((pageNo - 1) * 10) + updatedFriendsCommentList.length; i++) {
                  setState(() {
                    friendsCommentsList[i] = updatedFriendsCommentList[j];
                    j++;
                  });
                }
              } else {
                friendsCommentsList[index] = updatedLikeOnCommentData;
              }
            }
          }
        });
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }

  otherCommentListAPI({var index, var pageNo, var isActivity = false, var activityType = 0}) async {
    // activityType 0= any, 1= likeOnComment
    var jsonData;
    if (isActivity == false) {
      setState(() {
        _isOtherCommentListLoading = true;
      });
    }
    try {
      var response = await Dio().post(
        OTHER_COMMENTS_LIST,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'page_no': pageNo, 'content_thirdparty_id': widget.id},
      );
      print(response);
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          jsonData = jsonDecode(response.toString());
          if (jsonData['status'] == 1) {
            if (isActivity == false) {
              _isOtherCommentListLoading = false;
              otherCommentsList.addAll(jsonData['data']);
              for (int i = 0; i < otherCommentsList.length; i++) {
                othersReplyVisibility.add(true);
              }
              if (otherCommentsLoadMore == true) {
                if (othersPageNo != 1) {
                  otherCommentsView = otherCommentsList.length;
                  if (jsonData['data'].length < 10 || otherCommentsList.length % 10 != 0) {
                    otherCommentsLoadMore = false;
                    otherCommentText = 'Hide all Comments';
                  }
                } else {
                  if (jsonData['data'].length < 10 || otherCommentsList.length % 10 != 0) {
                    otherCommentsLoadMore = false;
                  }
                }
              } else {
                otherCommentText = 'Hide all Comments';
              }
            } else {
              if (activityType == 0) {
                othersReplyVisibility[index] = true;
                print(othersReplyVisibility);
                updatedOtherCommentList.clear();
                updatedOtherCommentList.addAll(jsonData['data']);
                var j = 0;
                for (int i = (pageNo - 1) * 10; i < ((pageNo - 1) * 10) + updatedOtherCommentList.length; i++) {
                  setState(() {
                    otherCommentsList[i] = updatedOtherCommentList[j];
                    j++;
                  });
                }
              } else {
                otherCommentsList[index] = updatedLikeOnCommentData;
              }
            }
          }
        });
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }

  _addToRecommended({
    var contentThirdPartyId,
    var contentType,
    required String contentDescription,
    required String title,
    required String posterPath,
    required String coverPhotoPath,
    required int runningTime,
    required int watchModeId,
    required String releaseYear,
    required String trailerUrl,
    var votes,
    required tags,
    var streamingProvider,
  }) async {
    var jsonData;

    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        ADD_TO_RECOMMENDED,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {
          'content_third_party_id': contentThirdPartyId,
          'content_type': contentType,
          'content_discription': contentDescription,
          'content_photo': posterPath,
          'content_title': title,
          'content_cover_photo': coverPhotoPath,
          'content_trailer_time': '00:00',
          'content_release_time': releaseYear,
          'content_tags': tags,
          'content_length': runningTime,
          'streaming_provider': streamingProvider,
          'trailer_url': trailerUrl,
          'vote_average': votes,
          'content_watchmode_id': watchModeId,
          'watch_mode_json': streamingProvider,
          'geners_id': generIdList.join(','),
          'source_id': sourceID.join(','),
          'free_source_id': sourceID.join(','),
          'free_type_name': type.join(','),
          'content_category': id == 203
              ? 1
              : id == 26
                  ? 10
                  : id == 372
                      ? 2
                      : id == 157
                          ? 9
                          : id == 387
                              ? 8
                              : id == 444
                                  ? 12
                                  : id == 388 || id == 389
                                      ? 11
                                      : id == 371
                                          ? 13
                                          : 0
          // 'content_clip_json': jsonEncode(clipList),
        },
      );
      print(response);
      if (response.statusCode == 200) {
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
          print(jsonData);
          print('jsonData');
        });
        if (jsonData['status'] == 1) {
          setState(() {
            recommended = !recommended;
            if (recommended == true) {
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
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.45),
                            height: 120,
                            width: MediaQuery.of(context).size.width - 50,
                            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(14)),
                            child: Center(
                              child: AppText(
                                'Nice job! Your friends on Oneflix have been notified. Invite more friends to join you on Oneflix so they can see all your recommendations.',
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.60,
                            right: 18,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                height: 32,
                                width: 32,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                                child: Icon(Icons.close, color: Colors.white, size: 22),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
              );
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

  addToViewed() async {
    print(id);
    print('id');
    var jsonData;

    try {
      var response = await Dio().post(
        ADD_TO_VIEWED,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {
          'content_third_party_id': widget.id,
          'content_type': widget.contentType,
          'content_discription': content['overview'],
          'content_photo': content['poster_path'],
          'content_title': content['title'] ?? content['name'],
          'content_cover_photo': content['backdrop_path'],
          'content_trailer_time': '00:00',
          'content_release_time': widget.contentType == 0 ? content['release_date'] : content['first_air_date'],
          'content_tags': jsonEncode(content['genres']),
          'content_length': content['runtime'] == null && (content['episode_run_time'] as List).isEmpty
              ? 0
              : widget.contentType == 0
                  ? content['runtime']
                  : content['episode_run_time'][0],
          'trailer_url': trailerKey ?? 'null',
          'vote_average': content['vote_average'],
          'content_watchmode_id': watchModeId,
          'watch_mode_json': jsonEncode(streamData),
          'geners_id': generIdList.join(','),
          'source_id': sourceID.join(','),
          'free_source_id': sourceID.join(','),
          'free_type_name': type.join(','),
          'content_category': id == 203
              ? 1
              : id == 26
                  ? 10
                  : id == 372
                      ? 2
                      : id == 157
                          ? 9
                          : id == 387
                              ? 8
                              : id == 444
                                  ? 12
                                  : id == 388 || id == 389
                                      ? 11
                                      : id == 371
                                          ? 13
                                          : 0
        },
      );
      print(response);
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          jsonData = jsonDecode(response.toString());
          print(jsonData);
          print('jsonData12355678');
        });
        if (jsonData['status'] != 1) {
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }

  _addToWatchList({var contentThirdPartyId, var contentType}) async {
    var jsonData;

    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        ADD_TO_WATCHLIST,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'watch_type': contentType, 'content_third_party_id': contentThirdPartyId},
      );
      print(response);
      if (response.statusCode == 200) {
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        setState(() {
          if (jsonData['added_to_watchlist'] == 1) {
            addedToWatchList = true;
          } else if (jsonData['added_to_watchlist'] == 0) {
            addedToWatchList = false;
          }
        });
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }

  reportComment(int thirdPartyId, int commentId) async {
    var jsonData;

    try {
      var response = await Dio().post(
        REPORT_COMMENT,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {
          'content_thirdparty_id': thirdPartyId,
          'comment_id': commentId,
        },
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
                        'Thank you for reporting this comment. We will review it within 24 hours and remove it immediately if we find it to be in violation of our community guidelines. We\'ll also take further actions against the comment author if necessary.',
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
}
