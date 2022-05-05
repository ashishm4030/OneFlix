import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Components/LiveDot.dart';
import 'package:oneflix/Screens/BottomBar/Discover/PlatformContent.dart';
import 'package:oneflix/Screens/BottomBar/Home/PostContentScreen.dart';
import 'package:oneflix/Screens/BottomBar/Profile/UserViewScreen.dart';
import 'package:oneflix/Screens/BottomBar/Trending/ProviderHubScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../Constants.dart';

class Trending extends StatefulWidget {
  const Trending({Key? key}) : super(key: key);

  @override
  _TrendingState createState() => _TrendingState();
}

class _TrendingState extends State<Trending> with TickerProviderStateMixin {
  int selectedButton = 1;
  var getContent, genereData, newData, topForYou, region, top10data;
  String? isSignUp;
  int selected = 0;
  int top10TrendingCurrentIndex = 0;
  int topForYouCurrentIndex = 0;
  int? _currentItem;
  int? _currentItem1;
  String? userToken;
  bool _loading = false;
  bool locationPermission = false;
  bool contactsPermission = false;

  Map<Permission, PermissionStatus>? statuses;

  List contacts = [];
  List contactList = [];
  List image = [];
  List selectedindex = [];
  List projectIdList = [];
  List comingSoonData = [];
  List biggestEvent = [];
  List getArriveData = [];
  List getArriveDataToday = [];
  List getArriveDataYesterday = [];
  List tredingDiscussion = [];
  List actionMovie = [];
  List comedyMovie = [];
  List romanceMovie = [];
  List actionTv = [];
  List comedyTv = [];
  List scifiFanstyTv = [];
  List adventureMovies = [];
  List familyMovies = [];
  List dramaMovies = [];
  List adventureTv = [];
  List familyTv = [];
  List dramaTv = [];
  List thrillerMovies = [];
  List horrorMovies = [];
  List thrillerTV = [];
  List crimeTv = [];
  List newNetflix = [];
  List newAmezon = [];
  List newDisney = [];
  List newHBO = [];
  List hulu = [];
  List peacock = [];
  List paramount = [];
  List appleTv = [];
  List tubi = [];
  List pluto = [];
  List starz = [];
  List showtime = [];
  List scienceFictionMovie = [];
  List yourWatchList = [];
  String? isFirstOccurrenceOfMonth;
  List getContent1 = [];
  List streamingTrendingIDs5 = [];
  List streamingTrendingIDs6 = [];
  List top10Trending = [];
  List streamingTrendingIDs = [];
  List streamingTopForYouIDs = [];
  List sourceList = [];
  List staticID = [203, 26, 387, 157, 388];

  void previous() => controller.previousPage();

  void next() => controller.nextPage();

  final controller = CarouselController();

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  @override
  void initState() {
    get();
    Timer.periodic(Duration(seconds: 5), (Timer t) async => _getActiveUserCount());
    super.initState();
  }

  var activeUserCountTrendng = 0;
  bool showColor = false;

  get() async {
    print("skdfhgdsjf");
    await getToken2();
    await getToken();
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

  getToken() async {
    setState(() {
      _loading = true;
    });
    await FirebaseAnalytics.instance.logEvent(name: 'trending_tab', parameters: {'status': 'Visited'});
    var usertoken = await readData('user_token');
    var signUpCheck = await readData('isSignUp');
    var isFirst = await readData('isFirstOccurrenceOfMonth');

    setState(() {
      userToken = usertoken;
      isSignUp = signUpCheck;
      isFirstOccurrenceOfMonth = isFirst;
    });
    await _getActiveUserCount();
    await _getSouceList();
    await _getProviderName();
    await _getArriveData();
    _top10Trending(selectedType: 1, permission: locationPermission);
    _getComingSoonData();
    _getBiggestEventData();
    _getArriveStreamingData();
    _getTredingDiscussion();
    _getGenereData();
    _getNewlyData();
    _getWhatYouFriendStreaming();
    await requestContactPermission();
  }

  getToken2() async {
    var selected1 = await readData('selected');
    setState(() {
      if (selected1 != null) {
        selected = selected1;
      }
    });
  }

  Future<void> requestContactPermission() async {
    contactsPermission = await Permission.contacts.isGranted;
    statuses = await [Permission.contacts].request();
    if (!mounted) return;
    setState(() {
      if (statuses![Permission.contacts]!.isGranted) {
        contactsPermission = true;
      } else if (statuses![Permission.contacts]!.isDenied) {
        contactsPermission = false;
      } else if (statuses![Permission.contacts]!.isPermanentlyDenied) {
        contactsPermission = false;
      }
    });
    if (contactsPermission == true) {
      await _getContacts();
      await updateContacts();
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
    });
  }

  updateContacts() async {
    try {
      var response = await Dio().post(
        ADD_CONTACT,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {'contact_diary': jsonEncode(contactList)},
      );

      if (response.statusCode == 200) {
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      opacity: 0,
      progressIndicator: SizedBox(width: 20, height: 20, child: kProgressIndicator),
      child: Scaffold(
        backgroundColor: Color(0xff011138),
        appBar: AppBar(
          backgroundColor: Color(0xff011138),
          automaticallyImplyLeading: false,
          elevation: 0.0,
          centerTitle: true,
          bottom: PreferredSize(
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    await _getSouceList();
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                color: Colors.black87,
                                height: MediaQuery.of(context).size.height * 0.80,
                                width: MediaQuery.of(context).size.width,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 20),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Icon(
                                              Icons.clear,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      AppText(
                                        'PERSONALIZE ONEFLIX',
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: AppText(
                                          'Select your streaming services and then scroll down to save your options.',
                                          fontSize: 18,
                                          color: Colors.white,
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: sourceList.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (selectedindex.contains(index)) {
                                                    selectedindex.remove(index);
                                                    if (projectIdList.contains(sourceList[index]["source_id"])) {
                                                      projectIdList.remove(sourceList[index]["source_id"]);
                                                    }
                                                  } else {
                                                    selectedindex.add(index);
                                                    projectIdList.add(sourceList[index]["source_id"]);
                                                  }
                                                  setState(() {
                                                    showColor = true;
                                                  });
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                                  child: Container(
                                                    height: 60,
                                                    width: MediaQuery.of(context).size.width,
                                                    decoration: BoxDecoration(
                                                        color: showColor == true
                                                            ? selectedindex.contains(index)
                                                                ? Color(0xffFF4F01)
                                                                : Color(0xff30353d)
                                                            : sourceList[index]['is_selected_me'] != 0
                                                                ? Color(0xffFF4F01)
                                                                : Color(0xff30353d),
                                                        borderRadius: BorderRadius.circular(4)),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 40),
                                                            child: CachedImage(
                                                              imageUrl: 'https://oneflixapp.com/oneflix/${sourceList[index]['images']}',
                                                              height: 35,
                                                              width: 60,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          AppText(
                                                            sourceList[index]['names'],
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                          Container(),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          if (validate()) {
                                            _addSouceData();
                                            _getProviderName();
                                            _getArriveStreamingData();
                                            _getArriveData();
                                            _getGenereData();
                                            _getNewlyData();
                                            _getTredingDiscussion();
                                            await writeData('selected_list', projectIdList);
                                            await writeData('color_list', selectedindex);
                                            await writeData('selected', 1);
                                          }
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: AppText('SAVE', color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, fontFamily: 'OpenSans'),
                                          height: 50,
                                          width: MediaQuery.of(context).size.width * 0.40,
                                          decoration: BoxDecoration(color: Color(0xff22b069), borderRadius: BorderRadius.circular(8)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(9)),
                    alignment: Alignment.center,
                    child: AppText(
                      'CUSTOMIZE',
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            preferredSize: Size.fromHeight(30.0),
          ),
        ),
        body: Stack(
          children: [
            Offstage(
              offstage: selectedButton != 1,
              child: new TickerMode(
                enabled: selectedButton == 1,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              AppText(
                                'Click on any logo below to go to its streaming page.',
                                textAlign: TextAlign.center,
                                fontSize: 10,
                              ),
                              Expanded(
                                child: ScrollablePositionedList.builder(
                                  itemScrollController: itemScrollController,
                                  itemPositionsListener: itemPositionsListener,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: image.length,
                                  itemBuilder: (context, index1) {
                                    return VisibilityDetector(
                                      key: Key(index1.toString()),
                                      onVisibilityChanged: (VisibilityInfo info) {
                                        if (info.visibleFraction == 1)
                                          setState(() {
                                            _currentItem = index1;
                                          });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
                                        child: Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => ProviderHubScreen(
                                                      type: image[index1]['unique_id'],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Image.asset(
                                                  image[index1]['provider_name'] == 'Netflix'
                                                      ? 'assets/TopTreding/Netflix (1).png'
                                                      : image[index1]['provider_name'] == 'Disney'
                                                          ? 'assets/TopTreding/Disney.png'
                                                          : image[index1]['provider_name'] == 'Prime Video'
                                                              ? 'assets/TopTreding/Amazon.png'
                                                              : image[index1]['provider_name'] == 'HBO Max'
                                                                  ? 'assets/TopTreding/HBO.png'
                                                                  : image[index1]['provider_name'] == 'Hulu'
                                                                      ? 'assets/TopTreding/Hulu.png'
                                                                      : image[index1]['provider_name'] == 'Peacock'
                                                                          ? 'assets/TopTreding/Peacock.png'
                                                                          : image[index1]['provider_name'] == 'Paramount'
                                                                              ? 'assets/TopTreding/Paramount.png'
                                                                              : image[index1]['provider_name'] == 'AppleTV'
                                                                                  ? 'assets/TopTreding/Apple TV.png'
                                                                                  : image[index1]['provider_name'] == 'Tubi'
                                                                                      ? 'assets/TopTreding/Tubi.png'
                                                                                      : image[index1]['provider_name'] == 'Pluto'
                                                                                          ? 'assets/TopTreding/Pluto.png'
                                                                                          : image[index1]['provider_name'] == 'Starz'
                                                                                              ? 'assets/TopTreding/Starz.png'
                                                                                              : 'assets/TopTreding/Showtime.png',
                                                  width: 80,
                                                  height: 80,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        image.length <= 3
                            ? Container()
                            : Positioned(
                                left: 5,
                                bottom: 30,
                                child: GestureDetector(
                                  onTap: () {
                                    itemScrollController.scrollTo(index: 0, duration: Duration(seconds: 1));
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                        image.length <= 3
                            ? Container()
                            : Positioned(
                                right: 5,
                                bottom: 30,
                                child: GestureDetector(
                                  onTap: () {
                                    if (_currentItem == 4 || _currentItem == 5 || _currentItem == 6) {
                                      itemScrollController.scrollTo(index: 6, duration: Duration(seconds: 1));
                                    } else if (_currentItem == 7 || _currentItem == 8) {
                                      itemScrollController.scrollTo(index: 8, duration: Duration(seconds: 1));
                                    } else {
                                      itemScrollController.scrollTo(index: 3, duration: Duration(seconds: 1));
                                    }
                                  },
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          getArriveDataToday.length == 0
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
                                          'Arrived Today',
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "OpenSans",
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: getArriveDataToday.length,
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
                                                              contentTPId: getArriveDataToday[index1]['content_third_party_id'],
                                                              contentID: getArriveDataToday[index1]['content_id'],
                                                              contentType: getArriveDataToday[index1]['content_type'],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(6),
                                                        ),
                                                        child: CachedImage(
                                                          imageUrl: 'https://image.tmdb.org/t/p/original/${getArriveDataToday[index1]['content_photo']}',
                                                          width: MediaQuery.of(context).size.width * 0.27,
                                                          height: 170,
                                                          radius: 6,
                                                          colors: Colors.white,
                                                          thikness: 0.5,
                                                        ),
                                                      ),
                                                    ),
                                                    getArriveDataToday[index1]['new_episode'].toString() == '2'
                                                        ? Container()
                                                        : Positioned(
                                                            bottom: 10,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(right: 1, left: 1),
                                                              child: Container(
                                                                height: 30,
                                                                width: MediaQuery.of(context).size.width * 0.265,
                                                                decoration: BoxDecoration(
                                                                  color: Color(0xffFF1B0A),
                                                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(6), bottomLeft: Radius.circular(6)),
                                                                ),
                                                                child: Center(
                                                                  child: AppText(
                                                                    'New Episode',
                                                                    color: Colors.white,
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "OpenSans",
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                    Positioned(
                                                      top: 7,
                                                      left: 7,
                                                      child: Image.asset(
                                                        '$TRENDING_URL/${getArriveDataToday[index1]['source_id'] == '203' ? 'NetflixNew' : getArriveDataToday[index1]['source_id'] == '26' ? 'AmazonPrime' : getArriveDataToday[index1]['source_id'] == '372' ? 'Disney' : getArriveDataToday[index1]['source_id'] == '157' ? 'Hulu' : getArriveDataToday[index1]['source_id'] == '387' ? 'HBOMax' : getArriveDataToday[index1]['source_id'] == '444' ? 'Paramount' : getArriveDataToday[index1]['source_id'] == '388' || getArriveDataToday[index1]['source_id'] == '389' ? 'Peacock' : getArriveDataToday[index1]['source_id'] == '371' ? 'AppleTV' : getArriveData[index1]['source_id'] == '445' ? 'DiscoveryPlus' : getArriveDataToday[index1]['source_id'] == '248' ? 'Showtime' : getArriveDataToday[index1]['source_id'] == '232' ? 'Starz' : getArriveDataToday[index1]['source_id'] == '296' ? 'Tubi' : getArriveDataToday[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
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
                          getArriveDataYesterday.length == 0
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
                                          'Arrived Yesterday',
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "OpenSans",
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: getArriveDataYesterday.length,
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
                                                              contentTPId: getArriveDataYesterday[index1]['content_third_party_id'],
                                                              contentID: getArriveDataYesterday[index1]['content_id'],
                                                              contentType: getArriveDataYesterday[index1]['content_type'],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(6),
                                                        ),
                                                        child: CachedImage(
                                                          imageUrl: 'https://image.tmdb.org/t/p/original/${getArriveDataYesterday[index1]['content_photo']}',
                                                          width: MediaQuery.of(context).size.width * 0.27,
                                                          height: 170,
                                                          radius: 6,
                                                          colors: Colors.white,
                                                          thikness: 0.5,
                                                        ),
                                                      ),
                                                    ),
                                                    getArriveDataYesterday[index1]['new_episode'].toString() == '2'
                                                        ? Container()
                                                        : Positioned(
                                                            bottom: 10,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(right: 1, left: 1),
                                                              child: Container(
                                                                height: 30,
                                                                width: MediaQuery.of(context).size.width * 0.265,
                                                                decoration: BoxDecoration(
                                                                  color: Color(0xffFF1B0A),
                                                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(6), bottomLeft: Radius.circular(6)),
                                                                ),
                                                                child: Center(
                                                                  child: AppText(
                                                                    'New Episode',
                                                                    color: Colors.white,
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "OpenSans",
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                    Positioned(
                                                      top: 7,
                                                      left: 7,
                                                      child: Image.asset(
                                                        '$TRENDING_URL/${getArriveDataYesterday[index1]['source_id'] == '203' ? 'NetflixNew' : getArriveDataYesterday[index1]['source_id'] == '26' ? 'AmazonPrime' : getArriveDataYesterday[index1]['source_id'] == '372' ? 'Disney' : getArriveDataYesterday[index1]['source_id'] == '157' ? 'Hulu' : getArriveDataYesterday[index1]['source_id'] == '387' ? 'HBOMax' : getArriveDataYesterday[index1]['source_id'] == '444' ? 'Paramount' : getArriveDataYesterday[index1]['source_id'] == '388' || getArriveDataYesterday[index1]['source_id'] == '389' ? 'Peacock' : getArriveDataYesterday[index1]['source_id'] == '371' ? 'AppleTV' : getArriveDataYesterday[index1]['source_id'] == '445' ? 'DiscoveryPlus' : getArriveDataYesterday[index1]['source_id'] == '248' ? 'Showtime' : getArriveDataYesterday[index1]['source_id'] == '232' ? 'Starz' : getArriveDataYesterday[index1]['source_id'] == '296' ? 'Tubi' : getArriveDataYesterday[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
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
                          SizedBox(
                            height: 25,
                          ),
                          top10Trending.length == 0
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      AppText(
                                        'Top 10 Trending',
                                        textAlign: TextAlign.center,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      // SizedBox(width: 3),
                                      // Padding(
                                      //   padding: EdgeInsets.only(top: 17),
                                      //   child: BlinkingPoint(
                                      //     xCoor: 12,
                                      //     yCoor: -16,
                                      //     pointSize: 14,
                                      //     pointColor: Color(0xffF5581F),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                          top10Trending.length != 0
                              ? CarouselSlider.builder(
                                  options: CarouselOptions(
                                    height: 350,
                                    viewportFraction: 1,
                                    // autoPlay: true,
                                    enableInfiniteScroll: false,
                                    scrollPhysics: BouncingScrollPhysics(),
                                  ),
                                  itemCount: top10Trending.length ~/ 2 + top10Trending.length % 2,
                                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                                    return Container(
                                      height: 270,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment: itemIndex * 2 + 1 >= top10Trending.length ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => PostContentScreen(
                                                      contentTPId: top10Trending[(itemIndex * 2)]['content_third_party_id'],
                                                      contentID: top10Trending[(itemIndex * 2)]['content_id'],
                                                      contentType: top10Trending[(itemIndex * 2)]['content_type'],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  // shrinkWrap: true,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Image.asset('assets/icons/${((itemIndex * 2) + 1).toString()}.png', height: 50, width: 70),
                                                    SizedBox(height: 16),
                                                    Stack(
                                                      alignment: Alignment.center,
                                                      children: [
                                                        Container(
                                                          height: 260,
                                                          width: MediaQuery.of(context).size.width * 0.43,
                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white)),
                                                          child: Column(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius: BorderRadius.circular(6),
                                                                child: CachedImage(
                                                                  imageUrl: 'https://image.tmdb.org/t/p/original/${top10Trending[itemIndex * 2]['content_photo']}',
                                                                  height: 258,
                                                                  width: MediaQuery.of(context).size.width * 0.43,
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                              Spacer(),
                                                            ],
                                                          ),
                                                        ),
                                                        streamingTrendingIDs[itemIndex * 2] == 203 ||
                                                                streamingTrendingIDs[itemIndex * 2] == 26 ||
                                                                streamingTrendingIDs[itemIndex * 2] == 372 ||
                                                                streamingTrendingIDs[itemIndex * 2] == 157 ||
                                                                streamingTrendingIDs[itemIndex * 2] == 387 ||
                                                                streamingTrendingIDs[itemIndex * 2] == 444 ||
                                                                streamingTrendingIDs[itemIndex * 2] == 388 ||
                                                                streamingTrendingIDs[itemIndex * 2] == 389 ||
                                                                streamingTrendingIDs[itemIndex * 2] == 371 ||
                                                                streamingTrendingIDs[itemIndex * 2] == 445 ||
                                                                streamingTrendingIDs[itemIndex * 2] == 248 ||
                                                                streamingTrendingIDs[itemIndex * 2] == 232 ||
                                                                streamingTrendingIDs[itemIndex * 2] == 296 ||
                                                                streamingTrendingIDs[itemIndex * 2] == 391
                                                            ? Positioned(
                                                                top: 10,
                                                                left: 10,
                                                                child: Image.asset(
                                                                  '$TRENDING_URL/${streamingTrendingIDs[itemIndex * 2] == 203 ? 'NetflixNew' : streamingTrendingIDs[itemIndex * 2] == 26 ? 'AmazonPrime' : streamingTrendingIDs[itemIndex * 2] == 372 ? 'Disney' : streamingTrendingIDs[itemIndex * 2] == 157 ? 'Hulu' : streamingTrendingIDs[itemIndex * 2] == 387 ? 'HBOMax' : streamingTrendingIDs[itemIndex * 2] == 444 ? 'Paramount' : streamingTrendingIDs[itemIndex * 2] == 388 || streamingTrendingIDs[itemIndex * 2] == 389 ? 'Peacock' : streamingTrendingIDs[itemIndex * 2] == 371 ? 'AppleTV' : streamingTrendingIDs[itemIndex * 2] == 445 ? 'DiscoveryPlus' : streamingTrendingIDs[itemIndex * 2] == 248 ? 'Showtime' : streamingTrendingIDs[itemIndex * 2] == 232 ? 'Starz' : streamingTrendingIDs[itemIndex * 2] == 296 ? 'Tubi' : streamingTrendingIDs[itemIndex * 2] == 391 ? 'Pluto' : ' '}.png',
                                                                  height: 40,
                                                                ),
                                                              )
                                                            : Positioned(top: 10, left: 10, child: Container()),
                                                        top10Trending[itemIndex * 2]['comment_count_top'] == 0
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
                                                                        '${top10Trending[itemIndex * 2]['comment_count_top']} Comments ',
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
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          itemIndex * 2 + 1 >= top10Trending.length
                                              ? Container()
                                              : Container(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => PostContentScreen(
                                                            contentTPId: top10Trending[(itemIndex * 2) + 1]['content_third_party_id'],
                                                            contentID: top10Trending[(itemIndex * 2) + 1]['content_id'],
                                                            contentType: top10Trending[(itemIndex * 2)]['content_type'],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        // shrinkWrap: true,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Image.asset('assets/icons/${((itemIndex * 2) + 2).toString()}.png', height: 50, width: 70),
                                                          SizedBox(height: 16),
                                                          Stack(
                                                            alignment: Alignment.center,
                                                            children: [
                                                              Container(
                                                                height: 260,
                                                                width: MediaQuery.of(context).size.width * 0.43,
                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white)),
                                                                child: Column(
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius: BorderRadius.circular(6),
                                                                      child: CachedImage(
                                                                        imageUrl: 'https://image.tmdb.org/t/p/original/${top10Trending[(itemIndex * 2) + 1]['content_photo']}',
                                                                        height: 258,
                                                                        width: MediaQuery.of(context).size.width * 0.43,
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                    ),
                                                                    Spacer(),
                                                                  ],
                                                                ),
                                                              ),
                                                              streamingTrendingIDs[(itemIndex * 2) + 1] == 203 ||
                                                                      streamingTrendingIDs[(itemIndex * 2) + 1] == 26 ||
                                                                      streamingTrendingIDs[(itemIndex * 2) + 1] == 372 ||
                                                                      streamingTrendingIDs[(itemIndex * 2) + 1] == 157 ||
                                                                      streamingTrendingIDs[(itemIndex * 2) + 1] == 387 ||
                                                                      streamingTrendingIDs[(itemIndex * 2) + 1] == 444 ||
                                                                      streamingTrendingIDs[(itemIndex * 2) + 1] == 388 ||
                                                                      streamingTrendingIDs[(itemIndex * 2) + 1] == 389 ||
                                                                      streamingTrendingIDs[(itemIndex * 2) + 1] == 371 ||
                                                                      streamingTrendingIDs[(itemIndex * 2) + 1] == 445 ||
                                                                      streamingTrendingIDs[(itemIndex * 2) + 1] == 248 ||
                                                                      streamingTrendingIDs[(itemIndex * 2) + 1] == 232 ||
                                                                      streamingTrendingIDs[(itemIndex * 2) + 1] == 296 ||
                                                                      streamingTrendingIDs[(itemIndex * 2) + 1] == 391
                                                                  ? Positioned(
                                                                      top: 10,
                                                                      left: 10,
                                                                      child: Image.asset(
                                                                        '$TRENDING_URL/${streamingTrendingIDs[(itemIndex * 2) + 1] == 203 ? 'NetflixNew' : streamingTrendingIDs[(itemIndex * 2) + 1] == 26 ? 'AmazonPrime' : streamingTrendingIDs[(itemIndex * 2) + 1] == 372 ? 'Disney' : streamingTrendingIDs[(itemIndex * 2) + 1] == 157 ? 'Hulu' : streamingTrendingIDs[(itemIndex * 2) + 1] == 387 ? 'HBOMax' : streamingTrendingIDs[(itemIndex * 2) + 1] == 444 ? 'Paramount' : streamingTrendingIDs[(itemIndex * 2) + 1] == 388 || streamingTrendingIDs[(itemIndex * 2) + 1] == 389 ? 'Peacock' : streamingTrendingIDs[(itemIndex * 2) + 1] == 371 ? 'AppleTV' : streamingTrendingIDs[(itemIndex * 2) + 1] == 445 ? 'DiscoveryPlus' : streamingTrendingIDs[(itemIndex * 2) + 1] == 248 ? 'Showtime' : streamingTrendingIDs[(itemIndex * 2) + 1] == 232 ? 'Starz' : streamingTrendingIDs[(itemIndex * 2) + 1] == 296 ? 'Tubi' : streamingTrendingIDs[(itemIndex * 2) + 1] == 391 ? 'Pluto' : ' '}.png',
                                                                        height: 40,
                                                                      ),
                                                                    )
                                                                  : Positioned(top: 10, left: 10, child: Container()),
                                                              top10Trending[(itemIndex * 2) + 1]['comment_count_top'] == 0
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
                                                                              '${top10Trending[(itemIndex * 2) + 1]['comment_count_top']} Comments ',
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
                                                                      ) /*Container(
                                                                  decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(42)),
                                                                  child: CircularPercentIndicator(
                                                                    radius: 42.0,
                                                                    lineWidth: 2.0,
                                                                    percent: double.tryParse(top10Trending[(itemIndex * 2)]['vote_average'])! / 10,
                                                                    center: AppText(
                                                                      (double.tryParse(top10Trending[(itemIndex * 2)]['vote_average'])! * 10).toInt().toString() + "%",
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w900,
                                                                      fontSize: 12,
                                                                    ),
                                                                    progressColor: Colors.greenAccent,
                                                                    backgroundColor: Colors.black,
                                                                    circularStrokeCap: CircularStrokeCap.round,
                                                                  ),
                                                                ),*/
                                                                      ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                          getArriveData.length == 0
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
                                          'Arrived This Week',
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "OpenSans",
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: getArriveData.length,
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
                                                              contentTPId: getArriveData[index1]['content_third_party_id'],
                                                              contentID: getArriveData[index1]['content_id'],
                                                              contentType: getArriveData[index1]['content_type'],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(6),
                                                        ),
                                                        child: CachedImage(
                                                          imageUrl: 'https://image.tmdb.org/t/p/original/${getArriveData[index1]['content_photo']}',
                                                          width: MediaQuery.of(context).size.width * 0.27,
                                                          height: 170,
                                                          radius: 6,
                                                          colors: Colors.white,
                                                          thikness: 0.5,
                                                        ),
                                                      ),
                                                    ),
                                                    getArriveData[index1]['new_episode'].toString() == '2'
                                                        ? Container()
                                                        : Positioned(
                                                            bottom: 10,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(right: 1, left: 1),
                                                              child: Container(
                                                                height: 30,
                                                                width: MediaQuery.of(context).size.width * 0.265,
                                                                decoration: BoxDecoration(
                                                                  color: Color(0xffFF1B0A),
                                                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(6), bottomLeft: Radius.circular(6)),
                                                                ),
                                                                child: Center(
                                                                  child: AppText(
                                                                    'New Episode',
                                                                    color: Colors.white,
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "OpenSans",
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                    Positioned(
                                                      top: 7,
                                                      left: 7,
                                                      child: Image.asset(
                                                        '$TRENDING_URL/${getArriveData[index1]['source_id'] == '203' ? 'NetflixNew' : getArriveData[index1]['source_id'] == '26' ? 'AmazonPrime' : getArriveData[index1]['source_id'] == '372' ? 'Disney' : getArriveData[index1]['source_id'] == '157' ? 'Hulu' : getArriveData[index1]['source_id'] == '387' ? 'HBOMax' : getArriveData[index1]['source_id'] == '444' ? 'Paramount' : getArriveData[index1]['source_id'] == '388' || getArriveData[index1]['source_id'] == '389' ? 'Peacock' : getArriveData[index1]['source_id'] == '371' ? 'AppleTV' : getArriveData[index1]['source_id'] == '445' ? 'DiscoveryPlus' : getArriveData[index1]['source_id'] == '248' ? 'Showtime' : getArriveData[index1]['source_id'] == '232' ? 'Starz' : getArriveData[index1]['source_id'] == '296' ? 'Tubi' : getArriveData[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
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
                          tredingDiscussion.length == 0
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
                                          'Trending Discussions',
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "OpenSans",
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: tredingDiscussion.length,
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
                                                              contentTPId: tredingDiscussion[index1]['content_third_party_id'],
                                                              contentID: tredingDiscussion[index1]['content_id'],
                                                              contentType: tredingDiscussion[index1]['content_type'],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(6),
                                                        ),
                                                        child: CachedImage(
                                                          imageUrl: 'https://image.tmdb.org/t/p/original/${tredingDiscussion[index1]['content_photo']}',
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
                                                        '$TRENDING_URL/${tredingDiscussion[index1]['source_id'] == '203' ? 'NetflixNew' : tredingDiscussion[index1]['source_id'] == '26' ? 'AmazonPrime' : tredingDiscussion[index1]['source_id'] == '372' ? 'Disney' : tredingDiscussion[index1]['source_id'] == '157' ? 'Hulu' : tredingDiscussion[index1]['source_id'] == '387' ? 'HBOMax' : tredingDiscussion[index1]['source_id'] == '444' ? 'Paramount' : tredingDiscussion[index1]['source_id'] == '388' || tredingDiscussion[index1]['source_id'] == '389' ? 'Peacock' : tredingDiscussion[index1]['source_id'] == '371' ? 'AppleTV' : tredingDiscussion[index1]['source_id'] == '445' ? 'DiscoveryPlus' : tredingDiscussion[index1]['source_id'] == '248' ? 'Showtime' : tredingDiscussion[index1]['source_id'] == '232' ? 'Starz' : tredingDiscussion[index1]['source_id'] == '296' ? 'Tubi' : tredingDiscussion[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
                                                        height: 25,
                                                      ),
                                                    ),
                                                    tredingDiscussion[index1]['comment_count_top'].toString() == '0'
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
                                                                    '${tredingDiscussion[index1]['comment_count_top']} Comments ',
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
                          yourWatchList.length == 0
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
                                                              // contentID: yourWatchList[index1]['content_id'],
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
                                                    Positioned(
                                                      top: 7,
                                                      left: 7,
                                                      child: Image.asset(
                                                        '$TRENDING_URL/${yourWatchList[index1]['source_id'] == '203' ? 'NetflixNew' : yourWatchList[index1]['source_id'] == '26' ? 'AmazonPrime' : yourWatchList[index1]['source_id'] == '372' ? 'Disney' : yourWatchList[index1]['source_id'] == '157' ? 'Hulu' : yourWatchList[index1]['source_id'] == '387' ? 'HBOMax' : yourWatchList[index1]['source_id'] == '444' ? 'Paramount' : yourWatchList[index1]['source_id'] == '388' || yourWatchList[index1]['source_id'] == '389' ? 'Peacock' : yourWatchList[index1]['source_id'] == '371' ? 'AppleTV' : yourWatchList[index1]['source_id'] == '445' ? 'DiscoveryPlus' : yourWatchList[index1]['source_id'] == '248' ? 'Showtime' : yourWatchList[index1]['source_id'] == '232' ? 'Starz' : yourWatchList[index1]['source_id'] == '296' ? 'Tubi' : yourWatchList[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
                                                        height: 25,
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
                          biggestEvent.length != 0
                              ? SizedBox(
                                  height: 25,
                                )
                              : Container(),
                          biggestEvent.length != 0
                              ? Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      AppText(
                                        'Biggest Events This Week',
                                        textAlign: TextAlign.center,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          biggestEvent.length != 0
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CarouselSlider.builder(
                                      carouselController: controller,
                                      options: CarouselOptions(
                                        height: 365,
                                        viewportFraction: 1,
                                        // autoPlay: true,
                                        enableInfiniteScroll: false,
                                        scrollPhysics: BouncingScrollPhysics(),
                                      ),
                                      itemCount: biggestEvent.length,
                                      itemBuilder: (BuildContext context, int index1, int pageViewIndex) {
                                        return VisibilityDetector(
                                          key: Key(index1.toString()),
                                          onVisibilityChanged: (VisibilityInfo info) {
                                            setState(() {
                                              _currentItem1 = index1;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PostContentScreen(
                                                          contentTPId: biggestEvent[index1]['content_third_party_id'],
                                                          contentID: '0',
                                                          contentType: biggestEvent[index1]['content_type'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        child: CachedImage1(
                                                          imageUrl: 'https://oneflixapp.com/oneflix/${biggestEvent[index1]['content_cover_image']}',
                                                          width: MediaQuery.of(context).size.width,
                                                          height: 250,
                                                          // colors: Colors.white,
                                                          thikness: 0.5,
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                                                            color: Colors.white),
                                                        width: MediaQuery.of(context).size.width,
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
                                                          child: AppText(
                                                            biggestEvent[index1]['content_discription'],
                                                            fontSize: 14,
                                                            maxLines: 4,
                                                            fontWeight: FontWeight.bold,
                                                            color: Color(0xff4B4949),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  left: 15,
                                                  child: Image.asset(
                                                    '$TRENDING_URL/${biggestEvent[index1]['category_title'] == 'Netflix' ? 'NetflixNew' : biggestEvent[index1]['category_title'] == 'Amazon' ? 'AmazonPrime' : biggestEvent[index1]['category_title'] == 'Disney' ? 'Disney' : biggestEvent[index1]['category_title'] == 'Hulu' ? 'Hulu' : biggestEvent[index1]['category_title'] == 'HBO Max' ? 'HBOMax' : biggestEvent[index1]['category_title'] == 'Paramount' ? 'Paramount' : biggestEvent[index1]['category_title'] == 'Peacock' ? 'Peacock' : biggestEvent[index1]['category_title'] == 'Apple TV' ? 'AppleTV' : 'AppleTV'}.png',
                                                    height: 70,
                                                    width: 70,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Positioned(
                                      left: 5,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (_currentItem1 != 0) {
                                            previous();
                                          }
                                        },
                                        child: Icon(
                                          Icons.arrow_back_ios,
                                          size: 28,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (_currentItem1 != biggestEvent.length - 1) {
                                            next();
                                          }
                                        },
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 28,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Container(),
                          if (projectIdList.length == 0)
                            newNetflix.length == 0
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
                                            'New On Netflix',
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
                                                          '$TRENDING_URL/${'NetflixNew'}.png',
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
                          for (int i = 0; i < projectIdList.length; i++)
                            newNetflix.length == 0 || projectIdList[i] != 203
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
                                            'New On Netflix',
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
                                                          '$TRENDING_URL/${'NetflixNew'}.png',
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
                          if (projectIdList.length == 0)
                            newAmezon.length == 0
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
                                            'New On Amazon',
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
                                                          '$TRENDING_URL/${'AmazonPrime'}.png',
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
                          for (int i = 0; i < projectIdList.length; i++)
                            newAmezon.length == 0 || projectIdList[i] != 26
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
                                            'New On Amazon',
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
                                                          '$TRENDING_URL/${'AmazonPrime'}.png',
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
                          for (int i = 0; i < projectIdList.length; i++)
                            newDisney.length == 0 || projectIdList[i] != 372
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
                                            'New On Disney',
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "OpenSans",
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: newDisney.length,
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
                                                                contentTPId: newDisney[index1]['content_third_party_id'],
                                                                contentID: newDisney[index1]['content_id'],
                                                                contentType: newDisney[index1]['content_type'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                          child: CachedImage(
                                                            imageUrl: 'https://image.tmdb.org/t/p/original/${newDisney[index1]['content_photo']}',
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
                                                          '$TRENDING_URL/${'Disney'}.png',
                                                          height: 27,
                                                        ),
                                                      ),
                                                      newDisney[index1]['comment_count_top'] == 0
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
                                                                      '${newDisney[index1]['comment_count_top']} Comments ',
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
                          if (projectIdList.length == 0)
                            newHBO.length == 0
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
                                            'New On HBO Max',
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "OpenSans",
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: newHBO.length,
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
                                                                contentTPId: newHBO[index1]['content_third_party_id'],
                                                                contentID: newHBO[index1]['content_id'],
                                                                contentType: newHBO[index1]['content_type'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                          child: CachedImage(
                                                            imageUrl: 'https://image.tmdb.org/t/p/original/${newHBO[index1]['content_photo']}',
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
                                                          '$TRENDING_URL/${'HBOMax'}.png',
                                                          height: 27,
                                                        ),
                                                      ),
                                                      newHBO[index1]['comment_count_top'] == 0
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
                                                                      '${newHBO[index1]['comment_count_top']} Comments ',
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
                          for (int i = 0; i < projectIdList.length; i++)
                            newHBO.length == 0 || projectIdList[i] != 387
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
                                            'New On HBO Max',
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "OpenSans",
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: newHBO.length,
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
                                                                contentTPId: newHBO[index1]['content_third_party_id'],
                                                                contentID: newHBO[index1]['content_id'],
                                                                contentType: newHBO[index1]['content_type'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                          child: CachedImage(
                                                            imageUrl: 'https://image.tmdb.org/t/p/original/${newHBO[index1]['content_photo']}',
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
                                                          '$TRENDING_URL/${'HBOMax'}.png',
                                                          height: 27,
                                                        ),
                                                      ),
                                                      newHBO[index1]['comment_count_top'] == 0
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
                                                                      '${newHBO[index1]['comment_count_top']} Comments ',
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
                          if (projectIdList.length == 0)
                            hulu.length == 0
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
                                            'New On Hulu',
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "OpenSans",
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: hulu.length,
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
                                                                contentTPId: hulu[index1]['content_third_party_id'],
                                                                contentID: hulu[index1]['content_id'],
                                                                contentType: hulu[index1]['content_type'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                          child: CachedImage(
                                                            imageUrl: 'https://image.tmdb.org/t/p/original/${hulu[index1]['content_photo']}',
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
                                                          '$TRENDING_URL/${'Hulu'}.png',
                                                          height: 27,
                                                        ),
                                                      ),
                                                      hulu[index1]['comment_count_top'] == 0
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
                                                                      '${hulu[index1]['comment_count_top']} Comments ',
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
                          for (int i = 0; i < projectIdList.length; i++)
                            hulu.length == 0 || projectIdList[i] != 157
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
                                            'New On Hulu',
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "OpenSans",
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: hulu.length,
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
                                                                contentTPId: hulu[index1]['content_third_party_id'],
                                                                contentID: hulu[index1]['content_id'],
                                                                contentType: hulu[index1]['content_type'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                          child: CachedImage(
                                                            imageUrl: 'https://image.tmdb.org/t/p/original/${hulu[index1]['content_photo']}',
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
                                                          '$TRENDING_URL/${'Hulu'}.png',
                                                          height: 27,
                                                        ),
                                                      ),
                                                      hulu[index1]['comment_count_top'] == 0
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
                                                                      '${hulu[index1]['comment_count_top']} Comments ',
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
                          if (projectIdList.length == 0)
                            peacock.length == 0
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
                                            'New On Peacock',
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "OpenSans",
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: peacock.length,
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
                                                                contentTPId: peacock[index1]['content_third_party_id'],
                                                                contentID: peacock[index1]['content_id'],
                                                                contentType: peacock[index1]['content_type'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                          child: CachedImage(
                                                            imageUrl: 'https://image.tmdb.org/t/p/original/${peacock[index1]['content_photo']}',
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
                                                          '$TRENDING_URL/${'Peacock'}.png',
                                                          height: 27,
                                                        ),
                                                      ),
                                                      peacock[index1]['comment_count_top'] == 0
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
                                                                      '${peacock[index1]['comment_count_top']} Comments ',
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
                          for (int i = 0; i < projectIdList.length; i++)
                            peacock.length == 0 || projectIdList[i] != 388
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
                                            'New On Peacock',
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "OpenSans",
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: peacock.length,
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
                                                                contentTPId: peacock[index1]['content_third_party_id'],
                                                                contentID: peacock[index1]['content_id'],
                                                                contentType: peacock[index1]['content_type'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                          child: CachedImage(
                                                            imageUrl: 'https://image.tmdb.org/t/p/original/${peacock[index1]['content_photo']}',
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
                                                          '$TRENDING_URL/${'Peacock'}.png',
                                                          height: 27,
                                                        ),
                                                      ),
                                                      peacock[index1]['comment_count_top'] == 0
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
                                                                      '${peacock[index1]['comment_count_top']} Comments ',
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
                          for (int i = 0; i < projectIdList.length; i++)
                            paramount.length == 0 || projectIdList[i] != 444
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
                                            'New On Paramount',
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "OpenSans",
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: paramount.length,
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
                                                                contentTPId: paramount[index1]['content_third_party_id'],
                                                                contentID: paramount[index1]['content_id'],
                                                                contentType: paramount[index1]['content_type'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                          child: CachedImage(
                                                            imageUrl: 'https://image.tmdb.org/t/p/original/${paramount[index1]['content_photo']}',
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
                                                          '$TRENDING_URL/${'Paramount'}.png',
                                                          height: 27,
                                                        ),
                                                      ),
                                                      paramount[index1]['comment_count_top'] == 0
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
                                                                      '${paramount[index1]['comment_count_top']} Comments ',
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
                          for (int i = 0; i < projectIdList.length; i++)
                            appleTv.length == 0 || projectIdList[i] != 371
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
                                            'New On Apple TV',
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "OpenSans",
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: appleTv.length,
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
                                                                contentTPId: appleTv[index1]['content_third_party_id'],
                                                                contentID: appleTv[index1]['content_id'],
                                                                contentType: appleTv[index1]['content_type'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                          child: CachedImage(
                                                            imageUrl: 'https://image.tmdb.org/t/p/original/${appleTv[index1]['content_photo']}',
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
                                                          '$TRENDING_URL/${'AppleTV'}.png',
                                                          height: 27,
                                                        ),
                                                      ),
                                                      appleTv[index1]['comment_count_top'] == 0
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
                                                                      '${appleTv[index1]['comment_count_top']} Comments ',
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
                          for (int i = 0; i < projectIdList.length; i++)
                            tubi.length == 0 || projectIdList[i] != 296
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
                                            'New On Tubi',
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "OpenSans",
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: tubi.length,
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
                                                                contentTPId: tubi[index1]['content_third_party_id'],
                                                                contentID: tubi[index1]['content_id'],
                                                                contentType: tubi[index1]['content_type'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                          child: CachedImage(
                                                            imageUrl: 'https://image.tmdb.org/t/p/original/${tubi[index1]['content_photo']}',
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
                                                          '$TRENDING_URL/${'Tubi'}.png',
                                                          height: 27,
                                                        ),
                                                      ),
                                                      tubi[index1]['comment_count_top'] == 0
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
                                                                      '${tubi[index1]['comment_count_top']} Comments ',
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
                          for (int i = 0; i < projectIdList.length; i++)
                            pluto.length == 0 || projectIdList[i] != 391
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
                                            'New On Pluto',
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "OpenSans",
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: pluto.length,
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
                                                                contentTPId: pluto[index1]['content_third_party_id'],
                                                                contentID: pluto[index1]['content_id'],
                                                                contentType: pluto[index1]['content_type'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                          child: CachedImage(
                                                            imageUrl: 'https://image.tmdb.org/t/p/original/${pluto[index1]['content_photo']}',
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
                                                          '$TRENDING_URL/${'Pluto'}.png',
                                                          height: 27,
                                                        ),
                                                      ),
                                                      pluto[index1]['comment_count_top'] == 0
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
                                                                      '${pluto[index1]['comment_count_top']} Comments ',
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
                          for (int i = 0; i < projectIdList.length; i++)
                            starz.length == 0 || projectIdList[i] != 232
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
                                            'New On Starz',
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "OpenSans",
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: starz.length,
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
                                                                contentTPId: starz[index1]['content_third_party_id'],
                                                                contentID: starz[index1]['content_id'],
                                                                contentType: starz[index1]['content_type'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                          child: CachedImage(
                                                            imageUrl: 'https://image.tmdb.org/t/p/original/${starz[index1]['content_photo']}',
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
                                                          '$TRENDING_URL/${'Starz'}.png',
                                                          height: 27,
                                                        ),
                                                      ),
                                                      starz[index1]['comment_count_top'] == 0
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
                                                                      '${starz[index1]['comment_count_top']} Comments ',
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
                          for (int i = 0; i < projectIdList.length; i++)
                            showtime.length == 0 || projectIdList[i] != 248
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
                                            'New On Showtime',
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "OpenSans",
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: showtime.length,
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
                                                                contentTPId: showtime[index1]['content_third_party_id'],
                                                                contentID: showtime[index1]['content_id'],
                                                                contentType: showtime[index1]['content_type'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                          child: CachedImage(
                                                            imageUrl: 'https://image.tmdb.org/t/p/original/${showtime[index1]['content_photo']}',
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
                                                          '$TRENDING_URL/${'Showtime'}.png',
                                                          height: 27,
                                                        ),
                                                      ),
                                                      showtime[index1]['comment_count_top'] == 0
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
                                                                      '${showtime[index1]['comment_count_top']} Comments ',
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
                                                        '$TRENDING_URL/${actionMovie[index1]['source_id'] == '203' ? 'NetflixNew' : actionMovie[index1]['source_id'] == '26' ? 'AmazonPrime' : actionMovie[index1]['source_id'] == '372' ? 'Disney' : actionMovie[index1]['source_id'] == '157' ? 'Hulu' : actionMovie[index1]['source_id'] == '387' ? 'HBOMax' : actionMovie[index1]['source_id'] == '444' ? 'Paramount' : actionMovie[index1]['source_id'] == '388' || actionMovie[index1]['source_id'] == '389' ? 'Peacock' : actionMovie[index1]['source_id'] == '371' ? 'AppleTV' : actionMovie[index1]['source_id'] == '445' ? 'DiscoveryPlus' : actionMovie[index1]['source_id'] == '248' ? 'Showtime' : actionMovie[index1]['source_id'] == '232' ? 'Starz' : actionMovie[index1]['source_id'] == '296' ? 'Tubi' : actionMovie[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
                                                        height: 25,
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
                                                        '$TRENDING_URL/${comedyMovie[index1]['source_id'] == '203' ? 'NetflixNew' : comedyMovie[index1]['source_id'] == '26' ? 'AmazonPrime' : comedyMovie[index1]['source_id'] == '372' ? 'Disney' : comedyMovie[index1]['source_id'] == '157' ? 'Hulu' : comedyMovie[index1]['source_id'] == '387' ? 'HBOMax' : comedyMovie[index1]['source_id'] == '444' ? 'Paramount' : comedyMovie[index1]['source_id'] == '388' || comedyMovie[index1]['source_id'] == '389' ? 'Peacock' : comedyMovie[index1]['source_id'] == '371' ? 'AppleTV' : actionMovie[index1]['source_id'] == '445' ? 'DiscoveryPlus' : comedyMovie[index1]['source_id'] == '248' ? 'Showtime' : comedyMovie[index1]['source_id'] == '232' ? 'Starz' : comedyMovie[index1]['source_id'] == '296' ? 'Tubi' : comedyMovie[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
                                                        height: 25,
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
                                                        '$TRENDING_URL/${scienceFictionMovie[index1]['source_id'] == '203' ? 'NetflixNew' : scienceFictionMovie[index1]['source_id'] == '26' ? 'AmazonPrime' : scienceFictionMovie[index1]['source_id'] == '372' ? 'Disney' : scienceFictionMovie[index1]['source_id'] == '157' ? 'Hulu' : scienceFictionMovie[index1]['source_id'] == '387' ? 'HBOMax' : scienceFictionMovie[index1]['source_id'] == '444' ? 'Paramount' : scienceFictionMovie[index1]['source_id'] == '388' || scienceFictionMovie[index1]['source_id'] == '389' ? 'Peacock' : scienceFictionMovie[index1]['source_id'] == '371' ? 'AppleTV' : scienceFictionMovie[index1]['source_id'] == '445' ? 'DiscoveryPlus' : scienceFictionMovie[index1]['source_id'] == '248' ? 'Showtime' : scienceFictionMovie[index1]['source_id'] == '232' ? 'Starz' : scienceFictionMovie[index1]['source_id'] == '296' ? 'Tubi' : scienceFictionMovie[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
                                                        height: 25,
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
                                                        '$TRENDING_URL/${romanceMovie[index1]['source_id'] == '203' ? 'NetflixNew' : romanceMovie[index1]['source_id'] == '26' ? 'AmazonPrime' : romanceMovie[index1]['source_id'] == '372' ? 'Disney' : romanceMovie[index1]['source_id'] == '157' ? 'Hulu' : romanceMovie[index1]['source_id'] == '387' ? 'HBOMax' : romanceMovie[index1]['source_id'] == '444' ? 'Paramount' : romanceMovie[index1]['source_id'] == '388' || romanceMovie[index1]['source_id'] == '389' ? 'Peacock' : romanceMovie[index1]['source_id'] == '371' ? 'AppleTV' : romanceMovie[index1]['source_id'] == '445' ? 'DiscoveryPlus' : romanceMovie[index1]['source_id'] == '248' ? 'Showtime' : romanceMovie[index1]['source_id'] == '232' ? 'Starz' : romanceMovie[index1]['source_id'] == '296' ? 'Tubi' : romanceMovie[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
                                                        height: 25,
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
                                                        '$TRENDING_URL/${actionTv[index1]['source_id'] == '203' ? 'NetflixNew' : actionTv[index1]['source_id'] == '26' ? 'AmazonPrime' : actionTv[index1]['source_id'] == '372' ? 'Disney' : actionTv[index1]['source_id'] == '157' ? 'Hulu' : actionTv[index1]['source_id'] == '387' ? 'HBOMax' : actionTv[index1]['source_id'] == '444' ? 'Paramount' : actionTv[index1]['source_id'] == '388' || actionTv[index1]['source_id'] == '389' ? 'Peacock' : actionTv[index1]['source_id'] == '371' ? 'AppleTV' : actionTv[index1]['source_id'] == '445' ? 'DiscoveryPlus' : actionTv[index1]['source_id'] == '248' ? 'Showtime' : actionTv[index1]['source_id'] == '232' ? 'Starz' : actionTv[index1]['source_id'] == '296' ? 'Tubi' : actionTv[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
                                                        height: 25,
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
                                                        '$TRENDING_URL/${comedyTv[index1]['source_id'] == '203' ? 'NetflixNew' : comedyTv[index1]['source_id'] == '26' ? 'AmazonPrime' : comedyTv[index1]['source_id'] == '372' ? 'Disney' : comedyTv[index1]['source_id'] == '157' ? 'Hulu' : comedyTv[index1]['source_id'] == '387' ? 'HBOMax' : comedyTv[index1]['source_id'] == '444' ? 'Paramount' : comedyTv[index1]['source_id'] == '388' || comedyTv[index1]['source_id'] == '389' ? 'Peacock' : comedyTv[index1]['source_id'] == '371' ? 'AppleTV' : comedyTv[index1]['source_id'] == '445' ? 'DiscoveryPlus' : comedyTv[index1]['source_id'] == '248' ? 'Showtime' : comedyTv[index1]['source_id'] == '232' ? 'Starz' : comedyTv[index1]['source_id'] == '296' ? 'Tubi' : actionTv[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
                                                        height: 25,
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
                                                        '$TRENDING_URL/${adventureMovies[index1]['source_id'] == '203' ? 'NetflixNew' : adventureMovies[index1]['source_id'] == '26' ? 'AmazonPrime' : adventureMovies[index1]['source_id'] == '372' ? 'Disney' : adventureMovies[index1]['source_id'] == '157' ? 'Hulu' : adventureMovies[index1]['source_id'] == '387' ? 'HBOMax' : adventureMovies[index1]['source_id'] == '444' ? 'Paramount' : adventureMovies[index1]['source_id'] == '388' || adventureMovies[index1]['source_id'] == '389' ? 'Peacock' : adventureMovies[index1]['source_id'] == '371' ? 'AppleTV' : adventureMovies[index1]['source_id'] == '445' ? 'DiscoveryPlus' : adventureMovies[index1]['source_id'] == '248' ? 'Showtime' : adventureMovies[index1]['source_id'] == '232' ? 'Starz' : adventureMovies[index1]['source_id'] == '296' ? 'Tubi' : adventureMovies[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
                                                        height: 25,
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
                                                        '$TRENDING_URL/${familyMovies[index1]['source_id'] == '203' ? 'NetflixNew' : familyMovies[index1]['source_id'] == '26' ? 'AmazonPrime' : familyMovies[index1]['source_id'] == '372' ? 'Disney' : familyMovies[index1]['source_id'] == '157' ? 'Hulu' : familyMovies[index1]['source_id'] == '387' ? 'HBOMax' : familyMovies[index1]['source_id'] == '444' ? 'Paramount' : familyMovies[index1]['source_id'] == '388' || familyMovies[index1]['source_id'] == '389' ? 'Peacock' : familyMovies[index1]['source_id'] == '371' ? 'AppleTV' : familyMovies[index1]['source_id'] == '445' ? 'DiscoveryPlus' : familyMovies[index1]['source_id'] == '248' ? 'Showtime' : familyMovies[index1]['source_id'] == '232' ? 'Starz' : familyMovies[index1]['source_id'] == '296' ? 'Tubi' : familyMovies[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
                                                        height: 25,
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
                                                        '$TRENDING_URL/${dramaMovies[index1]['source_id'] == '203' ? 'NetflixNew' : dramaMovies[index1]['source_id'] == '26' ? 'AmazonPrime' : dramaMovies[index1]['source_id'] == '372' ? 'Disney' : dramaMovies[index1]['source_id'] == '157' ? 'Hulu' : dramaMovies[index1]['source_id'] == '387' ? 'HBOMax' : dramaMovies[index1]['source_id'] == '444' ? 'Paramount' : dramaMovies[index1]['source_id'] == '388' || dramaMovies[index1]['source_id'] == '389' ? 'Peacock' : dramaMovies[index1]['source_id'] == '371' ? 'AppleTV' : dramaMovies[index1]['source_id'] == '445' ? 'DiscoveryPlus' : dramaMovies[index1]['source_id'] == '248' ? 'Showtime' : dramaMovies[index1]['source_id'] == '232' ? 'Starz' : dramaMovies[index1]['source_id'] == '296' ? 'Tubi' : dramaMovies[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
                                                        height: 25,
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
                                                        '$TRENDING_URL/${familyTv[index1]['source_id'] == '203' ? 'NetflixNew' : familyTv[index1]['source_id'] == '26' ? 'AmazonPrime' : familyTv[index1]['source_id'] == '372' ? 'Disney' : familyTv[index1]['source_id'] == '157' ? 'Hulu' : familyTv[index1]['source_id'] == '387' ? 'HBOMax' : familyTv[index1]['source_id'] == '444' ? 'Paramount' : familyTv[index1]['source_id'] == '388' || familyTv[index1]['source_id'] == '389' ? 'Peacock' : familyTv[index1]['source_id'] == '371' ? 'AppleTV' : familyTv[index1]['source_id'] == '445' ? 'DiscoveryPlus' : familyTv[index1]['source_id'] == '248' ? 'Showtime' : familyTv[index1]['source_id'] == '232' ? 'Starz' : familyTv[index1]['source_id'] == '296' ? 'Tubi' : familyTv[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
                                                        height: 25,
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
                                                        '$TRENDING_URL/${dramaTv[index1]['source_id'] == '203' ? 'NetflixNew' : dramaTv[index1]['source_id'] == '26' ? 'AmazonPrime' : dramaTv[index1]['source_id'] == '372' ? 'Disney' : dramaTv[index1]['source_id'] == '157' ? 'Hulu' : dramaTv[index1]['source_id'] == '387' ? 'HBOMax' : dramaTv[index1]['source_id'] == '444' ? 'Paramount' : dramaTv[index1]['source_id'] == '388' || dramaTv[index1]['source_id'] == '389' ? 'Peacock' : dramaTv[index1]['source_id'] == '371' ? 'AppleTV' : dramaTv[index1]['source_id'] == '445' ? 'DiscoveryPlus' : dramaTv[index1]['source_id'] == '248' ? 'Showtime' : dramaTv[index1]['source_id'] == '232' ? 'Starz' : dramaTv[index1]['source_id'] == '296' ? 'Tubi' : dramaTv[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
                                                        height: 25,
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
                          thrillerMovies.length <= 3
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
                                                            builder: (context) => PostContentScreen(
                                                              contentTPId: thrillerMovies[index1]['content_third_party_id'],
                                                              contentID: thrillerMovies[index1]['content_id'],
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
                                                      left: 7,
                                                      child: Image.asset(
                                                        '$TRENDING_URL/${thrillerMovies[index1]['source_id'] == '203' ? 'NetflixNew' : thrillerMovies[index1]['source_id'] == '26' ? 'AmazonPrime' : thrillerMovies[index1]['source_id'] == '372' ? 'Disney' : thrillerMovies[index1]['source_id'] == '157' ? 'Hulu' : thrillerMovies[index1]['source_id'] == '387' ? 'HBOMax' : thrillerMovies[index1]['source_id'] == '444' ? 'Paramount' : thrillerMovies[index1]['source_id'] == '388' || thrillerMovies[index1]['source_id'] == '389' ? 'Peacock' : thrillerMovies[index1]['source_id'] == '371' ? 'AppleTV' : thrillerMovies[index1]['source_id'] == '445' ? 'DiscoveryPlus' : thrillerMovies[index1]['source_id'] == '248' ? 'Showtime' : thrillerMovies[index1]['source_id'] == '232' ? 'Starz' : thrillerMovies[index1]['source_id'] == '296' ? 'Tubi' : thrillerMovies[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
                                                        height: 25,
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
                          horrorMovies.length <= 3
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
                                                            builder: (context) => PostContentScreen(
                                                              contentTPId: horrorMovies[index1]['content_third_party_id'],
                                                              contentID: horrorMovies[index1]['content_id'],
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
                                                      left: 7,
                                                      child: Image.asset(
                                                        '$TRENDING_URL/${horrorMovies[index1]['source_id'] == '203' ? 'NetflixNew' : horrorMovies[index1]['source_id'] == '26' ? 'AmazonPrime' : horrorMovies[index1]['source_id'] == '372' ? 'Disney' : horrorMovies[index1]['source_id'] == '157' ? 'Hulu' : horrorMovies[index1]['source_id'] == '387' ? 'HBOMax' : horrorMovies[index1]['source_id'] == '444' ? 'Paramount' : horrorMovies[index1]['source_id'] == '388' || horrorMovies[index1]['source_id'] == '389' ? 'Peacock' : horrorMovies[index1]['source_id'] == '371' ? 'AppleTV' : horrorMovies[index1]['source_id'] == '445' ? 'DiscoveryPlus' : horrorMovies[index1]['source_id'] == '248' ? 'Showtime' : horrorMovies[index1]['source_id'] == '232' ? 'Starz' : thrillerMovies[index1]['source_id'] == '296' ? 'Tubi' : horrorMovies[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
                                                        height: 25,
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
                          thrillerTV.length <= 3
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
                                          'Thriller TV Shows',
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "OpenSans",
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: thrillerTV.length,
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
                                                              contentTPId: thrillerTV[index1]['content_third_party_id'],
                                                              contentID: thrillerTV[index1]['content_id'],
                                                              contentType: thrillerTV[index1]['content_type'],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(6),
                                                        ),
                                                        child: CachedImage(
                                                          imageUrl: 'https://image.tmdb.org/t/p/original/${thrillerTV[index1]['content_photo']}',
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
                                                        '$TRENDING_URL/${thrillerTV[index1]['source_id'] == '203' ? 'NetflixNew' : thrillerTV[index1]['source_id'] == '26' ? 'AmazonPrime' : thrillerTV[index1]['source_id'] == '372' ? 'Disney' : thrillerTV[index1]['source_id'] == '157' ? 'Hulu' : thrillerTV[index1]['source_id'] == '387' ? 'HBOMax' : thrillerTV[index1]['source_id'] == '444' ? 'Paramount' : thrillerTV[index1]['source_id'] == '388' || thrillerTV[index1]['source_id'] == '389' ? 'Peacock' : thrillerTV[index1]['source_id'] == '371' ? 'AppleTV' : horrorMovies[index1]['source_id'] == '445' ? 'DiscoveryPlus' : thrillerTV[index1]['source_id'] == '248' ? 'Showtime' : thrillerTV[index1]['source_id'] == '232' ? 'Starz' : thrillerTV[index1]['source_id'] == '296' ? 'Tubi' : thrillerTV[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
                                                        height: 25,
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
                                                        '$TRENDING_URL/${scifiFanstyTv[index1]['source_id'] == '203' ? 'NetflixNew' : scifiFanstyTv[index1]['source_id'] == '26' ? 'AmazonPrime' : scifiFanstyTv[index1]['source_id'] == '372' ? 'Disney' : scifiFanstyTv[index1]['source_id'] == '157' ? 'Hulu' : scifiFanstyTv[index1]['source_id'] == '387' ? 'HBOMax' : scifiFanstyTv[index1]['source_id'] == '444' ? 'Paramount' : scifiFanstyTv[index1]['source_id'] == '388' || scifiFanstyTv[index1]['source_id'] == '389' ? 'Peacock' : scifiFanstyTv[index1]['source_id'] == '371' ? 'AppleTV' : scifiFanstyTv[index1]['source_id'] == '445' ? 'DiscoveryPlus' : scifiFanstyTv[index1]['source_id'] == '248' ? 'Showtime' : scifiFanstyTv[index1]['source_id'] == '232' ? 'Starz' : scifiFanstyTv[index1]['source_id'] == '296' ? 'Tubi' : scifiFanstyTv[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
                                                        height: 25,
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
                                                        '$TRENDING_URL/${crimeTv[index1]['source_id'] == '203' ? 'NetflixNew' : crimeTv[index1]['source_id'] == '26' ? 'AmazonPrime' : crimeTv[index1]['source_id'] == '372' ? 'Disney' : crimeTv[index1]['source_id'] == '157' ? 'Hulu' : crimeTv[index1]['source_id'] == '387' ? 'HBOMax' : crimeTv[index1]['source_id'] == '444' ? 'Paramount' : crimeTv[index1]['source_id'] == '388' || crimeTv[index1]['source_id'] == '389' ? 'Peacock' : crimeTv[index1]['source_id'] == '371' ? 'AppleTV' : crimeTv[index1]['source_id'] == '445' ? 'DiscoveryPlus' : crimeTv[index1]['source_id'] == '248' ? 'Showtime' : crimeTv[index1]['source_id'] == '232' ? 'Starz' : crimeTv[index1]['source_id'] == '296' ? 'Tubi' : crimeTv[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
                                                        height: 25,
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
                          SizedBox(height: 20),
                          top10data == null
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: AlertBox(
                                    buttonText: 'INVITE YOUR FRIENDS',
                                    description:
                                        'Oneflix is better with your friends. Invite your friends to Oneflix so you can discover what they\'re streaming and recommend content to each other.',
                                    descFontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    onTap: () {
                                      Share.share('Join me on Oneflix to share and discuss the best content on streaming. https://oneflix.app/');
                                    },
                                    child: Image.asset('assets/images/Oneflix Social.png', fit: BoxFit.cover),
                                  ),
                                )
                        ],
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Color(0xff004AAD),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
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
            ),
          ],
        ),
      ),
    );
  }

  _getComingSoonData() async {
    var jsonData;
    if (!mounted) return;
    try {
      var response = await Dio().post(
        GET_COMING_SOON_DATA,
        data: {'type': 1},
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
            comingSoonData = jsonData['data'];
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

  _top10Trending({int? selectedType, bool? permission}) async {
    if (mounted) {
      setState(() {
        top10data = null;
        top10Trending = [];
        streamingTrendingIDs = [];
        _loading = true;
      });
    }
    try {
      var response = await Dio().post(
        TOP_10_TRENDING,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {
          'trending_type': 1,
          'permission': 1,
        },
      );
      // log(response.toString());
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          top10data = jsonDecode(response.toString());
        });
        if (top10data['status'] == 1) {
          setState(() {
            if (selectedType == 1) {
              region = top10data['country'];
            } else if (selectedType == 2) {
              region = top10data['state'];
            } else if (selectedType == 3) {
              region = top10data['city'];
            }

            if (top10data['data'] == null) {
              top10Trending = [];
            } else {
              top10Trending = top10data['data'];
            }
            streamingTrendingIDs = [];
            for (int i = 0; i < top10Trending.length; i++) {
              if (top10Trending[i]['watch_mode_json'] == [] || top10Trending[i]['watch_mode_json'] == null) {
                streamingTrendingIDs.insert(i, 0);
              } else {
                List temp = jsonDecode(top10Trending[i]['watch_mode_json']);

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
          });
        } else {
          Toasty.showtoast(top10data['message']);
        }
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }

  _getSouceList() async {
    var jsonData;
    projectIdList = [];
    selectedindex = [];
    if (!mounted) return;
    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        GET_SOURCE_DATA,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
      );
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            _loading = false;
            sourceList = jsonData['data'];
          });
          for (int i = 0; i < sourceList.length; i++) {
            if (sourceList[i]['is_selected_me'] == 1) {
              setState(() {
                projectIdList.add(sourceList[i]['source_id']);
                selectedindex.add(i);
              });
            }
          }
        } else {
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {}
  }

  _getProviderName() async {
    var jsonData;
    if (!mounted) return;
    try {
      var response = await Dio().post(
        GET_PROVIDER_NAME,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {
          'unique_id': projectIdList.length == 0 ? staticID.join(',') : projectIdList.join(','),
        },
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            image = jsonData['data'];
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

  _getBiggestEventData() async {
    var jsonData;
    if (!mounted) return;

    try {
      var response = await Dio().post(
        GET_BIGGEST_EVENT_DATA,
        data: {'type': 1},
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
            biggestEvent = jsonData['data'];
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

  _getGenereData() async {
    var jsonData;
    if (!mounted) return;
    try {
      var response = await Dio().post(GET_GENERS_DATA, options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}), data: {
        'source_id': projectIdList.length == 0 ? staticID.join(',') : projectIdList.join(','),
      });

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            genereData = jsonData['data'];
            actionMovie = genereData["Action Movies"];
            comedyMovie = genereData["Comedy Movies"];
            romanceMovie = genereData["Romance Movies"];
            actionTv = genereData["Action & Adventure TV Shows"];
            comedyTv = genereData["Comedy TV Shows"];
            scifiFanstyTv = genereData["Sci-Fi & Fantasy TV Shows"];
            adventureMovies = genereData["Adventure Movies"];
            familyMovies = genereData["Family Movies"];
            dramaMovies = genereData["Drama Movies"];
            familyTv = genereData["Family TV Shows"];
            dramaTv = genereData["Drama TV Shows"];
            thrillerMovies = genereData["Thriller Movies"];
            horrorMovies = genereData["Horror Movies"];
            thrillerTV = genereData["Thriller TV Shows"];
            crimeTv = genereData["Crime TV Shows"];
            scienceFictionMovie = genereData["Science Fiction Movies"];
            yourWatchList = genereData["Your Watchlist"];
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

  _getNewlyData() async {
    var jsonData;
    if (!mounted) return;
    try {
      var response = await Dio().post(GET_NEWLY_DATA, options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}), data: {
        'type': selected,
      });

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            newData = jsonData['data'];
            newNetflix = newData["New On Netflix"];
            newAmezon = newData["New On Amazon"];
            newHBO = newData["New On HBO Max"];
            hulu = newData["Hulu"];
            peacock = newData["Peacock"];
            paramount = newData["Paramount"];
            appleTv = newData["Apple TV"];
            tubi = newData["Tubi"];
            pluto = newData["Starz"];
            starz = newData["Pluto"];
            showtime = newData["Showtime"];
            newDisney = newData["New On Disney"];
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

  _getArriveStreamingData() async {
    var jsonData;
    if (!mounted) return;
    try {
      var response = await Dio().post(
        GET_ARRIVED_THIS_WEEK_DATA,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {
          'source_id': projectIdList.join(','),
        },
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            getArriveData = jsonData['data'];
            print(getArriveData);
            print('getArriveData');
          });

          for (int i = 0; i < getArriveData.length; i++) {
            if (getArriveData[i]['watch_mode_json'] == [] || getArriveData[i]['watch_mode_json'] == null || getArriveData[i]['watch_mode_json'] == '[]') {
              streamingTrendingIDs6.insert(i, 0);
            } else {
              List temp = jsonDecode(getArriveData[i]['watch_mode_json']);

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
                  streamingTrendingIDs6.insert(i, temp[j]['source_id']);
                  if (streamingTrendingIDs6[i] != null) {
                    break;
                  }
                } else {
                  streamingTrendingIDs6.insert(i, 0);
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

  _getArriveData() async {
    var jsonData;
    if (!mounted) return;
    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        GET_ARRIVED_DATA,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {
          'source_id': projectIdList.join(','),
        },
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            getArriveDataToday = jsonData['data']['Arrived Today'];
            getArriveDataYesterday = jsonData['data']['Arrived Yesterday'];
            print(getArriveData);
            print('getArriveData');
          });

          for (int i = 0; i < getArriveData.length; i++) {
            if (getArriveData[i]['watch_mode_json'] == [] || getArriveData[i]['watch_mode_json'] == null || getArriveData[i]['watch_mode_json'] == '[]') {
              streamingTrendingIDs6.insert(i, 0);
            } else {
              List temp = jsonDecode(getArriveData[i]['watch_mode_json']);

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
                  streamingTrendingIDs6.insert(i, temp[j]['source_id']);
                  if (streamingTrendingIDs6[i] != null) {
                    break;
                  }
                } else {
                  streamingTrendingIDs6.insert(i, 0);
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

  _getTredingDiscussion() async {
    var jsonData;
    if (!mounted) return;

    try {
      var response = await Dio().post(
        TREDING_DICUSSION,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {
          'source_id': projectIdList.join(','),
        },
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            tredingDiscussion = jsonData['data'];
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

  _addSouceData() async {
    var jsonData;
    if (!mounted) return;

    try {
      var response = await Dio().post(
        SELETED_SOURCE_DATA,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: {
          'source_id': projectIdList.join(','),
        },
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          Navigator.pop(context);
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

  _getWhatYouFriendStreaming() async {
    var jsonData;
    if (!mounted) return;
    try {
      var response = await Dio().post(
        YOUR_FRIENDS_STREAMING,
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
            getContent = jsonData['data'];

            for (int i = 0; i < getContent.length; i++) {
              for (var j = 0; j < getContent["${i + 1}"].length; j++) {
                getContent1.add(getContent["${i + 1}"][j]);
              }
            }

            for (int i = 0; i < getContent1.length; i++) {
              if (getContent1[i]['watch_mode_json'] == [] || getContent1[i]['watch_mode_json'] == null || getContent1[i]['watch_mode_json'] == '[]') {
                streamingTrendingIDs5.insert(i, 0);
              } else {
                List temp = jsonDecode(getContent1[i]['watch_mode_json']);

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
                    streamingTrendingIDs5.insert(i, temp[j]['source_id']);
                    if (streamingTrendingIDs5[i] != null) {
                      break;
                    }
                  } else {
                    streamingTrendingIDs5.insert(i, 0);
                  }
                }
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

  bool validate() {
    if (projectIdList.length == 0) {
      Toasty.showtoast('Please select at least one streaming service');
      return false;
    } else {
      return true;
    }
  }
}
