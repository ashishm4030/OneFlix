import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Components/LiveDot.dart';
import 'package:oneflix/Constants.dart';
import 'package:oneflix/Screens/BottomBar/Discover/PlatformContent.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({Key? key}) : super(key: key);

  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  int selectedType = 1;

  @override
  void initState() {
    getToken();
    Timer.periodic(Duration(seconds: 5), (Timer t) async => _getActiveUserCount());
    super.initState();
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

  String? userToken;
  getToken() async {
    var token = await readData('user_token');
    setState(() {
      userToken = token;
    });
    await _getWatchListContent(0);
    await _getWatchListContent(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff011138),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        opacity: 0,
        progressIndicator: SizedBox(height: 20, width: 20, child: kProgressIndicator),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
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
                            text: 'MOVIES',
                            onPressed: () => setState(() => selectedType = 1),
                          ),
                          SwitchButton(
                            bgColor: selectedType == 2 ? true : false,
                            textColor: selectedType == 2 ? Colors.white : Colors.black,
                            selectedButton: selectedType,
                            text: 'TV SHOWS',
                            onPressed: () => setState(() => selectedType = 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  selectedType == 1
                      ? Expanded(
                          child: movieList.isEmpty && _loading == false
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(30.0),
                                      child: AppText(
                                        'You have not added any movies to your watchlist.',
                                        color: Color(0xff494949),
                                        fontWeight: FontWeight.bold,
                                        textAlign: TextAlign.center,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                )
                              : SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      _loading == false
                                          ? Padding(
                                              padding: const EdgeInsets.only(bottom: 18, left: 5, right: 5),
                                              child: AppText(
                                                'To maintain your privacy, we do not make your watchlist visible to anybody else on Oneflix. Your friends can only see what you\'ve recommended, but they cannot see what you\'ve added to your watchlist. ',
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          : Container(),
                                      GridView.builder(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 2 / 3,
                                          crossAxisSpacing: 16,
                                          mainAxisSpacing: 16,
                                        ),
                                        itemCount: movieList.length,
                                        itemBuilder: (BuildContext ctx, index) {
                                          return GestureDetector(
                                            child: Container(
                                              height: 140,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white)),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(6),
                                                child: CachedImage(
                                                  imageUrl: 'https://image.tmdb.org/t/p/original/${movieList[index]['poster_path']}',
                                                  height: 140,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              print(movieList[index]['id']);
                                              Navigator.push(context,
                                                      MaterialPageRoute(builder: (context) => PlatformContent(contentType: 0, id: movieList[index]['content_third_party_id'])))
                                                  .then((_) {
                                                _getWatchListContent(0);
                                                setState(() {});
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                        )
                      : Expanded(
                          child: tvList.isEmpty && _loading == false
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(30.0),
                                      child: AppText(
                                        'You have not added any TV shows to your watchlist.',
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
                                    _loading == false
                                        ? Padding(
                                            padding: const EdgeInsets.only(bottom: 18, left: 5, right: 5),
                                            child: AppText(
                                              'To maintain your privacy, we do not make your watchlist visible to anybody else on Oneflix. Your friends can only see what you\'ve recommended, but they cannot see what you\'ve added to your watchlist. ',
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        : Container(),
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
                                            print(tvList[index]['id']);
                                            Navigator.push(
                                                    context, MaterialPageRoute(builder: (context) => PlatformContent(contentType: 1, id: tvList[index]['content_third_party_id'])))
                                                .then((_) {
                                              _getWatchListContent(1);
                                              setState(() {});
                                            });
                                          },
                                          child: Container(
                                            height: 140,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white)),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(6),
                                              child: CachedImage(
                                                imageUrl: 'https://image.tmdb.org/t/p/original/${tvList[index]['poster_path']}',
                                                height: 140,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
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
      ),
    );
  }

  List tvList = [];
  List movieList = [];

  bool _loading = false;
  _getWatchListContent(int selectedType) async {
    var jsonData;

    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        GET_WATCHLIST_CONTENT,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'type': selectedType},
      );
      print(response);
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            if (selectedType == 0) {
              movieList = jsonData['data'];
              print('Movie List: ${movieList.length}');
            } else if (selectedType == 1) {
              tvList = jsonData['data'];
              print('TV List: ${tvList.length}');
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
}
