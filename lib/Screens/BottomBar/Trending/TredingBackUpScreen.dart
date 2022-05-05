// import 'dart:convert';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:dio/dio.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/rendering.dart';
// import 'package:intl/intl.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:oneflix/Components/CustomWidgets.dart';
// import 'package:oneflix/Components/LiveDot.dart';
// import 'package:oneflix/Screens/BottomBar/Discover/PlatformContent.dart';
// import 'package:oneflix/Screens/BottomBar/Home/PostContentScreen.dart';
// import 'package:oneflix/Screens/BottomBar/Profile/UserViewScreen.dart';
// import 'package:oneflix/Screens/BottomBar/Trending/ProviderHubScreen.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:visibility_detector/visibility_detector.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';
// import '../../../Constants.dart';
// import '../../../InitialData.dart';
//
// class Trending extends StatefulWidget {
//   const Trending({Key? key}) : super(key: key);
//
//   @override
//   _TrendingState createState() => _TrendingState();
// }
//
// class _TrendingState extends State<Trending> with TickerProviderStateMixin {
//   int selectedButton = 1;
//   late TabController _tabController;
//   late TabController _tabController2;
//
//   int top10TrendingCurrentIndex = 0;
//   int topForYouCurrentIndex = 0;
//
//   List image = [];
//
//   @override
//   void initState() {
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController2 = TabController(length: 2, vsync: this);
//
//     _tabController.addListener(_top10TrendingTabIndex);
//     _tabController2.addListener(_topForYouTabIndex);
//     get();
//
//     super.initState();
//   }
//
//   bool showColor = false;
//
//   get() async {
//     await getToken2();
//     // await getToken1();
//     await getToken();
//   }
//
//   @override
//   void dispose() {
//     _tabController.removeListener(_top10TrendingTabIndex);
//     _tabController2.removeListener(_topForYouTabIndex);
//     super.dispose();
//   }
//
//   void _top10TrendingTabIndex() async {
//     setState(() {
//       top10TrendingCurrentIndex = _tabController.index;
//     });
//     // requestLocationPermission();
//
//     // if (locationPermission == true) {
//     //   await _top10Trending(selectedType: top10TrendingCurrentIndex + 1, permission: locationPermission);
//     // } else {
//     //   await _top10Trending(selectedType: top10TrendingCurrentIndex + 1, permission: locationPermission);
//     // }
//
//     // print(top10TrendingCurrentIndex);
//   }
//
//   void _topForYouTabIndex() async {
//     setState(() {
//       topForYouCurrentIndex = _tabController2.index;
//       if (contactsPermission == true) {
//         // await _getContacts();
//         // await updateContacts();
//       }
//     });
//     _topForYou(topForYouCurrentIndex + 1);
//     // print(topForYouCurrentIndex);
//   }
//
//   String? userToken;
//   bool _loading = false;
//
//   getToken() async {
//     setState(() {
//       _loading = true;
//     });
//     await FirebaseAnalytics.instance.logEvent(name: 'trending_tab', parameters: {'status': 'Visited'});
//     var usertoken = await readData('user_token');
//     var signUpCheck = await readData('isSignUp');
//     var isFirst = await readData('isFirstOccurrenceOfMonth');
//
//     setState(() {
//       userToken = usertoken;
//       isSignUp = signUpCheck;
//       isFirstOccurrenceOfMonth = isFirst;
//     });
//
//     await _getSouceList();
//     await _getProviderName();
//     _top10Trending(selectedType: 1, permission: locationPermission);
//     // _getNewPopularTrendingList(contentType: 0, productionType: 1);
//     // _getNewPopularTrendingList(contentType: 1, productionType: 1);
//     // _getNewPopularTrendingList(contentType: 0, productionType: 2);
//     // _getNewPopularTrendingList(contentType: 1, productionType: 2);
//     _getComingSoonData();
//     _getBiggestEventData();
//     _getArriveStreamingData();
//     _getTredingDiscussion();
//     _getGenereData();
//     _getNewlyData();
//
//     // _topForYou(1);
//     _getWhatYouFriendStreaming();
//     await requestContactPermission();
//   }
//
//   List projectIdList1 = [];
//   List selectedindex1 = [];
//   getToken2() async {
//     var selected1 = await readData('selected');
//     setState(() {
//       if (selected1 != null) {
//         selected = selected1;
//       }
//     });
//   }
//
//   bool locationPermission = false;
//   bool contactsPermission = false;
//   List contacts = [];
//   List contactList = [];
//
//   Map<Permission, PermissionStatus>? statuses;
//
//   Future<void> requestLocationPermission() async {
//     locationPermission = await Permission.location.isGranted;
//     setState(() {});
//     // print(locationPermission);
//     statuses = await [Permission.location].request();
//     setState(() {
//       if (statuses![Permission.location]!.isGranted) {
//         locationPermission = true;
//       } else if (statuses![Permission.location]!.isDenied) {
//         locationPermission = false;
//       } else if (statuses![Permission.location]!.isPermanentlyDenied) {
//         locationPermission = false;
//         // openAppSettings();
//       }
//     });
//     if (locationPermission == true) {
//       await updateLocationEveryMonth();
//     }
//   }
//
//   List newMovieStreaming = [];
//   List newMovieStreamingIDs = [];
//
//   List newTVStreaming = [];
//   List newTVStreamingIDs = [];
//
//   List bestMoviesStreaming = [];
//   List bestMoviesStreamingIDs = [];
//
//   List bestTVStreaming = [];
//   List bestTVStreamingIDs = [];
//
//   List comingSoonData = [];
//   List biggestEvent = [];
//   List getArriveData = [];
//   List tredingDiscussion = [];
//   var genereData;
//   var newData;
//   List actionMovie = [];
//   List comedyMovie = [];
//   List romanceMovie = [];
//   List actionTv = [];
//   List comedyTv = [];
//   List scifiFanstyTv = [];
//   List adventureMovies = [];
//   List familyMovies = [];
//   List dramaMovies = [];
//   List adventureTv = [];
//   List familyTv = [];
//   List dramaTv = [];
//   List thrillerMovies = [];
//   List horrorMovies = [];
//   List thrillerTV = [];
//   List crimeTv = [];
//   List newNetflix = [];
//   List newAmezon = [];
//   List newDisney = [];
//   List newHBO = [];
//   List hulu = [];
//   List peacock = [];
//   List paramount = [];
//   List appleTv = [];
//   List tubi = [];
//   List pluto = [];
//   List starz = [];
//   List showtime = [];
//   List scienceFictionMovie = [];
//   List yourWatchList = [];
//
//   _getNewPopularTrendingList({int contentType = 0, int productionType = 0}) async {
//     var jsonData;
//     if (!mounted) return;
//     // setState(() {
//     //   _loading = true;
//     // });
//     try {
//       var response = await Dio().post(
//         GET_NEW_POPULAR_DATA_IN_TRENDING,
//         options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
//         data: {
//           'content_type': contentType,
//           'production_type': productionType,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         if (!mounted) return;
//         setState(() {
//           // _loading = false;
//           jsonData = jsonDecode(response.toString());
//         });
//         if (jsonData['status'] == 1) {
//           setState(() {
//             if (contentType == 0 && productionType == 1) {
//               newMovieStreaming = jsonData['data'];
//             } else if (contentType == 1 && productionType == 1) {
//               newTVStreaming = jsonData['data'];
//             } else if (contentType == 0 && productionType == 2) {
//               bestMoviesStreaming = jsonData['data'];
//             } else if (contentType == 1 && productionType == 2) {
//               bestTVStreaming = jsonData['data'];
//             }
//
//             for (int i = 0; i < newMovieStreaming.length; i++) {
//               if (newMovieStreaming[i]['watch_mode_json'] == [] || newMovieStreaming[i]['watch_mode_json'] == null || newMovieStreaming[i]['watch_mode_json'] == '[]') {
//                 newMovieStreamingIDs.insert(i, 0);
//               } else {
//                 List temp = jsonDecode(newMovieStreaming[i]['watch_mode_json']);
//
//                 for (int j = 0; j < temp.length; j++) {
//                   // print(j);
//                   if (temp[j]['region'].toString() == "US" &&
//                       (temp[j]['type'].toString().toLowerCase() == "sub" || temp[j]['type'].toString().toLowerCase() == "free") &&
//                       (temp[j]['source_id'] == 203 ||
//                           temp[j]['source_id'] == 26 ||
//                           temp[j]['source_id'] == 372 ||
//                           temp[j]['source_id'] == 157 ||
//                           temp[j]['source_id'] == 387 ||
//                           temp[j]['source_id'] == 444 ||
//                           temp[j]['source_id'] == 388 ||
//                           temp[j]['source_id'] == 389 ||
//                           temp[j]['source_id'] == 371 ||
//                           temp[j]['source_id'] == 445 ||
//                           temp[j]['source_id'] == 248 ||
//                           temp[j]['source_id'] == 232 ||
//                           temp[j]['source_id'] == 296 ||
//                           temp[j]['source_id'] == 391)) {
//                     // print(jsonDecode(top10Trending[i]['watch_mode_json']).length);
//                     newMovieStreamingIDs.insert(i, temp[j]['source_id']);
//                     if (newMovieStreamingIDs[i] != null) {
//                       break;
//                     }
//                   } else {
//                     // print('ELSE 2: $i');
//                     // print(jsonDecode(top10Trending[i]['watch_mode_json']));
//                     newMovieStreamingIDs.insert(i, 0);
//                     // if (newMovieStreamingIDs[i] != null) {
//                     //   break;
//                     // }
//                   }
//                 }
//               }
//             }
//             for (int i = 0; i < newTVStreaming.length; i++) {
//               if (newTVStreaming[i]['watch_mode_json'] == [] || newTVStreaming[i]['watch_mode_json'] == null || newTVStreaming[i]['watch_mode_json'] == '[]') {
//                 newTVStreamingIDs.insert(i, 0);
//               } else {
//                 List temp = jsonDecode(newTVStreaming[i]['watch_mode_json']);
//
//                 for (int j = 0; j < temp.length; j++) {
//                   // print(j);
//                   if (temp[j]['region'].toString() == "US" &&
//                       (temp[j]['type'].toString().toLowerCase() == "sub" || temp[j]['type'].toString().toLowerCase() == "free") &&
//                       (temp[j]['source_id'] == 203 ||
//                           temp[j]['source_id'] == 26 ||
//                           temp[j]['source_id'] == 372 ||
//                           temp[j]['source_id'] == 157 ||
//                           temp[j]['source_id'] == 387 ||
//                           temp[j]['source_id'] == 444 ||
//                           temp[j]['source_id'] == 388 ||
//                           temp[j]['source_id'] == 389 ||
//                           temp[j]['source_id'] == 371 ||
//                           temp[j]['source_id'] == 445 ||
//                           temp[j]['source_id'] == 248 ||
//                           temp[j]['source_id'] == 232 ||
//                           temp[j]['source_id'] == 296 ||
//                           temp[j]['source_id'] == 391)) {
//                     // print(jsonDecode(top10Trending[i]['watch_mode_json']).length);
//                     newTVStreamingIDs.insert(i, temp[j]['source_id']);
//                     if (newTVStreamingIDs[i] != null) {
//                       break;
//                     }
//                   } else {
//                     // print('ELSE 2: $i');
//                     // print(jsonDecode(top10Trending[i]['watch_mode_json']));
//                     newTVStreamingIDs.insert(i, 0);
//                     // if (streamingTrendingIDs2[i] != null) {
//                     //   break;
//                     // }
//                   }
//                 }
//               }
//             }
//             for (int i = 0; i < bestMoviesStreaming.length; i++) {
//               if (bestMoviesStreaming[i]['watch_mode_json'] == [] || bestMoviesStreaming[i]['watch_mode_json'] == null || bestMoviesStreaming[i]['watch_mode_json'] == '[]') {
//                 bestMoviesStreamingIDs.insert(i, 0);
//               } else {
//                 List temp = jsonDecode(bestMoviesStreaming[i]['watch_mode_json']);
//
//                 for (int j = 0; j < temp.length; j++) {
//                   // print(j);
//                   if (temp[j]['region'].toString() == "US" &&
//                       (temp[j]['type'].toString().toLowerCase() == "sub" || temp[j]['type'].toString().toLowerCase() == "free") &&
//                       (temp[j]['source_id'] == 203 ||
//                           temp[j]['source_id'] == 26 ||
//                           temp[j]['source_id'] == 372 ||
//                           temp[j]['source_id'] == 157 ||
//                           temp[j]['source_id'] == 387 ||
//                           temp[j]['source_id'] == 444 ||
//                           temp[j]['source_id'] == 388 ||
//                           temp[j]['source_id'] == 389 ||
//                           temp[j]['source_id'] == 371 ||
//                           temp[j]['source_id'] == 445 ||
//                           temp[j]['source_id'] == 248 ||
//                           temp[j]['source_id'] == 232 ||
//                           temp[j]['source_id'] == 296 ||
//                           temp[j]['source_id'] == 391)) {
//                     // print(jsonDecode(top10Trending[i]['watch_mode_json']).length);
//                     bestMoviesStreamingIDs.insert(i, temp[j]['source_id']);
//                     if (bestMoviesStreamingIDs[i] != null) {
//                       break;
//                     }
//                   } else {
//                     // print('ELSE 2: $i');
//                     // print(jsonDecode(top10Trending[i]['watch_mode_json']));
//                     bestMoviesStreamingIDs.insert(i, 0);
//                     // if (bestMoviesStreamingIDs[i] != null) {
//                     //   break;
//                     // }
//                   }
//                 }
//               }
//             }
//             for (int i = 0; i < bestTVStreaming.length; i++) {
//               if (bestTVStreaming[i]['watch_mode_json'] == [] || bestTVStreaming[i]['watch_mode_json'] == null || bestTVStreaming[i]['watch_mode_json'] == '[]') {
//                 bestTVStreamingIDs.insert(i, 0);
//               } else {
//                 List temp = jsonDecode(bestTVStreaming[i]['watch_mode_json']);
//
//                 for (int j = 0; j < temp.length; j++) {
//                   // print(j);
//                   if (temp[j]['region'].toString() == "US" &&
//                       (temp[j]['type'].toString().toLowerCase() == "sub" || temp[j]['type'].toString().toLowerCase() == "free") &&
//                       (temp[j]['source_id'] == 203 ||
//                           temp[j]['source_id'] == 26 ||
//                           temp[j]['source_id'] == 372 ||
//                           temp[j]['source_id'] == 157 ||
//                           temp[j]['source_id'] == 387 ||
//                           temp[j]['source_id'] == 444 ||
//                           temp[j]['source_id'] == 388 ||
//                           temp[j]['source_id'] == 389 ||
//                           temp[j]['source_id'] == 371 ||
//                           temp[j]['source_id'] == 445 ||
//                           temp[j]['source_id'] == 248 ||
//                           temp[j]['source_id'] == 232 ||
//                           temp[j]['source_id'] == 296 ||
//                           temp[j]['source_id'] == 391)) {
//                     // print(jsonDecode(top10Trending[i]['watch_mode_json']).length);
//                     bestTVStreamingIDs.insert(i, temp[j]['source_id']);
//                     if (bestTVStreamingIDs[i] != null) {
//                       break;
//                     }
//                   } else {
//                     // print('ELSE 2: $i');
//                     // print(jsonDecode(top10Trending[i]['watch_mode_json']));
//                     bestTVStreamingIDs.insert(i, 0);
//                     // if (bestTVStreamingIDs[i] != null) {
//                     //   break;
//                     // }
//                   }
//                 }
//               }
//             }
//           });
//         } else {
//           // Toasty.showtoast(jsonData['message']);
//         }
//       } else {
//         Toasty.showtoast('Something Went Wrong');
//       }
//     } on DioError catch (e) {
//       print(e.response.toString());
//     }
//   }
//
//   _getComingSoonData() async {
//     var jsonData;
//     if (!mounted) return;
//     // setState(() {
//     //   // _loading = true;
//     // });
//     try {
//       var response = await Dio().post(
//         GET_COMING_SOON_DATA,
//         data: {'type': 1},
//         options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
//       );
//
//       if (response.statusCode == 200) {
//         if (!mounted) return;
//         setState(() {
//           _loading = false;
//           jsonData = jsonDecode(response.toString());
//         });
//         if (jsonData['status'] == 1) {
//           setState(() {
//             comingSoonData = jsonData['data'];
//             print(comingSoonData);
//             print('comingSoonData');
//           });
//         } else {
//           Toasty.showtoast(jsonData['message']);
//         }
//       } else {
//         Toasty.showtoast('Something Went Wrong');
//       }
//     } on DioError catch (e) {
//       print(e.response.toString());
//     }
//   }
//
//   List staticID = [203, 26, 387, 157, 388];
//
//   _getProviderName() async {
//     var jsonData;
//     if (!mounted) return;
//     // setState(() {
//     //   // _loading = true;
//     // });
//     try {
//       var response = await Dio().post(
//         GET_PROVIDER_NAME,
//         options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
//         data: {
//           // 'type': selected,
//           'unique_id': projectIdList.length == 0 ? staticID.join(',') : projectIdList.join(','),
//         },
//       );
//
//       if (response.statusCode == 200) {
//         if (!mounted) return;
//         setState(() {
//           _loading = false;
//           jsonData = jsonDecode(response.toString());
//         });
//         if (jsonData['status'] == 1) {
//           setState(() {
//             image = jsonData['data'];
//             print(image);
//             print('image');
//           });
//         } else {
//           Toasty.showtoast(jsonData['message']);
//         }
//       } else {
//         Toasty.showtoast('Something Went Wrong');
//       }
//     } on DioError catch (e) {
//       print(e.response.toString());
//     }
//   }
//
//   _getBiggestEventData() async {
//     var jsonData;
//     if (!mounted) return;
//     // setState(() {
//     //   // _loading = true;
//     // });
//     try {
//       var response = await Dio().post(
//         GET_BIGGEST_EVENT_DATA,
//         data: {'type': 1},
//         options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
//       );
//
//       if (response.statusCode == 200) {
//         if (!mounted) return;
//         setState(() {
//           _loading = false;
//           jsonData = jsonDecode(response.toString());
//         });
//         if (jsonData['status'] == 1) {
//           setState(() {
//             biggestEvent = jsonData['data'];
//             print(biggestEvent);
//             print('biggestEvent');
//           });
//         } else {
//           Toasty.showtoast(jsonData['message']);
//         }
//       } else {
//         Toasty.showtoast('Something Went Wrong');
//       }
//     } on DioError catch (e) {
//       print(e.response.toString());
//     }
//   }
//
//   _getGenereData() async {
//     var jsonData;
//     if (!mounted) return;
//     // setState(() {
//     //   // _loading = true;
//     // });
//     try {
//       var response = await Dio().post(GET_GENERS_DATA, options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}), data: {
//         'source_id': projectIdList.length == 0 ? staticID.join(',') : projectIdList.join(','),
//       });
//
//       if (response.statusCode == 200) {
//         if (!mounted) return;
//         setState(() {
//           _loading = false;
//           jsonData = jsonDecode(response.toString());
//         });
//         if (jsonData['status'] == 1) {
//           setState(() {
//             genereData = jsonData['data'];
//             print(genereData);
//             print('genereData');
//             actionMovie = genereData["Action Movies"];
//             comedyMovie = genereData["Comedy Movies"];
//             romanceMovie = genereData["Romance Movies"];
//             actionTv = genereData["Action & Adventure TV Shows"];
//             comedyTv = genereData["Comedy TV Shows"];
//             scifiFanstyTv = genereData["Sci-Fi & Fantasy TV Shows"];
//             adventureMovies = genereData["Adventure Movies"];
//             familyMovies = genereData["Family Movies"];
//             dramaMovies = genereData["Drama Movies"];
//             familyTv = genereData["Family TV Shows"];
//             dramaTv = genereData["Drama TV Shows"];
//             thrillerMovies = genereData["Thriller Movies"];
//             horrorMovies = genereData["Horror Movies"];
//             thrillerTV = genereData["Thriller TV Shows"];
//             crimeTv = genereData["Crime TV Shows"];
//             scienceFictionMovie = genereData["Science Fiction Movies"];
//             yourWatchList = genereData["Your Watchlist"];
//           });
//         } else {
//           Toasty.showtoast(jsonData['message']);
//         }
//       } else {
//         Toasty.showtoast('Something Went Wrong');
//       }
//     } on DioError catch (e) {
//       print(e.response.toString());
//     }
//   }
//
//   int selected = 0;
//
//   _getNewlyData() async {
//     print(selected);
//     print('selected');
//     var jsonData;
//     if (!mounted) return;
//     // setState(() {
//     //   // _loading = true;
//     // });
//     try {
//       var response = await Dio().post(GET_NEWLY_DATA, options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}), data: {
//         'type': selected,
//       });
//
//       if (response.statusCode == 200) {
//         if (!mounted) return;
//         setState(() {
//           _loading = false;
//           jsonData = jsonDecode(response.toString());
//         });
//         if (jsonData['status'] == 1) {
//           setState(() {
//             newData = jsonData['data'];
//             print(newData);
//             print('newData');
//             newNetflix = newData["New On Netflix"];
//             newAmezon = newData["New On Amazon"];
//             newHBO = newData["New On HBO Max"];
//             hulu = newData["Hulu"];
//             peacock = newData["Peacock"];
//             paramount = newData["Paramount"];
//             appleTv = newData["Apple TV"];
//             tubi = newData["Tubi"];
//             pluto = newData["Starz"];
//             starz = newData["Pluto"];
//             showtime = newData["Showtime"];
//             newDisney = newData["New On Disney"];
//           });
//         } else {
//           Toasty.showtoast(jsonData['message']);
//         }
//       } else {
//         Toasty.showtoast('Something Went Wrong');
//       }
//     } on DioError catch (e) {
//       print(e.response.toString());
//     }
//   }
//
//   _getArriveStreamingData() async {
//     var jsonData;
//     if (!mounted) return;
//
//     try {
//       var response = await Dio().post(
//         GET_ARRIVED_THIS_WEEK_DATA,
//         options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
//         data: {
//           'source_id': projectIdList.join(','),
//         },
//       );
//
//       if (response.statusCode == 200) {
//         if (!mounted) return;
//         setState(() {
//           _loading = false;
//           jsonData = jsonDecode(response.toString());
//         });
//         if (jsonData['status'] == 1) {
//           setState(() {
//             getArriveData = jsonData['data'];
//           });
//
//           for (int i = 0; i < getArriveData.length; i++) {
//             if (getArriveData[i]['watch_mode_json'] == [] || getArriveData[i]['watch_mode_json'] == null || getArriveData[i]['watch_mode_json'] == '[]') {
//               streamingTrendingIDs6.insert(i, 0);
//             } else {
//               List temp = jsonDecode(getArriveData[i]['watch_mode_json']);
//
//               for (int j = 0; j < temp.length; j++) {
//                 // print(j);
//                 if (temp[j]['region'].toString() == "US" &&
//                     (temp[j]['type'].toString().toLowerCase() == "sub" || temp[j]['type'].toString().toLowerCase() == "free") &&
//                     (temp[j]['source_id'] == 203 ||
//                         temp[j]['source_id'] == 26 ||
//                         temp[j]['source_id'] == 372 ||
//                         temp[j]['source_id'] == 157 ||
//                         temp[j]['source_id'] == 387 ||
//                         temp[j]['source_id'] == 444 ||
//                         temp[j]['source_id'] == 388 ||
//                         temp[j]['source_id'] == 389 ||
//                         temp[j]['source_id'] == 371 ||
//                         temp[j]['source_id'] == 445 ||
//                         temp[j]['source_id'] == 248 ||
//                         temp[j]['source_id'] == 232 ||
//                         temp[j]['source_id'] == 296 ||
//                         temp[j]['source_id'] == 391)) {
//                   // print(jsonDecode(top10Trending[i]['watch_mode_json']).length);
//                   streamingTrendingIDs6.insert(i, temp[j]['source_id']);
//                   if (streamingTrendingIDs6[i] != null) {
//                     break;
//                   }
//                 } else {
//                   // print('ELSE 2: $i');
//                   // print(jsonDecode(top10Trending[i]['watch_mode_json']));
//                   streamingTrendingIDs6.insert(i, 0);
//                   // if (newMovieStreamingIDs[i] != null) {
//                   //   break;
//                   // }
//                 }
//               }
//             }
//           }
//         } else {
//           Toasty.showtoast(jsonData['message']);
//         }
//       } else {
//         Toasty.showtoast('Something Went Wrong');
//       }
//     } on DioError catch (e) {
//       print(e.response.toString());
//     }
//   }
//
//   _getTredingDiscussion() async {
//     var jsonData;
//     if (!mounted) return;
//
//     try {
//       var response = await Dio().post(
//         TREDING_DICUSSION,
//         options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
//         data: {
//           'source_id': projectIdList.join(','),
//         },
//       );
//
//       if (response.statusCode == 200) {
//         if (!mounted) return;
//         setState(() {
//           _loading = false;
//           jsonData = jsonDecode(response.toString());
//         });
//         if (jsonData['status'] == 1) {
//           setState(() {
//             tredingDiscussion = jsonData['data'];
//           });
//           print(tredingDiscussion);
//           print('tredingDiscussion');
//         } else {
//           Toasty.showtoast(jsonData['message']);
//         }
//       } else {
//         Toasty.showtoast('Something Went Wrong');
//       }
//     } on DioError catch (e) {
//       print(e.response.toString());
//     }
//   }
//
//   _addSouceData() async {
//     var jsonData;
//     if (!mounted) return;
//
//     try {
//       var response = await Dio().post(
//         SELETED_SOURCE_DATA,
//         options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
//         data: {
//           'source_id': projectIdList.join(','),
//         },
//       );
//
//       if (response.statusCode == 200) {
//         if (!mounted) return;
//         setState(() {
//           _loading = false;
//           jsonData = jsonDecode(response.toString());
//         });
//         if (jsonData['status'] == 1) {
//           Navigator.pop(context);
//         } else {
//           Toasty.showtoast(jsonData['message']);
//         }
//       } else {
//         Toasty.showtoast('Something Went Wrong');
//       }
//     } on DioError catch (e) {
//       print(e.response.toString());
//     }
//   }
//
//   var getContent;
//   List getContent1 = [];
//   List streamingTrendingIDs5 = [];
//   List streamingTrendingIDs6 = [];
//   _getWhatYouFriendStreaming() async {
//     var jsonData;
//     if (!mounted) return;
//     // setState(() {
//     //   _loading = true;
//     // });
//     try {
//       var response = await Dio().post(
//         YOUR_FRIENDS_STREAMING,
//         options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
//       );
//
//       if (response.statusCode == 200) {
//         if (!mounted) return;
//         setState(() {
//           _loading = false;
//           jsonData = jsonDecode(response.toString());
//         });
//         if (jsonData['status'] == 1) {
//           setState(() {
//             getContent = jsonData['data'];
//
//             for (int i = 0; i < getContent.length; i++) {
//               for (var j = 0; j < getContent["${i + 1}"].length; j++) {
//                 getContent1.add(getContent["${i + 1}"][j]);
//               }
//             }
//
//             for (int i = 0; i < getContent1.length; i++) {
//               if (getContent1[i]['watch_mode_json'] == [] || getContent1[i]['watch_mode_json'] == null || getContent1[i]['watch_mode_json'] == '[]') {
//                 streamingTrendingIDs5.insert(i, 0);
//               } else {
//                 List temp = jsonDecode(getContent1[i]['watch_mode_json']);
//
//                 for (int j = 0; j < temp.length; j++) {
//                   // print(j);
//                   if (temp[j]['region'].toString() == "US" &&
//                       (temp[j]['type'].toString().toLowerCase() == "sub" || temp[j]['type'].toString().toLowerCase() == "free") &&
//                       (temp[j]['source_id'] == 203 ||
//                           temp[j]['source_id'] == 26 ||
//                           temp[j]['source_id'] == 372 ||
//                           temp[j]['source_id'] == 157 ||
//                           temp[j]['source_id'] == 387 ||
//                           temp[j]['source_id'] == 444 ||
//                           temp[j]['source_id'] == 388 ||
//                           temp[j]['source_id'] == 389 ||
//                           temp[j]['source_id'] == 371 ||
//                           temp[j]['source_id'] == 445 ||
//                           temp[j]['source_id'] == 248 ||
//                           temp[j]['source_id'] == 232 ||
//                           temp[j]['source_id'] == 296 ||
//                           temp[j]['source_id'] == 391)) {
//                     // print(jsonDecode(top10Trending[i]['watch_mode_json']).length);
//                     streamingTrendingIDs5.insert(i, temp[j]['source_id']);
//                     if (streamingTrendingIDs5[i] != null) {
//                       break;
//                     }
//                   } else {
//                     // print('ELSE 2: $i');
//                     // print(jsonDecode(top10Trending[i]['watch_mode_json']));
//                     streamingTrendingIDs5.insert(i, 0);
//                     // if (newMovieStreamingIDs[i] != null) {
//                     //   break;
//                     // }
//                   }
//                 }
//               }
//             }
//           });
//         } else {
//           Toasty.showtoast(jsonData['message']);
//         }
//       } else {
//         Toasty.showtoast('Something Went Wrong');
//       }
//     } on DioError catch (e) {
//       print(e.response.toString());
//     }
//   }
//
//   String? isSignUp;
//   String? isFirstOccurrenceOfMonth;
//   updateLocationEveryMonth() async {
//     final String formatted = DateFormat('dd').format(DateTime.now());
//
//     if (((formatted == '1' || formatted == '01') && (isFirstOccurrenceOfMonth != 'true' || isFirstOccurrenceOfMonth == null)) || isSignUp == 'true') {
//       print('FIRST IMPRESSION: $isSignUp');
//       print('FIRST IMPRESSION: $isFirstOccurrenceOfMonth');
//       await _updateProfile(1);
//       await writeData('isFirstOccurrenceOfMonth', 'true');
//       await writeData('isSignUp', 'false');
//     }
//   }
//
//   Future<void> requestContactPermission() async {
//     contactsPermission = await Permission.contacts.isGranted;
//     // setState(() {});
//     // print(contactsPermission);
//     statuses = await [Permission.contacts].request();
//     if (!mounted) return;
//     setState(() {
//       if (statuses![Permission.contacts]!.isGranted) {
//         contactsPermission = true;
//       } else if (statuses![Permission.contacts]!.isDenied) {
//         contactsPermission = false;
//       } else if (statuses![Permission.contacts]!.isPermanentlyDenied) {
//         contactsPermission = false;
//         // openAppSettings();
//       }
//     });
//     if (contactsPermission == true) {
//       await _getContacts();
//       await updateContacts();
//     }
//   }
//
//   _getContacts() async {
//     List<Contact> _contacts = (await ContactsService.getContacts(withThumbnails: false)).toList();
//     setState(() {
//       contacts.addAll(_contacts);
//       for (var i = 0; i < contacts.length; i++) {
//         contacts[i].phones.forEach((phone) {
//           // print(phone.value);
//           // print('+1 (893)-398-739'.replaceAll(RegExp(r'[^\w\s]+'), "").replaceAll(' ', ''));
//           setState(() {
//             contactList.add({
//               'phone_number': phone.value.replaceAll(RegExp(r'[^\w\s]+'), "").replaceAll(' ', ''),
//               'contact_name': contacts[i].displayName,
//             });
//           });
//         });
//       }
//       // print(jsonEncode(contactList));
//     });
//   }
//
//   updateContacts() async {
//     try {
//       var response = await Dio().post(
//         ADD_CONTACT,
//         options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
//         data: {'contact_diary': jsonEncode(contactList)},
//       );
//       print(response);
//       if (response.statusCode == 200) {
//       } else {
//         Toasty.showtoast('Something Went Wrong');
//       }
//     } on DioError catch (e) {
//       print(e.response.toString());
//     }
//   }
//
//   List top10Trending = [];
//   List streamingTrendingIDs = [];
//   List streamingTopForYouIDs = [];
//
//   List<ScrollController> newController = [];
//   List<ScrollController> popularController = [];
//   List newList = [];
//   List popularList = [];
//
//   var topForYou;
//   var region;
//
//   var top10data;
//
//   _top10Trending({int? selectedType, bool? permission}) async {
//     // print(selectedType);
//     // print(permission);
//     setState(() {
//       top10data = null;
//       top10Trending = [];
//       streamingTrendingIDs = [];
//       _loading = true;
//     });
//     try {
//       var response = await Dio().post(
//         TOP_10_TRENDING,
//         options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
//         data: {
//           // 'trending_type': selectedType,
//           // 'permission': selectedType == 1 && permission == false
//           //     ? 1
//           //     : selectedType == 2 && permission == false
//           //         ? 2
//           //         : selectedType == 3 && permission == false
//           //             ? 3
//           //             : 0,
//           'trending_type': 1,
//           'permission': 1,
//         },
//       );
//       // log(response.toString());
//       if (response.statusCode == 200) {
//         if (!mounted) return;
//         setState(() {
//           _loading = false;
//           top10data = jsonDecode(response.toString());
//         });
//         if (top10data['status'] == 1) {
//           setState(() {
//             if (selectedType == 1) {
//               region = top10data['country'];
//             } else if (selectedType == 2) {
//               region = top10data['state'];
//             } else if (selectedType == 3) {
//               region = top10data['city'];
//             }
//
//             if (top10data['data'] == null) {
//               top10Trending = [];
//             } else {
//               top10Trending = top10data['data'];
//             }
//             streamingTrendingIDs = [];
//             // print(top10Trending.length);
//             // log(top10Trending.toString());
//             for (int i = 0; i < top10Trending.length; i++) {
//               if (top10Trending[i]['watch_mode_json'] == [] || top10Trending[i]['watch_mode_json'] == null) {
//                 streamingTrendingIDs.insert(i, 0);
//               } else {
//                 List temp = jsonDecode(top10Trending[i]['watch_mode_json']);
//
//                 for (int j = 0; j < temp.length; j++) {
//                   // print(j);
//                   if (temp[j]['region'].toString() == "US" &&
//                       (temp[j]['type'].toString().toLowerCase() == "sub" || temp[j]['type'].toString().toLowerCase() == "free") &&
//                       (temp[j]['source_id'] == 203 ||
//                           temp[j]['source_id'] == 26 ||
//                           temp[j]['source_id'] == 372 ||
//                           temp[j]['source_id'] == 157 ||
//                           temp[j]['source_id'] == 387 ||
//                           temp[j]['source_id'] == 444 ||
//                           temp[j]['source_id'] == 388 ||
//                           temp[j]['source_id'] == 389 ||
//                           temp[j]['source_id'] == 371 ||
//                           temp[j]['source_id'] == 445 ||
//                           temp[j]['source_id'] == 248 ||
//                           temp[j]['source_id'] == 232 ||
//                           temp[j]['source_id'] == 296 ||
//                           temp[j]['source_id'] == 391)) {
//                     // print(jsonDecode(top10Trending[i]['watch_mode_json']).length);
//                     streamingTrendingIDs.insert(i, temp[j]['source_id']);
//                     if (streamingTrendingIDs[i] != null) {
//                       break;
//                     }
//                   } else {
//                     // print('ELSE 2: $i');
//                     // print(jsonDecode(top10Trending[i]['watch_mode_json']));
//                     streamingTrendingIDs.insert(i, 0);
//                     if (streamingTrendingIDs[i] != null) {
//                       break;
//                     }
//                   }
//                 }
//               }
//             }
//             // print('streamingTrendingIDs: $streamingTrendingIDs');
//           });
//         } else {
//           Toasty.showtoast(top10data['message']);
//         }
//       } else {
//         Toasty.showtoast('Something Went Wrong');
//       }
//     } on DioError catch (e) {
//       print(e.response.toString());
//     }
//   }
//
//   List sourceList = [];
//
//   _getSouceList() async {
//     var jsonData;
//     projectIdList = [];
//     selectedindex = [];
//     if (!mounted) return;
//     setState(() {
//       _loading = true;
//     });
//     try {
//       var response = await Dio().post(
//         GET_SOURCE_DATA,
//         options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
//       );
//       if (response.statusCode == 200) {
//         if (!mounted) return;
//         setState(() {
//           jsonData = jsonDecode(response.toString());
//         });
//         print(jsonData);
//         print('jsonData utsav');
//         if (jsonData['status'] == 1) {
//           setState(() {
//             _loading = false;
//             sourceList = jsonData['data'];
//           });
//           for (int i = 0; i < sourceList.length; i++) {
//             if (sourceList[i]['is_selected_me'] == 1) {
//               setState(() {
//                 projectIdList.add(sourceList[i]['source_id']);
//                 selectedindex.add(i);
//               });
//             }
//           }
//         } else {
//           Toasty.showtoast(jsonData['message']);
//         }
//       } else {
//         Toasty.showtoast('Something Went Wrong');
//       }
//     } on DioError catch (e) {
//       print(e.response.toString());
//     }
//   }
//
//   _topForYou(int selectedType) async {
//     var jsonData;
//     if (!mounted) return;
//     setState(() {
//       topForYou = null;
//       _loading = true;
//     });
//     try {
//       var response = await Dio().post(
//         TOP_FOR_YOU,
//         options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
//         data: {'type': selectedType},
//       );
//       // log(response.toString());
//       if (response.statusCode == 200) {
//         if (!mounted) return;
//         setState(() {
//           _loading = false;
//           jsonData = jsonDecode(response.toString());
//         });
//         if (jsonData['status'] == 1) {
//           setState(() {
//             topForYou = [];
//             topForYou = jsonData['data'];
//             streamingTopForYouIDs = [];
//             for (int i = 0; i < topForYou.length; i++) {
//               if (topForYou[i]['watch_mode_json'] == [] || topForYou[i]['watch_mode_json'] == null) {
//                 streamingTopForYouIDs.insert(i, 0);
//               } else {
//                 List temp = jsonDecode(topForYou[i]['watch_mode_json']);
//                 for (int j = 0; j < temp.length; j++) {
//                   if (temp[j]['region'].toString() == "US" &&
//                       (temp[j]['type'].toString().toLowerCase() == "sub" || temp[j]['type'].toString().toLowerCase() == "free") &&
//                       (temp[j]['source_id'] == 203 ||
//                           temp[j]['source_id'] == 26 ||
//                           temp[j]['source_id'] == 372 ||
//                           temp[j]['source_id'] == 157 ||
//                           temp[j]['source_id'] == 387 ||
//                           temp[j]['source_id'] == 444 ||
//                           temp[j]['source_id'] == 388 ||
//                           temp[j]['source_id'] == 389 ||
//                           temp[j]['source_id'] == 371 ||
//                           temp[j]['source_id'] == 445 ||
//                           temp[j]['source_id'] == 248 ||
//                           temp[j]['source_id'] == 232 ||
//                           temp[j]['source_id'] == 296 ||
//                           temp[j]['source_id'] == 391)) {
//                     streamingTopForYouIDs.insert(i, temp[j]['source_id']);
//                     if (streamingTopForYouIDs[i] != null) {
//                       break;
//                     }
//                   } else {
//                     streamingTopForYouIDs.insert(i, 0);
//                     // if (streamingTopForYouIDs[i] != null) {
//                     //   break;
//                     // }
//                   }
//                 }
//               }
//             }
//             // print('streamingTopForYouIDs: $streamingTopForYouIDs');
//           });
//         } else {
//           Toasty.showtoast(jsonData['message']);
//         }
//       } else {
//         Toasty.showtoast('Something Went Wrong');
//       }
//     } on DioError catch (e) {
//       print(e.response.toString());
//     }
//   }
//
//   void previous() => controller.previousPage();
//
//   void next() => controller.nextPage();
//
//   final controller = CarouselController();
//
//   final ItemScrollController itemScrollController = ItemScrollController();
//   final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
//
//   int? _currentItem;
//   int? _currentItem1;
//
//   List selectedindex = [];
//   List projectIdList = [];
//   List formIdList = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return ModalProgressHUD(
//       inAsyncCall: _loading,
//       opacity: 0,
//       progressIndicator: SizedBox(width: 20, height: 20, child: kProgressIndicator),
//       child: Scaffold(
//         backgroundColor: Color(0xff011138),
//         appBar: AppBar(
//           backgroundColor: Color(0xff011138),
//           automaticallyImplyLeading: false,
//           elevation: 0.0,
//           centerTitle: true,
//           bottom: PreferredSize(
//             child: Column(
//               children: [
//                 InkWell(
//                   onTap: () async {
//                     await _getSouceList();
//                     showDialog(
//                       barrierDismissible: true,
//                       context: context,
//                       builder: (context) {
//                         return StatefulBuilder(
//                           builder: (context, setState) {
//                             return Align(
//                               alignment: Alignment.topCenter,
//                               child: Container(
//                                 color: Colors.black87,
//                                 height: MediaQuery.of(context).size.height * 0.80,
//                                 width: MediaQuery.of(context).size.width,
//                                 child: SingleChildScrollView(
//                                   child: Column(
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.only(right: 20),
//                                         child: Align(
//                                           alignment: Alignment.topRight,
//                                           child: GestureDetector(
//                                             onTap: () {
//                                               Navigator.pop(context);
//                                             },
//                                             child: Icon(
//                                               Icons.clear,
//                                               size: 30,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       AppText(
//                                         'PERSONALIZE ONEFLIX',
//                                         fontSize: 22,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w900,
//                                       ),
//                                       SizedBox(
//                                         height: 15,
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                                         child: AppText(
//                                           'Select your streaming services and then scroll down to save your options.',
//                                           fontSize: 18,
//                                           color: Colors.white,
//                                           textAlign: TextAlign.center,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 40,
//                                       ),
//                                       ListView.builder(
//                                         physics: BouncingScrollPhysics(),
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.vertical,
//                                         itemCount: sourceList.length,
//                                         itemBuilder: (context, index) {
//                                           return Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   if (selectedindex.contains(index)) {
//                                                     selectedindex.remove(index);
//                                                     if (projectIdList.contains(sourceList[index]["source_id"])) {
//                                                       projectIdList.remove(sourceList[index]["source_id"]);
//                                                     }
//                                                     print('remove $projectIdList');
//                                                   } else {
//                                                     print('utsav satani');
//                                                     print(projectIdList);
//
//                                                     selectedindex.add(index);
//                                                     projectIdList.add(sourceList[index]["source_id"]);
//                                                     print('projectIdList');
//                                                     print(projectIdList);
//                                                   }
//                                                   setState(() {
//                                                     showColor = true;
//                                                   });
//                                                 },
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.symmetric(horizontal: 30),
//                                                   child: Container(
//                                                     height: 60,
//                                                     width: MediaQuery.of(context).size.width,
//                                                     decoration: BoxDecoration(
//                                                         color: showColor == true
//                                                             ? selectedindex.contains(index)
//                                                             ? Color(0xffFF4F01)
//                                                             : Color(0xff30353d)
//                                                             : sourceList[index]['is_selected_me'] != 0
//                                                             ? Color(0xffFF4F01)
//                                                             : Color(0xff30353d),
//                                                         borderRadius: BorderRadius.circular(4)),
//                                                     child: Padding(
//                                                       padding: const EdgeInsets.all(8.0),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                         children: [
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 40),
//                                                             child: CachedImage(
//                                                               imageUrl: 'https://oneflixapp.com/oneflix/${sourceList[index]['images']}',
//                                                               height: 35,
//                                                               width: 60,
//                                                               fit: BoxFit.cover,
//                                                             ),
//                                                           ),
//                                                           AppText(
//                                                             sourceList[index]['names'],
//                                                             color: Colors.white,
//                                                             fontWeight: FontWeight.bold,
//                                                             fontSize: 16,
//                                                           ),
//                                                           Container(),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 height: 20,
//                                               ),
//                                             ],
//                                           );
//                                         },
//                                       ),
//                                       GestureDetector(
//                                         onTap: () async {
//                                           if (validate()) {
//                                             _addSouceData();
//                                             _getProviderName();
//                                             _getArriveStreamingData();
//                                             _getGenereData();
//                                             _getNewlyData();
//                                             _getTredingDiscussion();
//                                             await writeData('selected_list', projectIdList);
//                                             await writeData('color_list', selectedindex);
//                                             await writeData('selected', 1);
//                                           }
//                                         },
//                                         child: Container(
//                                           alignment: Alignment.center,
//                                           child: AppText('SAVE', color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, fontFamily: 'OpenSans'),
//                                           height: 50,
//                                           width: MediaQuery.of(context).size.width * 0.40,
//                                           decoration: BoxDecoration(color: Color(0xff22b069), borderRadius: BorderRadius.circular(8)),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 20,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     );
//                   },
//                   child: Container(
//                     height: 40,
//                     width: MediaQuery.of(context).size.width * 0.45,
//                     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(9)),
//                     alignment: Alignment.center,
//                     child: AppText(
//                       'CUSTOMIZE',
//                       fontSize: 16,
//                       color: Colors.black87,
//                       fontWeight: FontWeight.w700,
//                     ),
//                     // child: Padding(
//                     //   padding: const EdgeInsets.symmetric(horizontal: 15),
//                     //   child: Row(
//                     //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     //     children: [
//                     //       SwitchButton(
//                     //         bgColor: selectedButton == 1 ? true : false,
//                     //         textColor: selectedButton == 1 ? Colors.white : Colors.black,
//                     //         selectedButton: selectedButton,
//                     //         text: 'YOUR LOCATION',
//                     //         fontSize: 15,
//                     //         height: 45,
//                     //         onPressed: () {
//                     //           setState(() {
//                     //             selectedButton = 1;
//                     //             // _top10Trending(1);
//                     //           });
//                     //         },
//                     //       ),
//                     //       SwitchButton(
//                     //         bgColor: selectedButton == 2 ? true : false,
//                     //         textColor: selectedButton == 2 ? Colors.white : Colors.black,
//                     //         selectedButton: selectedButton,
//                     //         text: 'YOUR FRIENDS',
//                     //         fontSize: 15,
//                     //         height: 45,
//                     //         onPressed: () {
//                     //           setState(() {
//                     //             selectedButton = 2;
//                     //           });
//                     //         },
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 AppText(
//                   'Click on any logo below to go to its streaming page.',
//                   textAlign: TextAlign.center,
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ],
//             ),
//             preferredSize: Size.fromHeight(30.0),
//           ),
//         ),
//         body: Stack(
//           children: [
//             Offstage(
//               offstage: selectedButton != 1,
//               child: new TickerMode(
//                 enabled: selectedButton == 1,
//                 child: Column(
//                   children: [
//                     Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         Container(
//                           margin: EdgeInsets.symmetric(horizontal: 20),
//                           height: 100,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 child: ScrollablePositionedList.builder(
//                                   itemScrollController: itemScrollController,
//                                   itemPositionsListener: itemPositionsListener,
//                                   shrinkWrap: true,
//                                   scrollDirection: Axis.horizontal,
//                                   itemCount: image.length,
//                                   itemBuilder: (context, index1) {
//                                     return VisibilityDetector(
//                                       key: Key(index1.toString()),
//                                       onVisibilityChanged: (VisibilityInfo info) {
//                                         if (info.visibleFraction == 1)
//                                           setState(() {
//                                             _currentItem = index1;
//                                             print(_currentItem);
//                                             print('_currentItem');
//                                           });
//                                       },
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                         child: Stack(
//                                           children: [
//                                             GestureDetector(
//                                               onTap: () {
//                                                 Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                     builder: (context) => ProviderHubScreen(
//                                                       type: image[index1]['unique_id'],
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                   borderRadius: BorderRadius.circular(6),
//                                                 ),
//                                                 child: Image.asset(
//                                                   image[index1]['provider_name'] == 'Netflix'
//                                                       ? 'assets/TopTreding/Netflix (1).png'
//                                                       : image[index1]['provider_name'] == 'Disney'
//                                                       ? 'assets/TopTreding/Disney.png'
//                                                       : image[index1]['provider_name'] == 'Prime Video'
//                                                       ? 'assets/TopTreding/Amazon.png'
//                                                       : image[index1]['provider_name'] == 'HBO Max'
//                                                       ? 'assets/TopTreding/HBO.png'
//                                                       : image[index1]['provider_name'] == 'Hulu'
//                                                       ? 'assets/TopTreding/Hulu.png'
//                                                       : image[index1]['provider_name'] == 'Peacock'
//                                                       ? 'assets/TopTreding/Peacock.png'
//                                                       : image[index1]['provider_name'] == 'Paramount'
//                                                       ? 'assets/TopTreding/Paramount.png'
//                                                       : image[index1]['provider_name'] == 'AppleTV'
//                                                       ? 'assets/TopTreding/Apple TV.png'
//                                                       : image[index1]['provider_name'] == 'Tubi'
//                                                       ? 'assets/TopTreding/Tubi.png'
//                                                       : image[index1]['provider_name'] == 'Pluto'
//                                                       ? 'assets/TopTreding/Pluto.png'
//                                                       : image[index1]['provider_name'] == 'Starz'
//                                                       ? 'assets/TopTreding/Starz.png'
//                                                       : 'assets/TopTreding/Showtime.png',
//                                                   width: 80,
//                                                   height: 80,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         image.length <= 3
//                             ? Container()
//                             : Positioned(
//                           left: 5,
//                           child: GestureDetector(
//                             onTap: () {
//                               itemScrollController.scrollTo(index: 0, duration: Duration(seconds: 1));
//                             },
//                             child: Icon(
//                               Icons.arrow_back_ios,
//                               size: 28,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         image.length <= 3
//                             ? Container()
//                             : Positioned(
//                           right: 5,
//                           child: GestureDetector(
//                             onTap: () {
//                               if (_currentItem == 4 || _currentItem == 5 || _currentItem == 6) {
//                                 itemScrollController.scrollTo(index: 6, duration: Duration(seconds: 1));
//                               } else if (_currentItem == 7 || _currentItem == 8) {
//                                 itemScrollController.scrollTo(index: 8, duration: Duration(seconds: 1));
//                               } else {
//                                 itemScrollController.scrollTo(index: 3, duration: Duration(seconds: 1));
//                               }
//                             },
//                             child: Icon(
//                               Icons.arrow_forward_ios,
//                               size: 28,
//                               color: Colors.white,
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                     // Padding(
//                     //   padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
//                     //   child: TabBar(
//                     //     unselectedLabelColor: Colors.white,
//                     //     labelPadding: EdgeInsets.symmetric(horizontal: 3),
//                     //     indicatorColor: Colors.white,
//                     //     labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'OpenSans'),
//                     //     unselectedLabelStyle: TextStyle(color: Color(0xff959594), fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'OpenSans'),
//                     //     tabs: [
//                     //       Tab(child: Text('COUNTRY', style: TextStyle(fontWeight: FontWeight.bold))),
//                     //       Tab(child: Text('STATE', style: TextStyle(fontWeight: FontWeight.bold))),
//                     //       //Tab(child: Text('CITY', style: TextStyle(fontWeight: FontWeight.bold)))
//                     //     ],
//                     //     controller: _tabController,
//                     //     indicatorSize: TabBarIndicatorSize.tab,
//                     //   ),
//                     // ),
//                     top10data == null
//                         ? Container()
//                         : Expanded(
//                       child: ListView(
//                         shrinkWrap: true,
//                         children: [
//                           // locationPermission == true || region != null
//                           //     ? region != null
//                           //         ? Column(
//                           //             children: [
//                           //               RichText(
//                           //                 textAlign: TextAlign.center,
//                           //                 text: TextSpan(
//                           //                   text: 'What everyone in ',
//                           //                   style: TextStyle(
//                           //                     fontSize: 15,
//                           //                     fontFamily: 'OpenSans',
//                           //                     color: Colors.white,
//                           //                     fontWeight: FontWeight.bold,
//                           //                   ),
//                           //                   children: [
//                           //                     TextSpan(
//                           //                       text: region.toLowerCase() == 'us' || region.toLowerCase() == 'usa' || region.toLowerCase() == 'uk'
//                           //                           ? 'the $region'
//                           //                           : '$region',
//                           //                       style: TextStyle(
//                           //                         fontSize: 15,
//                           //                         color: kPrimaryColor,
//                           //                         fontFamily: 'OpenSans',
//                           //                         fontWeight: FontWeight.bold,
//                           //                       ),
//                           //                     ),
//                           //                     TextSpan(
//                           //                       text: ' is streaming right now. ',
//                           //                       style: TextStyle(
//                           //                         fontSize: 15,
//                           //                         color: Colors.white,
//                           //                         fontFamily: 'OpenSans',
//                           //                         fontWeight: FontWeight.bold,
//                           //                       ),
//                           //                     ),
//                           //                   ],
//                           //                 ),
//                           //               ),
//                           //               RichText(
//                           //                 textAlign: TextAlign.center,
//                           //                 text: TextSpan(
//                           //                   text: 'Live top 10 rankings ',
//                           //                   style: TextStyle(
//                           //                     fontSize: 15,
//                           //                     fontFamily: 'OpenSans',
//                           //                     color: Colors.white,
//                           //                     fontWeight: FontWeight.bold,
//                           //                   ),
//                           //                   children: [
//                           //                     WidgetSpan(
//                           //                         child: BlinkingPoint(
//                           //                       xCoor: 12,
//                           //                       yCoor: -16,
//                           //                       pointSize: 14,
//                           //                       pointColor: Color(0xffF5581F),
//                           //                     ))
//                           //                   ],
//                           //                 ),
//                           //               ),
//                           //             ],
//                           //           )
//                           //         : AppText(
//                           //             'What everyone in your country is streaming right now.',
//                           //             textAlign: TextAlign.center,
//                           //             fontSize: 15,
//                           //             fontWeight: FontWeight.bold,
//                           //           )
//                           //     : AppText(
//                           //         'What everyone in your country is streaming right now.',
//                           //         textAlign: TextAlign.center,
//                           //         fontSize: 15,
//                           //         fontWeight: FontWeight.bold,
//                           //       ),
//                           Padding(
//                             padding: EdgeInsets.only(left: 20),
//                             child: Row(
//                               children: [
//                                 AppText(
//                                   'Top 10 Trending',
//                                   textAlign: TextAlign.center,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 SizedBox(width: 3),
//                                 Padding(
//                                   padding: EdgeInsets.only(top: 17),
//                                   child: BlinkingPoint(
//                                     xCoor: 12,
//                                     yCoor: -16,
//                                     pointSize: 14,
//                                     pointColor: Color(0xffF5581F),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           top10Trending.length != 0
//                               ? CarouselSlider.builder(
//                             options: CarouselOptions(
//                               height: 350,
//                               viewportFraction: 1,
//                               // autoPlay: true,
//                               enableInfiniteScroll: false,
//                               scrollPhysics: BouncingScrollPhysics(),
//                             ),
//                             itemCount: top10Trending.length ~/ 2 + top10Trending.length % 2,
//                             itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
//                               return Container(
//                                 height: 270,
//                                 width: MediaQuery.of(context).size.width,
//                                 child: Row(
//                                   mainAxisAlignment: itemIndex * 2 + 1 >= top10Trending.length ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     Container(
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           print(top10Trending[(itemIndex * 2)]['content_third_party_id']);
//                                           print(top10Trending[(itemIndex * 2)]['content_id']);
//                                           print(streamingTrendingIDs[(itemIndex * 2)]);
//                                           print((itemIndex * 2));
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) => PostContentScreen(
//                                                 contentTPId: top10Trending[(itemIndex * 2)]['content_third_party_id'],
//                                                 contentID: top10Trending[(itemIndex * 2)]['content_id'],
//                                                 contentType: top10Trending[(itemIndex * 2)]['content_type'],
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                         child: SingleChildScrollView(
//                                           child: Column(
//                                             // shrinkWrap: true,
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             children: [
//                                               Image.asset('assets/icons/${((itemIndex * 2) + 1).toString()}.png', height: 50, width: 70),
//                                               SizedBox(height: 16),
//                                               Stack(
//                                                 alignment: Alignment.center,
//                                                 children: [
//                                                   Container(
//                                                     height: 260,
//                                                     width: MediaQuery.of(context).size.width * 0.43,
//                                                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white)),
//                                                     child: Column(
//                                                       children: [
//                                                         ClipRRect(
//                                                           borderRadius: BorderRadius.circular(6),
//                                                           child: CachedImage(
//                                                             imageUrl: 'https://image.tmdb.org/t/p/original/${top10Trending[itemIndex * 2]['content_photo']}',
//                                                             height: 258,
//                                                             width: MediaQuery.of(context).size.width * 0.43,
//                                                             fit: BoxFit.cover,
//                                                           ),
//                                                         ),
//                                                         Spacer(),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   streamingTrendingIDs[itemIndex * 2] == 203 ||
//                                                       streamingTrendingIDs[itemIndex * 2] == 26 ||
//                                                       streamingTrendingIDs[itemIndex * 2] == 372 ||
//                                                       streamingTrendingIDs[itemIndex * 2] == 157 ||
//                                                       streamingTrendingIDs[itemIndex * 2] == 387 ||
//                                                       streamingTrendingIDs[itemIndex * 2] == 444 ||
//                                                       streamingTrendingIDs[itemIndex * 2] == 388 ||
//                                                       streamingTrendingIDs[itemIndex * 2] == 389 ||
//                                                       streamingTrendingIDs[itemIndex * 2] == 371 ||
//                                                       streamingTrendingIDs[itemIndex * 2] == 445 ||
//                                                       streamingTrendingIDs[itemIndex * 2] == 248 ||
//                                                       streamingTrendingIDs[itemIndex * 2] == 232 ||
//                                                       streamingTrendingIDs[itemIndex * 2] == 296 ||
//                                                       streamingTrendingIDs[itemIndex * 2] == 391
//                                                       ? Positioned(
//                                                     top: 10,
//                                                     left: 10,
//                                                     child: Image.asset(
//                                                       '$TRENDING_URL/${streamingTrendingIDs[itemIndex * 2] == 203 ? 'NetflixNew' : streamingTrendingIDs[itemIndex * 2] == 26 ? 'AmazonPrime' : streamingTrendingIDs[itemIndex * 2] == 372 ? 'Disney' : streamingTrendingIDs[itemIndex * 2] == 157 ? 'Hulu' : streamingTrendingIDs[itemIndex * 2] == 387 ? 'HBOMax' : streamingTrendingIDs[itemIndex * 2] == 444 ? 'Paramount' : streamingTrendingIDs[itemIndex * 2] == 388 || streamingTrendingIDs[itemIndex * 2] == 389 ? 'Peacock' : streamingTrendingIDs[itemIndex * 2] == 371 ? 'AppleTV' : streamingTrendingIDs[itemIndex * 2] == 445 ? 'DiscoveryPlus' : streamingTrendingIDs[itemIndex * 2] == 248 ? 'Showtime' : streamingTrendingIDs[itemIndex * 2] == 232 ? 'Starz' : streamingTrendingIDs[itemIndex * 2] == 296 ? 'Tubi' : streamingTrendingIDs[itemIndex * 2] == 391 ? 'Pluto' : ' '}.png',
//                                                       height: 40,
//                                                     ),
//                                                   )
//                                                       : Positioned(top: 10, left: 10, child: Container()),
//                                                   top10Trending[itemIndex * 2]['comment_count_top'] == 0
//                                                       ? Container()
//                                                       : Positioned(
//                                                       bottom: 15,
//                                                       left: 10,
//                                                       right: 10,
//                                                       child: Container(
//                                                         height: 40,
//                                                         width: MediaQuery.of(context).size.width * 0.40,
//                                                         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                                                         child: Row(
//                                                           mainAxisAlignment: MainAxisAlignment.center,
//                                                           children: [
//                                                             AppText(
//                                                               '${top10Trending[itemIndex * 2]['comment_count_top']} Comments ',
//                                                               fontSize: 16,
//                                                               color: Colors.black,
//                                                               fontWeight: FontWeight.bold,
//                                                             ),
//                                                             Padding(
//                                                               padding: EdgeInsets.only(top: 5),
//                                                               child: Image.asset(
//                                                                 'assets/icons/Comment Icon - Grey.png',
//                                                                 height: 16,
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ) /*Container(
//                                                                   decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(42)),
//                                                                   child: CircularPercentIndicator(
//                                                                     radius: 42.0,
//                                                                     lineWidth: 2.0,
//                                                                     percent: double.tryParse(top10Trending[(itemIndex * 2)]['vote_average'])! / 10,
//                                                                     center: AppText(
//                                                                       (double.tryParse(top10Trending[(itemIndex * 2)]['vote_average'])! * 10).toInt().toString() + "%",
//                                                                       color: Colors.white,
//                                                                       fontWeight: FontWeight.w900,
//                                                                       fontSize: 12,
//                                                                     ),
//                                                                     progressColor: Colors.greenAccent,
//                                                                     backgroundColor: Colors.black,
//                                                                     circularStrokeCap: CircularStrokeCap.round,
//                                                                   ),
//                                                                 ),*/
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     itemIndex * 2 + 1 >= top10Trending.length
//                                         ? Container()
//                                         : Container(
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           print(top10Trending[(itemIndex * 2) + 1]['content_third_party_id']);
//                                           print(top10Trending[(itemIndex * 2) + 1]['content_id']);
//                                           print(streamingTrendingIDs[(itemIndex * 2) + 1]);
//                                           print((itemIndex * 2) + 1);
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) => PostContentScreen(
//                                                 contentTPId: top10Trending[(itemIndex * 2) + 1]['content_third_party_id'],
//                                                 contentID: top10Trending[(itemIndex * 2) + 1]['content_id'],
//                                                 contentType: top10Trending[(itemIndex * 2)]['content_type'],
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                         child: SingleChildScrollView(
//                                           child: Column(
//                                             // shrinkWrap: true,
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             children: [
//                                               Image.asset('assets/icons/${((itemIndex * 2) + 2).toString()}.png', height: 50, width: 70),
//                                               SizedBox(height: 16),
//                                               Stack(
//                                                 alignment: Alignment.center,
//                                                 children: [
//                                                   Container(
//                                                     height: 260,
//                                                     width: MediaQuery.of(context).size.width * 0.43,
//                                                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white)),
//                                                     child: Column(
//                                                       children: [
//                                                         ClipRRect(
//                                                           borderRadius: BorderRadius.circular(6),
//                                                           child: CachedImage(
//                                                             imageUrl:
//                                                             'https://image.tmdb.org/t/p/original/${top10Trending[(itemIndex * 2) + 1]['content_photo']}',
//                                                             height: 258,
//                                                             width: MediaQuery.of(context).size.width * 0.43,
//                                                             fit: BoxFit.cover,
//                                                           ),
//                                                         ),
//                                                         Spacer(),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   streamingTrendingIDs[(itemIndex * 2) + 1] == 203 ||
//                                                       streamingTrendingIDs[(itemIndex * 2) + 1] == 26 ||
//                                                       streamingTrendingIDs[(itemIndex * 2) + 1] == 372 ||
//                                                       streamingTrendingIDs[(itemIndex * 2) + 1] == 157 ||
//                                                       streamingTrendingIDs[(itemIndex * 2) + 1] == 387 ||
//                                                       streamingTrendingIDs[(itemIndex * 2) + 1] == 444 ||
//                                                       streamingTrendingIDs[(itemIndex * 2) + 1] == 388 ||
//                                                       streamingTrendingIDs[(itemIndex * 2) + 1] == 389 ||
//                                                       streamingTrendingIDs[(itemIndex * 2) + 1] == 371 ||
//                                                       streamingTrendingIDs[(itemIndex * 2) + 1] == 445 ||
//                                                       streamingTrendingIDs[(itemIndex * 2) + 1] == 248 ||
//                                                       streamingTrendingIDs[(itemIndex * 2) + 1] == 232 ||
//                                                       streamingTrendingIDs[(itemIndex * 2) + 1] == 296 ||
//                                                       streamingTrendingIDs[(itemIndex * 2) + 1] == 391
//                                                       ? Positioned(
//                                                     top: 10,
//                                                     left: 10,
//                                                     child: Image.asset(
//                                                       '$TRENDING_URL/${streamingTrendingIDs[(itemIndex * 2) + 1] == 203 ? 'NetflixNew' : streamingTrendingIDs[(itemIndex * 2) + 1] == 26 ? 'AmazonPrime' : streamingTrendingIDs[(itemIndex * 2) + 1] == 372 ? 'Disney' : streamingTrendingIDs[(itemIndex * 2) + 1] == 157 ? 'Hulu' : streamingTrendingIDs[(itemIndex * 2) + 1] == 387 ? 'HBOMax' : streamingTrendingIDs[(itemIndex * 2) + 1] == 444 ? 'Paramount' : streamingTrendingIDs[(itemIndex * 2) + 1] == 388 || streamingTrendingIDs[(itemIndex * 2) + 1] == 389 ? 'Peacock' : streamingTrendingIDs[(itemIndex * 2) + 1] == 371 ? 'AppleTV' : streamingTrendingIDs[(itemIndex * 2) + 1] == 445 ? 'DiscoveryPlus' : streamingTrendingIDs[(itemIndex * 2) + 1] == 248 ? 'Showtime' : streamingTrendingIDs[(itemIndex * 2) + 1] == 232 ? 'Starz' : streamingTrendingIDs[(itemIndex * 2) + 1] == 296 ? 'Tubi' : streamingTrendingIDs[(itemIndex * 2) + 1] == 391 ? 'Pluto' : ' '}.png',
//                                                       height: 40,
//                                                     ),
//                                                   )
//                                                       : Positioned(top: 10, left: 10, child: Container()),
//                                                   top10Trending[(itemIndex * 2) + 1]['comment_count_top'] == 0
//                                                       ? Container()
//                                                       : Positioned(
//                                                       bottom: 15,
//                                                       left: 10,
//                                                       right: 10,
//                                                       child: Container(
//                                                         height: 40,
//                                                         width: MediaQuery.of(context).size.width * 0.40,
//                                                         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                                                         child: Row(
//                                                           mainAxisAlignment: MainAxisAlignment.center,
//                                                           children: [
//                                                             AppText(
//                                                               '${top10Trending[(itemIndex * 2) + 1]['comment_count_top']} Comments ',
//                                                               fontSize: 16,
//                                                               color: Colors.black,
//                                                               fontWeight: FontWeight.bold,
//                                                             ),
//                                                             Padding(
//                                                               padding: EdgeInsets.only(top: 5),
//                                                               child: Image.asset(
//                                                                 'assets/icons/Comment Icon - Grey.png',
//                                                                 height: 16,
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ) /*Container(
//                                                                   decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(42)),
//                                                                   child: CircularPercentIndicator(
//                                                                     radius: 42.0,
//                                                                     lineWidth: 2.0,
//                                                                     percent: double.tryParse(top10Trending[(itemIndex * 2)]['vote_average'])! / 10,
//                                                                     center: AppText(
//                                                                       (double.tryParse(top10Trending[(itemIndex * 2)]['vote_average'])! * 10).toInt().toString() + "%",
//                                                                       color: Colors.white,
//                                                                       fontWeight: FontWeight.w900,
//                                                                       fontSize: 12,
//                                                                     ),
//                                                                     progressColor: Colors.greenAccent,
//                                                                     backgroundColor: Colors.black,
//                                                                     circularStrokeCap: CircularStrokeCap.round,
//                                                                   ),
//                                                                 ),*/
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           )
//                               : Container(),
//                           // : locationPermission == true
//                           //     ? NoEnoughDataWarning()
//                           //     : Column(
//                           //         children: [
//                           //           SizedBox(height: 30),
//                           //           AlertBox(
//                           //             buttonText: 'ENABLE LOCATION',
//                           //             description: 'Oneflix needs your location in order to function. Click here to go to your phone settings and enable location.',
//                           //             onTap: () async {
//                           //               await requestLocationPermission();
//                           //               if (locationPermission == false) {
//                           //                 openAppSettings();
//                           //               }
//                           //             },
//                           //             child: Padding(
//                           //               padding: const EdgeInsets.only(bottom: 16.0),
//                           //               child: Image.asset('$ICON_URL/map.png', width: 150, height: 124),
//                           //             ),
//                           //           ),
//                           //         ],
//                           //       ),
//                           SizedBox(height: 15),
//                           getArriveData.length == 0
//                               ? Container()
//                               : Padding(
//                             padding: const EdgeInsets.only(top: 25),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 20),
//                               height: 220,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppText(
//                                     'Arrived On Streaming This Week',
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "OpenSans",
//                                   ),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: getArriveData.length,
//                                       itemBuilder: (context, index1) {
//                                         return getArriveData[index1]['watch_mode_json'] == null || getArriveData[index1]['watch_mode_json'] == 'null'
//                                             ? Container()
//                                             : Padding(
//                                           padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                           child: Stack(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => PostContentScreen(
//                                                         contentTPId: getArriveData[index1]['content_third_party_id'],
//                                                         contentID: getArriveData[index1]['content_id'],
//                                                         contentType: getArriveData[index1]['content_type'],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(6),
//                                                   ),
//                                                   child: CachedImage(
//                                                     imageUrl: 'https://image.tmdb.org/t/p/original/${getArriveData[index1]['content_photo']}',
//                                                     width: MediaQuery.of(context).size.width * 0.27,
//                                                     height: 170,
//                                                     radius: 6,
//                                                     colors: Colors.white,
//                                                     thikness: 0.5,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 7,
//                                                 left: 7,
//                                                 child: Image.asset(
//                                                   '$TRENDING_URL/${getArriveData[index1]['source_id'] == '203' ? 'NetflixNew' : getArriveData[index1]['source_id'] == '26' ? 'AmazonPrime' : getArriveData[index1]['source_id'] == '372' ? 'Disney' : getArriveData[index1]['source_id'] == '157' ? 'Hulu' : getArriveData[index1]['source_id'] == '387' ? 'HBOMax' : getArriveData[index1]['source_id'] == '444' ? 'Paramount' : getArriveData[index1]['source_id'] == '388' || getArriveData[index1]['source_id'] == '389' ? 'Peacock' : getArriveData[index1]['source_id'] == '371' ? 'AppleTV' : getArriveData[index1]['source_id'] == '445' ? 'DiscoveryPlus' : getArriveData[index1]['source_id'] == '248' ? 'Showtime' : getArriveData[index1]['source_id'] == '232' ? 'Starz' : getArriveData[index1]['source_id'] == '296' ? 'Tubi' : getArriveData[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
//                                                   height: 25,
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           tredingDiscussion.length == 0
//                               ? Container()
//                               : Padding(
//                             padding: const EdgeInsets.only(top: 25),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 20),
//                               height: 290,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppText(
//                                     'Trending Discussions',
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "OpenSans",
//                                   ),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: tredingDiscussion.length,
//                                       itemBuilder: (context, index1) {
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                           child: Stack(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => PostContentScreen(
//                                                         contentTPId: tredingDiscussion[index1]['content_third_party_id'],
//                                                         contentID: tredingDiscussion[index1]['content_id'],
//                                                         contentType: tredingDiscussion[index1]['content_type'],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(6),
//                                                   ),
//                                                   child: CachedImage(
//                                                     imageUrl: 'https://image.tmdb.org/t/p/original/${tredingDiscussion[index1]['content_photo']}',
//                                                     width: MediaQuery.of(context).size.width * 0.42,
//                                                     height: 250,
//                                                     radius: 6,
//                                                     colors: Colors.white,
//                                                     thikness: 0.5,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 7,
//                                                 left: 7,
//                                                 child: Image.asset(
//                                                   '$TRENDING_URL/${tredingDiscussion[index1]['source_id'] == '203' ? 'NetflixNew' : tredingDiscussion[index1]['source_id'] == '26' ? 'AmazonPrime' : tredingDiscussion[index1]['source_id'] == '372' ? 'Disney' : tredingDiscussion[index1]['source_id'] == '157' ? 'Hulu' : tredingDiscussion[index1]['source_id'] == '387' ? 'HBOMax' : tredingDiscussion[index1]['source_id'] == '444' ? 'Paramount' : tredingDiscussion[index1]['source_id'] == '388' || tredingDiscussion[index1]['source_id'] == '389' ? 'Peacock' : tredingDiscussion[index1]['source_id'] == '371' ? 'AppleTV' : tredingDiscussion[index1]['source_id'] == '445' ? 'DiscoveryPlus' : tredingDiscussion[index1]['source_id'] == '248' ? 'Showtime' : tredingDiscussion[index1]['source_id'] == '232' ? 'Starz' : tredingDiscussion[index1]['source_id'] == '296' ? 'Tubi' : tredingDiscussion[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
//                                                   height: 25,
//                                                 ),
//                                               ),
//                                               tredingDiscussion[index1]['comment_count_top'] == '0'
//                                                   ? Container()
//                                                   : Positioned(
//                                                   bottom: 15,
//                                                   left: 10,
//                                                   right: 10,
//                                                   child: Container(
//                                                     height: 40,
//                                                     width: MediaQuery.of(context).size.width * 0.40,
//                                                     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                                                     child: Row(
//                                                       mainAxisAlignment: MainAxisAlignment.center,
//                                                       children: [
//                                                         AppText(
//                                                           '${tredingDiscussion[index1]['comment_count_top']} Comments ',
//                                                           fontSize: 16,
//                                                           color: Colors.black,
//                                                           fontWeight: FontWeight.bold,
//                                                         ),
//                                                         Padding(
//                                                           padding: EdgeInsets.only(top: 5),
//                                                           child: Image.asset(
//                                                             'assets/icons/Comment Icon - Grey.png',
//                                                             height: 16,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   )),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           yourWatchList.length == 0
//                               ? Container()
//                               : Padding(
//                             padding: const EdgeInsets.only(top: 25),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 20),
//                               height: 220,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppText(
//                                     'Your Watchlist',
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "OpenSans",
//                                   ),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: yourWatchList.length,
//                                       itemBuilder: (context, index1) {
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                           child: Stack(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => PlatformContent(
//                                                         id: yourWatchList[index1]['content_third_party_id'],
//                                                         // contentID: yourWatchList[index1]['content_id'],
//                                                         contentType: yourWatchList[index1]['watch_type'],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(6),
//                                                   ),
//                                                   child: CachedImage(
//                                                     imageUrl: 'https://image.tmdb.org/t/p/original/${yourWatchList[index1]['poster_path']}',
//                                                     width: MediaQuery.of(context).size.width * 0.27,
//                                                     height: 170,
//                                                     radius: 6,
//                                                     colors: Colors.white,
//                                                     thikness: 0.5,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 7,
//                                                 left: 7,
//                                                 child: Image.asset(
//                                                   '$TRENDING_URL/${yourWatchList[index1]['source_id'] == '203' ? 'NetflixNew' : yourWatchList[index1]['source_id'] == '26' ? 'AmazonPrime' : yourWatchList[index1]['source_id'] == '372' ? 'Disney' : yourWatchList[index1]['source_id'] == '157' ? 'Hulu' : yourWatchList[index1]['source_id'] == '387' ? 'HBOMax' : yourWatchList[index1]['source_id'] == '444' ? 'Paramount' : yourWatchList[index1]['source_id'] == '388' || yourWatchList[index1]['source_id'] == '389' ? 'Peacock' : yourWatchList[index1]['source_id'] == '371' ? 'AppleTV' : yourWatchList[index1]['source_id'] == '445' ? 'DiscoveryPlus' : yourWatchList[index1]['source_id'] == '248' ? 'Showtime' : yourWatchList[index1]['source_id'] == '232' ? 'Starz' : yourWatchList[index1]['source_id'] == '296' ? 'Tubi' : yourWatchList[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
//                                                   height: 25,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           biggestEvent.length != 0
//                               ? SizedBox(
//                             height: 25,
//                           )
//                               : Container(),
//                           biggestEvent.length != 0
//                               ? Padding(
//                             padding: EdgeInsets.only(left: 20),
//                             child: Row(
//                               children: [
//                                 AppText(
//                                   'Biggest Events This Week',
//                                   textAlign: TextAlign.center,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ],
//                             ),
//                           )
//                               : Container(),
//                           biggestEvent.length != 0
//                               ? Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               CarouselSlider.builder(
//                                 carouselController: controller,
//                                 options: CarouselOptions(
//                                   height: 365,
//                                   viewportFraction: 1,
//                                   // autoPlay: true,
//                                   enableInfiniteScroll: false,
//                                   scrollPhysics: BouncingScrollPhysics(),
//                                 ),
//                                 itemCount: biggestEvent.length,
//                                 itemBuilder: (BuildContext context, int index1, int pageViewIndex) {
//                                   return VisibilityDetector(
//                                     key: Key(index1.toString()),
//                                     onVisibilityChanged: (VisibilityInfo info) {
//                                       setState(() {
//                                         print(biggestEvent.length);
//                                         print('biggestEvent.length');
//                                         _currentItem1 = index1;
//                                         print(_currentItem1);
//                                         print('_currentItem');
//                                       });
//                                     },
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
//                                       child: Stack(
//                                         alignment: Alignment.center,
//                                         children: [
//                                           GestureDetector(
//                                             onTap: () {
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) => PostContentScreen(
//                                                     contentTPId: biggestEvent[index1]['content_third_party_id'],
//                                                     contentID: '0',
//                                                     contentType: biggestEvent[index1]['content_type'],
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                             child: Column(
//                                               children: [
//                                                 Container(
//                                                   child: CachedImage1(
//                                                     imageUrl: 'https://oneflixapp.com/oneflix/${biggestEvent[index1]['content_cover_image']}',
//                                                     width: MediaQuery.of(context).size.width,
//                                                     height: 250,
//                                                     // colors: Colors.white,
//                                                     thikness: 0.5,
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
//                                                       color: Colors.white),
//                                                   width: MediaQuery.of(context).size.width,
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
//                                                     child: AppText(
//                                                       biggestEvent[index1]['content_discription'],
//                                                       fontSize: 14,
//                                                       maxLines: 4,
//                                                       fontWeight: FontWeight.bold,
//                                                       color: Color(0xff4B4949),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           Positioned(
//                                             top: 0,
//                                             left: 15,
//                                             child: Image.asset(
//                                               '$TRENDING_URL/${biggestEvent[index1]['category_title'] == 'Netflix' ? 'NetflixNew' : biggestEvent[index1]['category_title'] == 'Amazon' ? 'AmazonPrime' : biggestEvent[index1]['category_title'] == 'Disney' ? 'Disney' : biggestEvent[index1]['category_title'] == 'Hulu' ? 'Hulu' : biggestEvent[index1]['category_title'] == 'HBO Max' ? 'HBOMax' : biggestEvent[index1]['category_title'] == 'Paramount' ? 'Paramount' : biggestEvent[index1]['category_title'] == 'Peacock' ? 'Peacock' : biggestEvent[index1]['category_title'] == 'Apple TV' ? 'AppleTV' : 'AppleTV'}.png',
//                                               height: 70,
//                                               width: 70,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                               Positioned(
//                                 left: 5,
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     if (_currentItem1 != 0) {
//                                       previous();
//                                     }
//                                   },
//                                   child: Icon(
//                                     Icons.arrow_back_ios,
//                                     size: 28,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 right: 0,
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     if (_currentItem1 != biggestEvent.length - 1) {
//                                       next();
//                                     }
//                                   },
//                                   child: Icon(
//                                     Icons.arrow_forward_ios,
//                                     size: 28,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           )
//                               : Container(),
//                           if (projectIdList.length == 0)
//                             newNetflix.length == 0
//                                 ? Container()
//                                 : Padding(
//                               padding: const EdgeInsets.only(top: 25),
//                               child: Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 height: 290,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     AppText(
//                                       'New On Netflix',
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: "OpenSans",
//                                     ),
//                                     Expanded(
//                                       child: ListView.builder(
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: newNetflix.length,
//                                         itemBuilder: (context, index1) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                             child: Stack(
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) => PostContentScreen(
//                                                           contentTPId: newNetflix[index1]['content_third_party_id'],
//                                                           contentID: newNetflix[index1]['content_id'],
//                                                           contentType: newNetflix[index1]['content_type'],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(6),
//                                                     ),
//                                                     child: CachedImage(
//                                                       imageUrl: 'https://image.tmdb.org/t/p/original/${newNetflix[index1]['content_photo']}',
//                                                       width: MediaQuery.of(context).size.width * 0.42,
//                                                       height: 250,
//                                                       radius: 6,
//                                                       colors: Colors.white,
//                                                       thikness: 0.5,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Positioned(
//                                                   top: 7,
//                                                   left: 7,
//                                                   child: Image.asset(
//                                                     '$TRENDING_URL/${'NetflixNew'}.png',
//                                                     height: 27,
//                                                   ),
//                                                 ),
//                                                 newNetflix[index1]['comment_count_top'] == 0
//                                                     ? Container()
//                                                     : Positioned(
//                                                     bottom: 15,
//                                                     left: 10,
//                                                     right: 10,
//                                                     child: Container(
//                                                       height: 40,
//                                                       width: MediaQuery.of(context).size.width * 0.40,
//                                                       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         children: [
//                                                           AppText(
//                                                             '${newNetflix[index1]['comment_count_top']} Comments ',
//                                                             fontSize: 16,
//                                                             color: Colors.black,
//                                                             fontWeight: FontWeight.bold,
//                                                           ),
//                                                           Padding(
//                                                             padding: EdgeInsets.only(top: 5),
//                                                             child: Image.asset(
//                                                               'assets/icons/Comment Icon - Grey.png',
//                                                               height: 16,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           for (int i = 0; i < projectIdList.length; i++)
//                             newNetflix.length == 0 || projectIdList[i] != 203
//                                 ? Container()
//                                 : Padding(
//                               padding: const EdgeInsets.only(top: 25),
//                               child: Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 height: 290,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     AppText(
//                                       'New On Netflix',
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: "OpenSans",
//                                     ),
//                                     Expanded(
//                                       child: ListView.builder(
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: newNetflix.length,
//                                         itemBuilder: (context, index1) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                             child: Stack(
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) => PostContentScreen(
//                                                           contentTPId: newNetflix[index1]['content_third_party_id'],
//                                                           contentID: newNetflix[index1]['content_id'],
//                                                           contentType: newNetflix[index1]['content_type'],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(6),
//                                                     ),
//                                                     child: CachedImage(
//                                                       imageUrl: 'https://image.tmdb.org/t/p/original/${newNetflix[index1]['content_photo']}',
//                                                       width: MediaQuery.of(context).size.width * 0.42,
//                                                       height: 250,
//                                                       radius: 6,
//                                                       colors: Colors.white,
//                                                       thikness: 0.5,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Positioned(
//                                                   top: 7,
//                                                   left: 7,
//                                                   child: Image.asset(
//                                                     '$TRENDING_URL/${'NetflixNew'}.png',
//                                                     height: 27,
//                                                   ),
//                                                 ),
//                                                 newNetflix[index1]['comment_count_top'] == 0
//                                                     ? Container()
//                                                     : Positioned(
//                                                     bottom: 15,
//                                                     left: 10,
//                                                     right: 10,
//                                                     child: Container(
//                                                       height: 40,
//                                                       width: MediaQuery.of(context).size.width * 0.40,
//                                                       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         children: [
//                                                           AppText(
//                                                             '${newNetflix[index1]['comment_count_top']} Comments ',
//                                                             fontSize: 16,
//                                                             color: Colors.black,
//                                                             fontWeight: FontWeight.bold,
//                                                           ),
//                                                           Padding(
//                                                             padding: EdgeInsets.only(top: 5),
//                                                             child: Image.asset(
//                                                               'assets/icons/Comment Icon - Grey.png',
//                                                               height: 16,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           if (projectIdList.length == 0)
//                             newAmezon.length == 0
//                                 ? Container()
//                                 : Padding(
//                               padding: const EdgeInsets.only(top: 25),
//                               child: Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 height: 290,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     AppText(
//                                       'New On Amazon',
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: "OpenSans",
//                                     ),
//                                     Expanded(
//                                       child: ListView.builder(
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: newAmezon.length,
//                                         itemBuilder: (context, index1) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                             child: Stack(
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) => PostContentScreen(
//                                                           contentTPId: newAmezon[index1]['content_third_party_id'],
//                                                           contentID: newAmezon[index1]['content_id'],
//                                                           contentType: newAmezon[index1]['content_type'],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(6),
//                                                     ),
//                                                     child: CachedImage(
//                                                       imageUrl: 'https://image.tmdb.org/t/p/original/${newAmezon[index1]['content_photo']}',
//                                                       width: MediaQuery.of(context).size.width * 0.42,
//                                                       height: 250,
//                                                       radius: 6,
//                                                       colors: Colors.white,
//                                                       thikness: 0.5,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Positioned(
//                                                   top: 7,
//                                                   left: 7,
//                                                   child: Image.asset(
//                                                     '$TRENDING_URL/${'AmazonPrime'}.png',
//                                                     height: 27,
//                                                   ),
//                                                 ),
//                                                 newAmezon[index1]['comment_count_top'] == 0
//                                                     ? Container()
//                                                     : Positioned(
//                                                     bottom: 15,
//                                                     left: 10,
//                                                     right: 10,
//                                                     child: Container(
//                                                       height: 40,
//                                                       width: MediaQuery.of(context).size.width * 0.40,
//                                                       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         children: [
//                                                           AppText(
//                                                             '${newAmezon[index1]['comment_count_top']} Comments ',
//                                                             fontSize: 16,
//                                                             color: Colors.black,
//                                                             fontWeight: FontWeight.bold,
//                                                           ),
//                                                           Padding(
//                                                             padding: EdgeInsets.only(top: 5),
//                                                             child: Image.asset(
//                                                               'assets/icons/Comment Icon - Grey.png',
//                                                               height: 16,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           for (int i = 0; i < projectIdList.length; i++)
//                             newAmezon.length == 0 || projectIdList[i] != 26
//                                 ? Container()
//                                 : Padding(
//                               padding: const EdgeInsets.only(top: 25),
//                               child: Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 height: 290,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     AppText(
//                                       'New On Amazon',
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: "OpenSans",
//                                     ),
//                                     Expanded(
//                                       child: ListView.builder(
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: newAmezon.length,
//                                         itemBuilder: (context, index1) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                             child: Stack(
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) => PostContentScreen(
//                                                           contentTPId: newAmezon[index1]['content_third_party_id'],
//                                                           contentID: newAmezon[index1]['content_id'],
//                                                           contentType: newAmezon[index1]['content_type'],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(6),
//                                                     ),
//                                                     child: CachedImage(
//                                                       imageUrl: 'https://image.tmdb.org/t/p/original/${newAmezon[index1]['content_photo']}',
//                                                       width: MediaQuery.of(context).size.width * 0.42,
//                                                       height: 250,
//                                                       radius: 6,
//                                                       colors: Colors.white,
//                                                       thikness: 0.5,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Positioned(
//                                                   top: 7,
//                                                   left: 7,
//                                                   child: Image.asset(
//                                                     '$TRENDING_URL/${'AmazonPrime'}.png',
//                                                     height: 27,
//                                                   ),
//                                                 ),
//                                                 newAmezon[index1]['comment_count_top'] == 0
//                                                     ? Container()
//                                                     : Positioned(
//                                                     bottom: 15,
//                                                     left: 10,
//                                                     right: 10,
//                                                     child: Container(
//                                                       height: 40,
//                                                       width: MediaQuery.of(context).size.width * 0.40,
//                                                       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         children: [
//                                                           AppText(
//                                                             '${newAmezon[index1]['comment_count_top']} Comments ',
//                                                             fontSize: 16,
//                                                             color: Colors.black,
//                                                             fontWeight: FontWeight.bold,
//                                                           ),
//                                                           Padding(
//                                                             padding: EdgeInsets.only(top: 5),
//                                                             child: Image.asset(
//                                                               'assets/icons/Comment Icon - Grey.png',
//                                                               height: 16,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           for (int i = 0; i < projectIdList.length; i++)
//                             newDisney.length == 0 || projectIdList[i] != 372
//                                 ? Container()
//                                 : Padding(
//                               padding: const EdgeInsets.only(top: 25),
//                               child: Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 height: 290,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     AppText(
//                                       'New On Disney',
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: "OpenSans",
//                                     ),
//                                     Expanded(
//                                       child: ListView.builder(
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: newDisney.length,
//                                         itemBuilder: (context, index1) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                             child: Stack(
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) => PostContentScreen(
//                                                           contentTPId: newDisney[index1]['content_third_party_id'],
//                                                           contentID: newDisney[index1]['content_id'],
//                                                           contentType: newDisney[index1]['content_type'],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(6),
//                                                     ),
//                                                     child: CachedImage(
//                                                       imageUrl: 'https://image.tmdb.org/t/p/original/${newDisney[index1]['content_photo']}',
//                                                       width: MediaQuery.of(context).size.width * 0.42,
//                                                       height: 250,
//                                                       radius: 6,
//                                                       colors: Colors.white,
//                                                       thikness: 0.5,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Positioned(
//                                                   top: 7,
//                                                   left: 7,
//                                                   child: Image.asset(
//                                                     '$TRENDING_URL/${'Disney'}.png',
//                                                     height: 27,
//                                                   ),
//                                                 ),
//                                                 newDisney[index1]['comment_count_top'] == 0
//                                                     ? Container()
//                                                     : Positioned(
//                                                     bottom: 15,
//                                                     left: 10,
//                                                     right: 10,
//                                                     child: Container(
//                                                       height: 40,
//                                                       width: MediaQuery.of(context).size.width * 0.40,
//                                                       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         children: [
//                                                           AppText(
//                                                             '${newDisney[index1]['comment_count_top']} Comments ',
//                                                             fontSize: 16,
//                                                             color: Colors.black,
//                                                             fontWeight: FontWeight.bold,
//                                                           ),
//                                                           Padding(
//                                                             padding: EdgeInsets.only(top: 5),
//                                                             child: Image.asset(
//                                                               'assets/icons/Comment Icon - Grey.png',
//                                                               height: 16,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           if (projectIdList.length == 0)
//                             newHBO.length == 0
//                                 ? Container()
//                                 : Padding(
//                               padding: const EdgeInsets.only(top: 25),
//                               child: Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 height: 290,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     AppText(
//                                       'New On HBO Max',
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: "OpenSans",
//                                     ),
//                                     Expanded(
//                                       child: ListView.builder(
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: newHBO.length,
//                                         itemBuilder: (context, index1) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                             child: Stack(
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) => PostContentScreen(
//                                                           contentTPId: newHBO[index1]['content_third_party_id'],
//                                                           contentID: newHBO[index1]['content_id'],
//                                                           contentType: newHBO[index1]['content_type'],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(6),
//                                                     ),
//                                                     child: CachedImage(
//                                                       imageUrl: 'https://image.tmdb.org/t/p/original/${newHBO[index1]['content_photo']}',
//                                                       width: MediaQuery.of(context).size.width * 0.42,
//                                                       height: 250,
//                                                       radius: 6,
//                                                       colors: Colors.white,
//                                                       thikness: 0.5,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Positioned(
//                                                   top: 7,
//                                                   left: 7,
//                                                   child: Image.asset(
//                                                     '$TRENDING_URL/${'HBOMax'}.png',
//                                                     height: 27,
//                                                   ),
//                                                 ),
//                                                 newHBO[index1]['comment_count_top'] == 0
//                                                     ? Container()
//                                                     : Positioned(
//                                                     bottom: 15,
//                                                     left: 10,
//                                                     right: 10,
//                                                     child: Container(
//                                                       height: 40,
//                                                       width: MediaQuery.of(context).size.width * 0.40,
//                                                       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         children: [
//                                                           AppText(
//                                                             '${newHBO[index1]['comment_count_top']} Comments ',
//                                                             fontSize: 16,
//                                                             color: Colors.black,
//                                                             fontWeight: FontWeight.bold,
//                                                           ),
//                                                           Padding(
//                                                             padding: EdgeInsets.only(top: 5),
//                                                             child: Image.asset(
//                                                               'assets/icons/Comment Icon - Grey.png',
//                                                               height: 16,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           for (int i = 0; i < projectIdList.length; i++)
//                             newHBO.length == 0 || projectIdList[i] != 387
//                                 ? Container()
//                                 : Padding(
//                               padding: const EdgeInsets.only(top: 25),
//                               child: Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 height: 290,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     AppText(
//                                       'New On HBO Max',
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: "OpenSans",
//                                     ),
//                                     Expanded(
//                                       child: ListView.builder(
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: newHBO.length,
//                                         itemBuilder: (context, index1) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                             child: Stack(
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) => PostContentScreen(
//                                                           contentTPId: newHBO[index1]['content_third_party_id'],
//                                                           contentID: newHBO[index1]['content_id'],
//                                                           contentType: newHBO[index1]['content_type'],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(6),
//                                                     ),
//                                                     child: CachedImage(
//                                                       imageUrl: 'https://image.tmdb.org/t/p/original/${newHBO[index1]['content_photo']}',
//                                                       width: MediaQuery.of(context).size.width * 0.42,
//                                                       height: 250,
//                                                       radius: 6,
//                                                       colors: Colors.white,
//                                                       thikness: 0.5,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Positioned(
//                                                   top: 7,
//                                                   left: 7,
//                                                   child: Image.asset(
//                                                     '$TRENDING_URL/${'HBOMax'}.png',
//                                                     height: 27,
//                                                   ),
//                                                 ),
//                                                 newHBO[index1]['comment_count_top'] == 0
//                                                     ? Container()
//                                                     : Positioned(
//                                                     bottom: 15,
//                                                     left: 10,
//                                                     right: 10,
//                                                     child: Container(
//                                                       height: 40,
//                                                       width: MediaQuery.of(context).size.width * 0.40,
//                                                       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         children: [
//                                                           AppText(
//                                                             '${newHBO[index1]['comment_count_top']} Comments ',
//                                                             fontSize: 16,
//                                                             color: Colors.black,
//                                                             fontWeight: FontWeight.bold,
//                                                           ),
//                                                           Padding(
//                                                             padding: EdgeInsets.only(top: 5),
//                                                             child: Image.asset(
//                                                               'assets/icons/Comment Icon - Grey.png',
//                                                               height: 16,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           if (projectIdList.length == 0)
//                             hulu.length == 0
//                                 ? Container()
//                                 : Padding(
//                               padding: const EdgeInsets.only(top: 25),
//                               child: Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 height: 290,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     AppText(
//                                       'New On Hulu',
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: "OpenSans",
//                                     ),
//                                     Expanded(
//                                       child: ListView.builder(
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: hulu.length,
//                                         itemBuilder: (context, index1) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                             child: Stack(
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) => PostContentScreen(
//                                                           contentTPId: hulu[index1]['content_third_party_id'],
//                                                           contentID: hulu[index1]['content_id'],
//                                                           contentType: hulu[index1]['content_type'],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(6),
//                                                     ),
//                                                     child: CachedImage(
//                                                       imageUrl: 'https://image.tmdb.org/t/p/original/${hulu[index1]['content_photo']}',
//                                                       width: MediaQuery.of(context).size.width * 0.42,
//                                                       height: 250,
//                                                       radius: 6,
//                                                       colors: Colors.white,
//                                                       thikness: 0.5,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Positioned(
//                                                   top: 7,
//                                                   left: 7,
//                                                   child: Image.asset(
//                                                     '$TRENDING_URL/${'Hulu'}.png',
//                                                     height: 27,
//                                                   ),
//                                                 ),
//                                                 hulu[index1]['comment_count_top'] == 0
//                                                     ? Container()
//                                                     : Positioned(
//                                                     bottom: 15,
//                                                     left: 10,
//                                                     right: 10,
//                                                     child: Container(
//                                                       height: 40,
//                                                       width: MediaQuery.of(context).size.width * 0.40,
//                                                       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         children: [
//                                                           AppText(
//                                                             '${hulu[index1]['comment_count_top']} Comments ',
//                                                             fontSize: 16,
//                                                             color: Colors.black,
//                                                             fontWeight: FontWeight.bold,
//                                                           ),
//                                                           Padding(
//                                                             padding: EdgeInsets.only(top: 5),
//                                                             child: Image.asset(
//                                                               'assets/icons/Comment Icon - Grey.png',
//                                                               height: 16,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           for (int i = 0; i < projectIdList.length; i++)
//                             hulu.length == 0 || projectIdList[i] != 157
//                                 ? Container()
//                                 : Padding(
//                               padding: const EdgeInsets.only(top: 25),
//                               child: Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 height: 290,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     AppText(
//                                       'New On Hulu',
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: "OpenSans",
//                                     ),
//                                     Expanded(
//                                       child: ListView.builder(
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: hulu.length,
//                                         itemBuilder: (context, index1) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                             child: Stack(
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) => PostContentScreen(
//                                                           contentTPId: hulu[index1]['content_third_party_id'],
//                                                           contentID: hulu[index1]['content_id'],
//                                                           contentType: hulu[index1]['content_type'],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(6),
//                                                     ),
//                                                     child: CachedImage(
//                                                       imageUrl: 'https://image.tmdb.org/t/p/original/${hulu[index1]['content_photo']}',
//                                                       width: MediaQuery.of(context).size.width * 0.42,
//                                                       height: 250,
//                                                       radius: 6,
//                                                       colors: Colors.white,
//                                                       thikness: 0.5,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Positioned(
//                                                   top: 7,
//                                                   left: 7,
//                                                   child: Image.asset(
//                                                     '$TRENDING_URL/${'Hulu'}.png',
//                                                     height: 27,
//                                                   ),
//                                                 ),
//                                                 hulu[index1]['comment_count_top'] == 0
//                                                     ? Container()
//                                                     : Positioned(
//                                                     bottom: 15,
//                                                     left: 10,
//                                                     right: 10,
//                                                     child: Container(
//                                                       height: 40,
//                                                       width: MediaQuery.of(context).size.width * 0.40,
//                                                       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         children: [
//                                                           AppText(
//                                                             '${hulu[index1]['comment_count_top']} Comments ',
//                                                             fontSize: 16,
//                                                             color: Colors.black,
//                                                             fontWeight: FontWeight.bold,
//                                                           ),
//                                                           Padding(
//                                                             padding: EdgeInsets.only(top: 5),
//                                                             child: Image.asset(
//                                                               'assets/icons/Comment Icon - Grey.png',
//                                                               height: 16,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           if (projectIdList.length == 0)
//                             peacock.length == 0
//                                 ? Container()
//                                 : Padding(
//                               padding: const EdgeInsets.only(top: 25),
//                               child: Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 height: 290,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     AppText(
//                                       'New On Peacock',
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: "OpenSans",
//                                     ),
//                                     Expanded(
//                                       child: ListView.builder(
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: peacock.length,
//                                         itemBuilder: (context, index1) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                             child: Stack(
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) => PostContentScreen(
//                                                           contentTPId: peacock[index1]['content_third_party_id'],
//                                                           contentID: peacock[index1]['content_id'],
//                                                           contentType: peacock[index1]['content_type'],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(6),
//                                                     ),
//                                                     child: CachedImage(
//                                                       imageUrl: 'https://image.tmdb.org/t/p/original/${peacock[index1]['content_photo']}',
//                                                       width: MediaQuery.of(context).size.width * 0.42,
//                                                       height: 250,
//                                                       radius: 6,
//                                                       colors: Colors.white,
//                                                       thikness: 0.5,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Positioned(
//                                                   top: 7,
//                                                   left: 7,
//                                                   child: Image.asset(
//                                                     '$TRENDING_URL/${'Peacock'}.png',
//                                                     height: 27,
//                                                   ),
//                                                 ),
//                                                 peacock[index1]['comment_count_top'] == 0
//                                                     ? Container()
//                                                     : Positioned(
//                                                     bottom: 15,
//                                                     left: 10,
//                                                     right: 10,
//                                                     child: Container(
//                                                       height: 40,
//                                                       width: MediaQuery.of(context).size.width * 0.40,
//                                                       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         children: [
//                                                           AppText(
//                                                             '${peacock[index1]['comment_count_top']} Comments ',
//                                                             fontSize: 16,
//                                                             color: Colors.black,
//                                                             fontWeight: FontWeight.bold,
//                                                           ),
//                                                           Padding(
//                                                             padding: EdgeInsets.only(top: 5),
//                                                             child: Image.asset(
//                                                               'assets/icons/Comment Icon - Grey.png',
//                                                               height: 16,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           for (int i = 0; i < projectIdList.length; i++)
//                             peacock.length == 0 || projectIdList[i] != 388
//                                 ? Container()
//                                 : Padding(
//                               padding: const EdgeInsets.only(top: 25),
//                               child: Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 height: 290,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     AppText(
//                                       'New On Peacock',
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: "OpenSans",
//                                     ),
//                                     Expanded(
//                                       child: ListView.builder(
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: peacock.length,
//                                         itemBuilder: (context, index1) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                             child: Stack(
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) => PostContentScreen(
//                                                           contentTPId: peacock[index1]['content_third_party_id'],
//                                                           contentID: peacock[index1]['content_id'],
//                                                           contentType: peacock[index1]['content_type'],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(6),
//                                                     ),
//                                                     child: CachedImage(
//                                                       imageUrl: 'https://image.tmdb.org/t/p/original/${peacock[index1]['content_photo']}',
//                                                       width: MediaQuery.of(context).size.width * 0.42,
//                                                       height: 250,
//                                                       radius: 6,
//                                                       colors: Colors.white,
//                                                       thikness: 0.5,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Positioned(
//                                                   top: 7,
//                                                   left: 7,
//                                                   child: Image.asset(
//                                                     '$TRENDING_URL/${'Peacock'}.png',
//                                                     height: 27,
//                                                   ),
//                                                 ),
//                                                 peacock[index1]['comment_count_top'] == 0
//                                                     ? Container()
//                                                     : Positioned(
//                                                     bottom: 15,
//                                                     left: 10,
//                                                     right: 10,
//                                                     child: Container(
//                                                       height: 40,
//                                                       width: MediaQuery.of(context).size.width * 0.40,
//                                                       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         children: [
//                                                           AppText(
//                                                             '${peacock[index1]['comment_count_top']} Comments ',
//                                                             fontSize: 16,
//                                                             color: Colors.black,
//                                                             fontWeight: FontWeight.bold,
//                                                           ),
//                                                           Padding(
//                                                             padding: EdgeInsets.only(top: 5),
//                                                             child: Image.asset(
//                                                               'assets/icons/Comment Icon - Grey.png',
//                                                               height: 16,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           for (int i = 0; i < projectIdList.length; i++)
//                             paramount.length == 0 || projectIdList[i] != 444
//                                 ? Container()
//                                 : Padding(
//                               padding: const EdgeInsets.only(top: 25),
//                               child: Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 height: 290,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     AppText(
//                                       'New On Paramount',
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: "OpenSans",
//                                     ),
//                                     Expanded(
//                                       child: ListView.builder(
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: paramount.length,
//                                         itemBuilder: (context, index1) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                             child: Stack(
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) => PostContentScreen(
//                                                           contentTPId: paramount[index1]['content_third_party_id'],
//                                                           contentID: paramount[index1]['content_id'],
//                                                           contentType: paramount[index1]['content_type'],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(6),
//                                                     ),
//                                                     child: CachedImage(
//                                                       imageUrl: 'https://image.tmdb.org/t/p/original/${paramount[index1]['content_photo']}',
//                                                       width: MediaQuery.of(context).size.width * 0.42,
//                                                       height: 250,
//                                                       radius: 6,
//                                                       colors: Colors.white,
//                                                       thikness: 0.5,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Positioned(
//                                                   top: 7,
//                                                   left: 7,
//                                                   child: Image.asset(
//                                                     '$TRENDING_URL/${'Paramount'}.png',
//                                                     height: 27,
//                                                   ),
//                                                 ),
//                                                 paramount[index1]['comment_count_top'] == 0
//                                                     ? Container()
//                                                     : Positioned(
//                                                     bottom: 15,
//                                                     left: 10,
//                                                     right: 10,
//                                                     child: Container(
//                                                       height: 40,
//                                                       width: MediaQuery.of(context).size.width * 0.40,
//                                                       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         children: [
//                                                           AppText(
//                                                             '${paramount[index1]['comment_count_top']} Comments ',
//                                                             fontSize: 16,
//                                                             color: Colors.black,
//                                                             fontWeight: FontWeight.bold,
//                                                           ),
//                                                           Padding(
//                                                             padding: EdgeInsets.only(top: 5),
//                                                             child: Image.asset(
//                                                               'assets/icons/Comment Icon - Grey.png',
//                                                               height: 16,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           for (int i = 0; i < projectIdList.length; i++)
//                             appleTv.length == 0 || projectIdList[i] != 371
//                                 ? Container()
//                                 : Padding(
//                               padding: const EdgeInsets.only(top: 25),
//                               child: Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 height: 290,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     AppText(
//                                       'New On Apple TV',
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: "OpenSans",
//                                     ),
//                                     Expanded(
//                                       child: ListView.builder(
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: appleTv.length,
//                                         itemBuilder: (context, index1) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                             child: Stack(
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) => PostContentScreen(
//                                                           contentTPId: appleTv[index1]['content_third_party_id'],
//                                                           contentID: appleTv[index1]['content_id'],
//                                                           contentType: appleTv[index1]['content_type'],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(6),
//                                                     ),
//                                                     child: CachedImage(
//                                                       imageUrl: 'https://image.tmdb.org/t/p/original/${appleTv[index1]['content_photo']}',
//                                                       width: MediaQuery.of(context).size.width * 0.42,
//                                                       height: 250,
//                                                       radius: 6,
//                                                       colors: Colors.white,
//                                                       thikness: 0.5,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Positioned(
//                                                   top: 7,
//                                                   left: 7,
//                                                   child: Image.asset(
//                                                     '$TRENDING_URL/${'AppleTV'}.png',
//                                                     height: 27,
//                                                   ),
//                                                 ),
//                                                 appleTv[index1]['comment_count_top'] == 0
//                                                     ? Container()
//                                                     : Positioned(
//                                                     bottom: 15,
//                                                     left: 10,
//                                                     right: 10,
//                                                     child: Container(
//                                                       height: 40,
//                                                       width: MediaQuery.of(context).size.width * 0.40,
//                                                       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         children: [
//                                                           AppText(
//                                                             '${appleTv[index1]['comment_count_top']} Comments ',
//                                                             fontSize: 16,
//                                                             color: Colors.black,
//                                                             fontWeight: FontWeight.bold,
//                                                           ),
//                                                           Padding(
//                                                             padding: EdgeInsets.only(top: 5),
//                                                             child: Image.asset(
//                                                               'assets/icons/Comment Icon - Grey.png',
//                                                               height: 16,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           for (int i = 0; i < projectIdList.length; i++)
//                             tubi.length == 0 || projectIdList[i] != 296
//                                 ? Container()
//                                 : Padding(
//                               padding: const EdgeInsets.only(top: 25),
//                               child: Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 height: 290,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     AppText(
//                                       'New On Tubi',
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: "OpenSans",
//                                     ),
//                                     Expanded(
//                                       child: ListView.builder(
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: tubi.length,
//                                         itemBuilder: (context, index1) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                             child: Stack(
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) => PostContentScreen(
//                                                           contentTPId: tubi[index1]['content_third_party_id'],
//                                                           contentID: tubi[index1]['content_id'],
//                                                           contentType: tubi[index1]['content_type'],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(6),
//                                                     ),
//                                                     child: CachedImage(
//                                                       imageUrl: 'https://image.tmdb.org/t/p/original/${tubi[index1]['content_photo']}',
//                                                       width: MediaQuery.of(context).size.width * 0.42,
//                                                       height: 250,
//                                                       radius: 6,
//                                                       colors: Colors.white,
//                                                       thikness: 0.5,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Positioned(
//                                                   top: 7,
//                                                   left: 7,
//                                                   child: Image.asset(
//                                                     '$TRENDING_URL/${'Tubi'}.png',
//                                                     height: 27,
//                                                   ),
//                                                 ),
//                                                 tubi[index1]['comment_count_top'] == 0
//                                                     ? Container()
//                                                     : Positioned(
//                                                     bottom: 15,
//                                                     left: 10,
//                                                     right: 10,
//                                                     child: Container(
//                                                       height: 40,
//                                                       width: MediaQuery.of(context).size.width * 0.40,
//                                                       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         children: [
//                                                           AppText(
//                                                             '${tubi[index1]['comment_count_top']} Comments ',
//                                                             fontSize: 16,
//                                                             color: Colors.black,
//                                                             fontWeight: FontWeight.bold,
//                                                           ),
//                                                           Padding(
//                                                             padding: EdgeInsets.only(top: 5),
//                                                             child: Image.asset(
//                                                               'assets/icons/Comment Icon - Grey.png',
//                                                               height: 16,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           for (int i = 0; i < projectIdList.length; i++)
//                             pluto.length == 0 || projectIdList[i] != 391
//                                 ? Container()
//                                 : Padding(
//                               padding: const EdgeInsets.only(top: 25),
//                               child: Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 height: 290,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     AppText(
//                                       'New On Pluto',
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: "OpenSans",
//                                     ),
//                                     Expanded(
//                                       child: ListView.builder(
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: pluto.length,
//                                         itemBuilder: (context, index1) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                             child: Stack(
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) => PostContentScreen(
//                                                           contentTPId: pluto[index1]['content_third_party_id'],
//                                                           contentID: pluto[index1]['content_id'],
//                                                           contentType: pluto[index1]['content_type'],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(6),
//                                                     ),
//                                                     child: CachedImage(
//                                                       imageUrl: 'https://image.tmdb.org/t/p/original/${pluto[index1]['content_photo']}',
//                                                       width: MediaQuery.of(context).size.width * 0.42,
//                                                       height: 250,
//                                                       radius: 6,
//                                                       colors: Colors.white,
//                                                       thikness: 0.5,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Positioned(
//                                                   top: 7,
//                                                   left: 7,
//                                                   child: Image.asset(
//                                                     '$TRENDING_URL/${'Pluto'}.png',
//                                                     height: 27,
//                                                   ),
//                                                 ),
//                                                 pluto[index1]['comment_count_top'] == 0
//                                                     ? Container()
//                                                     : Positioned(
//                                                     bottom: 15,
//                                                     left: 10,
//                                                     right: 10,
//                                                     child: Container(
//                                                       height: 40,
//                                                       width: MediaQuery.of(context).size.width * 0.40,
//                                                       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         children: [
//                                                           AppText(
//                                                             '${pluto[index1]['comment_count_top']} Comments ',
//                                                             fontSize: 16,
//                                                             color: Colors.black,
//                                                             fontWeight: FontWeight.bold,
//                                                           ),
//                                                           Padding(
//                                                             padding: EdgeInsets.only(top: 5),
//                                                             child: Image.asset(
//                                                               'assets/icons/Comment Icon - Grey.png',
//                                                               height: 16,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           for (int i = 0; i < projectIdList.length; i++)
//                             starz.length == 0 || projectIdList[i] != 232
//                                 ? Container()
//                                 : Padding(
//                               padding: const EdgeInsets.only(top: 25),
//                               child: Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 height: 290,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     AppText(
//                                       'New On Starz',
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: "OpenSans",
//                                     ),
//                                     Expanded(
//                                       child: ListView.builder(
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: starz.length,
//                                         itemBuilder: (context, index1) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                             child: Stack(
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) => PostContentScreen(
//                                                           contentTPId: starz[index1]['content_third_party_id'],
//                                                           contentID: starz[index1]['content_id'],
//                                                           contentType: starz[index1]['content_type'],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(6),
//                                                     ),
//                                                     child: CachedImage(
//                                                       imageUrl: 'https://image.tmdb.org/t/p/original/${starz[index1]['content_photo']}',
//                                                       width: MediaQuery.of(context).size.width * 0.42,
//                                                       height: 250,
//                                                       radius: 6,
//                                                       colors: Colors.white,
//                                                       thikness: 0.5,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Positioned(
//                                                   top: 7,
//                                                   left: 7,
//                                                   child: Image.asset(
//                                                     '$TRENDING_URL/${'Starz'}.png',
//                                                     height: 27,
//                                                   ),
//                                                 ),
//                                                 starz[index1]['comment_count_top'] == 0
//                                                     ? Container()
//                                                     : Positioned(
//                                                     bottom: 15,
//                                                     left: 10,
//                                                     right: 10,
//                                                     child: Container(
//                                                       height: 40,
//                                                       width: MediaQuery.of(context).size.width * 0.40,
//                                                       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         children: [
//                                                           AppText(
//                                                             '${starz[index1]['comment_count_top']} Comments ',
//                                                             fontSize: 16,
//                                                             color: Colors.black,
//                                                             fontWeight: FontWeight.bold,
//                                                           ),
//                                                           Padding(
//                                                             padding: EdgeInsets.only(top: 5),
//                                                             child: Image.asset(
//                                                               'assets/icons/Comment Icon - Grey.png',
//                                                               height: 16,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           for (int i = 0; i < projectIdList.length; i++)
//                             showtime.length == 0 || projectIdList[i] != 248
//                                 ? Container()
//                                 : Padding(
//                               padding: const EdgeInsets.only(top: 25),
//                               child: Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 height: 290,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     AppText(
//                                       'New On Showtime',
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: "OpenSans",
//                                     ),
//                                     Expanded(
//                                       child: ListView.builder(
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: showtime.length,
//                                         itemBuilder: (context, index1) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                             child: Stack(
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) => PostContentScreen(
//                                                           contentTPId: showtime[index1]['content_third_party_id'],
//                                                           contentID: showtime[index1]['content_id'],
//                                                           contentType: showtime[index1]['content_type'],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(6),
//                                                     ),
//                                                     child: CachedImage(
//                                                       imageUrl: 'https://image.tmdb.org/t/p/original/${showtime[index1]['content_photo']}',
//                                                       width: MediaQuery.of(context).size.width * 0.42,
//                                                       height: 250,
//                                                       radius: 6,
//                                                       colors: Colors.white,
//                                                       thikness: 0.5,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Positioned(
//                                                   top: 7,
//                                                   left: 7,
//                                                   child: Image.asset(
//                                                     '$TRENDING_URL/${'Showtime'}.png',
//                                                     height: 27,
//                                                   ),
//                                                 ),
//                                                 showtime[index1]['comment_count_top'] == 0
//                                                     ? Container()
//                                                     : Positioned(
//                                                     bottom: 15,
//                                                     left: 10,
//                                                     right: 10,
//                                                     child: Container(
//                                                       height: 40,
//                                                       width: MediaQuery.of(context).size.width * 0.40,
//                                                       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         children: [
//                                                           AppText(
//                                                             '${showtime[index1]['comment_count_top']} Comments ',
//                                                             fontSize: 16,
//                                                             color: Colors.black,
//                                                             fontWeight: FontWeight.bold,
//                                                           ),
//                                                           Padding(
//                                                             padding: EdgeInsets.only(top: 5),
//                                                             child: Image.asset(
//                                                               'assets/icons/Comment Icon - Grey.png',
//                                                               height: 16,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           comingSoonData.length == 0
//                               ? Container()
//                               : Padding(
//                             padding: const EdgeInsets.only(top: 20),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 20),
//                               height: 260,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppText(
//                                     'Coming Soon To Streaming',
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "OpenSans",
//                                   ),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: comingSoonData.length,
//                                       itemBuilder: (context, index1) {
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 20, bottom: 10),
//                                           child: Stack(
//                                             alignment: Alignment.center,
//                                             children: [
//                                               Container(
//                                                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white)),
//                                                 child: CachedImage(
//                                                   imageUrl: 'https://oneflixapp.com/oneflix/${comingSoonData[index1]['cover_photo']}',
//                                                   width: MediaQuery.of(context).size.width * 0.87,
//                                                   height: 210,
//                                                   radius: 6,
//                                                   colors: Colors.white,
//                                                   thikness: 0.5,
//                                                 ),
//                                               ),
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   showDialog(
//                                                     barrierDismissible: true,
//                                                     barrierColor: Colors.black.withOpacity(0.9),
//                                                     context: context,
//                                                     builder: (context) {
//                                                       return StatefulBuilder(
//                                                         builder: (context, setState) {
//                                                           return Stack(
//                                                             alignment: Alignment.center,
//                                                             children: [
//                                                               comingSoonData[index1]['youtube_key'] != null
//                                                                   ? SizedBox(height: 20, width: 20, child: kProgressIndicator)
//                                                                   : Container(),
//                                                               comingSoonData[index1]['youtube_key'] != null
//                                                                   ? YoutubePlayerIFrame(
//                                                                 controller: YoutubePlayerController(
//                                                                   initialVideoId: comingSoonData[index1]['youtube_key'],
//                                                                   params: YoutubePlayerParams(
//                                                                     startAt: Duration(seconds: 1),
//                                                                     showControls: true,
//                                                                     mute: false,
//                                                                     loop: true,
//                                                                     showFullscreenButton: true,
//                                                                     autoPlay: true,
//                                                                     showVideoAnnotations: false,
//                                                                   ),
//                                                                 )..play(),
//                                                               )
//                                                                   : Container(
//                                                                 margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 40),
//                                                                 child: AppText('Trailer is not available currently.', textAlign: TextAlign.center),
//                                                                 alignment: Alignment.center,
//                                                               ),
//                                                               Positioned(
//                                                                 top: 0,
//                                                                 right: 0,
//                                                                 child: GestureDetector(
//                                                                   onTap: () => Navigator.pop(context),
//                                                                   child: Icon(Icons.close, color: Colors.white, size: 30),
//                                                                 ),
//                                                               )
//                                                             ],
//                                                           );
//                                                         },
//                                                       );
//                                                     },
//                                                   );
//                                                 },
//                                                 child: Icon(
//                                                   /*  value.playerState == PlayerState.playing ? Icons.pause :*/ Icons.play_arrow_rounded,
//                                                   size: 100,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 10,
//                                                 left: 20,
//                                                 child: Image.asset(
//                                                   '$TRENDING_URL/${comingSoonData[index1]['title'] == 'Netflix' ? 'NetflixNew' : comingSoonData[index1]['title'] == 'Amazon' ? 'AmazonPrime' : comingSoonData[index1]['title'] == 'Disney' ? 'Disney' : comingSoonData[index1]['title'] == 'Hulu' ? 'Hulu' : comingSoonData[index1]['title'] == 'HBO Max' ? 'HBOMax' : comingSoonData[index1]['title'] == 'Paramount' ? 'Paramount' : comingSoonData[index1]['title'] == 'Peacock' ? 'Peacock' : comingSoonData[index1]['title'] == 'Apple TV' ? 'AppleTV' : comingSoonData[index1]['title'] == 445 ? 'DiscoveryPlus' : comingSoonData[index1]['title'] == 248 ? 'Showtime' : comingSoonData[index1]['title'] == 232 ? 'Starz' : comingSoonData[index1]['title'] == 296 ? 'Tubi' : comingSoonData[index1]['title'] == 391 ? 'Pluto' : ' '}.png',
//                                                   height: 70,
//                                                   width: 70,
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                   bottom: 25,
//                                                   right: 20,
//                                                   child: Container(
//                                                     height: 32,
//                                                     width: MediaQuery.of(context).size.width * 0.16,
//                                                     decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6)),
//                                                     child: Center(
//                                                         child: AppText(
//                                                           comingSoonData[index1]['new_arrival_date'] ?? '',
//                                                           fontSize: 14,
//                                                           fontWeight: FontWeight.w900,
//                                                         )),
//                                                   ))
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           actionMovie.length <= 3
//                               ? Container()
//                               : Padding(
//                             padding: const EdgeInsets.only(top: 25),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 20),
//                               height: 220,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppText(
//                                     'Action Movies',
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "OpenSans",
//                                   ),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: actionMovie.length,
//                                       itemBuilder: (context, index1) {
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                           child: Stack(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => PostContentScreen(
//                                                         contentTPId: actionMovie[index1]['content_third_party_id'],
//                                                         contentID: actionMovie[index1]['content_id'],
//                                                         contentType: actionMovie[index1]['content_type'],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(6),
//                                                   ),
//                                                   child: CachedImage(
//                                                     imageUrl: 'https://image.tmdb.org/t/p/original/${actionMovie[index1]['content_photo']}',
//                                                     width: MediaQuery.of(context).size.width * 0.27,
//                                                     height: 170,
//                                                     radius: 6,
//                                                     colors: Colors.white,
//                                                     thikness: 0.5,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 7,
//                                                 left: 7,
//                                                 child: Image.asset(
//                                                   '$TRENDING_URL/${actionMovie[index1]['source_id'] == '203' ? 'NetflixNew' : actionMovie[index1]['source_id'] == '26' ? 'AmazonPrime' : actionMovie[index1]['source_id'] == '372' ? 'Disney' : actionMovie[index1]['source_id'] == '157' ? 'Hulu' : actionMovie[index1]['source_id'] == '387' ? 'HBOMax' : actionMovie[index1]['source_id'] == '444' ? 'Paramount' : actionMovie[index1]['source_id'] == '388' || actionMovie[index1]['source_id'] == '389' ? 'Peacock' : actionMovie[index1]['source_id'] == '371' ? 'AppleTV' : actionMovie[index1]['source_id'] == '445' ? 'DiscoveryPlus' : actionMovie[index1]['source_id'] == '248' ? 'Showtime' : actionMovie[index1]['source_id'] == '232' ? 'Starz' : actionMovie[index1]['source_id'] == '296' ? 'Tubi' : actionMovie[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
//                                                   height: 25,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           comedyMovie.length <= 3
//                               ? Container()
//                               : Padding(
//                             padding: const EdgeInsets.only(top: 25),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 20),
//                               height: 220,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppText(
//                                     'Comedy Movies',
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "OpenSans",
//                                   ),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: comedyMovie.length,
//                                       itemBuilder: (context, index1) {
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                           child: Stack(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => PostContentScreen(
//                                                         contentTPId: comedyMovie[index1]['content_third_party_id'],
//                                                         contentID: comedyMovie[index1]['content_id'],
//                                                         contentType: comedyMovie[index1]['content_type'],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(6),
//                                                   ),
//                                                   child: CachedImage(
//                                                     imageUrl: 'https://image.tmdb.org/t/p/original/${comedyMovie[index1]['content_photo']}',
//                                                     width: MediaQuery.of(context).size.width * 0.27,
//                                                     height: 170,
//                                                     radius: 6,
//                                                     colors: Colors.white,
//                                                     thikness: 0.5,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 7,
//                                                 left: 7,
//                                                 child: Image.asset(
//                                                   '$TRENDING_URL/${comedyMovie[index1]['source_id'] == '203' ? 'NetflixNew' : comedyMovie[index1]['source_id'] == '26' ? 'AmazonPrime' : comedyMovie[index1]['source_id'] == '372' ? 'Disney' : comedyMovie[index1]['source_id'] == '157' ? 'Hulu' : comedyMovie[index1]['source_id'] == '387' ? 'HBOMax' : comedyMovie[index1]['source_id'] == '444' ? 'Paramount' : comedyMovie[index1]['source_id'] == '388' || comedyMovie[index1]['source_id'] == '389' ? 'Peacock' : comedyMovie[index1]['source_id'] == '371' ? 'AppleTV' : actionMovie[index1]['source_id'] == '445' ? 'DiscoveryPlus' : comedyMovie[index1]['source_id'] == '248' ? 'Showtime' : comedyMovie[index1]['source_id'] == '232' ? 'Starz' : comedyMovie[index1]['source_id'] == '296' ? 'Tubi' : comedyMovie[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
//                                                   height: 25,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           scienceFictionMovie.length <= 3
//                               ? Container()
//                               : Padding(
//                             padding: const EdgeInsets.only(top: 25),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 20),
//                               height: 220,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppText(
//                                     'Science Fiction Movies',
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "OpenSans",
//                                   ),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: scienceFictionMovie.length,
//                                       itemBuilder: (context, index1) {
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                           child: Stack(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => PostContentScreen(
//                                                         contentTPId: scienceFictionMovie[index1]['content_third_party_id'],
//                                                         contentID: scienceFictionMovie[index1]['content_id'],
//                                                         contentType: scienceFictionMovie[index1]['content_type'],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(6),
//                                                   ),
//                                                   child: CachedImage(
//                                                     imageUrl: 'https://image.tmdb.org/t/p/original/${scienceFictionMovie[index1]['content_photo']}',
//                                                     width: MediaQuery.of(context).size.width * 0.27,
//                                                     height: 170,
//                                                     radius: 6,
//                                                     colors: Colors.white,
//                                                     thikness: 0.5,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 7,
//                                                 left: 7,
//                                                 child: Image.asset(
//                                                   '$TRENDING_URL/${scienceFictionMovie[index1]['source_id'] == '203' ? 'NetflixNew' : scienceFictionMovie[index1]['source_id'] == '26' ? 'AmazonPrime' : scienceFictionMovie[index1]['source_id'] == '372' ? 'Disney' : scienceFictionMovie[index1]['source_id'] == '157' ? 'Hulu' : scienceFictionMovie[index1]['source_id'] == '387' ? 'HBOMax' : scienceFictionMovie[index1]['source_id'] == '444' ? 'Paramount' : scienceFictionMovie[index1]['source_id'] == '388' || scienceFictionMovie[index1]['source_id'] == '389' ? 'Peacock' : scienceFictionMovie[index1]['source_id'] == '371' ? 'AppleTV' : scienceFictionMovie[index1]['source_id'] == '445' ? 'DiscoveryPlus' : scienceFictionMovie[index1]['source_id'] == '248' ? 'Showtime' : scienceFictionMovie[index1]['source_id'] == '232' ? 'Starz' : scienceFictionMovie[index1]['source_id'] == '296' ? 'Tubi' : scienceFictionMovie[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
//                                                   height: 25,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           romanceMovie.length <= 3
//                               ? Container()
//                               : Padding(
//                             padding: const EdgeInsets.only(top: 25),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 20),
//                               height: 220,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppText(
//                                     'Romance Movies',
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "OpenSans",
//                                   ),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: romanceMovie.length,
//                                       itemBuilder: (context, index1) {
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                           child: Stack(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => PostContentScreen(
//                                                         contentTPId: romanceMovie[index1]['content_third_party_id'],
//                                                         contentID: romanceMovie[index1]['content_id'],
//                                                         contentType: romanceMovie[index1]['content_type'],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(6),
//                                                   ),
//                                                   child: CachedImage(
//                                                     imageUrl: 'https://image.tmdb.org/t/p/original/${romanceMovie[index1]['content_photo']}',
//                                                     width: MediaQuery.of(context).size.width * 0.27,
//                                                     height: 170,
//                                                     radius: 6,
//                                                     colors: Colors.white,
//                                                     thikness: 0.5,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 7,
//                                                 left: 7,
//                                                 child: Image.asset(
//                                                   '$TRENDING_URL/${romanceMovie[index1]['source_id'] == '203' ? 'NetflixNew' : romanceMovie[index1]['source_id'] == '26' ? 'AmazonPrime' : romanceMovie[index1]['source_id'] == '372' ? 'Disney' : romanceMovie[index1]['source_id'] == '157' ? 'Hulu' : romanceMovie[index1]['source_id'] == '387' ? 'HBOMax' : romanceMovie[index1]['source_id'] == '444' ? 'Paramount' : romanceMovie[index1]['source_id'] == '388' || romanceMovie[index1]['source_id'] == '389' ? 'Peacock' : romanceMovie[index1]['source_id'] == '371' ? 'AppleTV' : romanceMovie[index1]['source_id'] == '445' ? 'DiscoveryPlus' : romanceMovie[index1]['source_id'] == '248' ? 'Showtime' : romanceMovie[index1]['source_id'] == '232' ? 'Starz' : romanceMovie[index1]['source_id'] == '296' ? 'Tubi' : romanceMovie[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
//                                                   height: 25,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           actionTv.length <= 3
//                               ? Container()
//                               : Padding(
//                             padding: const EdgeInsets.only(top: 25),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 20),
//                               height: 220,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppText(
//                                     'Action & Adventure TV Shows',
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "OpenSans",
//                                   ),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: actionTv.length,
//                                       itemBuilder: (context, index1) {
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                           child: Stack(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => PostContentScreen(
//                                                         contentTPId: actionTv[index1]['content_third_party_id'],
//                                                         contentID: actionTv[index1]['content_id'],
//                                                         contentType: actionTv[index1]['content_type'],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(6),
//                                                   ),
//                                                   child: CachedImage(
//                                                     imageUrl: 'https://image.tmdb.org/t/p/original/${actionTv[index1]['content_photo']}',
//                                                     width: MediaQuery.of(context).size.width * 0.27,
//                                                     height: 170,
//                                                     radius: 6,
//                                                     colors: Colors.white,
//                                                     thikness: 0.5,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 7,
//                                                 left: 7,
//                                                 child: Image.asset(
//                                                   '$TRENDING_URL/${actionTv[index1]['source_id'] == '203' ? 'NetflixNew' : actionTv[index1]['source_id'] == '26' ? 'AmazonPrime' : actionTv[index1]['source_id'] == '372' ? 'Disney' : actionTv[index1]['source_id'] == '157' ? 'Hulu' : actionTv[index1]['source_id'] == '387' ? 'HBOMax' : actionTv[index1]['source_id'] == '444' ? 'Paramount' : actionTv[index1]['source_id'] == '388' || actionTv[index1]['source_id'] == '389' ? 'Peacock' : actionTv[index1]['source_id'] == '371' ? 'AppleTV' : actionTv[index1]['source_id'] == '445' ? 'DiscoveryPlus' : actionTv[index1]['source_id'] == '248' ? 'Showtime' : actionTv[index1]['source_id'] == '232' ? 'Starz' : actionTv[index1]['source_id'] == '296' ? 'Tubi' : actionTv[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
//                                                   height: 25,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           comedyTv.length <= 3
//                               ? Container()
//                               : Padding(
//                             padding: const EdgeInsets.only(top: 25),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 20),
//                               height: 220,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppText(
//                                     'Comedy TV Shows',
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "OpenSans",
//                                   ),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: comedyTv.length,
//                                       itemBuilder: (context, index1) {
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                           child: Stack(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => PostContentScreen(
//                                                         contentTPId: comedyTv[index1]['content_third_party_id'],
//                                                         contentID: comedyTv[index1]['content_id'],
//                                                         contentType: comedyTv[index1]['content_type'],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(6),
//                                                   ),
//                                                   child: CachedImage(
//                                                     imageUrl: 'https://image.tmdb.org/t/p/original/${comedyTv[index1]['content_photo']}',
//                                                     width: MediaQuery.of(context).size.width * 0.27,
//                                                     height: 170,
//                                                     radius: 6,
//                                                     colors: Colors.white,
//                                                     thikness: 0.5,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 7,
//                                                 left: 7,
//                                                 child: Image.asset(
//                                                   '$TRENDING_URL/${comedyTv[index1]['source_id'] == '203' ? 'NetflixNew' : comedyTv[index1]['source_id'] == '26' ? 'AmazonPrime' : comedyTv[index1]['source_id'] == '372' ? 'Disney' : comedyTv[index1]['source_id'] == '157' ? 'Hulu' : comedyTv[index1]['source_id'] == '387' ? 'HBOMax' : comedyTv[index1]['source_id'] == '444' ? 'Paramount' : comedyTv[index1]['source_id'] == '388' || comedyTv[index1]['source_id'] == '389' ? 'Peacock' : comedyTv[index1]['source_id'] == '371' ? 'AppleTV' : comedyTv[index1]['source_id'] == '445' ? 'DiscoveryPlus' : comedyTv[index1]['source_id'] == '248' ? 'Showtime' : comedyTv[index1]['source_id'] == '232' ? 'Starz' : comedyTv[index1]['source_id'] == '296' ? 'Tubi' : actionTv[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
//                                                   height: 25,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           adventureMovies.length <= 3
//                               ? Container()
//                               : Padding(
//                             padding: const EdgeInsets.only(top: 25),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 20),
//                               height: 220,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppText(
//                                     'Adventure Movies',
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "OpenSans",
//                                   ),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: adventureMovies.length,
//                                       itemBuilder: (context, index1) {
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                           child: Stack(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => PostContentScreen(
//                                                         contentTPId: adventureMovies[index1]['content_third_party_id'],
//                                                         contentID: adventureMovies[index1]['content_id'],
//                                                         contentType: adventureMovies[index1]['content_type'],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(6),
//                                                   ),
//                                                   child: CachedImage(
//                                                     imageUrl: 'https://image.tmdb.org/t/p/original/${adventureMovies[index1]['content_photo']}',
//                                                     width: MediaQuery.of(context).size.width * 0.27,
//                                                     height: 170,
//                                                     radius: 6,
//                                                     colors: Colors.white,
//                                                     thikness: 0.5,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 7,
//                                                 left: 7,
//                                                 child: Image.asset(
//                                                   '$TRENDING_URL/${adventureMovies[index1]['source_id'] == '203' ? 'NetflixNew' : adventureMovies[index1]['source_id'] == '26' ? 'AmazonPrime' : adventureMovies[index1]['source_id'] == '372' ? 'Disney' : adventureMovies[index1]['source_id'] == '157' ? 'Hulu' : adventureMovies[index1]['source_id'] == '387' ? 'HBOMax' : adventureMovies[index1]['source_id'] == '444' ? 'Paramount' : adventureMovies[index1]['source_id'] == '388' || adventureMovies[index1]['source_id'] == '389' ? 'Peacock' : adventureMovies[index1]['source_id'] == '371' ? 'AppleTV' : adventureMovies[index1]['source_id'] == '445' ? 'DiscoveryPlus' : adventureMovies[index1]['source_id'] == '248' ? 'Showtime' : adventureMovies[index1]['source_id'] == '232' ? 'Starz' : adventureMovies[index1]['source_id'] == '296' ? 'Tubi' : adventureMovies[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
//                                                   height: 25,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           familyMovies.length <= 3
//                               ? Container()
//                               : Padding(
//                             padding: const EdgeInsets.only(top: 25),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 20),
//                               height: 220,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppText(
//                                     'Family Movies',
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "OpenSans",
//                                   ),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: familyMovies.length,
//                                       itemBuilder: (context, index1) {
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                           child: Stack(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => PostContentScreen(
//                                                         contentTPId: familyMovies[index1]['content_third_party_id'],
//                                                         contentID: familyMovies[index1]['content_id'],
//                                                         contentType: familyMovies[index1]['content_type'],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(6),
//                                                   ),
//                                                   child: CachedImage(
//                                                     imageUrl: 'https://image.tmdb.org/t/p/original/${familyMovies[index1]['content_photo']}',
//                                                     width: MediaQuery.of(context).size.width * 0.27,
//                                                     height: 170,
//                                                     radius: 6,
//                                                     colors: Colors.white,
//                                                     thikness: 0.5,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 7,
//                                                 left: 7,
//                                                 child: Image.asset(
//                                                   '$TRENDING_URL/${familyMovies[index1]['source_id'] == '203' ? 'NetflixNew' : familyMovies[index1]['source_id'] == '26' ? 'AmazonPrime' : familyMovies[index1]['source_id'] == '372' ? 'Disney' : familyMovies[index1]['source_id'] == '157' ? 'Hulu' : familyMovies[index1]['source_id'] == '387' ? 'HBOMax' : familyMovies[index1]['source_id'] == '444' ? 'Paramount' : familyMovies[index1]['source_id'] == '388' || familyMovies[index1]['source_id'] == '389' ? 'Peacock' : familyMovies[index1]['source_id'] == '371' ? 'AppleTV' : familyMovies[index1]['source_id'] == '445' ? 'DiscoveryPlus' : familyMovies[index1]['source_id'] == '248' ? 'Showtime' : familyMovies[index1]['source_id'] == '232' ? 'Starz' : familyMovies[index1]['source_id'] == '296' ? 'Tubi' : familyMovies[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
//                                                   height: 25,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           dramaMovies.length <= 3
//                               ? Container()
//                               : Padding(
//                             padding: const EdgeInsets.only(top: 25),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 20),
//                               height: 220,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppText(
//                                     'Drama Movies',
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "OpenSans",
//                                   ),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: dramaMovies.length,
//                                       itemBuilder: (context, index1) {
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                           child: Stack(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => PostContentScreen(
//                                                         contentTPId: dramaMovies[index1]['content_third_party_id'],
//                                                         contentID: dramaMovies[index1]['content_id'],
//                                                         contentType: dramaMovies[index1]['content_type'],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(6),
//                                                   ),
//                                                   child: CachedImage(
//                                                     imageUrl: 'https://image.tmdb.org/t/p/original/${dramaMovies[index1]['content_photo']}',
//                                                     width: MediaQuery.of(context).size.width * 0.27,
//                                                     height: 170,
//                                                     radius: 6,
//                                                     colors: Colors.white,
//                                                     thikness: 0.5,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 7,
//                                                 left: 7,
//                                                 child: Image.asset(
//                                                   '$TRENDING_URL/${dramaMovies[index1]['source_id'] == '203' ? 'NetflixNew' : dramaMovies[index1]['source_id'] == '26' ? 'AmazonPrime' : dramaMovies[index1]['source_id'] == '372' ? 'Disney' : dramaMovies[index1]['source_id'] == '157' ? 'Hulu' : dramaMovies[index1]['source_id'] == '387' ? 'HBOMax' : dramaMovies[index1]['source_id'] == '444' ? 'Paramount' : dramaMovies[index1]['source_id'] == '388' || dramaMovies[index1]['source_id'] == '389' ? 'Peacock' : dramaMovies[index1]['source_id'] == '371' ? 'AppleTV' : dramaMovies[index1]['source_id'] == '445' ? 'DiscoveryPlus' : dramaMovies[index1]['source_id'] == '248' ? 'Showtime' : dramaMovies[index1]['source_id'] == '232' ? 'Starz' : dramaMovies[index1]['source_id'] == '296' ? 'Tubi' : dramaMovies[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
//                                                   height: 25,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           familyTv.length <= 3
//                               ? Container()
//                               : Padding(
//                             padding: const EdgeInsets.only(top: 25),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 20),
//                               height: 220,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppText(
//                                     'Family TV Shows',
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "OpenSans",
//                                   ),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: familyTv.length,
//                                       itemBuilder: (context, index1) {
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                           child: Stack(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => PostContentScreen(
//                                                         contentTPId: familyTv[index1]['content_third_party_id'],
//                                                         contentID: familyTv[index1]['content_id'],
//                                                         contentType: familyTv[index1]['content_type'],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(6),
//                                                   ),
//                                                   child: CachedImage(
//                                                     imageUrl: 'https://image.tmdb.org/t/p/original/${familyTv[index1]['content_photo']}',
//                                                     width: MediaQuery.of(context).size.width * 0.27,
//                                                     height: 170,
//                                                     radius: 6,
//                                                     colors: Colors.white,
//                                                     thikness: 0.5,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 7,
//                                                 left: 7,
//                                                 child: Image.asset(
//                                                   '$TRENDING_URL/${familyTv[index1]['source_id'] == '203' ? 'NetflixNew' : familyTv[index1]['source_id'] == '26' ? 'AmazonPrime' : familyTv[index1]['source_id'] == '372' ? 'Disney' : familyTv[index1]['source_id'] == '157' ? 'Hulu' : familyTv[index1]['source_id'] == '387' ? 'HBOMax' : familyTv[index1]['source_id'] == '444' ? 'Paramount' : familyTv[index1]['source_id'] == '388' || familyTv[index1]['source_id'] == '389' ? 'Peacock' : familyTv[index1]['source_id'] == '371' ? 'AppleTV' : familyTv[index1]['source_id'] == '445' ? 'DiscoveryPlus' : familyTv[index1]['source_id'] == '248' ? 'Showtime' : familyTv[index1]['source_id'] == '232' ? 'Starz' : familyTv[index1]['source_id'] == '296' ? 'Tubi' : familyTv[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
//                                                   height: 25,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           dramaTv.length <= 3
//                               ? Container()
//                               : Padding(
//                             padding: const EdgeInsets.only(top: 25),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 20),
//                               height: 220,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppText(
//                                     'Drama TV Shows',
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "OpenSans",
//                                   ),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: dramaTv.length,
//                                       itemBuilder: (context, index1) {
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                           child: Stack(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => PostContentScreen(
//                                                         contentTPId: dramaTv[index1]['content_third_party_id'],
//                                                         contentID: dramaTv[index1]['content_id'],
//                                                         contentType: dramaTv[index1]['content_type'],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(6),
//                                                   ),
//                                                   child: CachedImage(
//                                                     imageUrl: 'https://image.tmdb.org/t/p/original/${dramaTv[index1]['content_photo']}',
//                                                     width: MediaQuery.of(context).size.width * 0.27,
//                                                     height: 170,
//                                                     radius: 6,
//                                                     colors: Colors.white,
//                                                     thikness: 0.5,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 7,
//                                                 left: 7,
//                                                 child: Image.asset(
//                                                   '$TRENDING_URL/${dramaTv[index1]['source_id'] == '203' ? 'NetflixNew' : dramaTv[index1]['source_id'] == '26' ? 'AmazonPrime' : dramaTv[index1]['source_id'] == '372' ? 'Disney' : dramaTv[index1]['source_id'] == '157' ? 'Hulu' : dramaTv[index1]['source_id'] == '387' ? 'HBOMax' : dramaTv[index1]['source_id'] == '444' ? 'Paramount' : dramaTv[index1]['source_id'] == '388' || dramaTv[index1]['source_id'] == '389' ? 'Peacock' : dramaTv[index1]['source_id'] == '371' ? 'AppleTV' : dramaTv[index1]['source_id'] == '445' ? 'DiscoveryPlus' : dramaTv[index1]['source_id'] == '248' ? 'Showtime' : dramaTv[index1]['source_id'] == '232' ? 'Starz' : dramaTv[index1]['source_id'] == '296' ? 'Tubi' : dramaTv[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
//                                                   height: 25,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           thrillerMovies.length <= 3
//                               ? Container()
//                               : Padding(
//                             padding: const EdgeInsets.only(top: 25),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 20),
//                               height: 220,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppText(
//                                     'Thriller Movies',
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "OpenSans",
//                                   ),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: thrillerMovies.length,
//                                       itemBuilder: (context, index1) {
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                           child: Stack(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => PostContentScreen(
//                                                         contentTPId: thrillerMovies[index1]['content_third_party_id'],
//                                                         contentID: thrillerMovies[index1]['content_id'],
//                                                         contentType: thrillerMovies[index1]['content_type'],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(6),
//                                                   ),
//                                                   child: CachedImage(
//                                                     imageUrl: 'https://image.tmdb.org/t/p/original/${thrillerMovies[index1]['content_photo']}',
//                                                     width: MediaQuery.of(context).size.width * 0.27,
//                                                     height: 170,
//                                                     radius: 6,
//                                                     colors: Colors.white,
//                                                     thikness: 0.5,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 7,
//                                                 left: 7,
//                                                 child: Image.asset(
//                                                   '$TRENDING_URL/${thrillerMovies[index1]['source_id'] == '203' ? 'NetflixNew' : thrillerMovies[index1]['source_id'] == '26' ? 'AmazonPrime' : thrillerMovies[index1]['source_id'] == '372' ? 'Disney' : thrillerMovies[index1]['source_id'] == '157' ? 'Hulu' : thrillerMovies[index1]['source_id'] == '387' ? 'HBOMax' : thrillerMovies[index1]['source_id'] == '444' ? 'Paramount' : thrillerMovies[index1]['source_id'] == '388' || thrillerMovies[index1]['source_id'] == '389' ? 'Peacock' : thrillerMovies[index1]['source_id'] == '371' ? 'AppleTV' : thrillerMovies[index1]['source_id'] == '445' ? 'DiscoveryPlus' : thrillerMovies[index1]['source_id'] == '248' ? 'Showtime' : thrillerMovies[index1]['source_id'] == '232' ? 'Starz' : thrillerMovies[index1]['source_id'] == '296' ? 'Tubi' : thrillerMovies[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
//                                                   height: 25,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           horrorMovies.length <= 3
//                               ? Container()
//                               : Padding(
//                             padding: const EdgeInsets.only(top: 25),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 20),
//                               height: 220,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppText(
//                                     'Horror Movies',
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "OpenSans",
//                                   ),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: horrorMovies.length,
//                                       itemBuilder: (context, index1) {
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                           child: Stack(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => PostContentScreen(
//                                                         contentTPId: horrorMovies[index1]['content_third_party_id'],
//                                                         contentID: horrorMovies[index1]['content_id'],
//                                                         contentType: horrorMovies[index1]['content_type'],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(6),
//                                                   ),
//                                                   child: CachedImage(
//                                                     imageUrl: 'https://image.tmdb.org/t/p/original/${horrorMovies[index1]['content_photo']}',
//                                                     width: MediaQuery.of(context).size.width * 0.27,
//                                                     height: 170,
//                                                     radius: 6,
//                                                     colors: Colors.white,
//                                                     thikness: 0.5,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 7,
//                                                 left: 7,
//                                                 child: Image.asset(
//                                                   '$TRENDING_URL/${horrorMovies[index1]['source_id'] == '203' ? 'NetflixNew' : horrorMovies[index1]['source_id'] == '26' ? 'AmazonPrime' : horrorMovies[index1]['source_id'] == '372' ? 'Disney' : horrorMovies[index1]['source_id'] == '157' ? 'Hulu' : horrorMovies[index1]['source_id'] == '387' ? 'HBOMax' : horrorMovies[index1]['source_id'] == '444' ? 'Paramount' : horrorMovies[index1]['source_id'] == '388' || horrorMovies[index1]['source_id'] == '389' ? 'Peacock' : horrorMovies[index1]['source_id'] == '371' ? 'AppleTV' : horrorMovies[index1]['source_id'] == '445' ? 'DiscoveryPlus' : horrorMovies[index1]['source_id'] == '248' ? 'Showtime' : horrorMovies[index1]['source_id'] == '232' ? 'Starz' : thrillerMovies[index1]['source_id'] == '296' ? 'Tubi' : horrorMovies[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
//                                                   height: 25,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           thrillerTV.length <= 3
//                               ? Container()
//                               : Padding(
//                             padding: const EdgeInsets.only(top: 25),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 20),
//                               height: 220,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppText(
//                                     'Thriller TV Shows',
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "OpenSans",
//                                   ),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: thrillerTV.length,
//                                       itemBuilder: (context, index1) {
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                           child: Stack(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => PostContentScreen(
//                                                         contentTPId: thrillerTV[index1]['content_third_party_id'],
//                                                         contentID: thrillerTV[index1]['content_id'],
//                                                         contentType: thrillerTV[index1]['content_type'],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(6),
//                                                   ),
//                                                   child: CachedImage(
//                                                     imageUrl: 'https://image.tmdb.org/t/p/original/${thrillerTV[index1]['content_photo']}',
//                                                     width: MediaQuery.of(context).size.width * 0.27,
//                                                     height: 170,
//                                                     radius: 6,
//                                                     colors: Colors.white,
//                                                     thikness: 0.5,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 7,
//                                                 left: 7,
//                                                 child: Image.asset(
//                                                   '$TRENDING_URL/${thrillerTV[index1]['source_id'] == '203' ? 'NetflixNew' : thrillerTV[index1]['source_id'] == '26' ? 'AmazonPrime' : thrillerTV[index1]['source_id'] == '372' ? 'Disney' : thrillerTV[index1]['source_id'] == '157' ? 'Hulu' : thrillerTV[index1]['source_id'] == '387' ? 'HBOMax' : thrillerTV[index1]['source_id'] == '444' ? 'Paramount' : thrillerTV[index1]['source_id'] == '388' || thrillerTV[index1]['source_id'] == '389' ? 'Peacock' : thrillerTV[index1]['source_id'] == '371' ? 'AppleTV' : horrorMovies[index1]['source_id'] == '445' ? 'DiscoveryPlus' : thrillerTV[index1]['source_id'] == '248' ? 'Showtime' : thrillerTV[index1]['source_id'] == '232' ? 'Starz' : thrillerTV[index1]['source_id'] == '296' ? 'Tubi' : thrillerTV[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
//                                                   height: 25,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           scifiFanstyTv.length <= 3
//                               ? Container()
//                               : Padding(
//                             padding: const EdgeInsets.only(top: 25),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 20),
//                               height: 220,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppText(
//                                     'Sci-Fi & Fantasy TV Shows',
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "OpenSans",
//                                   ),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: scifiFanstyTv.length,
//                                       itemBuilder: (context, index1) {
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                           child: Stack(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => PostContentScreen(
//                                                         contentTPId: scifiFanstyTv[index1]['content_third_party_id'],
//                                                         contentID: scifiFanstyTv[index1]['content_id'],
//                                                         contentType: scifiFanstyTv[index1]['content_type'],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(6),
//                                                   ),
//                                                   child: CachedImage(
//                                                     imageUrl: 'https://image.tmdb.org/t/p/original/${scifiFanstyTv[index1]['content_photo']}',
//                                                     width: MediaQuery.of(context).size.width * 0.27,
//                                                     height: 170,
//                                                     radius: 6,
//                                                     colors: Colors.white,
//                                                     thikness: 0.5,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 7,
//                                                 left: 7,
//                                                 child: Image.asset(
//                                                   '$TRENDING_URL/${scifiFanstyTv[index1]['source_id'] == '203' ? 'NetflixNew' : scifiFanstyTv[index1]['source_id'] == '26' ? 'AmazonPrime' : scifiFanstyTv[index1]['source_id'] == '372' ? 'Disney' : scifiFanstyTv[index1]['source_id'] == '157' ? 'Hulu' : scifiFanstyTv[index1]['source_id'] == '387' ? 'HBOMax' : scifiFanstyTv[index1]['source_id'] == '444' ? 'Paramount' : scifiFanstyTv[index1]['source_id'] == '388' || scifiFanstyTv[index1]['source_id'] == '389' ? 'Peacock' : scifiFanstyTv[index1]['source_id'] == '371' ? 'AppleTV' : scifiFanstyTv[index1]['source_id'] == '445' ? 'DiscoveryPlus' : scifiFanstyTv[index1]['source_id'] == '248' ? 'Showtime' : scifiFanstyTv[index1]['source_id'] == '232' ? 'Starz' : scifiFanstyTv[index1]['source_id'] == '296' ? 'Tubi' : scifiFanstyTv[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
//                                                   height: 25,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           crimeTv.length <= 3
//                               ? Container()
//                               : Padding(
//                             padding: EdgeInsets.only(top: 25),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 20),
//                               height: 220,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppText(
//                                     'Crime TV Shows',
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "OpenSans",
//                                   ),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: crimeTv.length,
//                                       itemBuilder: (context, index1) {
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                                           child: Stack(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => PostContentScreen(
//                                                         contentTPId: crimeTv[index1]['content_third_party_id'],
//                                                         contentID: crimeTv[index1]['content_id'],
//                                                         contentType: crimeTv[index1]['content_type'],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(6),
//                                                   ),
//                                                   child: CachedImage(
//                                                     imageUrl: 'https://image.tmdb.org/t/p/original/${crimeTv[index1]['content_photo']}',
//                                                     width: MediaQuery.of(context).size.width * 0.27,
//                                                     height: 170,
//                                                     radius: 6,
//                                                     colors: Colors.white,
//                                                     thikness: 0.5,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 7,
//                                                 left: 7,
//                                                 child: Image.asset(
//                                                   '$TRENDING_URL/${crimeTv[index1]['source_id'] == '203' ? 'NetflixNew' : crimeTv[index1]['source_id'] == '26' ? 'AmazonPrime' : crimeTv[index1]['source_id'] == '372' ? 'Disney' : crimeTv[index1]['source_id'] == '157' ? 'Hulu' : crimeTv[index1]['source_id'] == '387' ? 'HBOMax' : crimeTv[index1]['source_id'] == '444' ? 'Paramount' : crimeTv[index1]['source_id'] == '388' || crimeTv[index1]['source_id'] == '389' ? 'Peacock' : crimeTv[index1]['source_id'] == '371' ? 'AppleTV' : crimeTv[index1]['source_id'] == '445' ? 'DiscoveryPlus' : crimeTv[index1]['source_id'] == '248' ? 'Showtime' : crimeTv[index1]['source_id'] == '232' ? 'Starz' : crimeTv[index1]['source_id'] == '296' ? 'Tubi' : crimeTv[index1]['source_id'] == '391' ? 'Pluto' : ' '}.png',
//                                                   height: 25,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 20),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 20.0),
//                             child: AlertBox(
//                               buttonText: 'INVITE YOUR FRIENDS',
//                               description:
//                               'Oneflix is better with your friends. Invite your friends to Oneflix so you can discover what they\'re streaming and recommend content to each other.',
//                               descFontSize: 13,
//                               fontWeight: FontWeight.bold,
//                               onTap: () {
//                                 Share.share('Join me on Oneflix to share and discuss the best content on streaming. https://oneflix.app/');
//                               },
//                               child: Image.asset('assets/images/Oneflix Social.png', fit: BoxFit.cover),
//                             ),
//                           )
//                         ],
//                       ),
//
//                       // TabBarView(
//                       //   children: [
//                       //
//                       //     // Padding(
//                       //     //   padding: const EdgeInsets.only(top: 10),
//                       //     //   child: ListView(
//                       //     //     shrinkWrap: true,
//                       //     //     children: [
//                       //     //       locationPermission == true || region != null
//                       //     //           ? region != null
//                       //     //               ? Column(
//                       //     //                   children: [
//                       //     //                     RichText(
//                       //     //                       textAlign: TextAlign.center,
//                       //     //                       text: TextSpan(
//                       //     //                         text: 'What everyone in ',
//                       //     //                         style: TextStyle(
//                       //     //                           fontSize: 15,
//                       //     //                           fontFamily: 'OpenSans',
//                       //     //                           color: Colors.white,
//                       //     //                           fontWeight: FontWeight.bold,
//                       //     //                         ),
//                       //     //                         children: <TextSpan>[
//                       //     //                           TextSpan(
//                       //     //                             text: '$region',
//                       //     //                             style: TextStyle(
//                       //     //                               fontSize: 15,
//                       //     //                               color: kPrimaryColor,
//                       //     //                               fontFamily: 'OpenSans',
//                       //     //                               fontWeight: FontWeight.bold,
//                       //     //                             ),
//                       //     //                           ),
//                       //     //                           TextSpan(
//                       //     //                             text: ' is streaming right now.',
//                       //     //                             style: TextStyle(
//                       //     //                               fontSize: 15,
//                       //     //                               color: Colors.white,
//                       //     //                               fontFamily: 'OpenSans',
//                       //     //                               fontWeight: FontWeight.bold,
//                       //     //                             ),
//                       //     //                           ),
//                       //     //                         ],
//                       //     //                       ),
//                       //     //                     ),
//                       //     //                     RichText(
//                       //     //                       textAlign: TextAlign.center,
//                       //     //                       text: TextSpan(
//                       //     //                         text: 'Live top 10 rankings ',
//                       //     //                         style: TextStyle(
//                       //     //                           fontSize: 15,
//                       //     //                           fontFamily: 'OpenSans',
//                       //     //                           color: Colors.white,
//                       //     //                           fontWeight: FontWeight.bold,
//                       //     //                         ),
//                       //     //                         children: [
//                       //     //                           WidgetSpan(
//                       //     //                             child: BlinkingPoint(
//                       //     //                               xCoor: 12,
//                       //     //                               yCoor: -16,
//                       //     //                               pointSize: 14,
//                       //     //                               pointColor: Color(0xffF5581F),
//                       //     //                             ),
//                       //     //                           )
//                       //     //                         ],
//                       //     //                       ),
//                       //     //                     ),
//                       //     //                   ],
//                       //     //                 )
//                       //     //               : AppText(
//                       //     //                   'What everyone in your state is streaming right now.',
//                       //     //                   textAlign: TextAlign.center,
//                       //     //                   fontSize: 15,
//                       //     //                   fontWeight: FontWeight.bold,
//                       //     //                 )
//                       //     //           : AppText(
//                       //     //               'Enable your location in order to see what everyone in your state is streaming.',
//                       //     //               textAlign: TextAlign.center,
//                       //     //               fontSize: 15,
//                       //     //               fontWeight: FontWeight.bold,
//                       //     //             ),
//                       //     //       SizedBox(height: 14),
//                       //     //       top10Trending.length != 0
//                       //     //           ? CarouselSlider.builder(
//                       //     //               options: CarouselOptions(
//                       //     //                 height: 350,
//                       //     //                 viewportFraction: 1,
//                       //     //                 // autoPlay: true,
//                       //     //                 enableInfiniteScroll: false,
//                       //     //                 scrollPhysics: BouncingScrollPhysics(),
//                       //     //               ),
//                       //     //               itemCount: top10Trending.length ~/ 2 + top10Trending.length % 2,
//                       //     //               itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
//                       //     //                 return Container(
//                       //     //                   height: 270,
//                       //     //                   width: MediaQuery.of(context).size.width,
//                       //     //                   child: Row(
//                       //     //                     mainAxisAlignment: itemIndex * 2 + 1 >= top10Trending.length ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
//                       //     //                     children: [
//                       //     //                       Container(
//                       //     //                         child: GestureDetector(
//                       //     //                           onTap: () {
//                       //     //                             print(top10Trending[(itemIndex * 2)]['content_third_party_id']);
//                       //     //                             print(top10Trending[(itemIndex * 2)]['content_id']);
//                       //     //                             print(streamingTrendingIDs[(itemIndex * 2)]);
//                       //     //                             print((itemIndex * 2));
//                       //     //                             Navigator.push(
//                       //     //                               context,
//                       //     //                               MaterialPageRoute(
//                       //     //                                 builder: (context) => PostContentScreen(
//                       //     //                                   contentTPId: top10Trending[(itemIndex * 2)]['content_third_party_id'],
//                       //     //                                   contentID: top10Trending[(itemIndex * 2)]['content_id'],
//                       //     //                                 ),
//                       //     //                               ),
//                       //     //                             );
//                       //     //                           },
//                       //     //                           child: SingleChildScrollView(
//                       //     //                             child: Column(
//                       //     //                               // shrinkWrap: true,
//                       //     //                               mainAxisAlignment: MainAxisAlignment.start,
//                       //     //                               children: [
//                       //     //                                 Image.asset('assets/icons/${((itemIndex * 2) + 1).toString()}.png', height: 50, width: 70),
//                       //     //                                 SizedBox(height: 16),
//                       //     //                                 Stack(
//                       //     //                                   alignment: Alignment.center,
//                       //     //                                   children: [
//                       //     //                                     Container(
//                       //     //                                       height: 260,
//                       //     //                                       width: MediaQuery.of(context).size.width * 0.43,
//                       //     //                                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white)),
//                       //     //                                       child: Column(
//                       //     //                                         children: [
//                       //     //                                           ClipRRect(
//                       //     //                                             borderRadius: BorderRadius.circular(6),
//                       //     //                                             child: CachedImage(
//                       //     //                                               imageUrl: 'https://image.tmdb.org/t/p/original/${top10Trending[itemIndex * 2]['content_photo']}',
//                       //     //                                               height: 258,
//                       //     //                                               width: MediaQuery.of(context).size.width * 0.43,
//                       //     //                                               fit: BoxFit.cover,
//                       //     //                                             ),
//                       //     //                                           ),
//                       //     //                                           Spacer(),
//                       //     //                                         ],
//                       //     //                                       ),
//                       //     //                                     ),
//                       //     //                                     streamingTrendingIDs[(itemIndex * 2)] == 203 ||
//                       //     //                                             streamingTrendingIDs[(itemIndex * 2)] == 26 ||
//                       //     //                                             streamingTrendingIDs[(itemIndex * 2)] == 372 ||
//                       //     //                                             streamingTrendingIDs[(itemIndex * 2)] == 157 ||
//                       //     //                                             streamingTrendingIDs[(itemIndex * 2)] == 387 ||
//                       //     //                                             streamingTrendingIDs[(itemIndex * 2)] == 444 ||
//                       //     //                                             streamingTrendingIDs[(itemIndex * 2)] == 388 ||
//                       //     //                                             streamingTrendingIDs[(itemIndex * 2)] == 389 ||
//                       //     //                                             streamingTrendingIDs[(itemIndex * 2)] == 371 ||
//                       //     //                                             streamingTrendingIDs[(itemIndex * 2)] == 445 ||
//                       //     //                                             streamingTrendingIDs[(itemIndex * 2)] == 248 ||
//                       //     //                                             streamingTrendingIDs[(itemIndex * 2)] == 232 ||
//                       //     //                                             streamingTrendingIDs[(itemIndex * 2)] == 296 ||
//                       //     //                                             streamingTrendingIDs[(itemIndex * 2)] == 391
//                       //     //                                         ? Positioned(
//                       //     //                                             top: 10,
//                       //     //                                             left: 10,
//                       //     //                                             child: Image.asset(
//                       //     //                                               '$TRENDING_URL/${streamingTrendingIDs[(itemIndex * 2)] == 203 ? 'NetflixNew' : streamingTrendingIDs[(itemIndex * 2)] == 26 ? 'AmazonPrime' : streamingTrendingIDs[(itemIndex * 2)] == 372 ? 'Disney' : streamingTrendingIDs[(itemIndex * 2)] == 157 ? 'Hulu' : streamingTrendingIDs[(itemIndex * 2)] == 387 ? 'HBOMax' : streamingTrendingIDs[(itemIndex * 2)] == 444 ? 'Paramount' : streamingTrendingIDs[(itemIndex * 2)] == 388 || streamingTrendingIDs[(itemIndex * 2)] == 389 ? 'Peacock' : streamingTrendingIDs[(itemIndex * 2)] == 371 ? 'AppleTV' : streamingTrendingIDs[(itemIndex * 2)] == 445 ? 'DiscoveryPlus' : streamingTrendingIDs[(itemIndex * 2)] == 248 ? 'Showtime' : streamingTrendingIDs[(itemIndex * 2)] == 232 ? 'Starz' : streamingTrendingIDs[(itemIndex * 2)] == 296 ? 'Tubi' : streamingTrendingIDs[(itemIndex * 2)] == 391 ? 'Pluto' : ' '}.png',
//                       //     //                                               height: 40,
//                       //     //                                             ),
//                       //     //                                           )
//                       //     //                                         : Positioned(top: 10, left: 10, child: Container()),
//                       //     //                                     Positioned(
//                       //     //                                       bottom: 25,
//                       //     //                                       right: 15,
//                       //     //                                       child: Container(
//                       //     //                                         decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(42)),
//                       //     //                                         child: CircularPercentIndicator(
//                       //     //                                           radius: 42.0,
//                       //     //                                           lineWidth: 2.0,
//                       //     //                                           percent: double.tryParse(top10Trending[(itemIndex * 2)]['vote_average'])! / 10,
//                       //     //                                           center: AppText(
//                       //     //                                             (double.tryParse(top10Trending[(itemIndex * 2)]['vote_average'])! * 10).toInt().toString() + "%",
//                       //     //                                             color: Colors.white,
//                       //     //                                             fontWeight: FontWeight.w900,
//                       //     //                                             fontSize: 12,
//                       //     //                                           ),
//                       //     //                                           progressColor: Colors.greenAccent,
//                       //     //                                           backgroundColor: Colors.black,
//                       //     //                                           circularStrokeCap: CircularStrokeCap.round,
//                       //     //                                         ),
//                       //     //                                       ),
//                       //     //                                     ),
//                       //     //                                   ],
//                       //     //                                 ),
//                       //     //                               ],
//                       //     //                             ),
//                       //     //                           ),
//                       //     //                         ),
//                       //     //                       ),
//                       //     //                       itemIndex * 2 + 1 >= top10Trending.length
//                       //     //                           ? Container()
//                       //     //                           : Container(
//                       //     //                               child: GestureDetector(
//                       //     //                                 onTap: () {
//                       //     //                                   print(top10Trending[(itemIndex * 2) + 1]['content_third_party_id']);
//                       //     //                                   print(top10Trending[(itemIndex * 2) + 1]['content_id']);
//                       //     //                                   print(streamingTrendingIDs[(itemIndex * 2) + 1]);
//                       //     //                                   print((itemIndex * 2) + 1);
//                       //     //                                   Navigator.push(
//                       //     //                                     context,
//                       //     //                                     MaterialPageRoute(
//                       //     //                                       builder: (context) => PostContentScreen(
//                       //     //                                         contentTPId: top10Trending[(itemIndex * 2) + 1]['content_third_party_id'],
//                       //     //                                         contentID: top10Trending[(itemIndex * 2) + 1]['content_id'],
//                       //     //                                       ),
//                       //     //                                     ),
//                       //     //                                   );
//                       //     //                                 },
//                       //     //                                 child: SingleChildScrollView(
//                       //     //                                   child: Column(
//                       //     //                                     // shrinkWrap: true,
//                       //     //                                     mainAxisAlignment: MainAxisAlignment.start,
//                       //     //                                     children: [
//                       //     //                                       Image.asset('assets/icons/${((itemIndex * 2) + 2).toString()}.png', height: 50, width: 70),
//                       //     //                                       SizedBox(height: 16),
//                       //     //                                       Stack(
//                       //     //                                         alignment: Alignment.center,
//                       //     //                                         children: [
//                       //     //                                           Container(
//                       //     //                                             height: 260,
//                       //     //                                             width: MediaQuery.of(context).size.width * 0.43,
//                       //     //                                             decoration:
//                       //     //                                                 BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white)),
//                       //     //                                             child: Column(
//                       //     //                                               children: [
//                       //     //                                                 ClipRRect(
//                       //     //                                                   borderRadius: BorderRadius.circular(6),
//                       //     //                                                   child: CachedImage(
//                       //     //                                                     imageUrl:
//                       //     //                                                         'https://image.tmdb.org/t/p/original/${top10Trending[(itemIndex * 2) + 1]['content_photo']}',
//                       //     //                                                     height: 258,
//                       //     //                                                     width: MediaQuery.of(context).size.width * 0.43,
//                       //     //                                                     fit: BoxFit.cover,
//                       //     //                                                   ),
//                       //     //                                                 ),
//                       //     //                                                 Spacer(),
//                       //     //                                               ],
//                       //     //                                             ),
//                       //     //                                           ),
//                       //     //                                           streamingTrendingIDs[(itemIndex * 2) + 1] == 203 ||
//                       //     //                                                   streamingTrendingIDs[(itemIndex * 2) + 1] == 26 ||
//                       //     //                                                   streamingTrendingIDs[(itemIndex * 2) + 1] == 372 ||
//                       //     //                                                   streamingTrendingIDs[(itemIndex * 2) + 1] == 157 ||
//                       //     //                                                   streamingTrendingIDs[(itemIndex * 2) + 1] == 387 ||
//                       //     //                                                   streamingTrendingIDs[(itemIndex * 2) + 1] == 444 ||
//                       //     //                                                   streamingTrendingIDs[(itemIndex * 2) + 1] == 388 ||
//                       //     //                                                   streamingTrendingIDs[(itemIndex * 2) + 1] == 389 ||
//                       //     //                                                   streamingTrendingIDs[(itemIndex * 2) + 1] == 371 ||
//                       //     //                                                   streamingTrendingIDs[(itemIndex * 2) + 1] == 445 ||
//                       //     //                                                   streamingTrendingIDs[(itemIndex * 2) + 1] == 248 ||
//                       //     //                                                   streamingTrendingIDs[(itemIndex * 2) + 1] == 232 ||
//                       //     //                                                   streamingTrendingIDs[(itemIndex * 2) + 1] == 296 ||
//                       //     //                                                   streamingTrendingIDs[(itemIndex * 2) + 1] == 391
//                       //     //                                               ? Positioned(
//                       //     //                                                   top: 10,
//                       //     //                                                   left: 10,
//                       //     //                                                   child: Image.asset(
//                       //     //                                                     '$TRENDING_URL/${streamingTrendingIDs[(itemIndex * 2) + 1] == 203 ? 'NetflixNew' : streamingTrendingIDs[(itemIndex * 2) + 1] == 26 ? 'AmazonPrime' : streamingTrendingIDs[(itemIndex * 2) + 1] == 372 ? 'Disney' : streamingTrendingIDs[(itemIndex * 2) + 1] == 157 ? 'Hulu' : streamingTrendingIDs[(itemIndex * 2) + 1] == 387 ? 'HBOMax' : streamingTrendingIDs[(itemIndex * 2) + 1] == 444 ? 'Paramount' : streamingTrendingIDs[(itemIndex * 2) + 1] == 388 || streamingTrendingIDs[(itemIndex * 2) + 1] == 389 ? 'Peacock' : streamingTrendingIDs[(itemIndex * 2) + 1] == 371 ? 'AppleTV' : streamingTrendingIDs[(itemIndex * 2) + 1] == 445 ? 'DiscoveryPlus' : streamingTrendingIDs[(itemIndex * 2) + 1] == 248 ? 'Showtime' : streamingTrendingIDs[(itemIndex * 2) + 1] == 232 ? 'Starz' : streamingTrendingIDs[(itemIndex * 2) + 1] == 296 ? 'Tubi' : streamingTrendingIDs[(itemIndex * 2) + 1] == 391 ? 'Pluto' : ' '}.png',
//                       //     //                                                     height: 40,
//                       //     //                                                   ),
//                       //     //                                                 )
//                       //     //                                               : Positioned(top: 10, left: 10, child: Container()),
//                       //     //                                           Positioned(
//                       //     //                                             bottom: 25,
//                       //     //                                             right: 15,
//                       //     //                                             child: Container(
//                       //     //                                               decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(42)),
//                       //     //                                               child: CircularPercentIndicator(
//                       //     //                                                 radius: 42.0,
//                       //     //                                                 lineWidth: 2.0,
//                       //     //                                                 percent: double.tryParse(top10Trending[(itemIndex * 2) + 1]['vote_average'])! / 10,
//                       //     //                                                 center: AppText(
//                       //     //                                                   (double.tryParse(top10Trending[(itemIndex * 2) + 1]['vote_average'])! * 10).toInt().toString() +
//                       //     //                                                       "%",
//                       //     //                                                   color: Colors.white,
//                       //     //                                                   fontWeight: FontWeight.w900,
//                       //     //                                                   fontSize: 12,
//                       //     //                                                 ),
//                       //     //                                                 progressColor: Colors.greenAccent,
//                       //     //                                                 backgroundColor: Colors.black,
//                       //     //                                                 circularStrokeCap: CircularStrokeCap.round,
//                       //     //                                               ),
//                       //     //                                             ),
//                       //     //                                           ),
//                       //     //                                         ],
//                       //     //                                       ),
//                       //     //                                     ],
//                       //     //                                   ),
//                       //     //                                 ),
//                       //     //                               ),
//                       //     //                             ),
//                       //     //                     ],
//                       //     //                   ),
//                       //     //                 );
//                       //     //               },
//                       //     //             )
//                       //     //           : locationPermission == true
//                       //     //               ? NoEnoughDataWarning()
//                       //     //               : Column(
//                       //     //                   children: [
//                       //     //                     SizedBox(height: 30),
//                       //     //                     AlertBox(
//                       //     //                       buttonText: 'ENABLE LOCATION',
//                       //     //                       description: 'Oneflix needs your location in order to function. Click here to go to your phone settings and enable location.',
//                       //     //                       onTap: () async {
//                       //     //                         await requestLocationPermission();
//                       //     //                         if (locationPermission == false) {
//                       //     //                           openAppSettings();
//                       //     //                         }
//                       //     //                       },
//                       //     //                       child: Padding(
//                       //     //                         padding: const EdgeInsets.only(bottom: 16.0),
//                       //     //                         child: Image.asset('$ICON_URL/map.png', width: 150, height: 124),
//                       //     //                       ),
//                       //     //                     ),
//                       //     //                   ],
//                       //     //                 ),
//                       //     //       SizedBox(height: 15),
//                       //     //       getContent1.length == 0
//                       //     //           ? Container()
//                       //     //           : Padding(
//                       //     //               padding: const EdgeInsets.only(top: 20),
//                       //     //               child: Container(
//                       //     //                 margin: EdgeInsets.symmetric(horizontal: 20),
//                       //     //                 height: 220,
//                       //     //                 child: Column(
//                       //     //                   crossAxisAlignment: CrossAxisAlignment.start,
//                       //     //                   children: [
//                       //     //                     Row(
//                       //     //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       //     //                       children: [
//                       //     //                         AppText(
//                       //     //                           'What Your Friends Are Streaming',
//                       //     //                           color: Colors.white,
//                       //     //                           fontSize: 15,
//                       //     //                           fontWeight: FontWeight.bold,
//                       //     //                           fontFamily: "OpenSans",
//                       //     //                         ),
//                       //     //                         GestureDetector(
//                       //     //                           onTap: () {
//                       //     //                             showDialog(
//                       //     //                               barrierDismissible: false,
//                       //     //                               barrierColor: Colors.black.withOpacity(0.9),
//                       //     //                               context: context,
//                       //     //                               builder: (context) {
//                       //     //                                 return StatefulBuilder(
//                       //     //                                   builder: (context, setState) {
//                       //     //                                     return Stack(
//                       //     //                                       alignment: Alignment.center,
//                       //     //                                       children: [
//                       //     //                                         Padding(
//                       //     //                                           padding: const EdgeInsets.only(left: 10, right: 10),
//                       //     //                                           child: AppText(
//                       //     //                                             'This is a curated list of content that your friends have recently recommended or interacted with. This list is only as good as the number of friends you have on Oneflix. So to get a better curation, follow more people or invite more friends to join you on Oneflix.',
//                       //     //                                             color: Colors.white,
//                       //     //                                             fontSize: 14,
//                       //     //                                             fontWeight: FontWeight.bold,
//                       //     //                                             textAlign: TextAlign.start,
//                       //     //                                           ),
//                       //     //                                         ),
//                       //     //                                         Positioned(
//                       //     //                                           top: 0,
//                       //     //                                           right: 0,
//                       //     //                                           child: GestureDetector(
//                       //     //                                             onTap: () => Navigator.pop(context),
//                       //     //                                             child: Icon(Icons.close, color: Colors.white, size: 30),
//                       //     //                                           ),
//                       //     //                                         )
//                       //     //                                       ],
//                       //     //                                     );
//                       //     //                                   },
//                       //     //                                 );
//                       //     //                               },
//                       //     //                             );
//                       //     //                           },
//                       //     //                           child: Text(
//                       //     //                             'Info',
//                       //     //                             style: TextStyle(
//                       //     //                               fontSize: 12,
//                       //     //                               fontWeight: FontWeight.bold,
//                       //     //                               fontFamily: "OpenSans",
//                       //     //                               color: Colors.white,
//                       //     //                               decoration: TextDecoration.underline,
//                       //     //                               decorationThickness: 4,
//                       //     //                             ),
//                       //     //                           ),
//                       //     //                         )
//                       //     //                       ],
//                       //     //                     ),
//                       //     //                     Expanded(
//                       //     //                       child: ListView.builder(
//                       //     //                         shrinkWrap: true,
//                       //     //                         scrollDirection: Axis.horizontal,
//                       //     //                         itemCount: getContent1.length,
//                       //     //                         itemBuilder: (context, index1) {
//                       //     //                           return getContent1[index1]['watch_mode_json'] == null || getContent1[index1]['watch_mode_json'] == 'null'
//                       //     //                               ? Container()
//                       //     //                               : Padding(
//                       //     //                                   padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                       //     //                                   child: Stack(
//                       //     //                                     children: [
//                       //     //                                       GestureDetector(
//                       //     //                                         onTap: () {
//                       //     //                                           Navigator.push(
//                       //     //                                             context,
//                       //     //                                             MaterialPageRoute(
//                       //     //                                               builder: (context) => PostContentScreen(
//                       //     //                                                 contentTPId: getContent1[index1]['content_third_party_id'],
//                       //     //                                                 contentID: getContent1[index1]['content_id'],
//                       //     //                                               ),
//                       //     //                                             ),
//                       //     //                                           );
//                       //     //                                         },
//                       //     //                                         child: Container(
//                       //     //                                           decoration: BoxDecoration(
//                       //     //                                             borderRadius: BorderRadius.circular(6),
//                       //     //                                           ),
//                       //     //                                           child: CachedImage(
//                       //     //                                             imageUrl: 'https://image.tmdb.org/t/p/original/${getContent1[index1]['content_photo']}',
//                       //     //                                             width: MediaQuery.of(context).size.width * 0.27,
//                       //     //                                             height: 170,
//                       //     //                                             radius: 6,
//                       //     //                                             colors: Colors.white,
//                       //     //                                             thikness: 0.5,
//                       //     //                                           ),
//                       //     //                                         ),
//                       //     //                                       ),
//                       //     //                                       streamingTrendingIDs5[index1] == 203 ||
//                       //     //                                               streamingTrendingIDs5[index1] == 26 ||
//                       //     //                                               streamingTrendingIDs5[index1] == 372 ||
//                       //     //                                               streamingTrendingIDs5[index1] == 157 ||
//                       //     //                                               streamingTrendingIDs5[index1] == 387 ||
//                       //     //                                               streamingTrendingIDs5[index1] == 444 ||
//                       //     //                                               streamingTrendingIDs5[index1] == 388 ||
//                       //     //                                               streamingTrendingIDs5[index1] == 389 ||
//                       //     //                                               streamingTrendingIDs5[index1] == 371 ||
//                       //     //                                               streamingTrendingIDs5[index1] == 445 ||
//                       //     //                                               streamingTrendingIDs5[index1] == 248 ||
//                       //     //                                               streamingTrendingIDs5[index1] == 232 ||
//                       //     //                                               streamingTrendingIDs5[index1] == 296 ||
//                       //     //                                               streamingTrendingIDs5[index1] == 391
//                       //     //                                           ? Positioned(
//                       //     //                                               top: 7,
//                       //     //                                               left: 7,
//                       //     //                                               child: Image.asset(
//                       //     //                                                 '$TRENDING_URL/${streamingTrendingIDs5[index1] == 203 ? 'NetflixNew' : streamingTrendingIDs5[index1] == 26 ? 'AmazonPrime' : streamingTrendingIDs5[index1] == 372 ? 'Disney' : streamingTrendingIDs5[index1] == 157 ? 'Hulu' : streamingTrendingIDs5[index1] == 387 ? 'HBOMax' : streamingTrendingIDs5[index1] == 444 ? 'Paramount' : streamingTrendingIDs5[index1] == 388 || streamingTrendingIDs5[index1] == 389 ? 'Peacock' : streamingTrendingIDs5[index1] == 371 ? 'AppleTV' : streamingTrendingIDs5[index1] == 445 ? 'DiscoveryPlus' : streamingTrendingIDs5[index1] == 248 ? 'Showtime' : streamingTrendingIDs5[index1] == 232 ? 'Starz' : streamingTrendingIDs5[index1] == 296 ? 'Tubi' : streamingTrendingIDs5[index1] == 391 ? 'Pluto' : ' '}.png',
//                       //     //                                                 height: 25,
//                       //     //                                               ),
//                       //     //                                             )
//                       //     //                                           : Positioned(top: 10, left: 10, child: Container()),
//                       //     //                                       Positioned(
//                       //     //                                         top: 7,
//                       //     //                                         right: 7,
//                       //     //                                         child: ClipRRect(
//                       //     //                                           borderRadius: BorderRadius.only(topRight: Radius.circular(6)),
//                       //     //                                           child: Image.asset(
//                       //     //                                             'assets/icons/Friends Icon.png',
//                       //     //                                             height: 25,
//                       //     //                                           ),
//                       //     //                                         ),
//                       //     //                                       )
//                       //     //                                     ],
//                       //     //                                   ),
//                       //     //                                 );
//                       //     //                         },
//                       //     //                       ),
//                       //     //                     ),
//                       //     //                   ],
//                       //     //                 ),
//                       //     //               ),
//                       //     //             ),
//                       //     //       comingSoonData.length == 0
//                       //     //           ? Container()
//                       //     //           : Padding(
//                       //     //               padding: const EdgeInsets.only(top: 20),
//                       //     //               child: Container(
//                       //     //                 margin: EdgeInsets.symmetric(horizontal: 20),
//                       //     //                 height: 260,
//                       //     //                 child: Column(
//                       //     //                   crossAxisAlignment: CrossAxisAlignment.start,
//                       //     //                   children: [
//                       //     //                     AppText(
//                       //     //                       'Coming Soon To Streaming',
//                       //     //                       color: Colors.white,
//                       //     //                       fontSize: 15,
//                       //     //                       fontWeight: FontWeight.bold,
//                       //     //                       fontFamily: "OpenSans",
//                       //     //                     ),
//                       //     //                     Expanded(
//                       //     //                       child: ListView.builder(
//                       //     //                         shrinkWrap: true,
//                       //     //                         scrollDirection: Axis.horizontal,
//                       //     //                         itemCount: comingSoonData.length,
//                       //     //                         itemBuilder: (context, index1) {
//                       //     //                           return Padding(
//                       //     //                             padding: const EdgeInsets.only(right: 20, bottom: 10),
//                       //     //                             child: Stack(
//                       //     //                               alignment: Alignment.center,
//                       //     //                               children: [
//                       //     //                                 Container(
//                       //     //                                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white)),
//                       //     //                                   child: CachedImage(
//                       //     //                                     imageUrl: 'https://oneflixapp.com/oneflix/${comingSoonData[index1]['cover_photo']}',
//                       //     //                                     width: MediaQuery.of(context).size.width * 0.87,
//                       //     //                                     height: 210,
//                       //     //                                     radius: 6,
//                       //     //                                     colors: Colors.white,
//                       //     //                                     thikness: 0.5,
//                       //     //                                   ),
//                       //     //                                 ),
//                       //     //                                 GestureDetector(
//                       //     //                                   onTap: () {
//                       //     //                                     showDialog(
//                       //     //                                       barrierDismissible: true,
//                       //     //                                       barrierColor: Colors.black.withOpacity(0.9),
//                       //     //                                       context: context,
//                       //     //                                       builder: (context) {
//                       //     //                                         return StatefulBuilder(
//                       //     //                                           builder: (context, setState) {
//                       //     //                                             return Stack(
//                       //     //                                               alignment: Alignment.center,
//                       //     //                                               children: [
//                       //     //                                                 comingSoonData[index1]['youtube_key'] != null
//                       //     //                                                     ? SizedBox(height: 20, width: 20, child: kProgressIndicator)
//                       //     //                                                     : Container(),
//                       //     //                                                 comingSoonData[index1]['youtube_key'] != null
//                       //     //                                                     ? YoutubePlayerIFrame(
//                       //     //                                                         controller: YoutubePlayerController(
//                       //     //                                                           initialVideoId: comingSoonData[index1]['youtube_key'],
//                       //     //                                                           params: YoutubePlayerParams(
//                       //     //                                                             startAt: Duration(seconds: 1),
//                       //     //                                                             showControls: true,
//                       //     //                                                             mute: false,
//                       //     //                                                             loop: true,
//                       //     //                                                             showFullscreenButton: true,
//                       //     //                                                             autoPlay: true,
//                       //     //                                                             showVideoAnnotations: false,
//                       //     //                                                           ),
//                       //     //                                                         )..play(),
//                       //     //                                                       )
//                       //     //                                                     : Container(
//                       //     //                                                         margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 40),
//                       //     //                                                         child: AppText('Trailer is not available currently.', textAlign: TextAlign.center),
//                       //     //                                                         alignment: Alignment.center,
//                       //     //                                                       ),
//                       //     //                                                 Positioned(
//                       //     //                                                   top: 0,
//                       //     //                                                   right: 0,
//                       //     //                                                   child: GestureDetector(
//                       //     //                                                     onTap: () => Navigator.pop(context),
//                       //     //                                                     child: Icon(Icons.close, color: Colors.white, size: 30),
//                       //     //                                                   ),
//                       //     //                                                 )
//                       //     //                                               ],
//                       //     //                                             );
//                       //     //                                           },
//                       //     //                                         );
//                       //     //                                       },
//                       //     //                                     );
//                       //     //                                   },
//                       //     //                                   child: Icon(
//                       //     //                                     /*  value.playerState == PlayerState.playing ? Icons.pause :*/ Icons.play_arrow_rounded,
//                       //     //                                     size: 100,
//                       //     //                                     color: Colors.white,
//                       //     //                                   ),
//                       //     //                                 ),
//                       //     //                                 Positioned(
//                       //     //                                   top: 10,
//                       //     //                                   left: 20,
//                       //     //                                   child: Image.asset(
//                       //     //                                     '$TRENDING_URL/${comingSoonData[index1]['title'] == 'Netflix' ? 'NetflixNew' : comingSoonData[index1]['title'] == 'Amazon' ? 'AmazonPrime' : comingSoonData[index1]['title'] == 'Disney' ? 'Disney' : comingSoonData[index1]['title'] == 'Hulu' ? 'Hulu' : comingSoonData[index1]['title'] == 'HBO Max' ? 'HBOMax' : comingSoonData[index1]['title'] == 'Paramount' ? 'Paramount' : comingSoonData[index1]['title'] == 'Peacock' ? 'Peacock' : comingSoonData[index1]['title'] == 'Apple TV' ? 'AppleTV' : comingSoonData[index1]['title'] == 445 ? 'DiscoveryPlus' : comingSoonData[index1]['title'] == 248 ? 'Showtime' : comingSoonData[index1]['title'] == 232 ? 'Starz' : comingSoonData[index1]['title'] == 296 ? 'Tubi' : comingSoonData[index1]['title'] == 391 ? 'Pluto' : ' '}.png',
//                       //     //                                     height: 70,
//                       //     //                                     width: 70,
//                       //     //                                   ),
//                       //     //                                 ),
//                       //     //                                 Positioned(
//                       //     //                                     bottom: 25,
//                       //     //                                     right: 20,
//                       //     //                                     child: Container(
//                       //     //                                       height: 40,
//                       //     //                                       width: MediaQuery.of(context).size.width * 0.20,
//                       //     //                                       decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6)),
//                       //     //                                       child: Center(
//                       //     //                                           child: AppText(
//                       //     //                                         comingSoonData[index1]['arrival_date'] ?? '',
//                       //     //                                         fontSize: 16,
//                       //     //                                         fontWeight: FontWeight.w900,
//                       //     //                                       )),
//                       //     //                                     ))
//                       //     //                               ],
//                       //     //                             ),
//                       //     //                           );
//                       //     //                         },
//                       //     //                       ),
//                       //     //                     ),
//                       //     //                   ],
//                       //     //                 ),
//                       //     //               ),
//                       //     //             ),
//                       //     //       getArriveData.length == 0
//                       //     //           ? Container()
//                       //     //           : Padding(
//                       //     //               padding: const EdgeInsets.only(top: 25),
//                       //     //               child: Container(
//                       //     //                 margin: EdgeInsets.symmetric(horizontal: 20),
//                       //     //                 height: 220,
//                       //     //                 child: Column(
//                       //     //                   crossAxisAlignment: CrossAxisAlignment.start,
//                       //     //                   children: [
//                       //     //                     AppText(
//                       //     //                       'Arrived On Streaming This Week',
//                       //     //                       color: Colors.white,
//                       //     //                       fontSize: 15,
//                       //     //                       fontWeight: FontWeight.bold,
//                       //     //                       fontFamily: "OpenSans",
//                       //     //                     ),
//                       //     //                     Expanded(
//                       //     //                       child: ListView.builder(
//                       //     //                         shrinkWrap: true,
//                       //     //                         scrollDirection: Axis.horizontal,
//                       //     //                         itemCount: getArriveData.length,
//                       //     //                         itemBuilder: (context, index1) {
//                       //     //                           return getArriveData[index1]['watch_mode_json'] == null || getArriveData[index1]['watch_mode_json'] == 'null'
//                       //     //                               ? Container()
//                       //     //                               : Padding(
//                       //     //                                   padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                       //     //                                   child: Stack(
//                       //     //                                     children: [
//                       //     //                                       GestureDetector(
//                       //     //                                         onTap: () {
//                       //     //                                           Navigator.push(
//                       //     //                                             context,
//                       //     //                                             MaterialPageRoute(
//                       //     //                                               builder: (context) => PostContentScreen(
//                       //     //                                                 contentTPId: getArriveData[index1]['content_third_party_id'],
//                       //     //                                                 contentID: getArriveData[index1]['content_id'],
//                       //     //                                               ),
//                       //     //                                             ),
//                       //     //                                           );
//                       //     //                                         },
//                       //     //                                         child: Container(
//                       //     //                                           decoration: BoxDecoration(
//                       //     //                                             borderRadius: BorderRadius.circular(6),
//                       //     //                                           ),
//                       //     //                                           child: CachedImage(
//                       //     //                                             imageUrl: 'https://image.tmdb.org/t/p/original/${getArriveData[index1]['content_photo']}',
//                       //     //                                             width: MediaQuery.of(context).size.width * 0.27,
//                       //     //                                             height: 170,
//                       //     //                                             radius: 6,
//                       //     //                                             colors: Colors.white,
//                       //     //                                             thikness: 0.5,
//                       //     //                                           ),
//                       //     //                                         ),
//                       //     //                                       ),
//                       //     //                                       streamingTrendingIDs6[index1] == 203 ||
//                       //     //                                               streamingTrendingIDs6[index1] == 26 ||
//                       //     //                                               streamingTrendingIDs6[index1] == 372 ||
//                       //     //                                               streamingTrendingIDs6[index1] == 157 ||
//                       //     //                                               streamingTrendingIDs6[index1] == 387 ||
//                       //     //                                               streamingTrendingIDs6[index1] == 444 ||
//                       //     //                                               streamingTrendingIDs6[index1] == 388 ||
//                       //     //                                               streamingTrendingIDs6[index1] == 389 ||
//                       //     //                                               streamingTrendingIDs6[index1] == 371 ||
//                       //     //                                               streamingTrendingIDs6[index1] == 445 ||
//                       //     //                                               streamingTrendingIDs6[index1] == 248 ||
//                       //     //                                               streamingTrendingIDs6[index1] == 232 ||
//                       //     //                                               streamingTrendingIDs6[index1] == 296 ||
//                       //     //                                               streamingTrendingIDs6[index1] == 391
//                       //     //                                           ? Positioned(
//                       //     //                                               top: 7,
//                       //     //                                               left: 7,
//                       //     //                                               child: Image.asset(
//                       //     //                                                 '$TRENDING_URL/${streamingTrendingIDs6[index1] == 203 ? 'NetflixNew' : streamingTrendingIDs6[index1] == 26 ? 'AmazonPrime' : streamingTrendingIDs6[index1] == 372 ? 'Disney' : streamingTrendingIDs6[index1] == 157 ? 'Hulu' : streamingTrendingIDs6[index1] == 387 ? 'HBOMax' : streamingTrendingIDs6[index1] == 444 ? 'Paramount' : streamingTrendingIDs6[index1] == 388 || streamingTrendingIDs6[index1] == 389 ? 'Peacock' : streamingTrendingIDs6[index1] == 371 ? 'AppleTV' : streamingTrendingIDs6[index1] == 445 ? 'DiscoveryPlus' : streamingTrendingIDs6[index1] == 248 ? 'Showtime' : streamingTrendingIDs6[index1] == 232 ? 'Starz' : streamingTrendingIDs6[index1] == 296 ? 'Tubi' : streamingTrendingIDs6[index1] == 391 ? 'Pluto' : ' '}.png',
//                       //     //                                                 height: 25,
//                       //     //                                               ),
//                       //     //                                             )
//                       //     //                                           : Positioned(top: 7, left: 7, child: Container()),
//                       //     //                                     ],
//                       //     //                                   ),
//                       //     //                                 );
//                       //     //                         },
//                       //     //                       ),
//                       //     //                     ),
//                       //     //                   ],
//                       //     //                 ),
//                       //     //               ),
//                       //     //             ),
//                       //     //       newMovieStreaming.length == 0
//                       //     //           ? Container()
//                       //     //           : Padding(
//                       //     //               padding: const EdgeInsets.only(top: 25),
//                       //     //               child: Container(
//                       //     //                 margin: EdgeInsets.symmetric(horizontal: 20),
//                       //     //                 height: 220,
//                       //     //                 child: Column(
//                       //     //                   crossAxisAlignment: CrossAxisAlignment.start,
//                       //     //                   children: [
//                       //     //                     AppText(
//                       //     //                       'New Movies',
//                       //     //                       color: Colors.white,
//                       //     //                       fontSize: 15,
//                       //     //                       fontWeight: FontWeight.bold,
//                       //     //                       fontFamily: "OpenSans",
//                       //     //                     ),
//                       //     //                     Expanded(
//                       //     //                       child: ListView.builder(
//                       //     //                         shrinkWrap: true,
//                       //     //                         scrollDirection: Axis.horizontal,
//                       //     //                         itemCount: newMovieStreaming.length,
//                       //     //                         itemBuilder: (context, index1) {
//                       //     //                           return newMovieStreaming[index1]['watch_mode_json'] == null || newMovieStreaming[index1]['watch_mode_json'] == 'null'
//                       //     //                               ? Container()
//                       //     //                               : Padding(
//                       //     //                                   padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                       //     //                                   child: Stack(
//                       //     //                                     children: [
//                       //     //                                       GestureDetector(
//                       //     //                                         onTap: () {
//                       //     //                                           Navigator.push(
//                       //     //                                             context,
//                       //     //                                             MaterialPageRoute(
//                       //     //                                               builder: (context) => PostContentScreen(
//                       //     //                                                 contentTPId: newMovieStreaming[index1]['content_third_party_id'],
//                       //     //                                                 contentID: newMovieStreaming[index1]['content_id'],
//                       //     //                                               ),
//                       //     //                                             ),
//                       //     //                                           );
//                       //     //                                         },
//                       //     //                                         child: Container(
//                       //     //                                           decoration: BoxDecoration(
//                       //     //                                             borderRadius: BorderRadius.circular(6),
//                       //     //                                           ),
//                       //     //                                           child: CachedImage(
//                       //     //                                             imageUrl: 'https://image.tmdb.org/t/p/original/${newMovieStreaming[index1]['content_photo']}',
//                       //     //                                             width: MediaQuery.of(context).size.width * 0.27,
//                       //     //                                             height: 170,
//                       //     //                                             radius: 6,
//                       //     //                                             colors: Colors.white,
//                       //     //                                             thikness: 0.5,
//                       //     //                                           ),
//                       //     //                                         ),
//                       //     //                                       ),
//                       //     //                                       newMovieStreamingIDs[index1] == 203 ||
//                       //     //                                               newMovieStreamingIDs[index1] == 26 ||
//                       //     //                                               newMovieStreamingIDs[index1] == 372 ||
//                       //     //                                               newMovieStreamingIDs[index1] == 157 ||
//                       //     //                                               newMovieStreamingIDs[index1] == 387 ||
//                       //     //                                               newMovieStreamingIDs[index1] == 444 ||
//                       //     //                                               newMovieStreamingIDs[index1] == 388 ||
//                       //     //                                               newMovieStreamingIDs[index1] == 389 ||
//                       //     //                                               newMovieStreamingIDs[index1] == 371 ||
//                       //     //                                               newMovieStreamingIDs[index1] == 445 ||
//                       //     //                                               newMovieStreamingIDs[index1] == 248 ||
//                       //     //                                               newMovieStreamingIDs[index1] == 232 ||
//                       //     //                                               newMovieStreamingIDs[index1] == 296 ||
//                       //     //                                               newMovieStreamingIDs[index1] == 391
//                       //     //                                           ? Positioned(
//                       //     //                                               top: 7,
//                       //     //                                               left: 7,
//                       //     //                                               child: Image.asset(
//                       //     //                                                 '$TRENDING_URL/${newMovieStreamingIDs[index1] == 203 ? 'NetflixNew' : newMovieStreamingIDs[index1] == 26 ? 'AmazonPrime' : newMovieStreamingIDs[index1] == 372 ? 'Disney' : newMovieStreamingIDs[index1] == 157 ? 'Hulu' : newMovieStreamingIDs[index1] == 387 ? 'HBOMax' : newMovieStreamingIDs[index1] == 444 ? 'Paramount' : newMovieStreamingIDs[index1] == 388 || newMovieStreamingIDs[index1] == 389 ? 'Peacock' : newMovieStreamingIDs[index1] == 371 ? 'AppleTV' : newMovieStreamingIDs[index1] == 445 ? 'DiscoveryPlus' : newMovieStreamingIDs[index1] == 248 ? 'Showtime' : newMovieStreamingIDs[index1] == 232 ? 'Starz' : newMovieStreamingIDs[index1] == 296 ? 'Tubi' : newMovieStreamingIDs[index1] == 391 ? 'Pluto' : ' '}.png',
//                       //     //                                                 height: 25,
//                       //     //                                               ),
//                       //     //                                             )
//                       //     //                                           : Positioned(top: 7, left: 7, child: Container()),
//                       //     //                                     ],
//                       //     //                                   ),
//                       //     //                                 );
//                       //     //                         },
//                       //     //                       ),
//                       //     //                     ),
//                       //     //                   ],
//                       //     //                 ),
//                       //     //               ),
//                       //     //             ),
//                       //     //       newTVStreaming.length == 0
//                       //     //           ? Container()
//                       //     //           : Padding(
//                       //     //               padding: const EdgeInsets.only(top: 25),
//                       //     //               child: Container(
//                       //     //                 margin: EdgeInsets.symmetric(horizontal: 20),
//                       //     //                 height: 220,
//                       //     //                 child: Column(
//                       //     //                   crossAxisAlignment: CrossAxisAlignment.start,
//                       //     //                   children: [
//                       //     //                     AppText(
//                       //     //                       'New TV Shows',
//                       //     //                       color: Colors.white,
//                       //     //                       fontSize: 15,
//                       //     //                       fontWeight: FontWeight.bold,
//                       //     //                       fontFamily: "OpenSans",
//                       //     //                     ),
//                       //     //                     Expanded(
//                       //     //                       child: ListView.builder(
//                       //     //                         shrinkWrap: true,
//                       //     //                         scrollDirection: Axis.horizontal,
//                       //     //                         itemCount: newTVStreaming.length,
//                       //     //                         itemBuilder: (context, index1) {
//                       //     //                           return newTVStreaming[index1]['watch_mode_json'] == null || newTVStreaming[index1]['watch_mode_json'] == 'null'
//                       //     //                               ? Container()
//                       //     //                               : Padding(
//                       //     //                                   padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                       //     //                                   child: Stack(
//                       //     //                                     children: [
//                       //     //                                       GestureDetector(
//                       //     //                                         onTap: () {
//                       //     //                                           Navigator.push(
//                       //     //                                             context,
//                       //     //                                             MaterialPageRoute(
//                       //     //                                               builder: (context) => PostContentScreen(
//                       //     //                                                 contentTPId: newTVStreaming[index1]['content_third_party_id'],
//                       //     //                                                 contentID: newTVStreaming[index1]['content_id'],
//                       //     //                                               ),
//                       //     //                                             ),
//                       //     //                                           );
//                       //     //                                         },
//                       //     //                                         child: Container(
//                       //     //                                           decoration: BoxDecoration(
//                       //     //                                             borderRadius: BorderRadius.circular(6),
//                       //     //                                           ),
//                       //     //                                           child: CachedImage(
//                       //     //                                             imageUrl: 'https://image.tmdb.org/t/p/original/${newTVStreaming[index1]['content_photo']}',
//                       //     //                                             width: MediaQuery.of(context).size.width * 0.27,
//                       //     //                                             height: 170,
//                       //     //                                             radius: 6,
//                       //     //                                             colors: Colors.white,
//                       //     //                                             thikness: 0.5,
//                       //     //                                           ),
//                       //     //                                         ),
//                       //     //                                       ),
//                       //     //                                       newTVStreamingIDs[index1] == 203 ||
//                       //     //                                               newTVStreamingIDs[index1] == 26 ||
//                       //     //                                               newTVStreamingIDs[index1] == 372 ||
//                       //     //                                               newTVStreamingIDs[index1] == 157 ||
//                       //     //                                               newTVStreamingIDs[index1] == 387 ||
//                       //     //                                               newTVStreamingIDs[index1] == 444 ||
//                       //     //                                               newTVStreamingIDs[index1] == 388 ||
//                       //     //                                               newTVStreamingIDs[index1] == 389 ||
//                       //     //                                               newTVStreamingIDs[index1] == 371 ||
//                       //     //                                               newTVStreamingIDs[index1] == 445 ||
//                       //     //                                               newTVStreamingIDs[index1] == 248 ||
//                       //     //                                               newTVStreamingIDs[index1] == 232 ||
//                       //     //                                               newTVStreamingIDs[index1] == 296 ||
//                       //     //                                               newTVStreamingIDs[index1] == 391
//                       //     //                                           ? Positioned(
//                       //     //                                               top: 7,
//                       //     //                                               left: 7,
//                       //     //                                               child: Image.asset(
//                       //     //                                                 '$TRENDING_URL/${newTVStreamingIDs[index1] == 203 ? 'NetflixNew' : newTVStreamingIDs[index1] == 26 ? 'AmazonPrime' : newTVStreamingIDs[index1] == 372 ? 'Disney' : newTVStreamingIDs[index1] == 157 ? 'Hulu' : newTVStreamingIDs[index1] == 387 ? 'HBOMax' : newTVStreamingIDs[index1] == 444 ? 'Paramount' : newTVStreamingIDs[index1] == 388 || newTVStreamingIDs[index1] == 389 ? 'Peacock' : newTVStreamingIDs[index1] == 371 ? 'AppleTV' : newTVStreamingIDs[index1] == 445 ? 'DiscoveryPlus' : newTVStreamingIDs[index1] == 248 ? 'Showtime' : newTVStreamingIDs[index1] == 232 ? 'Starz' : newTVStreamingIDs[index1] == 296 ? 'Tubi' : newTVStreamingIDs[index1] == 391 ? 'Pluto' : ' '}.png',
//                       //     //                                                 height: 25,
//                       //     //                                               ),
//                       //     //                                             )
//                       //     //                                           : Positioned(top: 7, left: 7, child: Container()),
//                       //     //                                       // newTVStreaming[index1]['is_added_on_top_10'] == 1
//                       //     //                                       //     ? Positioned(
//                       //     //                                       //         top: 1,
//                       //     //                                       //         right: 1,
//                       //     //                                       //         child: ClipRRect(
//                       //     //                                       //           borderRadius: BorderRadius.only(topRight: Radius.circular(6)),
//                       //     //                                       //           child: Image.asset(
//                       //     //                                       //             'assets/icons/Top10.png',
//                       //     //                                       //             height: 35,
//                       //     //                                       //           ),
//                       //     //                                       //         ),
//                       //     //                                       //       )
//                       //     //                                       //     : Container()
//                       //     //                                     ],
//                       //     //                                   ),
//                       //     //                                 );
//                       //     //                         },
//                       //     //                       ),
//                       //     //                     ),
//                       //     //                   ],
//                       //     //                 ),
//                       //     //               ),
//                       //     //             ),
//                       //     //       bestMoviesStreaming.length == 0
//                       //     //           ? Container()
//                       //     //           : Padding(
//                       //     //               padding: const EdgeInsets.only(top: 25),
//                       //     //               child: Container(
//                       //     //                 margin: EdgeInsets.symmetric(horizontal: 20),
//                       //     //                 height: 220,
//                       //     //                 child: Column(
//                       //     //                   crossAxisAlignment: CrossAxisAlignment.start,
//                       //     //                   children: [
//                       //     //                     AppText(
//                       //     //                       'Popular Movies',
//                       //     //                       color: Colors.white,
//                       //     //                       fontSize: 15,
//                       //     //                       fontWeight: FontWeight.bold,
//                       //     //                       fontFamily: "OpenSans",
//                       //     //                     ),
//                       //     //                     Expanded(
//                       //     //                       child: ListView.builder(
//                       //     //                         shrinkWrap: true,
//                       //     //                         scrollDirection: Axis.horizontal,
//                       //     //                         itemCount: bestMoviesStreaming.length,
//                       //     //                         itemBuilder: (context, index1) {
//                       //     //                           return bestMoviesStreaming[index1]['watch_mode_json'] == null || bestMoviesStreaming[index1]['watch_mode_json'] == 'null'
//                       //     //                               ? Container()
//                       //     //                               : Padding(
//                       //     //                                   padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                       //     //                                   child: Stack(
//                       //     //                                     children: [
//                       //     //                                       GestureDetector(
//                       //     //                                         onTap: () {
//                       //     //                                           Navigator.push(
//                       //     //                                             context,
//                       //     //                                             MaterialPageRoute(
//                       //     //                                               builder: (context) => PostContentScreen(
//                       //     //                                                 contentTPId: bestMoviesStreaming[index1]['content_third_party_id'],
//                       //     //                                                 contentID: bestMoviesStreaming[index1]['content_id'],
//                       //     //                                               ),
//                       //     //                                             ),
//                       //     //                                           );
//                       //     //                                         },
//                       //     //                                         child: Container(
//                       //     //                                           decoration: BoxDecoration(
//                       //     //                                             borderRadius: BorderRadius.circular(6),
//                       //     //                                           ),
//                       //     //                                           child: CachedImage(
//                       //     //                                             imageUrl: 'https://image.tmdb.org/t/p/original/${bestMoviesStreaming[index1]['content_photo']}',
//                       //     //                                             width: MediaQuery.of(context).size.width * 0.27,
//                       //     //                                             height: 170,
//                       //     //                                             radius: 6,
//                       //     //                                             colors: Colors.white,
//                       //     //                                             thikness: 0.5,
//                       //     //                                           ),
//                       //     //                                         ),
//                       //     //                                       ),
//                       //     //                                       bestMoviesStreamingIDs[index1] == 203 ||
//                       //     //                                               bestMoviesStreamingIDs[index1] == 26 ||
//                       //     //                                               bestMoviesStreamingIDs[index1] == 372 ||
//                       //     //                                               bestMoviesStreamingIDs[index1] == 157 ||
//                       //     //                                               bestMoviesStreamingIDs[index1] == 387 ||
//                       //     //                                               bestMoviesStreamingIDs[index1] == 444 ||
//                       //     //                                               bestMoviesStreamingIDs[index1] == 388 ||
//                       //     //                                               bestMoviesStreamingIDs[index1] == 389 ||
//                       //     //                                               bestMoviesStreamingIDs[index1] == 371 ||
//                       //     //                                               bestMoviesStreamingIDs[index1] == 445 ||
//                       //     //                                               bestMoviesStreamingIDs[index1] == 248 ||
//                       //     //                                               bestMoviesStreamingIDs[index1] == 232 ||
//                       //     //                                               bestMoviesStreamingIDs[index1] == 296 ||
//                       //     //                                               bestMoviesStreamingIDs[index1] == 391
//                       //     //                                           ? Positioned(
//                       //     //                                               top: 7,
//                       //     //                                               left: 7,
//                       //     //                                               child: Image.asset(
//                       //     //                                                 '$TRENDING_URL/${bestMoviesStreamingIDs[index1] == 203 ? 'NetflixNew' : bestMoviesStreamingIDs[index1] == 26 ? 'AmazonPrime' : bestMoviesStreamingIDs[index1] == 372 ? 'Disney' : bestMoviesStreamingIDs[index1] == 157 ? 'Hulu' : bestMoviesStreamingIDs[index1] == 387 ? 'HBOMax' : bestMoviesStreamingIDs[index1] == 444 ? 'Paramount' : bestMoviesStreamingIDs[index1] == 388 || bestMoviesStreamingIDs[index1] == 389 ? 'Peacock' : bestMoviesStreamingIDs[index1] == 371 ? 'AppleTV' : bestMoviesStreamingIDs[index1] == 445 ? 'DiscoveryPlus' : bestMoviesStreamingIDs[index1] == 248 ? 'Showtime' : bestMoviesStreamingIDs[index1] == 232 ? 'Starz' : bestMoviesStreamingIDs[index1] == 296 ? 'Tubi' : bestMoviesStreamingIDs[index1] == 391 ? 'Pluto' : ' '}.png',
//                       //     //                                                 height: 25,
//                       //     //                                               ),
//                       //     //                                             )
//                       //     //                                           : Positioned(top: 7, left: 7, child: Container()),
//                       //     //                                       Positioned(
//                       //     //                                         top: 7,
//                       //     //                                         right: 7,
//                       //     //                                         child: ClipRRect(
//                       //     //                                           borderRadius: BorderRadius.only(topRight: Radius.circular(6)),
//                       //     //                                           child: Image.asset(
//                       //     //                                             'assets/icons/Hot Content Icon.png',
//                       //     //                                             height: 28,
//                       //     //                                           ),
//                       //     //                                         ),
//                       //     //                                       )
//                       //     //                                     ],
//                       //     //                                   ),
//                       //     //                                 );
//                       //     //                         },
//                       //     //                       ),
//                       //     //                     ),
//                       //     //                   ],
//                       //     //                 ),
//                       //     //               ),
//                       //     //             ),
//                       //     //       bestTVStreaming.length == 0
//                       //     //           ? Container()
//                       //     //           : Padding(
//                       //     //               padding: const EdgeInsets.only(top: 25),
//                       //     //               child: Container(
//                       //     //                 margin: EdgeInsets.symmetric(horizontal: 20),
//                       //     //                 height: 220,
//                       //     //                 child: Column(
//                       //     //                   crossAxisAlignment: CrossAxisAlignment.start,
//                       //     //                   children: [
//                       //     //                     AppText(
//                       //     //                       'Popular TV Shows',
//                       //     //                       color: Colors.white,
//                       //     //                       fontSize: 15,
//                       //     //                       fontWeight: FontWeight.bold,
//                       //     //                       fontFamily: "OpenSans",
//                       //     //                     ),
//                       //     //                     Expanded(
//                       //     //                       child: ListView.builder(
//                       //     //                         shrinkWrap: true,
//                       //     //                         scrollDirection: Axis.horizontal,
//                       //     //                         itemCount: bestTVStreaming.length,
//                       //     //                         itemBuilder: (context, index1) {
//                       //     //                           return bestTVStreaming[index1]['watch_mode_json'] == null || bestTVStreaming[index1]['watch_mode_json'] == 'null'
//                       //     //                               ? Container()
//                       //     //                               : Padding(
//                       //     //                                   padding: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
//                       //     //                                   child: Stack(
//                       //     //                                     children: [
//                       //     //                                       GestureDetector(
//                       //     //                                         onTap: () {
//                       //     //                                           Navigator.push(
//                       //     //                                             context,
//                       //     //                                             MaterialPageRoute(
//                       //     //                                               builder: (context) => PostContentScreen(
//                       //     //                                                 contentTPId: bestTVStreaming[index1]['content_third_party_id'],
//                       //     //                                                 contentID: bestTVStreaming[index1]['content_id'],
//                       //     //                                               ),
//                       //     //                                             ),
//                       //     //                                           );
//                       //     //                                         },
//                       //     //                                         child: Container(
//                       //     //                                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
//                       //     //                                           child: CachedImage(
//                       //     //                                             imageUrl: 'https://image.tmdb.org/t/p/original/${bestTVStreaming[index1]['content_photo']}',
//                       //     //                                             width: MediaQuery.of(context).size.width * 0.27,
//                       //     //                                             height: 170,
//                       //     //                                             radius: 6,
//                       //     //                                             colors: Colors.white,
//                       //     //                                             thikness: 0.5,
//                       //     //                                           ),
//                       //     //                                         ),
//                       //     //                                       ),
//                       //     //                                       bestTVStreamingIDs[index1] == 203 ||
//                       //     //                                               bestTVStreamingIDs[index1] == 26 ||
//                       //     //                                               bestTVStreamingIDs[index1] == 372 ||
//                       //     //                                               bestTVStreamingIDs[index1] == 157 ||
//                       //     //                                               bestTVStreamingIDs[index1] == 387 ||
//                       //     //                                               bestTVStreamingIDs[index1] == 444 ||
//                       //     //                                               bestTVStreamingIDs[index1] == 388 ||
//                       //     //                                               bestTVStreamingIDs[index1] == 389 ||
//                       //     //                                               bestTVStreamingIDs[index1] == 371 ||
//                       //     //                                               bestTVStreamingIDs[index1] == 445 ||
//                       //     //                                               bestTVStreamingIDs[index1] == 248 ||
//                       //     //                                               bestTVStreamingIDs[index1] == 232 ||
//                       //     //                                               bestTVStreamingIDs[index1] == 296 ||
//                       //     //                                               bestTVStreamingIDs[index1] == 391
//                       //     //                                           ? Positioned(
//                       //     //                                               top: 7,
//                       //     //                                               left: 7,
//                       //     //                                               child: Image.asset(
//                       //     //                                                 '$TRENDING_URL/${bestTVStreamingIDs[index1] == 203 ? 'NetflixNew' : bestTVStreamingIDs[index1] == 26 ? 'AmazonPrime' : bestTVStreamingIDs[index1] == 372 ? 'Disney' : bestTVStreamingIDs[index1] == 157 ? 'Hulu' : bestTVStreamingIDs[index1] == 387 ? 'HBOMax' : bestTVStreamingIDs[index1] == 444 ? 'Paramount' : bestTVStreamingIDs[index1] == 388 || bestTVStreamingIDs[index1] == 389 ? 'Peacock' : bestTVStreamingIDs[index1] == 371 ? 'AppleTV' : bestTVStreamingIDs[index1] == 445 ? 'DiscoveryPlus' : bestTVStreamingIDs[index1] == 248 ? 'Showtime' : bestTVStreamingIDs[index1] == 232 ? 'Starz' : bestTVStreamingIDs[index1] == 296 ? 'Tubi' : bestTVStreamingIDs[index1] == 391 ? 'Pluto' : ' '}.png',
//                       //     //                                                 height: 25,
//                       //     //                                               ),
//                       //     //                                             )
//                       //     //                                           : Positioned(top: 7, left: 7, child: Container()),
//                       //     //                                       Positioned(
//                       //     //                                         top: 7,
//                       //     //                                         right: 7,
//                       //     //                                         child: ClipRRect(
//                       //     //                                           borderRadius: BorderRadius.only(topRight: Radius.circular(6)),
//                       //     //                                           child: Image.asset(
//                       //     //                                             'assets/icons/Hot Content Icon.png',
//                       //     //                                             height: 28,
//                       //     //                                           ),
//                       //     //                                         ),
//                       //     //                                       )
//                       //     //                                     ],
//                       //     //                                   ),
//                       //     //                                 );
//                       //     //                         },
//                       //     //                       ),
//                       //     //                     ),
//                       //     //                   ],
//                       //     //                 ),
//                       //     //               ),
//                       //     //             ),
//                       //     //       SizedBox(height: 20),
//                       //     //     ],
//                       //     //   ),
//                       //     // ),
//                       //     // Padding(
//                       //     //   padding: const EdgeInsets.only(top: 10),
//                       //     //   child: ListView(
//                       //     //     shrinkWrap: true,
//                       //     //     children: [
//                       //     //       locationPermission == true || region != null
//                       //     //           ? region != null
//                       //     //               ? Column(
//                       //     //                   children: [
//                       //     //                     RichText(
//                       //     //                       textAlign: TextAlign.center,
//                       //     //                       text: TextSpan(
//                       //     //                         text: 'What everyone in ',
//                       //     //                         style: TextStyle(fontSize: 15, fontFamily: 'OpenSans', color: Colors.white),
//                       //     //                         children: <TextSpan>[
//                       //     //                           TextSpan(
//                       //     //                             text: '$region',
//                       //     //                             style: TextStyle(fontSize: 15, color: kPrimaryColor, fontFamily: 'OpenSans'),
//                       //     //                           ),
//                       //     //                           TextSpan(
//                       //     //                             text: ' is streaming right now.',
//                       //     //                             style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'OpenSans'),
//                       //     //                           ),
//                       //     //                         ],
//                       //     //                       ),
//                       //     //                     ),
//                       //     //                     RichText(
//                       //     //                       textAlign: TextAlign.center,
//                       //     //                       text: TextSpan(
//                       //     //                         text: 'Live data ',
//                       //     //                         style: TextStyle(fontSize: 15, fontFamily: 'OpenSans', color: Colors.white),
//                       //     //                         children: [WidgetSpan(child: BlinkingPoint(xCoor: 12, yCoor: -16, pointSize: 14))],
//                       //     //                       ),
//                       //     //                     ),
//                       //     //                   ],
//                       //     //                 )
//                       //     //               : AppText(
//                       //     //                   'What everyone in your city is streaming right now.',
//                       //     //                   textAlign: TextAlign.center,
//                       //     //                   fontSize: 15,
//                       //     //                 )
//                       //     //           : AppText(
//                       //     //               'Enable your location in order to see what everyone in your city is streaming.',
//                       //     //               textAlign: TextAlign.center,
//                       //     //               fontSize: 15,
//                       //     //             ),
//                       //     //       SizedBox(height: 14),
//                       //     //       top10Trending.length != 0
//                       //     //           ? CarouselSlider.builder(
//                       //     //               options: CarouselOptions(
//                       //     //                 height: 530,
//                       //     //                 viewportFraction: 1.0,
//                       //     //                 autoPlay: true,
//                       //     //                 enableInfiniteScroll: false,
//                       //     //               ),
//                       //     //               itemCount: top10Trending.length,
//                       //     //               itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => Container(
//                       //     //                 child: GestureDetector(
//                       //     //                   onTap: () {
//                       //     //                     Navigator.push(
//                       //     //                       context,
//                       //     //                       MaterialPageRoute(
//                       //     //                         builder: (context) => PostContentScreen(
//                       //     //                           contentTPId: top10Trending[itemIndex]['content_third_party_id'],
//                       //     //                           contentID: top10Trending[itemIndex]['content_id'],
//                       //     //                         ),
//                       //     //                       ),
//                       //     //                     );
//                       //     //                   },
//                       //     //                   child: SingleChildScrollView(
//                       //     //                     child: Column(
//                       //     //                       // shrinkWrap: true,
//                       //     //                       mainAxisAlignment: MainAxisAlignment.start,
//                       //     //                       children: [
//                       //     //                         Image.asset('assets/icons/${(itemIndex + 1).toString()}.png', height: 50, width: 70),
//                       //     //                         SizedBox(height: 16),
//                       //     //                         Stack(
//                       //     //                           alignment: Alignment.center,
//                       //     //                           children: [
//                       //     //                             ClipRRect(
//                       //     //                               borderRadius: BorderRadius.circular(6),
//                       //     //                               child: CachedImage(
//                       //     //                                 imageUrl: 'https://image.tmdb.org/t/p/original/${top10Trending[itemIndex]['content_photo']}',
//                       //     //                                 height: 430,
//                       //     //                                 width: 270,
//                       //     //                                 fit: BoxFit.cover,
//                       //     //                               ),
//                       //     //                             ),
//                       //     //                             streamingTrendingIDs[itemIndex] == 203 ||
//                       //     //                                     streamingTrendingIDs[itemIndex] == 26 ||
//                       //     //                                     streamingTrendingIDs[itemIndex] == 372 ||
//                       //     //                                     streamingTrendingIDs[itemIndex] == 157 ||
//                       //     //                                     streamingTrendingIDs[itemIndex] == 387 ||
//                       //     //                                     streamingTrendingIDs[itemIndex] == 444 ||
//                       //     //                                     streamingTrendingIDs[itemIndex] == 388 ||
//                       //     //                                     streamingTrendingIDs[itemIndex] == 371 ||
//                       //     //                                     streamingTrendingIDs[itemIndex] == 445 ||
//                       //     //                                     streamingTrendingIDs[itemIndex] == 248 ||
//                       //     //                                     streamingTrendingIDs[itemIndex] == 232 ||
//                       //     //                                     streamingTrendingIDs[itemIndex] == 296 ||
//                       //     //                                     streamingTrendingIDs[itemIndex] == 391
//                       //     //                                 ? Positioned(
//                       //     //                                     top: 16,
//                       //     //                                     right: 10,
//                       //     //                                     child: Image.asset(
//                       //     //                                       '$TRENDING_URL/${streamingTrendingIDs[itemIndex] == 203 ? 'Netflix' : streamingTrendingIDs[itemIndex] == 26 ? 'AmazonPrime' : streamingTrendingIDs[itemIndex] == 372 ? 'Disney' : streamingTrendingIDs[itemIndex] == 157 ? 'Hulu' : streamingTrendingIDs[itemIndex] == 387 ? 'HBOMax' : streamingTrendingIDs[itemIndex] == 444 ? 'Paramount' : streamingTrendingIDs[itemIndex] == 388 ? 'Peacock' : streamingTrendingIDs[itemIndex] == 371 ? 'AppleTV' : streamingTrendingIDs[itemIndex] == 445 ? 'DiscoveryPlus' : streamingTrendingIDs[itemIndex] == 248 ? 'Showtime' : streamingTrendingIDs[itemIndex] == 232 ? 'Starz' : streamingTrendingIDs[itemIndex] == 296 ? 'Tubi' : streamingTrendingIDs[itemIndex] == 391 ? 'Pluto' : ' '}.png',
//                       //     //                                       height: 40,
//                       //     //                                     ),
//                       //     //                                   )
//                       //     //                                 : Container()
//                       //     //                           ],
//                       //     //                         ),
//                       //     //                       ],
//                       //     //                     ),
//                       //     //                   ),
//                       //     //                 ),
//                       //     //                 /*TrendingContent(
//                       //     //             rank: (itemIndex + 1).toString(),
//                       //     //             content: top10Trending[itemIndex]['content_photo'],
//                       //     //             provider: streamingIDs[itemIndex],
//                       //     //             onTap: () {
//                       //     //               Navigator.push(
//                       //     //                 context,
//                       //     //                 MaterialPageRoute(
//                       //     //                   builder: (context) => PostContentScreen(
//                       //     //                     contentTPId: top10Trending[itemIndex]['content_third_party_id'],
//                       //     //                     contentID: top10Trending[itemIndex]['content_id'],
//                       //     //                   ),
//                       //     //                 ),
//                       //     //               );
//                       //     //             },
//                       //     //             // provider: countryList[index]['image2'],
//                       //     //           ),*/
//                       //     //               ),
//                       //     //             )
//                       //     //           : locationPermission == true
//                       //     //               ? NoEnoughDataWarning()
//                       //     //               : Column(
//                       //     //                   children: [
//                       //     //                     SizedBox(height: 30),
//                       //     //                     AlertBox(
//                       //     //                       buttonText: 'ENABLE LOCATION',
//                       //     //                       description:  'Oneflix needs your location in order to function. Click here to go to your phone settings and enable location.',
//                       //     //                       onTap: () async {
//                       //     //                         await requestLocationPermission();
//                       //     //                         if (locationPermission == false) {
//                       //     //                           openAppSettings();
//                       //     //                         }
//                       //     //                       },
//                       //     //                       child: Padding(
//                       //     //                         padding: const EdgeInsets.only(bottom: 16.0),
//                       //     //                         child: Image.asset('$ICON_URL/map.png', width: 150, height: 124),
//                       //     //                       ),
//                       //     //                     ),
//                       //     //                   ],
//                       //     //                 ),
//                       //     //     ],
//                       //     //   ),
//                       //     // ),
//                       //   ],
//                       //   controller: _tabController,
//                       // ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Offstage(
//             //   offstage: selectedButton != 2,
//             //   child: new TickerMode(
//             //     enabled: selectedButton == 2,
//             //     child: Column(
//             //       children: [
//             //         Padding(
//             //           padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
//             //           child: TabBar(
//             //             unselectedLabelColor: Colors.white,
//             //             labelPadding: EdgeInsets.symmetric(horizontal: 3),
//             //             indicatorColor: Colors.white,
//             //             labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'OpenSans'),
//             //             unselectedLabelStyle: TextStyle(color: Color(0xff959594), fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'OpenSans'),
//             //             tabs: [
//             //               Tab(child: Text('This Week', style: TextStyle(fontWeight: FontWeight.bold))),
//             //               Tab(child: Text('ALL TIME', style: TextStyle(fontWeight: FontWeight.bold))),
//             //             ],
//             //             controller: _tabController2,
//             //             indicatorSize: TabBarIndicatorSize.tab,
//             //           ),
//             //         ),
//             //         topForYou == null
//             //             ? Container()
//             //             : Expanded(
//             //                 child: TabBarView(
//             //                   controller: _tabController2,
//             //                   children: [
//             //                     ListView(
//             //                       shrinkWrap: true,
//             //                       children: [
//             //                         SizedBox(height: 15),
//             //                         Text(
//             //                           'What your friends are streaming this week. Invite more friends to Oneflix to get more recommendations from them.',
//             //                           textAlign: TextAlign.center,
//             //                           style: TextStyle(
//             //                             fontSize: 12,
//             //                             fontWeight: FontWeight.bold,
//             //                             fontFamily: 'OpenSans',
//             //                             color: Colors.white,
//             //                           ),
//             //                         ),
//             //                         SizedBox(height: 15),
//             //                         CarouselSlider.builder(
//             //                           options: CarouselOptions(
//             //                             height: 550,
//             //                             viewportFraction: 1.0,
//             //                             // enlargeCenterPage: true,
//             //                             autoPlay: true,
//             //                             enableInfiniteScroll: false,
//             //                           ),
//             //                           itemCount: topForYou.length,
//             //                           itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => Container(
//             //                             child: GestureDetector(
//             //                               onTap: () {
//             //                                 Navigator.push(
//             //                                   context,
//             //                                   MaterialPageRoute(
//             //                                     builder: (context) => PostContentScreen(
//             //                                       contentTPId: topForYou[itemIndex]['content_third_party_id'],
//             //                                       contentID: topForYou[itemIndex]['content_id'],
//             //                                       contentType: topForYou[itemIndex]['content_type'],
//             //                                     ),
//             //                                   ),
//             //                                 );
//             //                               },
//             //                               child: SingleChildScrollView(
//             //                                 child: Column(
//             //                                   mainAxisAlignment: MainAxisAlignment.start,
//             //                                   children: [
//             //                                     Stack(
//             //                                       alignment: Alignment.center,
//             //                                       children: [
//             //                                         topForYou[itemIndex]['content_photo'] == null
//             //                                             ? Container()
//             //                                             : Container(
//             //                                                 height: 452,
//             //                                                 width: 270,
//             //                                                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white)),
//             //                                                 child: ClipRRect(
//             //                                                   borderRadius: BorderRadius.circular(6),
//             //                                                   child: CachedImage(
//             //                                                     imageUrl: 'https://image.tmdb.org/t/p/original/${topForYou[itemIndex]['content_photo']}',
//             //                                                     height: 450,
//             //                                                     width: 270,
//             //                                                     colors: Colors.white,
//             //                                                     fit: BoxFit.cover,
//             //                                                   ),
//             //                                                 ),
//             //                                               ),
//             //                                         streamingTopForYouIDs[itemIndex] == 203 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 26 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 372 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 157 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 387 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 444 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 388 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 389 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 371 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 445 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 248 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 232 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 296 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 391
//             //                                             ? Positioned(
//             //                                                 top: 16,
//             //                                                 left: 10,
//             //                                                 child: Image.asset(
//             //                                                   '$TRENDING_URL/${streamingTopForYouIDs[itemIndex] == 203 ? 'NetflixNew' : streamingTopForYouIDs[itemIndex] == 26 ? 'AmazonPrime' : streamingTopForYouIDs[itemIndex] == 372 ? 'Disney' : streamingTopForYouIDs[itemIndex] == 157 ? 'Hulu' : streamingTopForYouIDs[itemIndex] == 387 ? 'HBOMax' : streamingTopForYouIDs[itemIndex] == 444 ? 'Paramount' : streamingTopForYouIDs[itemIndex] == 388 || streamingTopForYouIDs[itemIndex] == 389 ? 'Peacock' : streamingTopForYouIDs[itemIndex] == 371 ? 'AppleTV' : streamingTopForYouIDs[itemIndex] == 445 ? 'DiscoveryPlus' : streamingTopForYouIDs[itemIndex] == 248 ? 'Showtime' : streamingTopForYouIDs[itemIndex] == 232 ? 'Starz' : streamingTopForYouIDs[itemIndex] == 296 ? 'Tubi' : streamingTopForYouIDs[itemIndex] == 391 ? 'Pluto' : ' '}.png',
//             //                                                   height: 40,
//             //                                                 ),
//             //                                               )
//             //                                             : Positioned(
//             //                                                 top: 16,
//             //                                                 left: 10,
//             //                                                 child: Container(),
//             //                                               ),
//             //                                         Positioned(
//             //                                           bottom: 25,
//             //                                           right: 15,
//             //                                           child: Container(
//             //                                             decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(42)),
//             //                                             child: CircularPercentIndicator(
//             //                                               radius: 42.0,
//             //                                               lineWidth: 2.0,
//             //                                               percent: double.tryParse(topForYou[itemIndex]['vote_average'])! / 10,
//             //                                               center: AppText((double.tryParse(topForYou[itemIndex]['vote_average'])! * 10).toInt().toString() + "%",
//             //                                                   color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12),
//             //                                               progressColor: Colors.greenAccent,
//             //                                               backgroundColor: Colors.black,
//             //                                               circularStrokeCap: CircularStrokeCap.round,
//             //                                             ),
//             //                                           ),
//             //                                         ),
//             //                                       ],
//             //                                     ),
//             //                                     SizedBox(height: 20),
//             //                                     TopForYouTile(
//             //                                       name: topForYou[itemIndex]['total_rec'] - 1 != 0
//             //                                           ? '${topForYou[itemIndex]['first_rec_user_name']} and ${topForYou[itemIndex]['total_rec'] - 1} ${topForYou[itemIndex]['total_rec'] == 1 ? 'other' : 'others'}'
//             //                                           : '${topForYou[itemIndex]['first_rec_user_name']}',
//             //                                       profile: topForYou[itemIndex]['first_rec_profile_pic'],
//             //                                       onTap: () {
//             //                                         Navigator.push(
//             //                                           context,
//             //                                           MaterialPageRoute(
//             //                                             builder: (context) => PostContentScreen(
//             //                                               contentTPId: topForYou[itemIndex]['content_third_party_id'],
//             //                                               contentID: topForYou[itemIndex]['content_id'],
//             //                                               contentType: topForYou[topForYou]['content_type'],
//             //                                             ),
//             //                                           ),
//             //                                         );
//             //                                       },
//             //                                     )
//             //                                   ],
//             //                                 ),
//             //                               ),
//             //                             ),
//             //                           ),
//             //                         ),
//             //                         contactsPermission == false
//             //                             ? AlertBox(
//             //                                 buttonText: 'FIND YOUR FRIENDS',
//             //                                 description: 'Oneflix is better with your friends. Enable your phone Contacts to find your friends already on Oneflix.',
//             //                                 descFontSize: 13,
//             //                                 fontWeight: FontWeight.bold,
//             //                                 onTap: () async {
//             //                                   await requestContactPermission();
//             //                                   if (contactsPermission == false) {
//             //                                     openAppSettings();
//             //                                   }
//             //                                 },
//             //                                 child: Image.asset('assets/images/Oneflix GPS.png', fit: BoxFit.cover),
//             //                               )
//             //                             : AlertBox(
//             //                                 buttonText: 'INVITE YOUR FRIENDS',
//             //                                 description:
//             //                                     'Oneflix is better with your friends. Invite your friends to Oneflix so you can discover what they\'re streaming and recommend content to each other.',
//             //                                 descFontSize: 13,
//             //                                 fontWeight: FontWeight.bold,
//             //                                 onTap: () {
//             //                                   Share.share('Join me on Oneflix to share and discuss the best content on streaming. https://oneflix.app/');
//             //                                 },
//             //                                 child: Image.asset('assets/images/Oneflix Social.png', fit: BoxFit.cover),
//             //                               )
//             //                         // Expanded(
//             //                         //   child: ListView.separated(
//             //                         //     physics: BouncingScrollPhysics(),
//             //                         //     shrinkWrap: true,
//             //                         //     scrollDirection: Axis.vertical,
//             //                         //     itemCount: topForYou.length,
//             //                         //     itemBuilder: (context, index) {
//             //                         //       return TopForYouTile(
//             //                         //         image: topForYou[index]['content_photo'],
//             //                         //         name: topForYou[index]['total_rec'] != 0
//             //                         //             ? '${topForYou[index]['first_rec_user_name']} and ${topForYou[index]['total_rec']} ${topForYou[index]['total_rec'] == 1 ? 'other' : 'others'}'
//             //                         //             : '${topForYou[index]['first_rec_user_name']}',
//             //                         //         profile: topForYou[index]['first_rec_profile_pic'],
//             //                         //         onTap: () {
//             //                         //           Navigator.push(
//             //                         //             context,
//             //                         //             MaterialPageRoute(
//             //                         //               builder: (context) => PostContentScreen(
//             //                         //                 contentTPId: topForYou[index]['content_third_party_id'],
//             //                         //                 contentID: topForYou[index]['content_id'],
//             //                         //               ),
//             //                         //             ),
//             //                         //           );
//             //                         //         },
//             //                         //       );
//             //                         //     },
//             //                         //     separatorBuilder: (context, index) {
//             //                         //       return (index + 1) == 2
//             //                         //           ? contactsPermission == false
//             //                         //               ? AlertBox(
//             //                         //                   buttonText: 'FIND YOUR FRIENDS',
//             //                         //                   description:
//             //                         //                       'Connect with your friends already on Oneflix to discover what they’re streaming and recommend content with each other.',
//             //                         //                   descFontSize: 13,
//             //                         //                   fontWeight: FontWeight.bold,
//             //                         //                   onTap: () async {
//             //                         //                     await requestContactPermission();
//             //                         //                     if (contactsPermission == false) {
//             //                         //                       openAppSettings();
//             //                         //                     }
//             //                         //                   },
//             //                         //                   child: Image.asset('$IMG_URL/pinnedmap.png', fit: BoxFit.cover),
//             //                         //                 )
//             //                         //               : AlertBox(
//             //                         //                   buttonText: 'INVITE YOUR FRIENDS',
//             //                         //                   description:
//             //                         //                       'Invite your friends to Oneflix so you can discover what they’re streaming and recommend content with each other.',
//             //                         //                   descFontSize: 13,
//             //                         //                   fontWeight: FontWeight.bold,
//             //                         //                   onTap: () {
//             //                         //                     Share.share('Join me on Oneflix, a streaming + social media app. https://oneflix.app/');
//             //                         //                   },
//             //                         //                   child: Image.asset('$IMG_URL/friends.jpg', fit: BoxFit.cover),
//             //                         //                 )
//             //                         //           : Container();
//             //                         //     },
//             //                         //   ),
//             //                         // ),
//             //                       ],
//             //                     ),
//             //                     ListView(
//             //                       shrinkWrap: true,
//             //                       children: [
//             //                         SizedBox(height: 15),
//             //                         Text(
//             //                           'The most popular content that your friends have recommended to you.' /*'Everything that your friends recommended to you since you joined Oneflix.'*/,
//             //                           textAlign: TextAlign.center,
//             //                           style: TextStyle(
//             //                             fontSize: 12,
//             //                             fontWeight: FontWeight.bold,
//             //                             fontFamily: 'OpenSans',
//             //                             color: Colors.white,
//             //                           ),
//             //                         ),
//             //                         SizedBox(height: 15),
//             //                         CarouselSlider.builder(
//             //                           options: CarouselOptions(
//             //                             height: 550,
//             //                             viewportFraction: 1.0,
//             //                             // enlargeCenterPage: true,
//             //                             autoPlay: true,
//             //                             enableInfiniteScroll: false,
//             //                           ),
//             //                           itemCount: topForYou.length,
//             //                           itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => Container(
//             //                             child: GestureDetector(
//             //                               onTap: () {
//             //                                 Navigator.push(
//             //                                   context,
//             //                                   MaterialPageRoute(
//             //                                     builder: (context) => PostContentScreen(
//             //                                       contentTPId: topForYou[itemIndex]['content_third_party_id'],
//             //                                       contentID: topForYou[itemIndex]['content_id'],
//             //                                       contentType: topForYou[itemIndex]['content_type'],
//             //                                     ),
//             //                                   ),
//             //                                 );
//             //                               },
//             //                               child: SingleChildScrollView(
//             //                                 child: Column(
//             //                                   mainAxisAlignment: MainAxisAlignment.start,
//             //                                   children: [
//             //                                     Stack(
//             //                                       alignment: Alignment.center,
//             //                                       children: [
//             //                                         Container(
//             //                                           height: 452,
//             //                                           width: 270,
//             //                                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white)),
//             //                                           child: ClipRRect(
//             //                                             borderRadius: BorderRadius.circular(6),
//             //                                             child: CachedImage(
//             //                                               imageUrl: 'https://image.tmdb.org/t/p/original/${topForYou[itemIndex]['content_photo']}',
//             //                                               height: 450,
//             //                                               width: 270,
//             //                                               fit: BoxFit.cover,
//             //                                             ),
//             //                                           ),
//             //                                         ),
//             //                                         streamingTopForYouIDs[itemIndex] == 203 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 26 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 372 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 157 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 387 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 444 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 388 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 389 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 371 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 445 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 248 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 232 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 296 ||
//             //                                                 streamingTopForYouIDs[itemIndex] == 391
//             //                                             ? Positioned(
//             //                                                 top: 16,
//             //                                                 left: 10,
//             //                                                 child: Image.asset(
//             //                                                   '$TRENDING_URL/${streamingTopForYouIDs[itemIndex] == 203 ? 'NetflixNew' : streamingTopForYouIDs[itemIndex] == 26 ? 'AmazonPrime' : streamingTopForYouIDs[itemIndex] == 372 ? 'Disney' : streamingTopForYouIDs[itemIndex] == 157 ? 'Hulu' : streamingTopForYouIDs[itemIndex] == 387 ? 'HBOMax' : streamingTopForYouIDs[itemIndex] == 444 ? 'Paramount' : streamingTopForYouIDs[itemIndex] == 388 ? 'Peacock' : streamingTopForYouIDs[itemIndex] == 371 ? 'AppleTV' : streamingTopForYouIDs[itemIndex] == 445 ? 'DiscoveryPlus' : streamingTopForYouIDs[itemIndex] == 248 ? 'Showtime' : streamingTopForYouIDs[itemIndex] == 232 ? 'Starz' : streamingTopForYouIDs[itemIndex] == 296 ? 'Tubi' : streamingTopForYouIDs[itemIndex] == 391 ? 'Pluto' : ' '}.png',
//             //                                                   height: 40,
//             //                                                 ),
//             //                                               )
//             //                                             : Positioned(top: 16, left: 10, child: Container()),
//             //                                         Positioned(
//             //                                           bottom: 25,
//             //                                           right: 15,
//             //                                           child: Container(
//             //                                             decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(42)),
//             //                                             child: CircularPercentIndicator(
//             //                                               radius: 42.0,
//             //                                               lineWidth: 2.0,
//             //                                               percent: double.tryParse(topForYou[itemIndex]['vote_average'])! / 10,
//             //                                               center: AppText((double.tryParse(topForYou[itemIndex]['vote_average'])! * 10).toInt().toString() + "%",
//             //                                                   color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12),
//             //                                               progressColor: Colors.greenAccent,
//             //                                               backgroundColor: Colors.black,
//             //                                               circularStrokeCap: CircularStrokeCap.round,
//             //                                             ),
//             //                                           ),
//             //                                         ),
//             //                                       ],
//             //                                     ),
//             //                                     SizedBox(height: 20),
//             //                                     TopForYouTile(
//             //                                       name: topForYou[itemIndex]['total_rec'] - 1 != 0
//             //                                           ? '${topForYou[itemIndex]['first_rec_user_name']} and ${topForYou[itemIndex]['total_rec'] - 1} ${topForYou[itemIndex]['total_rec'] - 1 == 1 ? 'other' : 'others'}'
//             //                                           : '${topForYou[itemIndex]['first_rec_user_name']}',
//             //                                       profile: topForYou[itemIndex]['first_rec_profile_pic'],
//             //                                       onTap: () {
//             //                                         Navigator.push(
//             //                                           context,
//             //                                           MaterialPageRoute(
//             //                                             builder: (context) => PostContentScreen(
//             //                                               contentTPId: topForYou[itemIndex]['content_third_party_id'],
//             //                                               contentID: topForYou[itemIndex]['content_id'],
//             //                                               contentType: topForYou[itemIndex]['content_type'],
//             //                                             ),
//             //                                           ),
//             //                                         );
//             //                                       },
//             //                                     )
//             //                                   ],
//             //                                 ),
//             //                               ),
//             //                             ),
//             //                           ),
//             //                         ),
//             //                         contactsPermission == false
//             //                             ? AlertBox(
//             //                                 buttonText: 'FIND YOUR FRIENDS',
//             //                                 description: 'Oneflix is better with your friends. Enable your phone Contacts to find your friends already on Oneflix.',
//             //                                 descFontSize: 13,
//             //                                 fontWeight: FontWeight.bold,
//             //                                 onTap: () async {
//             //                                   await requestContactPermission();
//             //                                   if (contactsPermission == false) {
//             //                                     openAppSettings();
//             //                                   }
//             //                                 },
//             //                                 child: Image.asset('assets/images/Oneflix GPS.png', fit: BoxFit.cover),
//             //                               )
//             //                             : AlertBox(
//             //                                 buttonText: 'INVITE YOUR FRIENDS',
//             //                                 description:
//             //                                     'Oneflix is better with your friends. Invite your friends to Oneflix so you can discover what they\'re streaming and recommend content to each other.',
//             //                                 descFontSize: 13,
//             //                                 fontWeight: FontWeight.bold,
//             //                                 onTap: () {
//             //                                   Share.share('Join me on Oneflix to share and discuss the best content on streaming. https://oneflix.app/');
//             //                                 },
//             //                                 child: Image.asset('assets/images/Oneflix Social.png', fit: BoxFit.cover),
//             //                               ),
//             //
//             //                         //     },
//             //                         //   ),
//             //                         // ),
//             //                       ],
//             //                     ),
//             //                   ],
//             //                 ),
//             //               ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   bool validate() {
//     if (projectIdList.length == 0) {
//       Toasty.showtoast('Please select at least one streaming service');
//       return false;
//     } else {
//       return true;
//     }
//   }
//
//   var userID;
//   String city = '';
//   String state = '';
//   String country = '';
//   _updateProfile(int type) async {
//     var jsonData;
//     InitialData getLocation = InitialData();
//     if (type == 1) {
//       await getLocation.getCurrentLocation();
//       await getAddressFromLatLng(lat: getLocation.latitude, lng: getLocation.longitude, mapApiKey: 'AIzaSyCp4l1LbSEK9pyTaq-GbIlNY_Pkqpt0uus');
//     }
//
//     try {
//       var response = await Dio().post(
//         UPDATE_PROFILE,
//         options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
//         data: type == 1
//             ? {
//           'lattitude': getLocation.latitude!,
//           'longitude': getLocation.longitude!,
//           'country': country,
//           'state': state,
//           'city': city,
//         }
//             : {},
//       );
//       print(response);
//       if (response.statusCode == 200) {
//         if (!mounted) return;
//         setState(() {
//           jsonData = jsonDecode(response.toString());
//         });
//         if (jsonData != null) {
//           if (!mounted) return;
//           setState(() {
//             userID = jsonData['data']['id'];
//           });
//         }
//       } else {
//         Toasty.showtoast('Something Went Wrong');
//       }
//     } on DioError catch (e) {
//       print(e.response.toString());
//     }
//   }
//
//   getAddressFromLatLng({double? lat, double? lng, String? mapApiKey}) async {
//     String _host = 'https://maps.google.com/maps/api/geocode/json';
//     final url = '$_host?key=$mapApiKey&language=en&latlng=$lat,$lng';
//     if (lat != null && lng != null) {
//       var response = await Dio().getUri((Uri.parse(url)));
//       if (response.statusCode == 200) {
//         String _formattedAddress;
//         if (!mounted) return;
//         setState(() {
//           Map data = jsonDecode(response.toString());
//           _formattedAddress = data["results"][0]["formatted_address"];
//           var split = _formattedAddress.split(',');
//           city = split[split.length - 3].trimLeft();
//           country = split[split.length - 1].trimLeft();
//           List<String> strings = split[split.length - 2].split(" ");
//           var res = strings.where((element) => element != strings.first);
//           state = res.elementAt(0);
//         });
//         print(city);
//         print(state);
//         print(country);
//       } else
//         return null;
//     } else
//       return null;
//   }
// }
//
// class TrendingContent extends StatelessWidget {
//   final String rank;
//   final content;
//   final provider;
//   final onTap;
//
//   TrendingContent({required this.rank, required this.content, required this.provider, this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     double mWidth = MediaQuery.of(context).size.width;
//     double mHeight = MediaQuery.of(context).size.height;
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         // shrinkWrap: true,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Image.asset('assets/icons/$rank.png', height: 50, width: 70),
//           SizedBox(height: 14),
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(6),
//                 child: CachedImage(
//                   imageUrl: 'https://image.tmdb.org/t/p/original/$content',
//                   height: 330,
//                   width: 230,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               provider == 203 ||
//                   provider == 26 ||
//                   provider == 372 ||
//                   provider == 157 ||
//                   provider == 387 ||
//                   provider == 444 ||
//                   provider == 388 ||
//                   provider == 389 ||
//                   provider == 371 ||
//                   provider == 445 ||
//                   provider == 248 ||
//                   provider == 232 ||
//                   provider == 296 ||
//                   provider == 391
//                   ? Positioned(
//                 top: 16,
//                 right: 10,
//                 child: Image.asset(
//                   '$TRENDING_URL/${provider == 203 ? 'NetflixNew' : provider == 26 ? 'AmazonPrime' : provider == 372 ? 'Disney' : provider == 157 ? 'Hulu' : provider == 387 ? 'HBOMax' : provider == 444 ? 'Paramount' : provider == 388 ? 'Peacock' : provider == 371 ? 'AppleTV' : provider == 445 ? 'DiscoveryPlus' : provider == 248 ? 'Showtime' : provider == 232 ? 'Starz' : provider == 296 ? 'Tubi' : provider == 391 ? 'Pluto' : ' '}.png',
//                   height: 40,
//                 ),
//               )
//                   : Container()
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class NoEnoughDataWarning extends StatelessWidget {
//   const NoEnoughDataWarning({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Image.asset('assets/icons/Group 51712.png', height: 220, width: 300),
//         SizedBox(height: 20),
//         Text(
//           'Oh-uh! Looks like there are not enough users or data signals for this location at the moment. Please check back in a few hours.',
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 12, color: kPrimaryColor),
//         ),
//       ],
//     );
//   }
// }
//
// class InviteYourFriendsDialog extends StatelessWidget {
//   const InviteYourFriendsDialog({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [],
//       ),
//     );
//   }
// }
