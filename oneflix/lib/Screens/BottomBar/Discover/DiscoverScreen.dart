import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Components/LiveDot.dart';
import 'package:oneflix/Constants.dart';
import 'package:oneflix/Screens/BottomBar/Discover/PlatformContent.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  TextEditingController search = TextEditingController();

  List<ScrollController> newController = [];
  List<ScrollController> popularController = [];

  int selectedType = 1;
  bool isSearch = false;

  @override
  void initState() {
    setState(() {});
    getToken();
    Timer.periodic(Duration(seconds: 5), (Timer t) async => _getActiveUserCount());
    search.addListener(_onMovieTvSearch);
    super.initState();
  }

  Future<void> _getActiveUserCount() async {
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

  String? userToken;
  getToken() async {
    var token = await readData('user_token');
    setState(() {
      userToken = token;
    });
    await _getActiveUserCount();
    await _getDiscoverContent();
  }

  _onMovieTvSearch() {
    Timer? _debounce;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (search.text.length != 0) {
        await _searchMoviesTvDetails(search.text.replaceAll(" ", "%20"));
      }
    });
  }

  @override
  void dispose() {
    search.removeListener(_onMovieTvSearch);
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    double mHeight = MediaQuery.of(context).size.height;
    return ModalProgressHUD(
      inAsyncCall: _loading,
      progressIndicator: SizedBox(width: 20, height: 20, child: kProgressIndicator),
      opacity: 0,
      child: Scaffold(
        backgroundColor: Color(0xff011138),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Visibility(
                    visible: isSearch,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              FocusScope.of(context).requestFocus(FocusNode());
                              search.clear();
                              isSearch = false;
                            });
                          },
                          child: Icon(Icons.chevron_left, size: 45),
                        ),
                      ),
                    ),
                  ),
                  CustomTextField1(
                    hintText: 'Search for a movie or tv show',
                    hintStyle: TextStyle(color: Color(0xff494949), fontFamily: 'OpenSans', fontSize: 14, fontWeight: FontWeight.bold),
                    controller: search,
                    input: TextInputType.text,
                    onChanged: (val) {
                      if (val.isEmpty) {
                        isSearch = false;
                      } else {
                        isSearch = true;
                      }
                      setState(() {});
                    },
                  ),
                  !isSearch
                      ? Expanded(
                          child: Column(
                            children: [
                              SizedBox(height: 30),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 54,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(9)),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SwitchButton(
                                          bgColor: selectedType == 1 ? true : false,
                                          textColor: selectedType == 1 ? Colors.white : Colors.black,
                                          selectedButton: selectedType,
                                          fontWeight: FontWeight.w900,
                                          text: 'FREE CONTENT',
                                          fontSize: 18,
                                          onPressed: () {
                                            setState(() {
                                              selectedType = 1;
                                            });
                                            _getDiscoverContent();
                                          }),
                                      SwitchButton(
                                          bgColor: selectedType == 2 ? true : false,
                                          textColor: selectedType == 2 ? Colors.white : Colors.black,
                                          selectedButton: selectedType,
                                          fontWeight: FontWeight.w900,
                                          text: 'FOR YOU',
                                          fontSize: 18,
                                          onPressed: () {
                                            setState(() {
                                              selectedType = 2;
                                            });
                                            _getDiscoverForYouContent();
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              selectedType == 1
                                  ? Expanded(
                                      child: ListView(
                                      children: [
                                        recentlyAdded.length == 0
                                            ? Container()
                                            : Container(
                                                margin: EdgeInsets.symmetric(horizontal: 20),
                                                height: 290,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    AppText(
                                                      'Recently Added',
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: "OpenSans",
                                                    ),
                                                    Expanded(
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        scrollDirection: Axis.horizontal,
                                                        itemCount: recentlyAdded.length,
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
                                                                        builder: (context) => PlatformContent(
                                                                          id: int.parse(recentlyAdded[index1]['content_third_party_id']),
                                                                          contentType: recentlyAdded[index1]['content_type'],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(6),
                                                                    ),
                                                                    child: CachedImage(
                                                                      imageUrl: 'https://image.tmdb.org/t/p/original/${recentlyAdded[index1]['content_photo']}',
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
                                                                  right: 7,
                                                                  child: Image.asset(
                                                                    'assets/icons/Free Icon.png',
                                                                    height: 28,
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
                                        mostPopular.length == 0
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
                                                        'Most Popular',
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: "OpenSans",
                                                      ),
                                                      Expanded(
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          scrollDirection: Axis.horizontal,
                                                          itemCount: mostPopular.length,
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
                                                                          builder: (context) => PlatformContent(
                                                                            id: int.parse(mostPopular[index1]['content_third_party_id']),
                                                                            contentType: mostPopular[index1]['content_type'],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(6),
                                                                      ),
                                                                      child: CachedImage(
                                                                        imageUrl: 'https://image.tmdb.org/t/p/original/${mostPopular[index1]['content_photo']}',
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
                                                                    right: 7,
                                                                    child: Image.asset(
                                                                      'assets/icons/Free Icon.png',
                                                                      height: 28,
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
                                        actionMovie.length == 0
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
                                                                          builder: (context) => PlatformContent(
                                                                            id: int.parse(actionMovie[index1]['content_third_party_id']),
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
                                                                    right: 7,
                                                                    child: Image.asset(
                                                                      'assets/icons/Free Icon.png',
                                                                      height: 25,
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
                                        comedyMovie.length == 0
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
                                                                          builder: (context) => PlatformContent(
                                                                            id: int.parse(comedyMovie[index1]['content_third_party_id']),
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
                                                                    right: 7,
                                                                    child: Image.asset(
                                                                      'assets/icons/Free Icon.png',
                                                                      height: 25,
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
                                        scienceFictionMovie.length == 0
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
                                                                          builder: (context) => PlatformContent(
                                                                            id: int.parse(scienceFictionMovie[index1]['content_third_party_id']),
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
                                                                    right: 7,
                                                                    child: Image.asset(
                                                                      'assets/icons/Free Icon.png',
                                                                      height: 25,
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
                                        familyMovies.length == 0
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
                                                                          builder: (context) => PlatformContent(
                                                                            id: int.parse(familyMovies[index1]['content_third_party_id']),
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
                                                                    right: 7,
                                                                    child: Image.asset(
                                                                      'assets/icons/Free Icon.png',
                                                                      height: 25,
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
                                        dramaMovies.length == 0
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
                                                                          builder: (context) => PlatformContent(
                                                                            id: int.parse(dramaMovies[index1]['content_third_party_id']),
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
                                                                    right: 7,
                                                                    child: Image.asset(
                                                                      'assets/icons/Free Icon.png',
                                                                      height: 25,
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
                                        adventureMovies.length == 0
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
                                                                          builder: (context) => PlatformContent(
                                                                            id: int.parse(adventureMovies[index1]['content_third_party_id']),
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
                                                                    right: 7,
                                                                    child: Image.asset(
                                                                      'assets/icons/Free Icon.png',
                                                                      height: 25,
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
                                        thrillerMovies.length == 0
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
                                                          itemCount: thrillerMovies.length,
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
                                                                          builder: (context) => PlatformContent(
                                                                            id: int.parse(thrillerMovies[index1]['content_third_party_id']),
                                                                            contentType: thrillerMovies[index1]['content_type'],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(6),
                                                                      ),
                                                                      child: CachedImage(
                                                                        imageUrl: 'https://image.tmdb.org/t/p/original/${thrillerMovies[index1]['content_photo']}',
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
                                                                    right: 7,
                                                                    child: Image.asset(
                                                                      'assets/icons/Free Icon.png',
                                                                      height: 25,
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
                                        horrorMovies.length == 0
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
                                                          itemCount: horrorMovies.length,
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
                                                                          builder: (context) => PlatformContent(
                                                                            id: int.parse(horrorMovies[index1]['content_third_party_id']),
                                                                            contentType: horrorMovies[index1]['content_type'],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(6),
                                                                      ),
                                                                      child: CachedImage(
                                                                        imageUrl: 'https://image.tmdb.org/t/p/original/${horrorMovies[index1]['content_photo']}',
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
                                                                    right: 7,
                                                                    child: Image.asset(
                                                                      'assets/icons/Free Icon.png',
                                                                      height: 25,
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
                                              )
                                      ],
                                    ))
                                  : Expanded(
                                      child: ListView(
                                        children: [
                                          yourWatchList.length == 0
                                              ? Container()
                                              : Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                                  height: 220,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      AppText(
                                                        'Your Watchlist',
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: "OpenSans",
                                                      ),
                                                      Expanded(
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          scrollDirection: Axis.horizontal,
                                                          itemCount: yourWatchList.length,
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
                                                                          builder: (context) => PlatformContent(
                                                                            id: yourWatchList[index1]['content_third_party_id'],
                                                                            contentType: yourWatchList[index1]['watch_type'],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(6),
                                                                      ),
                                                                      child: CachedImage(
                                                                        imageUrl: 'https://image.tmdb.org/t/p/original/${yourWatchList[index1]['poster_path']}',
                                                                        width: MediaQuery.of(context).size.width * 0.27,
                                                                        height: 170,
                                                                        radius: 6,
                                                                        colors: Colors.white,
                                                                        thikness: 0.5,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          recomandByFriend.length == 0
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
                                                          'Recommended By Your Friends',
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "OpenSans",
                                                        ),
                                                        Expanded(
                                                          child: ListView.builder(
                                                            shrinkWrap: true,
                                                            scrollDirection: Axis.horizontal,
                                                            itemCount: recomandByFriend.length,
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
                                                                            builder: (context) => PlatformContent(
                                                                              id: int.parse(recomandByFriend[index1]['content_third_party_id']),
                                                                              contentType: recomandByFriend[index1]['content_type'],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(6),
                                                                        ),
                                                                        child: CachedImage(
                                                                          imageUrl: 'https://image.tmdb.org/t/p/original/${recomandByFriend[index1]['content_photo']}',
                                                                          width: MediaQuery.of(context).size.width * 0.27,
                                                                          height: 170,
                                                                          radius: 6,
                                                                          colors: Colors.white,
                                                                          thikness: 0.5,
                                                                        ),
                                                                      ),
                                                                    ),
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
                                          recomandByOneflix.length == 0
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
                                                          'Recommended By Oneflix',
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "OpenSans",
                                                        ),
                                                        Expanded(
                                                          child: ListView.builder(
                                                            shrinkWrap: true,
                                                            scrollDirection: Axis.horizontal,
                                                            itemCount: recomandByOneflix.length,
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
                                                                            builder: (context) => PlatformContent(
                                                                              id: int.parse(recomandByOneflix[index1]['content_third_party_id']),
                                                                              contentType: recomandByOneflix[index1]['content_type'],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(6),
                                                                        ),
                                                                        child: CachedImage(
                                                                          imageUrl: 'https://image.tmdb.org/t/p/original/${recomandByOneflix[index1]['content_photo']}',
                                                                          width: MediaQuery.of(context).size.width * 0.27,
                                                                          height: 170,
                                                                          radius: 6,
                                                                          colors: Colors.white,
                                                                          thikness: 0.5,
                                                                        ),
                                                                      ),
                                                                    ),
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
                                          getContent1.length == 0
                                              ? Container()
                                              : Padding(
                                                  padding: const EdgeInsets.only(top: 20),
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 20),
                                                    height: 220,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            AppText(
                                                              'What Your Friends Are Streaming',
                                                              color: Colors.white,
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: "OpenSans",
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
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
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10, right: 10),
                                                                              child: AppText(
                                                                                'This is a curated list of content that your friends have recently recommended or interacted with. This list is only as good as the number of friends you have on Oneflix. So to get a better curation, follow more people or invite more friends to join you on Oneflix.',
                                                                                color: Colors.white,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                                textAlign: TextAlign.start,
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
                                                                );
                                                              },
                                                              child: Text(
                                                                'Info',
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontFamily: "OpenSans",
                                                                  color: Colors.white,
                                                                  decoration: TextDecoration.underline,
                                                                  decorationThickness: 4,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Expanded(
                                                          child: ListView.builder(
                                                            shrinkWrap: true,
                                                            scrollDirection: Axis.horizontal,
                                                            itemCount: getContent1.length,
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
                                                                            builder: (context) => PlatformContent(
                                                                              id: int.parse(getContent1[index1]['content_third_party_id']),
                                                                              contentType: getContent1[index1]['content_type'],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(6),
                                                                        ),
                                                                        child: CachedImage(
                                                                          imageUrl: 'https://image.tmdb.org/t/p/original/${getContent1[index1]['content_photo']}',
                                                                          width: MediaQuery.of(context).size.width * 0.27,
                                                                          height: 170,
                                                                          radius: 6,
                                                                          colors: Colors.white,
                                                                          thikness: 0.5,
                                                                        ),
                                                                      ),
                                                                    ),
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
                                                          'Coming Soon To Streaming',
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
                                                                        /*  value.playerState == PlayerState.playing ? Icons.pause :*/ Icons.play_arrow_rounded,
                                                                        size: 100,
                                                                        color: Colors.white,
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      top: 10,
                                                                      left: 20,
                                                                      child: Image.asset(
                                                                        '$TRENDING_URL/${comingSoonData[index1]['title'] == 'Netflix' ? 'NetflixNew' : comingSoonData[index1]['title'] == 'Amazon' ? 'AmazonPrime' : comingSoonData[index1]['title'] == 'Disney' ? 'Disney' : comingSoonData[index1]['title'] == 'Hulu' ? 'Hulu' : comingSoonData[index1]['title'] == 'HBO Max' ? 'HBOMax' : comingSoonData[index1]['title'] == 'Paramount' ? 'Paramount' : comingSoonData[index1]['title'] == 'Peacock' ? 'Peacock' : comingSoonData[index1]['title'] == 'Apple TV' ? 'AppleTV' : comingSoonData[index1]['title'] == 445 ? 'DiscoveryPlus' : comingSoonData[index1]['title'] == 248 ? 'Showtime' : comingSoonData[index1]['title'] == 232 ? 'Starz' : comingSoonData[index1]['title'] == 296 ? 'Tubi' : comingSoonData[index1]['title'] == 391 ? 'Pluto' : ' '}.png',
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
                                                                            comingSoonData[index1]['new_arrival_date'] ?? '',
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
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              SizedBox(height: 30),
                              movieList.length != 0 ? Divider(color: Colors.white) : Container(),
                              ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: movieList.length < 15 ? movieList.length : 15,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => PlatformContent(id: movieList[index]['id'], contentType: 0)));
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 30, right: 18, top: 6, bottom: 6),
                                            child: CachedImage(
                                              imageUrl: 'https://image.tmdb.org/t/p/original/${movieList[index]['poster_path']}',
                                              height: 140,
                                              width: mWidth * 0.26,
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                AppText(movieList[index]['title'], color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                                                Row(
                                                  children: [
                                                    Expanded(child: AppText('Movie', color: Colors.white, fontSize: 15)),
                                                    Expanded(
                                                      child: AppText(
                                                        movieList[index]['release_date'] == null || movieList[index]['release_date'] == ''
                                                            ? ''
                                                            : formatDate(DateTime.parse(movieList[index]['release_date'])),
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Divider(color: Colors.white);
                                },
                              ),
                              movieList.length == 0 ? Container() : Divider(color: Colors.white),
                              ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: tvList.length < 15 ? tvList.length : 15,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => PlatformContent(contentType: 1, id: tvList[index]['id'])));
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 30, right: 18, top: 6, bottom: 6),
                                            child: CachedImage(
                                              imageUrl: 'https://image.tmdb.org/t/p/original/${tvList[index]['poster_path']}',
                                              height: 140,
                                              width: mWidth * 0.26,
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                AppText(
                                                  tvList[index]['name'],
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(child: AppText('TV Show', color: Colors.white, fontSize: 15)),
                                                    Expanded(
                                                      child: AppText(
                                                        tvList[index]['first_air_date'] == null || tvList[index]['first_air_date'] == ''
                                                            ? ''
                                                            : formatDate(DateTime.parse(tvList[index]['first_air_date'])),
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Divider(color: Colors.white);
                                },
                              ),
                              tvList.length == 0 ? Container() : Divider(color: Colors.white),
                            ],
                          ),
                        )
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
                        '${activeUserCount.toString()} Users Online',
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
      ),
    );
  }

  bool _loading = false;
  List newList = [];
  List newList1 = [];
  List popularList = [];
  List streamingTrendingIDs5 = [];
  List actionMovie = [];
  List comedyMovie = [];
  List scienceFictionMovie = [];
  List familyMovies = [];
  List dramaMovies = [];
  List thrillerMovies = [];
  List horrorMovies = [];
  List adventureMovies = [];
  List recentlyAdded = [];
  List mostPopular = [];
  List comingSoonData = [];
  List getContent1 = [];
  List yourWatchList = [];
  List recomandByFriend = [];
  List recomandByOneflix = [];
  List tvList = [];
  List movieList = [];

  _getDiscoverContent() async {
    var jsonData;
    if (!mounted) return;
    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        GET_DISCOVER_CONTENT,
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
            actionMovie = jsonData['data']['Action Movies'];
            comedyMovie = jsonData['data']['Comedy Movies'];
            scienceFictionMovie = jsonData['data']['Science Fiction Movies'];
            familyMovies = jsonData['data']['Family Movies'];
            dramaMovies = jsonData['data']['Drama Movies'];
            thrillerMovies = jsonData['data']['Thriller Movies'];
            horrorMovies = jsonData['data']['Horror Movies'];
            adventureMovies = jsonData['data']['Adventure Movies'];
            recentlyAdded = jsonData['data']['Recently Added'];
            mostPopular = jsonData['data']['Most Popular'];
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

  _getDiscoverForYouContent() async {
    var jsonData;
    if (!mounted) return;
    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        GET_DISCOVER_CONTENT_FOR_YOU,
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
            comingSoonData = jsonData['data']['Coming Soon To Streaming'];
            getContent1 = jsonData['data']['What your friends are streaming'];
            yourWatchList = jsonData['data']['Your Watchlist'];
            recomandByFriend = jsonData['data']['Recommended By Your Friends'];
            recomandByOneflix = jsonData['data']['Recommended By Oneflix'];
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

  _searchMoviesTvDetails(String searchText) async {
    var jsonData;

    try {
      var response = await Dio().post(
        TV_MOVIE_SEARCH,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'search_text': searchText},
      );
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData != null) {
          if (!mounted) return;
          setState(() {
            movieList = [];
            tvList = [];
            movieList = jsonData['movie'];
            tvList = jsonData['tv'];
          });
        }
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }
}
