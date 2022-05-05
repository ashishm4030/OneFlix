import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:oneflix/Components/CustomWidgets.dart';
import 'package:oneflix/Components/LiveDot.dart';
import 'package:oneflix/Constants.dart';
import 'package:oneflix/InitialData.dart';
import 'package:oneflix/Screens/OnBoarding/NameScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreSettingsScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String bio;
  final profilePic;

  MoreSettingsScreen({required this.bio, required this.profilePic, required this.firstName, required this.lastName});

  @override
  _MoreSettingsScreenState createState() => _MoreSettingsScreenState();
}

class _MoreSettingsScreenState extends State<MoreSettingsScreen> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController bio = TextEditingController();

  String fileName = '';
  String? userToken;
  getToken() async {
    var user_token = await readData('user_token');
    setState(() {
      userToken = user_token;
    });
  }

  dynamic _pickImageError;
  File? _image;

  Future pickImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image

    try {
      var image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = File(image!.path);
        fileName = image.name;
      });
      print(_image);
      print(fileName);
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  @override
  void initState() {
    print(widget.firstName);
    print(widget.lastName);
    getToken();
    firstName = TextEditingController(text: widget.firstName);
    lastName = TextEditingController(text: widget.lastName);
    bio = TextEditingController(text: widget.bio);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      progressIndicator: SizedBox(height: 20, width: 20, child: kProgressIndicator),
      child: Scaffold(
        backgroundColor: Color(0xff011138),
        appBar: AppBar(
          backgroundColor: Color(0xff011138),
          leading: IconButton(
            icon: Icon(Icons.chevron_left_rounded, size: 38),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    widget.profilePic == '' || widget.profilePic == null || _image != null
                        ? _image == null
                            ? Container(
                                height: 90,
                                width: 90,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                                child: Image.asset('$ICON_URL/no_user.png', fit: BoxFit.cover),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.file(_image!, width: 90, height: 90, fit: BoxFit.cover),
                              )
                        : Container(
                            height: 90,
                            width: 90,
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(70),
                              child: CachedImage(imageUrl: widget.profilePic, height: 90, width: 90, isUserProfilePic: true),
                            ),
                          ),
                    GestureDetector(
                      onTap: pickImage,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText('Change Picture', fontSize: 15),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),
                      ProfileTextField(controller: firstName, title: 'First Name'),
                      SizedBox(height: 40),
                      ProfileTextField(controller: lastName, title: 'Last Name'),
                      SizedBox(height: 40),
                      ProfileTextField(
                        controller: bio,
                        title: 'Bio',
                        maxLines: 3,
                        textInputType: TextInputType.multiline,
                      ),
                      SizedBox(height: 40),
                      Column(
                        children: [
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton2(
                                title: 'Save Changes'.toUpperCase(),
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                horizontalPadding: 50,
                                borderRadius: 10,
                                height: 55,
                                onPressed: () async {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  if (validate()) {
                                    await _userProfile();
                                  }
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          GestureDetector(onTap: _logout, child: AppText('Logout'.toUpperCase(), fontSize: 20, fontWeight: FontWeight.w900, color: Colors.orange)),
                          SizedBox(height: 20),
                        ],
                      )
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

  validate() {
    if (firstName.text.isEmpty) {
      Toasty.showtoast('First Name cannot be Empty');
      return false;
    }
    if (lastName.text.isEmpty) {
      Toasty.showtoast('Last Name cannot be Empty');
      return false;
    } else {
      return true;
    }
  }

  bool _loading = false;
  String deviceID = '';
  getDeviceData() async {
    InitialData deviceInfo = InitialData();
    await deviceInfo.getDeviceTypeId();
    deviceID = deviceInfo.deviceID!;
  }

  var userID;
  String profilePic = '';
  _userProfile() async {
    var jsonData;
    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        UPDATE_PROFILE,
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
        data: FormData.fromMap({
          'profile_pic': _image == null ? '' : await MultipartFile.fromFile(_image!.path, filename: fileName),
          'first_name': firstName.text,
          'last_name': lastName.text,
          'bio': bio.text,
        }),
      );
      print(response);
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData != null) {
          Navigator.pop(context);
        }
      } else {
        Toasty.showtoast('Something Went Wrong');
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
  }

  _logout() async {
    await getDeviceData();
    var userToken = await readData('user_token');
    var jsonData;
    setState(() {
      _loading = true;
    });
    try {
      var response = await Dio().post(
        LOGOUT,
        data: {'device_id': deviceID},
        options: Options(headers: {"Accept": "application/json", 'Authorization': 'Bearer $userToken'}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          await FirebaseAuth.instance.signOut();
          await FirebaseMessaging.instance.deleteToken();
          await removeData('user_token');
          await removeData('device_token');

          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NameScreen()), (route) => false);
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

  Future<void> _launchInBrowser(String url) async {
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
}

class ProfileTextField extends StatelessWidget {
  final String title;
  final TextInputType textInputType;
  final int maxLines;
  final TextEditingController controller;
  final List<TextInputFormatter> inputFormatters;

  const ProfileTextField({
    Key? key,
    required this.title,
    this.textInputType = TextInputType.text,
    this.maxLines = 1,
    required this.controller,
    this.inputFormatters = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(title, fontSize: 18),
        SizedBox(height: 20),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: textInputType,
          inputFormatters: inputFormatters,
          style: TextStyle(color: Colors.white, fontFamily: 'OpenSans', fontSize: 14),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
      ],
    );
  }
}
