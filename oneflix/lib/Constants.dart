import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

const String IMG_URL = 'assets/images';
const String PROVIDER_URL = 'assets/providers';
const String TRENDING_URL = 'assets/trendingpro';
const String ICON_URL = 'assets/icons';

const Color kPrimaryColor = Color(0xffFF4F00);
// const Color kPrimaryColor2 = Color(0xff030819);
const Color kPrimaryColor2 = Color(0xff0F1620);

const kProgressIndicator = CircularProgressIndicator(color: Colors.blue, strokeWidth: 3);
const kProgressIndicatorThin = SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.blue, strokeWidth: 1));

///APIs

//URLS
const BASE_URL = 'https://oneflixapp.com/oneflix';
const API_URL = 'https://oneflixapp.com/oneflix/api';

///AUTH
const CHECK_USERNAME = '$API_URL/check_username';
const LOGIN = '$API_URL/login';
const LOGOUT = '$API_URL/logout';
const SIGNUP = '$API_URL/sign_up';
const UPDATE_DEVICE_TOKEN = '$API_URL/add_device_info';
const DUMMY_CHECK_NUMBER = '$API_URL/dummy_user_check';

///HOME
const HOME_DATA = '$API_URL/GetHomePageActivity';
const ADD_LIKE_ON_POST = '$API_URL/AddToLikes';
const ADD_LIKE_ON_COMMENT = '$API_URL/LikeToComment';
const ADD_COMMENT_ON_POST = '$API_URL/AddComment';
const EDIT_COMMENT = '$API_URL/editComment';
const NEAR_BY_FRIENDS = '$API_URL/GetNearByFriendsList';
const GET_PEOPLE_YOU_MAY_KNOW = '$API_URL/GetPeopleYouMayKnow';
const ADD_CONTACT = '$API_URL/add_contact_diary';
const GET_CONTENT_DETAILS = '$API_URL/GetContentDetails';
const GET_NOTIFICATION_COUNT = '$API_URL/GetNotificationCount';
const GET_ACTIVE_USER_COUNT = '$API_URL/get_live_count';
const CONTENT_RECOMMENDED_USER_LIST = '$API_URL/ContentRecommendedUserList';
const REPORT_POST = '$API_URL/report_content';

// https://oneflixapp.com/oneflix/api/report_content
///SEARCH
const USER_SEARCH = '$API_URL/GetUserSearch';
var activeUserCount;

///TRENDING
const TOP_10_TRENDING = '$API_URL/Top10Trending';
const TOP_FOR_YOU = '$API_URL/GetTopForYou';
const GET_NEW_POPULAR_DATA_IN_TRENDING = '$API_URL/GetbestNewDate';
const GET_GENERS_DATA = '$API_URL/GetGenersData';
const GET_NEWLY_DATA = '$API_URL/GetNewlyData';
const GET_PROVIDER_HUB_DATA = '$API_URL/GetProviderGetListv1';
const GET_SOURCE_DATA = '$API_URL/GetSourceList';
const SELETED_SOURCE_DATA = '$API_URL/AddSelectedSource';
const TREDING_DICUSSION = '$API_URL/TrendingDiscussions';

///DISCOVER
// const GET_DISCOVER_CONTENT = '$API_URL/GetDiscoverContent';
const GET_DISCOVER_CONTENT = '$API_URL/get_free_data';
const GET_DISCOVER_CONTENT_FOR_YOU = '$API_URL/GetForYouData';
const TV_MOVIE_SEARCH = '$API_URL/TvMovieSearchApi';

///CONTENT PAGE
const GET_MOVIES_TV_DETAILS = '$API_URL/GetMoviesTvDetails';
const ADD_TO_RECOMMENDED = '$API_URL/AddToRecommended';
const ADD_TO_VIEWED = '$API_URL/AddToviewed';
const ADD_TO_WATCHLIST = '$API_URL/AddToWatchList';
const UPDATE_SOURCE_IMPRESSIONS = '$API_URL/added_to_watch';
const OTHER_COMMENTS_LIST = '$API_URL/other_comment_pagination_data';
const FRIENDS_COMMENTS_LIST = '$API_URL/friend_comment_pagination_data';
const REPORT_COMMENT = '$API_URL/report_comment';

///WATCHLIST
const GET_WATCHLIST_CONTENT = '$API_URL/GetMywatchList';

///PROFILE
const UPDATE_PROFILE = '$API_URL/edit_profile';
const GET_USER_PROFILE = '$API_URL/GetUserProfile';
const FOLLOW_USER = '$API_URL/AddToMyFollow';
const GET_FOLLOW_USER_LIST = '$API_URL/GetUserfollowersFollowing';
const ACTION_ON_USER = '$API_URL/ActionOnUser';

///NOTIFICATIONS
const GET_NOTIFICATIONS = '$API_URL/MyNotifications';
const UPDATE_NOTIFICATION = '$API_URL/UpdateNotifications';

// const GET_TOP10_TRENDING_DATA = '$API_URL/GetToptrendingData';
const YOUR_FRIENDS_STREAMING = '$API_URL/GetWhatYouFriendStreaming';
const GET_COMING_SOON_DATA = '$API_URL/GetComingSoonStreaming';
const GET_ARRIVED_THIS_WEEK_DATA = '$API_URL/GetArrivedThisWeek';
const GET_ARRIVED_DATA = '$API_URL/Arrived_Row';
const GET_BIGGEST_EVENT_DATA = '$API_URL/GetBiggestEvent';
const GET_PROVIDER_NAME = '$API_URL/GetProviderNames';

String formatDate(DateTime date) => new DateFormat("yyyy").format(date);

Future writeData(String? key, dynamic value) async {
  final getX = GetStorage();
  getX.write(key!, value);
}

readData(String? key) async {
  final getX = GetStorage();
  final data = getX.read(key!);
  return data;
}

removeData(String? key) async {
  final getX = GetStorage();
  final data = getX.remove(key!);
  return data;
}

final kOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: BorderSide(color: Colors.white60, width: 1.0),
);
final kCommentFiledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(30),
  borderSide: BorderSide(color: Color(0xffebedf0), width: 1.0),
);
final kCommentFiledBorder1 = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.white, width: 1.0),
);

class Toasty {
  static showtoast(String message, {int second = 1}) {
    Fluttertoast.showToast(
      timeInSecForIosWeb: second,
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      backgroundColor: Colors.black.withOpacity(0.5),
    );
  }
}
