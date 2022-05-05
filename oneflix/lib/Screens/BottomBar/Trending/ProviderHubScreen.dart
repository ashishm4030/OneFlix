import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Components/LiveDot.dart';
import 'package:oneflix/Screens/BottomBar/Home/PostContentScreen.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../Constants.dart';

class ProviderHubScreen extends StatefulWidget {
  final type;
  const ProviderHubScreen({Key? key, this.type}) : super(key: key);

  @override
  _ProviderHubScreenState createState() => _ProviderHubScreenState();
}

class _ProviderHubScreenState extends State<ProviderHubScreen> {
  String? userToken;
  bool _loading = false;
  var genereData;
  List actionMovie = [];
  List comedyMovie = [];
  List romanceMovie = [];
  List actionTv = [];
  List comedyTv = [];
  List adventureMovies = [];
  List familyMovies = [];
  List dramaMovies = [];
  List familyTv = [];
  List dramaTv = [];
  List newNetflix = [];
  List newAmezon = [];
  List crimeTv = [];
  List scifiFanstyTv = [];
  List scienceFictionMovie = [];
  List fanstasyMovie = [];
  List thillerMovie = [];
  List horrorMovie = [];
  List comingSoonData = [];

  @override
  void initState() {
    getToken();
    super.initState();
  }

  getToken() async {
    print(widget.type);
    setState(() {
      _loading = true;
    });
    var usertoken = await readData('user_token');
    setState(() {
      userToken = usertoken;
    });
    _getGenereData();
  }

  _getGenereData() async {
    var jsonData;
    if (!mounted) return;
    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        GET_PROVIDER_HUB_DATA,
        data: {'type': widget.type},
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            genereData = jsonData['data'];
            newNetflix = genereData["New On Netflix"];
            newAmezon = genereData["Popular On Netflix"];
            actionMovie = genereData["Action Movies"];
            comedyMovie = genereData["Comedy Movies"];
            romanceMovie = genereData["Romance Movies"];
            actionTv = genereData["Action & Adventure TV Shows"];
            comedyTv = genereData["Comedy TV Shows"];
            adventureMovies = genereData["Adventure Movies"];
            familyMovies = genereData["Family Movies"];
            dramaMovies = genereData["Drama Movies"];
            familyTv = genereData["Family TV Shows"];
            dramaTv = genereData["Drama TV Shows"];
            scifiFanstyTv = genereData["Sci-Fi & Fantasy TV Shows"];
            crimeTv = genereData["Crime TV Shows"];
            scienceFictionMovie = genereData["Science Fiction Movies"];
            fanstasyMovie = genereData["Fantasy Movies"];
            thillerMovie = genereData["Thriller Movies"];
            horrorMovie = genereData["Horror Movies"];
            comingSoonData = genereData["comming soon"];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff011138),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.0),
        child: AppBar(
          backgroundColor: widget.type == 203
              ? Color(0xffFF1B0A)
              : widget.type == 372
                  ? Color(0xff09092D)
                  : widget.type == 26
                      ? Color(0xff00AAE2)
                      : widget.type == 387
                          ? Color(0xffD631DB)
                          : widget.type == 157
                              ? Color(0xff19E782)
                              : widget.type == 388
                                  ? Color(0xffFFFFFF)
                                  : widget.type == 444
                                      ? Color(0xff025DFB)
                                      : widget.type == 371
                                          ? Color(0xffFFFFFF)
                                          : widget.type == 296
                                              ? Color(0xffFF2922)
                                              : widget.type == 391
                                                  ? Color(0xffFFFFFF)
                                                  : widget.type == 232
                                                      ? Color(0xffFFFFFF)
                                                      : Color(0xffB30F19),
          automaticallyImplyLeading: false,
          elevation: 0.0,
          centerTitle: true,
          title: Image.asset(
            widget.type == 203
                ? 'assets/ProviderHeader/Netflix.png'
                : widget.type == 372
                    ? 'assets/ProviderHeader/Disney.png'
                    : widget.type == 26
                        ? 'assets/ProviderHeader/Amazon.png'
                        : widget.type == 387
                            ? 'assets/ProviderHeader/HBO.png'
                            : widget.type == 157
                                ? 'assets/ProviderHeader/Hulu.png'
                                : widget.type == 388
                                    ? 'assets/ProviderHeader/Peacock.png'
                                    : widget.type == 444
                                        ? 'assets/ProviderHeader/Paramount.png'
                                        : widget.type == 371
                                            ? 'assets/ProviderHeader/Apple TV.png'
                                            : widget.type == 296
                                                ? 'assets/ProviderHeader/Tubi.png'
                                                : widget.type == 391
                                                    ? 'assets/ProviderHeader/Pluto TV.png'
                                                    : widget.type == 232
                                                        ? 'assets/ProviderHeader/Starz.png'
                                                        : 'assets/ProviderHeader/Showtime.png',
            scale: widget.type == 372
                ? 3.3
                : widget.type == 371
                    ? 7
                    : widget.type == 296
                        ? 5
                        : widget.type == 391
                            ? 6
                            : 4,
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.only(left: 30),
              child: Icon(
                Icons.arrow_back_ios,
                size: 32,
                color: widget.type == 388 || widget.type == 371 || widget.type == 232 || widget.type == 391 ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        opacity: 0,
        progressIndicator: SizedBox(width: 20, height: 20, child: kProgressIndicator),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      newNetflix.length <= 3
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 290,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      widget.type == 203
                                          ? 'New On Netflix'
                                          : widget.type == 372
                                              ? 'New On Disney'
                                              : widget.type == 26
                                                  ? 'New On Amazon'
                                                  : widget.type == 387
                                                      ? 'New On HBO Max'
                                                      : widget.type == 157
                                                          ? 'New On Hulu'
                                                          : widget.type == 388
                                                              ? 'New On Peacock'
                                                              : widget.type == 444
                                                                  ? 'New On Paramount'
                                                                  : widget.type == 371
                                                                      ? 'New On Apple TV'
                                                                      : widget.type == 296
                                                                          ? 'New On Tubi'
                                                                          : widget.type == 391
                                                                              ? 'New On Pluto'
                                                                              : widget.type == 391
                                                                                  ? 'New On Starz'
                                                                                  : 'New On Showtime',
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans",
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: newNetflix.length,
                                        itemBuilder: (context, index1) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: newNetflix[index1]['content_third_party_id'],
                                                          contentID: newNetflix[index1]['content_id'],
                                                          contentType: newNetflix[index1]['content_type'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: CachedImage(
                                                      imageUrl: 'https://image.tmdb.org/t/p/original/${newNetflix[index1]['content_photo']}',
                                                      width: MediaQuery.of(context).size.width * 0.42,
                                                      height: 250,
                                                      radius: 6,
                                                      colors: Colors.white,
                                                      thikness: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 7,
                                                  left: 7,
                                                  child: Image.asset(
                                                    widget.type == 203
                                                        ? 'assets/trendingpro/NetflixNew.png'
                                                        : widget.type == 372
                                                            ? 'assets/trendingpro/Disney.png'
                                                            : widget.type == 26
                                                                ? 'assets/trendingpro/AmazonPrime.png'
                                                                : widget.type == 387
                                                                    ? 'assets/trendingpro/HBOMax.png'
                                                                    : widget.type == 157
                                                                        ? 'assets/trendingpro/Hulu.png'
                                                                        : widget.type == 388
                                                                            ? 'assets/trendingpro/Peacock.png'
                                                                            : widget.type == 444
                                                                                ? 'assets/trendingpro/Paramount.png'
                                                                                : widget.type == 371
                                                                                    ? 'assets/trendingpro/AppleTV.png'
                                                                                    : widget.type == 296
                                                                                        ? 'assets/trendingpro/Tubi.png'
                                                                                        : widget.type == 391
                                                                                            ? 'assets/trendingpro/Pluto.png'
                                                                                            : widget.type == 232
                                                                                                ? 'assets/trendingpro/Starz.png'
                                                                                                : 'assets/trendingpro/Showtime.png',
                                                    height: 27,
                                                  ),
                                                ),
                                                newNetflix[index1]['comment_count_top'] == 0
                                                    ? Container()
                                                    : Positioned(
                                                        bottom: 15,
                                                        left: 10,
                                                        right: 10,
                                                        child: Container(
                                                          height: 40,
                                                          width: MediaQuery.of(context).size.width * 0.40,
                                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              AppText(
                                                                '${newNetflix[index1]['comment_count_top']} Comments ',
                                                                fontSize: 16,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(top: 5),
                                                                child: Image.asset(
                                                                  'assets/icons/Comment Icon - Grey.png',
                                                                  height: 16,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      newAmezon.length <= 3
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 290,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      widget.type == 203
                                          ? 'Popular On Netflix'
                                          : widget.type == 372
                                              ? 'Popular On Disney'
                                              : widget.type == 26
                                                  ? 'Popular On Amazon'
                                                  : widget.type == 387
                                                      ? 'Popular On HBO Max'
                                                      : widget.type == 157
                                                          ? 'Popular On Hulu'
                                                          : widget.type == 388
                                                              ? 'Popular On Peacock'
                                                              : widget.type == 444
                                                                  ? 'Popular On Paramount'
                                                                  : widget.type == 371
                                                                      ? 'Popular On Apple TV'
                                                                      : widget.type == 296
                                                                          ? 'Popular On Tubi'
                                                                          : widget.type == 391
                                                                              ? 'Popular On Pluto'
                                                                              : widget.type == 391
                                                                                  ? 'Popular On Starz'
                                                                                  : 'Popular On Showtime',
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans",
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: newAmezon.length,
                                        itemBuilder: (context, index1) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: newAmezon[index1]['content_third_party_id'],
                                                          contentID: newAmezon[index1]['content_id'],
                                                          contentType: newAmezon[index1]['content_type'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: CachedImage(
                                                      imageUrl: 'https://image.tmdb.org/t/p/original/${newAmezon[index1]['content_photo']}',
                                                      width: MediaQuery.of(context).size.width * 0.42,
                                                      height: 250,
                                                      radius: 6,
                                                      colors: Colors.white,
                                                      thikness: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 7,
                                                  left: 7,
                                                  child: Image.asset(
                                                    widget.type == 203
                                                        ? 'assets/trendingpro/NetflixNew.png'
                                                        : widget.type == 372
                                                            ? 'assets/trendingpro/Disney.png'
                                                            : widget.type == 26
                                                                ? 'assets/trendingpro/AmazonPrime.png'
                                                                : widget.type == 387
                                                                    ? 'assets/trendingpro/HBOMax.png'
                                                                    : widget.type == 157
                                                                        ? 'assets/trendingpro/Hulu.png'
                                                                        : widget.type == 388
                                                                            ? 'assets/trendingpro/Peacock.png'
                                                                            : widget.type == 444
                                                                                ? 'assets/trendingpro/Paramount.png'
                                                                                : widget.type == 371
                                                                                    ? 'assets/trendingpro/AppleTV.png'
                                                                                    : widget.type == 296
                                                                                        ? 'assets/trendingpro/Tubi.png'
                                                                                        : widget.type == 391
                                                                                            ? 'assets/trendingpro/Pluto.png'
                                                                                            : widget.type == 232
                                                                                                ? 'assets/trendingpro/Starz.png'
                                                                                                : 'assets/trendingpro/Showtime.png',
                                                    height: 27,
                                                  ),
                                                ),
                                                newAmezon[index1]['comment_count_top'] == 0
                                                    ? Container()
                                                    : Positioned(
                                                        bottom: 15,
                                                        left: 10,
                                                        right: 10,
                                                        child: Container(
                                                          height: 40,
                                                          width: MediaQuery.of(context).size.width * 0.40,
                                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              AppText(
                                                                '${newAmezon[index1]['comment_count_top']} Comments ',
                                                                fontSize: 16,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(top: 5),
                                                                child: Image.asset(
                                                                  'assets/icons/Comment Icon - Grey.png',
                                                                  height: 16,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      SizedBox(height: 10),
                      comingSoonData.length == 0
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 260,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      widget.type == 203
                                          ? 'Coming Soon To Netflix'
                                          : widget.type == 372
                                              ? 'Coming Soon To Disney'
                                              : widget.type == 26
                                                  ? 'Coming Soon To Amazon'
                                                  : widget.type == 387
                                                      ? 'Coming Soon To HBO Max'
                                                      : widget.type == 157
                                                          ? 'Coming Soon To Hulu'
                                                          : widget.type == 388
                                                              ? 'Coming Soon To Peacock'
                                                              : widget.type == 444
                                                                  ? 'Coming Soon To Paramount'
                                                                  : widget.type == 371
                                                                      ? 'Coming Soon To Apple TV'
                                                                      : widget.type == 296
                                                                          ? 'Coming Soon To Tubi'
                                                                          : widget.type == 391
                                                                              ? 'Coming Soon To Pluto'
                                                                              : widget.type == 391
                                                                                  ? 'Coming Soon To Starz'
                                                                                  : 'Coming Soon To Showtime',
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans",
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: comingSoonData.length,
                                        itemBuilder: (context, index1) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 20, bottom: 10),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white)),
                                                  child: CachedImage(
                                                    imageUrl: 'https://oneflixapp.com/oneflix/${comingSoonData[index1]['cover_photo']}',
                                                    width: MediaQuery.of(context).size.width * 0.87,
                                                    height: 210,
                                                    radius: 6,
                                                    colors: Colors.white,
                                                    thikness: 0.5,
                                                  ),
                                                ),
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
                                                                comingSoonData[index1]['youtube_key'] != null
                                                                    ? SizedBox(height: 20, width: 20, child: kProgressIndicator)
                                                                    : Container(),
                                                                comingSoonData[index1]['youtube_key'] != null
                                                                    ? YoutubePlayerIFrame(
                                                                        controller: YoutubePlayerController(
                                                                          initialVideoId: comingSoonData[index1]['youtube_key'],
                                                                          params: YoutubePlayerParams(
                                                                            startAt: Duration(seconds: 1),
                                                                            showControls: true,
                                                                            mute: false,
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
                                                    Icons.play_arrow_rounded,
                                                    size: 100,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 10,
                                                  left: 20,
                                                  child: Image.asset(
                                                    widget.type == 203
                                                        ? 'assets/trendingpro/NetflixNew.png'
                                                        : widget.type == 372
                                                            ? 'assets/trendingpro/Disney.png'
                                                            : widget.type == 26
                                                                ? 'assets/trendingpro/AmazonPrime.png'
                                                                : widget.type == 387
                                                                    ? 'assets/trendingpro/HBOMax.png'
                                                                    : widget.type == 157
                                                                        ? 'assets/trendingpro/Hulu.png'
                                                                        : widget.type == 388
                                                                            ? 'assets/trendingpro/Peacock.png'
                                                                            : widget.type == 444
                                                                                ? 'assets/trendingpro/Paramount.png'
                                                                                : widget.type == 371
                                                                                    ? 'assets/trendingpro/AppleTV.png'
                                                                                    : widget.type == 296
                                                                                        ? 'assets/trendingpro/Tubi.png'
                                                                                        : widget.type == 391
                                                                                            ? 'assets/trendingpro/Pluto.png'
                                                                                            : widget.type == 232
                                                                                                ? 'assets/trendingpro/Starz.png'
                                                                                                : 'assets/trendingpro/Showtime.png',
                                                    height: 70,
                                                    width: 70,
                                                  ),
                                                ),
                                                Positioned(
                                                    bottom: 25,
                                                    right: 20,
                                                    child: Container(
                                                      height: 32,
                                                      width: MediaQuery.of(context).size.width * 0.16,
                                                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6)),
                                                      child: Center(
                                                          child: AppText(
                                                        comingSoonData[index1]['arrival_date'] ?? '',
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w900,
                                                      )),
                                                    ))
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      actionMovie.length <= 3
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 220,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'Action Movies',
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans",
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: actionMovie.length,
                                        itemBuilder: (context, index1) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: actionMovie[index1]['content_third_party_id'],
                                                          contentID: actionMovie[index1]['content_id'],
                                                          contentType: actionMovie[index1]['content_type'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: CachedImage(
                                                      imageUrl: 'https://image.tmdb.org/t/p/original/${actionMovie[index1]['content_photo']}',
                                                      width: MediaQuery.of(context).size.width * 0.27,
                                                      height: 170,
                                                      radius: 6,
                                                      colors: Colors.white,
                                                      thikness: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 7,
                                                  left: 7,
                                                  child: Image.asset(
                                                    widget.type == 203
                                                        ? 'assets/trendingpro/NetflixNew.png'
                                                        : widget.type == 372
                                                            ? 'assets/trendingpro/Disney.png'
                                                            : widget.type == 26
                                                                ? 'assets/trendingpro/AmazonPrime.png'
                                                                : widget.type == 387
                                                                    ? 'assets/trendingpro/HBOMax.png'
                                                                    : widget.type == 157
                                                                        ? 'assets/trendingpro/Hulu.png'
                                                                        : widget.type == 388
                                                                            ? 'assets/trendingpro/Peacock.png'
                                                                            : widget.type == 444
                                                                                ? 'assets/trendingpro/Paramount.png'
                                                                                : widget.type == 371
                                                                                    ? 'assets/trendingpro/AppleTV.png'
                                                                                    : widget.type == 296
                                                                                        ? 'assets/trendingpro/Tubi.png'
                                                                                        : widget.type == 391
                                                                                            ? 'assets/trendingpro/Pluto.png'
                                                                                            : widget.type == 232
                                                                                                ? 'assets/trendingpro/Starz.png'
                                                                                                : 'assets/trendingpro/Showtime.png',
                                                    height: 27,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      familyMovies.length <= 3
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 220,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'Family Movies',
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans",
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: familyMovies.length,
                                        itemBuilder: (context, index1) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: familyMovies[index1]['content_third_party_id'],
                                                          contentID: familyMovies[index1]['content_id'],
                                                          contentType: familyMovies[index1]['content_type'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: CachedImage(
                                                      imageUrl: 'https://image.tmdb.org/t/p/original/${familyMovies[index1]['content_photo']}',
                                                      width: MediaQuery.of(context).size.width * 0.27,
                                                      height: 170,
                                                      radius: 6,
                                                      colors: Colors.white,
                                                      thikness: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 7,
                                                  left: 7,
                                                  child: Image.asset(
                                                    widget.type == 203
                                                        ? 'assets/trendingpro/NetflixNew.png'
                                                        : widget.type == 372
                                                            ? 'assets/trendingpro/Disney.png'
                                                            : widget.type == 26
                                                                ? 'assets/trendingpro/AmazonPrime.png'
                                                                : widget.type == 387
                                                                    ? 'assets/trendingpro/HBOMax.png'
                                                                    : widget.type == 157
                                                                        ? 'assets/trendingpro/Hulu.png'
                                                                        : widget.type == 388
                                                                            ? 'assets/trendingpro/Peacock.png'
                                                                            : widget.type == 444
                                                                                ? 'assets/trendingpro/Paramount.png'
                                                                                : widget.type == 371
                                                                                    ? 'assets/trendingpro/AppleTV.png'
                                                                                    : widget.type == 296
                                                                                        ? 'assets/trendingpro/Tubi.png'
                                                                                        : widget.type == 391
                                                                                            ? 'assets/trendingpro/Pluto.png'
                                                                                            : widget.type == 232
                                                                                                ? 'assets/trendingpro/Starz.png'
                                                                                                : 'assets/trendingpro/Showtime.png',
                                                    height: 27,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      comedyMovie.length <= 3
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 220,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'Comedy Movies',
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans",
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: comedyMovie.length,
                                        itemBuilder: (context, index1) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: comedyMovie[index1]['content_third_party_id'],
                                                          contentID: comedyMovie[index1]['content_id'],
                                                          contentType: comedyMovie[index1]['content_type'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: CachedImage(
                                                      imageUrl: 'https://image.tmdb.org/t/p/original/${comedyMovie[index1]['content_photo']}',
                                                      width: MediaQuery.of(context).size.width * 0.27,
                                                      height: 170,
                                                      radius: 6,
                                                      colors: Colors.white,
                                                      thikness: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 7,
                                                  left: 7,
                                                  child: Image.asset(
                                                    widget.type == 203
                                                        ? 'assets/trendingpro/NetflixNew.png'
                                                        : widget.type == 372
                                                            ? 'assets/trendingpro/Disney.png'
                                                            : widget.type == 26
                                                                ? 'assets/trendingpro/AmazonPrime.png'
                                                                : widget.type == 387
                                                                    ? 'assets/trendingpro/HBOMax.png'
                                                                    : widget.type == 157
                                                                        ? 'assets/trendingpro/Hulu.png'
                                                                        : widget.type == 388
                                                                            ? 'assets/trendingpro/Peacock.png'
                                                                            : widget.type == 444
                                                                                ? 'assets/trendingpro/Paramount.png'
                                                                                : widget.type == 371
                                                                                    ? 'assets/trendingpro/AppleTV.png'
                                                                                    : widget.type == 296
                                                                                        ? 'assets/trendingpro/Tubi.png'
                                                                                        : widget.type == 391
                                                                                            ? 'assets/trendingpro/Pluto.png'
                                                                                            : widget.type == 232
                                                                                                ? 'assets/trendingpro/Starz.png'
                                                                                                : 'assets/trendingpro/Showtime.png',
                                                    height: 27,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      scienceFictionMovie.length <= 3
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 220,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'Science Fiction Movies',
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans",
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: scienceFictionMovie.length,
                                        itemBuilder: (context, index1) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: scienceFictionMovie[index1]['content_third_party_id'],
                                                          contentID: scienceFictionMovie[index1]['content_id'],
                                                          contentType: scienceFictionMovie[index1]['content_type'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: CachedImage(
                                                      imageUrl: 'https://image.tmdb.org/t/p/original/${scienceFictionMovie[index1]['content_photo']}',
                                                      width: MediaQuery.of(context).size.width * 0.27,
                                                      height: 170,
                                                      radius: 6,
                                                      colors: Colors.white,
                                                      thikness: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 7,
                                                  left: 7,
                                                  child: Image.asset(
                                                    widget.type == 203
                                                        ? 'assets/trendingpro/NetflixNew.png'
                                                        : widget.type == 372
                                                            ? 'assets/trendingpro/Disney.png'
                                                            : widget.type == 26
                                                                ? 'assets/trendingpro/AmazonPrime.png'
                                                                : widget.type == 387
                                                                    ? 'assets/trendingpro/HBOMax.png'
                                                                    : widget.type == 157
                                                                        ? 'assets/trendingpro/Hulu.png'
                                                                        : widget.type == 388
                                                                            ? 'assets/trendingpro/Peacock.png'
                                                                            : widget.type == 444
                                                                                ? 'assets/trendingpro/Paramount.png'
                                                                                : widget.type == 371
                                                                                    ? 'assets/trendingpro/AppleTV.png'
                                                                                    : widget.type == 296
                                                                                        ? 'assets/trendingpro/Tubi.png'
                                                                                        : widget.type == 391
                                                                                            ? 'assets/trendingpro/Pluto.png'
                                                                                            : widget.type == 232
                                                                                                ? 'assets/trendingpro/Starz.png'
                                                                                                : 'assets/trendingpro/Showtime.png',
                                                    height: 27,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      romanceMovie.length <= 3
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 220,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'Romance Movies',
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans",
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: romanceMovie.length,
                                        itemBuilder: (context, index1) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: romanceMovie[index1]['content_third_party_id'],
                                                          contentID: romanceMovie[index1]['content_id'],
                                                          contentType: romanceMovie[index1]['content_type'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: CachedImage(
                                                      imageUrl: 'https://image.tmdb.org/t/p/original/${romanceMovie[index1]['content_photo']}',
                                                      width: MediaQuery.of(context).size.width * 0.27,
                                                      height: 170,
                                                      radius: 6,
                                                      colors: Colors.white,
                                                      thikness: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 7,
                                                  left: 7,
                                                  child: Image.asset(
                                                    widget.type == 203
                                                        ? 'assets/trendingpro/NetflixNew.png'
                                                        : widget.type == 372
                                                            ? 'assets/trendingpro/Disney.png'
                                                            : widget.type == 26
                                                                ? 'assets/trendingpro/AmazonPrime.png'
                                                                : widget.type == 387
                                                                    ? 'assets/trendingpro/HBOMax.png'
                                                                    : widget.type == 157
                                                                        ? 'assets/trendingpro/Hulu.png'
                                                                        : widget.type == 388
                                                                            ? 'assets/trendingpro/Peacock.png'
                                                                            : widget.type == 444
                                                                                ? 'assets/trendingpro/Paramount.png'
                                                                                : widget.type == 371
                                                                                    ? 'assets/trendingpro/AppleTV.png'
                                                                                    : widget.type == 296
                                                                                        ? 'assets/trendingpro/Tubi.png'
                                                                                        : widget.type == 391
                                                                                            ? 'assets/trendingpro/Pluto.png'
                                                                                            : widget.type == 232
                                                                                                ? 'assets/trendingpro/Starz.png'
                                                                                                : 'assets/trendingpro/Showtime.png',
                                                    height: 27,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      comedyTv.length <= 3
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 220,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'Comedy TV Shows',
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans",
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: comedyTv.length,
                                        itemBuilder: (context, index1) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: comedyTv[index1]['content_third_party_id'],
                                                          contentID: comedyTv[index1]['content_id'],
                                                          contentType: comedyTv[index1]['content_type'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: CachedImage(
                                                      imageUrl: 'https://image.tmdb.org/t/p/original/${comedyTv[index1]['content_photo']}',
                                                      width: MediaQuery.of(context).size.width * 0.27,
                                                      height: 170,
                                                      radius: 6,
                                                      colors: Colors.white,
                                                      thikness: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 7,
                                                  left: 7,
                                                  child: Image.asset(
                                                    widget.type == 203
                                                        ? 'assets/trendingpro/NetflixNew.png'
                                                        : widget.type == 372
                                                            ? 'assets/trendingpro/Disney.png'
                                                            : widget.type == 26
                                                                ? 'assets/trendingpro/AmazonPrime.png'
                                                                : widget.type == 387
                                                                    ? 'assets/trendingpro/HBOMax.png'
                                                                    : widget.type == 157
                                                                        ? 'assets/trendingpro/Hulu.png'
                                                                        : widget.type == 388
                                                                            ? 'assets/trendingpro/Peacock.png'
                                                                            : widget.type == 444
                                                                                ? 'assets/trendingpro/Paramount.png'
                                                                                : widget.type == 371
                                                                                    ? 'assets/trendingpro/AppleTV.png'
                                                                                    : widget.type == 296
                                                                                        ? 'assets/trendingpro/Tubi.png'
                                                                                        : widget.type == 391
                                                                                            ? 'assets/trendingpro/Pluto.png'
                                                                                            : widget.type == 232
                                                                                                ? 'assets/trendingpro/Starz.png'
                                                                                                : 'assets/trendingpro/Showtime.png',
                                                    height: 27,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      adventureMovies.length <= 3
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 220,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'Adventure Movies',
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans",
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: adventureMovies.length,
                                        itemBuilder: (context, index1) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: adventureMovies[index1]['content_third_party_id'],
                                                          contentID: adventureMovies[index1]['content_id'],
                                                          contentType: adventureMovies[index1]['content_type'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: CachedImage(
                                                      imageUrl: 'https://image.tmdb.org/t/p/original/${adventureMovies[index1]['content_photo']}',
                                                      width: MediaQuery.of(context).size.width * 0.27,
                                                      height: 170,
                                                      radius: 6,
                                                      colors: Colors.white,
                                                      thikness: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 7,
                                                  left: 7,
                                                  child: Image.asset(
                                                    widget.type == 203
                                                        ? 'assets/trendingpro/NetflixNew.png'
                                                        : widget.type == 372
                                                            ? 'assets/trendingpro/Disney.png'
                                                            : widget.type == 26
                                                                ? 'assets/trendingpro/AmazonPrime.png'
                                                                : widget.type == 387
                                                                    ? 'assets/trendingpro/HBOMax.png'
                                                                    : widget.type == 157
                                                                        ? 'assets/trendingpro/Hulu.png'
                                                                        : widget.type == 388
                                                                            ? 'assets/trendingpro/Peacock.png'
                                                                            : widget.type == 444
                                                                                ? 'assets/trendingpro/Paramount.png'
                                                                                : widget.type == 371
                                                                                    ? 'assets/trendingpro/AppleTV.png'
                                                                                    : widget.type == 296
                                                                                        ? 'assets/trendingpro/Tubi.png'
                                                                                        : widget.type == 391
                                                                                            ? 'assets/trendingpro/Pluto.png'
                                                                                            : widget.type == 232
                                                                                                ? 'assets/trendingpro/Starz.png'
                                                                                                : 'assets/trendingpro/Showtime.png',
                                                    height: 27,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      scifiFanstyTv.length <= 3
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 220,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'Sci-Fi & Fantasy TV Shows',
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans",
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: scifiFanstyTv.length,
                                        itemBuilder: (context, index1) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: scifiFanstyTv[index1]['content_third_party_id'],
                                                          contentID: scifiFanstyTv[index1]['content_id'],
                                                          contentType: scifiFanstyTv[index1]['content_type'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: CachedImage(
                                                      imageUrl: 'https://image.tmdb.org/t/p/original/${scifiFanstyTv[index1]['content_photo']}',
                                                      width: MediaQuery.of(context).size.width * 0.27,
                                                      height: 170,
                                                      radius: 6,
                                                      colors: Colors.white,
                                                      thikness: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 7,
                                                  left: 7,
                                                  child: Image.asset(
                                                    widget.type == 203
                                                        ? 'assets/trendingpro/NetflixNew.png'
                                                        : widget.type == 372
                                                            ? 'assets/trendingpro/Disney.png'
                                                            : widget.type == 26
                                                                ? 'assets/trendingpro/AmazonPrime.png'
                                                                : widget.type == 387
                                                                    ? 'assets/trendingpro/HBOMax.png'
                                                                    : widget.type == 157
                                                                        ? 'assets/trendingpro/Hulu.png'
                                                                        : widget.type == 388
                                                                            ? 'assets/trendingpro/Peacock.png'
                                                                            : widget.type == 444
                                                                                ? 'assets/trendingpro/Paramount.png'
                                                                                : widget.type == 371
                                                                                    ? 'assets/trendingpro/AppleTV.png'
                                                                                    : widget.type == 296
                                                                                        ? 'assets/trendingpro/Tubi.png'
                                                                                        : widget.type == 391
                                                                                            ? 'assets/trendingpro/Pluto.png'
                                                                                            : widget.type == 232
                                                                                                ? 'assets/trendingpro/Starz.png'
                                                                                                : 'assets/trendingpro/Showtime.png',
                                                    height: 27,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      actionTv.length <= 3
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 220,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'Action & Adventure TV Shows',
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans",
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: actionTv.length,
                                        itemBuilder: (context, index1) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: actionTv[index1]['content_third_party_id'],
                                                          contentID: actionTv[index1]['content_id'],
                                                          contentType: actionTv[index1]['content_type'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: CachedImage(
                                                      imageUrl: 'https://image.tmdb.org/t/p/original/${actionTv[index1]['content_photo']}',
                                                      width: MediaQuery.of(context).size.width * 0.27,
                                                      height: 170,
                                                      radius: 6,
                                                      colors: Colors.white,
                                                      thikness: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 7,
                                                  left: 7,
                                                  child: Image.asset(
                                                    widget.type == 203
                                                        ? 'assets/trendingpro/NetflixNew.png'
                                                        : widget.type == 372
                                                            ? 'assets/trendingpro/Disney.png'
                                                            : widget.type == 26
                                                                ? 'assets/trendingpro/AmazonPrime.png'
                                                                : widget.type == 387
                                                                    ? 'assets/trendingpro/HBOMax.png'
                                                                    : widget.type == 157
                                                                        ? 'assets/trendingpro/Hulu.png'
                                                                        : widget.type == 388
                                                                            ? 'assets/trendingpro/Peacock.png'
                                                                            : widget.type == 444
                                                                                ? 'assets/trendingpro/Paramount.png'
                                                                                : widget.type == 371
                                                                                    ? 'assets/trendingpro/AppleTV.png'
                                                                                    : widget.type == 296
                                                                                        ? 'assets/trendingpro/Tubi.png'
                                                                                        : widget.type == 391
                                                                                            ? 'assets/trendingpro/Pluto.png'
                                                                                            : widget.type == 232
                                                                                                ? 'assets/trendingpro/Starz.png'
                                                                                                : 'assets/trendingpro/Showtime.png',
                                                    height: 27,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      crimeTv.length <= 3
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.only(top: 25),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 220,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'Crime TV Shows',
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans",
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: crimeTv.length,
                                        itemBuilder: (context, index1) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: crimeTv[index1]['content_third_party_id'],
                                                          contentID: crimeTv[index1]['content_id'],
                                                          contentType: crimeTv[index1]['content_type'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: CachedImage(
                                                      imageUrl: 'https://image.tmdb.org/t/p/original/${crimeTv[index1]['content_photo']}',
                                                      width: MediaQuery.of(context).size.width * 0.27,
                                                      height: 170,
                                                      radius: 6,
                                                      colors: Colors.white,
                                                      thikness: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 7,
                                                  left: 7,
                                                  child: Image.asset(
                                                    widget.type == 203
                                                        ? 'assets/trendingpro/NetflixNew.png'
                                                        : widget.type == 372
                                                            ? 'assets/trendingpro/Disney.png'
                                                            : widget.type == 26
                                                                ? 'assets/trendingpro/AmazonPrime.png'
                                                                : widget.type == 387
                                                                    ? 'assets/trendingpro/HBOMax.png'
                                                                    : widget.type == 157
                                                                        ? 'assets/trendingpro/Hulu.png'
                                                                        : widget.type == 388
                                                                            ? 'assets/trendingpro/Peacock.png'
                                                                            : widget.type == 444
                                                                                ? 'assets/trendingpro/Paramount.png'
                                                                                : widget.type == 371
                                                                                    ? 'assets/trendingpro/AppleTV.png'
                                                                                    : widget.type == 296
                                                                                        ? 'assets/trendingpro/Tubi.png'
                                                                                        : widget.type == 391
                                                                                            ? 'assets/trendingpro/Pluto.png'
                                                                                            : widget.type == 232
                                                                                                ? 'assets/trendingpro/Starz.png'
                                                                                                : 'assets/trendingpro/Showtime.png',
                                                    height: 27,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      fanstasyMovie.length <= 3
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.only(top: 25),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 220,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'Fantasy Movies',
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans",
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: fanstasyMovie.length,
                                        itemBuilder: (context, index1) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: fanstasyMovie[index1]['content_third_party_id'],
                                                          contentID: fanstasyMovie[index1]['content_id'],
                                                          contentType: fanstasyMovie[index1]['content_type'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: CachedImage(
                                                      imageUrl: 'https://image.tmdb.org/t/p/original/${fanstasyMovie[index1]['content_photo']}',
                                                      width: MediaQuery.of(context).size.width * 0.27,
                                                      height: 170,
                                                      radius: 6,
                                                      colors: Colors.white,
                                                      thikness: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 7,
                                                  left: 7,
                                                  child: Image.asset(
                                                    widget.type == 203
                                                        ? 'assets/trendingpro/NetflixNew.png'
                                                        : widget.type == 372
                                                            ? 'assets/trendingpro/Disney.png'
                                                            : widget.type == 26
                                                                ? 'assets/trendingpro/AmazonPrime.png'
                                                                : widget.type == 387
                                                                    ? 'assets/trendingpro/HBOMax.png'
                                                                    : widget.type == 157
                                                                        ? 'assets/trendingpro/Hulu.png'
                                                                        : widget.type == 388
                                                                            ? 'assets/trendingpro/Peacock.png'
                                                                            : widget.type == 444
                                                                                ? 'assets/trendingpro/Paramount.png'
                                                                                : widget.type == 371
                                                                                    ? 'assets/trendingpro/AppleTV.png'
                                                                                    : widget.type == 296
                                                                                        ? 'assets/trendingpro/Tubi.png'
                                                                                        : widget.type == 391
                                                                                            ? 'assets/trendingpro/Pluto.png'
                                                                                            : widget.type == 232
                                                                                                ? 'assets/trendingpro/Starz.png'
                                                                                                : 'assets/trendingpro/Showtime.png',
                                                    height: 27,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      dramaMovies.length <= 3
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 220,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'Drama Movies',
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans",
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: dramaMovies.length,
                                        itemBuilder: (context, index1) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: dramaMovies[index1]['content_third_party_id'],
                                                          contentID: dramaMovies[index1]['content_id'],
                                                          contentType: dramaMovies[index1]['content_type'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: CachedImage(
                                                      imageUrl: 'https://image.tmdb.org/t/p/original/${dramaMovies[index1]['content_photo']}',
                                                      width: MediaQuery.of(context).size.width * 0.27,
                                                      height: 170,
                                                      radius: 6,
                                                      colors: Colors.white,
                                                      thikness: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 7,
                                                  left: 7,
                                                  child: Image.asset(
                                                    widget.type == 203
                                                        ? 'assets/trendingpro/NetflixNew.png'
                                                        : widget.type == 372
                                                            ? 'assets/trendingpro/Disney.png'
                                                            : widget.type == 26
                                                                ? 'assets/trendingpro/AmazonPrime.png'
                                                                : widget.type == 387
                                                                    ? 'assets/trendingpro/HBOMax.png'
                                                                    : widget.type == 157
                                                                        ? 'assets/trendingpro/Hulu.png'
                                                                        : widget.type == 388
                                                                            ? 'assets/trendingpro/Peacock.png'
                                                                            : widget.type == 444
                                                                                ? 'assets/trendingpro/Paramount.png'
                                                                                : widget.type == 371
                                                                                    ? 'assets/trendingpro/AppleTV.png'
                                                                                    : widget.type == 296
                                                                                        ? 'assets/trendingpro/Tubi.png'
                                                                                        : widget.type == 391
                                                                                            ? 'assets/trendingpro/Pluto.png'
                                                                                            : widget.type == 232
                                                                                                ? 'assets/trendingpro/Starz.png'
                                                                                                : 'assets/trendingpro/Showtime.png',
                                                    height: 27,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      familyTv.length <= 3
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 220,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'Family TV Shows',
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans",
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: familyTv.length,
                                        itemBuilder: (context, index1) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: familyTv[index1]['content_third_party_id'],
                                                          contentID: familyTv[index1]['content_id'],
                                                          contentType: familyTv[index1]['content_type'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: CachedImage(
                                                      imageUrl: 'https://image.tmdb.org/t/p/original/${familyTv[index1]['content_photo']}',
                                                      width: MediaQuery.of(context).size.width * 0.27,
                                                      height: 170,
                                                      radius: 6,
                                                      colors: Colors.white,
                                                      thikness: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 7,
                                                  left: 7,
                                                  child: Image.asset(
                                                    widget.type == 203
                                                        ? 'assets/trendingpro/NetflixNew.png'
                                                        : widget.type == 372
                                                            ? 'assets/trendingpro/Disney.png'
                                                            : widget.type == 26
                                                                ? 'assets/trendingpro/AmazonPrime.png'
                                                                : widget.type == 387
                                                                    ? 'assets/trendingpro/HBOMax.png'
                                                                    : widget.type == 157
                                                                        ? 'assets/trendingpro/Hulu.png'
                                                                        : widget.type == 388
                                                                            ? 'assets/trendingpro/Peacock.png'
                                                                            : widget.type == 444
                                                                                ? 'assets/trendingpro/Paramount.png'
                                                                                : widget.type == 371
                                                                                    ? 'assets/trendingpro/AppleTV.png'
                                                                                    : widget.type == 296
                                                                                        ? 'assets/trendingpro/Tubi.png'
                                                                                        : widget.type == 391
                                                                                            ? 'assets/trendingpro/Pluto.png'
                                                                                            : widget.type == 232
                                                                                                ? 'assets/trendingpro/Starz.png'
                                                                                                : 'assets/trendingpro/Showtime.png',
                                                    height: 27,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      dramaTv.length <= 3
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 220,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'Drama TV Shows',
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans",
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: dramaTv.length,
                                        itemBuilder: (context, index1) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: dramaTv[index1]['content_third_party_id'],
                                                          contentID: dramaTv[index1]['content_id'],
                                                          contentType: dramaTv[index1]['content_type'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: CachedImage(
                                                      imageUrl: 'https://image.tmdb.org/t/p/original/${dramaTv[index1]['content_photo']}',
                                                      width: MediaQuery.of(context).size.width * 0.27,
                                                      height: 170,
                                                      radius: 6,
                                                      colors: Colors.white,
                                                      thikness: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 7,
                                                  left: 7,
                                                  child: Image.asset(
                                                    widget.type == 203
                                                        ? 'assets/trendingpro/NetflixNew.png'
                                                        : widget.type == 372
                                                            ? 'assets/trendingpro/Disney.png'
                                                            : widget.type == 26
                                                                ? 'assets/trendingpro/AmazonPrime.png'
                                                                : widget.type == 387
                                                                    ? 'assets/trendingpro/HBOMax.png'
                                                                    : widget.type == 157
                                                                        ? 'assets/trendingpro/Hulu.png'
                                                                        : widget.type == 388
                                                                            ? 'assets/trendingpro/Peacock.png'
                                                                            : widget.type == 444
                                                                                ? 'assets/trendingpro/Paramount.png'
                                                                                : widget.type == 371
                                                                                    ? 'assets/trendingpro/AppleTV.png'
                                                                                    : widget.type == 296
                                                                                        ? 'assets/trendingpro/Tubi.png'
                                                                                        : widget.type == 391
                                                                                            ? 'assets/trendingpro/Pluto.png'
                                                                                            : widget.type == 232
                                                                                                ? 'assets/trendingpro/Starz.png'
                                                                                                : 'assets/trendingpro/Showtime.png',
                                                    height: 27,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      thillerMovie.length <= 3
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 220,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'Thriller Movies',
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans",
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: thillerMovie.length,
                                        itemBuilder: (context, index1) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: thillerMovie[index1]['content_third_party_id'],
                                                          contentID: thillerMovie[index1]['content_id'],
                                                          contentType: thillerMovie[index1]['content_type'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: CachedImage(
                                                      imageUrl: 'https://image.tmdb.org/t/p/original/${thillerMovie[index1]['content_photo']}',
                                                      width: MediaQuery.of(context).size.width * 0.27,
                                                      height: 170,
                                                      radius: 6,
                                                      colors: Colors.white,
                                                      thikness: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 7,
                                                  left: 7,
                                                  child: Image.asset(
                                                    widget.type == 203
                                                        ? 'assets/trendingpro/NetflixNew.png'
                                                        : widget.type == 372
                                                            ? 'assets/trendingpro/Disney.png'
                                                            : widget.type == 26
                                                                ? 'assets/trendingpro/AmazonPrime.png'
                                                                : widget.type == 387
                                                                    ? 'assets/trendingpro/HBOMax.png'
                                                                    : widget.type == 157
                                                                        ? 'assets/trendingpro/Hulu.png'
                                                                        : widget.type == 388
                                                                            ? 'assets/trendingpro/Peacock.png'
                                                                            : widget.type == 444
                                                                                ? 'assets/trendingpro/Paramount.png'
                                                                                : widget.type == 371
                                                                                    ? 'assets/trendingpro/AppleTV.png'
                                                                                    : widget.type == 296
                                                                                        ? 'assets/trendingpro/Tubi.png'
                                                                                        : widget.type == 391
                                                                                            ? 'assets/trendingpro/Pluto.png'
                                                                                            : widget.type == 232
                                                                                                ? 'assets/trendingpro/Starz.png'
                                                                                                : 'assets/trendingpro/Showtime.png',
                                                    height: 27,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      horrorMovie.length <= 3
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 220,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'Horror Movies',
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans",
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: horrorMovie.length,
                                        itemBuilder: (context, index1) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: horrorMovie[index1]['content_third_party_id'],
                                                          contentID: horrorMovie[index1]['content_id'],
                                                          contentType: horrorMovie[index1]['content_type'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: CachedImage(
                                                      imageUrl: 'https://image.tmdb.org/t/p/original/${horrorMovie[index1]['content_photo']}',
                                                      width: MediaQuery.of(context).size.width * 0.27,
                                                      height: 170,
                                                      radius: 6,
                                                      colors: Colors.white,
                                                      thikness: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 7,
                                                  left: 7,
                                                  child: Image.asset(
                                                    widget.type == 203
                                                        ? 'assets/trendingpro/NetflixNew.png'
                                                        : widget.type == 372
                                                            ? 'assets/trendingpro/Disney.png'
                                                            : widget.type == 26
                                                                ? 'assets/trendingpro/AmazonPrime.png'
                                                                : widget.type == 387
                                                                    ? 'assets/trendingpro/HBOMax.png'
                                                                    : widget.type == 157
                                                                        ? 'assets/trendingpro/Hulu.png'
                                                                        : widget.type == 388
                                                                            ? 'assets/trendingpro/Peacock.png'
                                                                            : widget.type == 444
                                                                                ? 'assets/trendingpro/Paramount.png'
                                                                                : widget.type == 371
                                                                                    ? 'assets/trendingpro/AppleTV.png'
                                                                                    : widget.type == 296
                                                                                        ? 'assets/trendingpro/Tubi.png'
                                                                                        : widget.type == 391
                                                                                            ? 'assets/trendingpro/Pluto.png'
                                                                                            : widget.type == 232
                                                                                                ? 'assets/trendingpro/Starz.png'
                                                                                                : 'assets/trendingpro/Showtime.png',
                                                    height: 27,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
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
      ),
    );
  }
}
