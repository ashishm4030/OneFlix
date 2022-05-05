import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneflix/Constants.dart';

class AppText extends StatelessWidget {
  final String text;
  final String fontFamily;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final double? letterSpacing;
  final double? height;
  final TextDecoration textDecoration;
  final TextAlign textAlign;
  final int maxLines;
  final FontStyle fontStyle;
  final decorationStyle;
  final decorationColor;
  final decorationThickness;
  AppText(
    this.text, {
    this.fontSize = 14,
    this.color = Colors.white,
    this.fontWeight = FontWeight.w300,
    this.fontFamily = 'OpenSans',
    this.letterSpacing,
    this.textDecoration = TextDecoration.none,
    this.textAlign = TextAlign.start,
    this.height = 1.4,
    this.maxLines = 100,
    this.fontStyle = FontStyle.normal,
    this.decorationStyle,
    this.decorationColor,
    this.decorationThickness,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        overflow: TextOverflow.ellipsis,
        height: height,
        color: color,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        decoration: textDecoration,
        decorationStyle: decorationStyle,
        decorationColor: decorationColor,
        decorationThickness: decorationThickness,
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  CustomTextField({
    this.controller,
    this.input,
    this.label = '',
    this.maxLines,
    this.fieldHeight = 70,
    this.focusNode,
    this.hintText,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.initialValue,
    this.readOnly = false,
    this.suffix,
    this.prefixIcon = '',
    this.suffixVisibility = false,
    this.obscureText = false,
    this.hintFontSize = 22,
    this.contentPadding = 5,
    this.onSubmit,
  });

  final TextEditingController? controller;
  final TextInputType? input;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final String? label;
  final String? prefixIcon;
  final int? maxLines;
  final double fieldHeight;
  final double contentPadding;
  final double hintFontSize;
  final FocusNode? focusNode;
  final String? hintText;
  final Function()? onTap;
  final String? initialValue;
  final bool readOnly;
  final Widget? suffix;
  final onSubmit;
  bool suffixVisibility;
  bool obscureText;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  toggle() {
    setState(() {
      widget.obscureText = !widget.obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.fieldHeight,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: TextField(
        onSubmitted: widget.onSubmit,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.center,
        obscureText: widget.obscureText,
        obscuringCharacter: '*',
        readOnly: widget.readOnly,
        cursorColor: Colors.black,
        focusNode: widget.focusNode,
        maxLines: widget.maxLines,
        controller: widget.controller,
        keyboardType: widget.input,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        inputFormatters: widget.inputFormatters,
        style: TextStyle(color: Colors.black, fontFamily: 'OpenSans', fontSize: 22, fontWeight: FontWeight.w900),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: widget.contentPadding),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey, fontFamily: 'OpenSans', fontSize: widget.hintFontSize, fontWeight: FontWeight.w900),
          border: kOutlineInputBorder,
          focusedBorder: kOutlineInputBorder,
          enabledBorder: kOutlineInputBorder,
          errorBorder: kOutlineInputBorder,
          focusedErrorBorder: kOutlineInputBorder,
        ),
      ),
    );
  }
}

class CustomTextField1 extends StatefulWidget {
  CustomTextField1({
    this.controller,
    this.input,
    this.label = '',
    this.maxLines,
    this.fieldHeight = 54,
    this.focusNode,
    this.hintText,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.initialValue,
    this.readOnly = false,
    this.suffix,
    this.prefixIcon = '',
    this.suffixVisibility = false,
    this.obscureText = false,
    required this.hintStyle,
    this.textAlign = TextAlign.left,
  });

  final TextEditingController? controller;
  final TextInputType? input;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final String? label;
  final String? prefixIcon;
  final int? maxLines;
  final double fieldHeight;
  final TextAlign textAlign;
  final FocusNode? focusNode;
  final String? hintText;
  final Function()? onTap;
  final String? initialValue;
  final bool readOnly;
  final Widget? suffix;
  final TextStyle hintStyle;
  bool suffixVisibility;
  bool obscureText;

  @override
  _CustomTextField1State createState() => _CustomTextField1State();
}

class _CustomTextField1State extends State<CustomTextField1> {
  toggle() {
    setState(() {
      widget.obscureText = !widget.obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(widget.label!, fontWeight: FontWeight.w300, fontSize: 13),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: widget.fieldHeight,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: TextField(
              textAlign: widget.textAlign,
              textAlignVertical: TextAlignVertical.center,
              obscureText: widget.obscureText,
              obscuringCharacter: '*',
              readOnly: widget.readOnly,
              cursorColor: Colors.black,
              focusNode: widget.focusNode,
              maxLines: widget.maxLines,
              controller: widget.controller,
              keyboardType: widget.input,
              onChanged: widget.onChanged,
              onTap: widget.onTap,
              inputFormatters: widget.inputFormatters,
              style: TextStyle(color: Colors.black, fontFamily: 'OpenSans', fontSize: 16 /*, height: 1.8*/),
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 12.0, top: 4),
                  child: IconButton(
                    icon: Container(height: 20, alignment: Alignment.center, child: Image.asset('$ICON_URL/Discover.png', height: 22, width: 22)),
                    onPressed: () {},
                  ),
                ),
                isCollapsed: true,
                contentPadding: EdgeInsets.only(left: 10),
                hintText: widget.hintText,
                hintStyle: widget.hintStyle,
                border: kOutlineInputBorder,
                focusedBorder: kOutlineInputBorder,
                enabledBorder: kOutlineInputBorder,
                errorBorder: kOutlineInputBorder,
                focusedErrorBorder: kOutlineInputBorder,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class CommentField extends StatefulWidget {
  CommentField({
    this.controller,
    this.input,
    this.fieldHeight = 40,
    this.hintText,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.focusNode,
    this.onSend,
  });

  final TextEditingController? controller;
  final TextInputType? input;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final double fieldHeight;
  final String? hintText;
  final Function()? onTap;
  final focusNode;
  final onSend;

  @override
  _CommentFieldState createState() => _CommentFieldState();
}

class _CommentFieldState extends State<CommentField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: AutoSizeTextField(
                maxFontSize: 13,
                minFontSize: 13,
                controller: widget.controller,
                maxLines: null,
                focusNode: widget.focusNode,
                textAlign: TextAlign.left,
                cursorColor: Colors.black,
                keyboardType: widget.input,
                onChanged: widget.onChanged,
                onTap: widget.onTap,
                inputFormatters: widget.inputFormatters,
                style: TextStyle(color: Colors.black, fontFamily: 'OpenSans', fontSize: 13),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xffebedf0),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  hintText: 'Write a comment...',
                  hintStyle: TextStyle(color: Colors.grey, fontFamily: 'OpenSans', fontSize: 13),
                  border: kCommentFiledBorder,
                  focusedBorder: kCommentFiledBorder,
                  enabledBorder: kCommentFiledBorder,
                  errorBorder: kCommentFiledBorder,
                  focusedErrorBorder: kCommentFiledBorder,
                ),
              ),
            ),
            SizedBox(width: 4.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Material(
                type: MaterialType.transparency,
                borderRadius: BorderRadius.circular(30),
                child: SizedBox(
                  width: 40,
                  child: IconButton(
                    padding: EdgeInsets.symmetric(),
                    highlightColor: Colors.grey.shade100,
                    splashColor: Colors.grey.shade400,
                    splashRadius: 20,
                    onPressed: widget.onSend,
                    icon: Image.asset('$ICON_URL/send.png', width: 22.0, height: 22.0),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  final String title;
  final String icon;
  final double height;
  final double borderRadius;
  final onPressed;

  CustomButton({this.title = '', this.onPressed, this.icon = '', this.height = 65, this.borderRadius = 16.0});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Material(
        color: Colors.white.withOpacity(0.0),
        child: InkWell(
          onTap: onPressed,
          child: Ink(
            color: Colors.white,
            child: Container(
              height: height,
              width: MediaQuery.of(context).size.width * 0.42,
              child: Center(child: AppText(title, fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black)),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButton2 extends StatelessWidget {
  final String title;
  final String icon;
  final double height;
  final double borderRadius;
  final double horizontalPadding;
  final double fontSize;
  final Color bgColor;
  final Color fontColor;
  final onPressed;
  final fontWeight;

  const CustomButton2({
    this.title = '',
    this.onPressed,
    this.icon = '',
    this.height = 60,
    this.borderRadius = 16.0,
    this.fontWeight = FontWeight.bold,
    this.horizontalPadding = 10,
    this.fontSize = 22,
    this.bgColor = Colors.white,
    this.fontColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(borderRadius)),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: AppText(title, fontWeight: fontWeight, fontSize: fontSize, color: fontColor),
          ),
        ),
      ),
    );
  }
}

class SwitchButton extends StatelessWidget {
  SwitchButton({
    required this.selectedButton,
    required this.text,
    required this.onPressed,
    required this.bgColor,
    required this.textColor,
    this.fontSize = 20,
    this.height = 50,
    this.fontWeight = FontWeight.bold,
  });
  final int selectedButton;
  final String text;
  final void Function() onPressed;
  final bool bgColor;
  final Color textColor;
  final double fontSize;
  final double height;
  final FontWeight fontWeight;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 3, right: 3),
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            alignment: Alignment.center,
            child: AppText(text, color: textColor, fontSize: fontSize, fontWeight: fontWeight, fontFamily: 'OpenSans'),
            height: height,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: bgColor == true ? kPrimaryColor : Colors.transparent),
                //BoxShadow(color: bgColor == true ? Colors.white : Colors.transparent, spreadRadius: -2.0, blurRadius: 2.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CachedImage extends StatelessWidget {
  final String? imageUrl;
  final bool? isUserProfilePic;
  final double? width;
  final double? height;
  final double? loaderSize;
  final placeHolderColor;
  final BoxFit? fit;
  final double radius;
  final double thikness;
  final Color colors;
  const CachedImage(
      {Key? key,
      this.imageUrl,
      this.isUserProfilePic = false,
      this.width,
      this.height,
      this.loaderSize = 20,
      this.fit = BoxFit.cover,
      this.placeHolderColor = Colors.blue,
      this.radius = 0.0,
      this.colors = Colors.transparent,
      this.thikness = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: fit,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: fit),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: colors, width: thikness),
        ),
      ),
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: SizedBox(height: loaderSize, width: loaderSize, child: CircularProgressIndicator(color: placeHolderColor, strokeWidth: 1)),
      ),
      errorWidget: (context, url, error) => Image.asset(
        "$ICON_URL/${isUserProfilePic == true ? 'no_user' : 'no-image'}.png",
        height: height,
        width: width,
        fit: fit,
      ),
    );
  }
}

class CachedImage1 extends StatelessWidget {
  final String? imageUrl;
  final bool? isUserProfilePic;
  final double? width;
  final double? height;
  final double? loaderSize;
  final placeHolderColor;
  final BoxFit? fit;
  final double radius;
  final double thikness;
  final Color colors;
  const CachedImage1(
      {Key? key,
      this.imageUrl,
      this.isUserProfilePic = false,
      this.width,
      this.height,
      this.loaderSize = 20,
      this.fit = BoxFit.cover,
      this.placeHolderColor = Colors.blue,
      this.radius = 0.0,
      this.colors = Colors.transparent,
      this.thikness = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: fit,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: fit),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          border: Border.all(color: colors, width: thikness),
        ),
      ),
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: SizedBox(height: loaderSize, width: loaderSize, child: CircularProgressIndicator(color: placeHolderColor, strokeWidth: 1)),
      ),
      errorWidget: (context, url, error) => Image.asset(
        "$ICON_URL/${isUserProfilePic == true ? 'no_user' : 'no-image'}.png",
        height: height,
        width: width,
        fit: fit,
      ),
    );
  }
}

class CommentFrame extends StatefulWidget {
  CommentFrame({
    required this.name,
    required this.profile,
    required this.comment,
    required this.likeCounts,
    this.isSubComment = false,
    this.onLike,
    this.onComment,
    this.viewReply,
    this.countReply,
    this.lengthReply,
    this.onTap,
    this.totalLikeCount,
    this.isLiked = false,
    this.likeState,
    this.onEdit,
    this.isSubEditComment = false,
    this.userID,
    this.onMoreMenu,
  });

  final String name;
  final String profile;
  final String comment;
  final String likeCounts;
  final bool isSubComment;
  final bool isSubEditComment;
  final bool isLiked;
  final onLike;
  final likeState;
  final viewReply;
  final countReply;
  final lengthReply;
  final onComment;
  final onEdit;
  final int? userID;
  final onTap;
  final onMoreMenu;
  final totalLikeCount;

  @override
  _CommentFrameState createState() => _CommentFrameState();
}

class _CommentFrameState extends State<CommentFrame> {
  int? userID;
  var userid;

  getToken() async {
    var userId = await readData('user_id');
    setState(() {
      userID = userId;
    });
  }

  @override
  void initState() {
    getToken();
    userid = widget.userID;
    print('CountReply: ${widget.countReply}');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getToken();
    userid = widget.userID;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: /*!widget.isSubComment ? MainAxisAlignment.start :*/ MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: widget.onTap,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedImage(imageUrl: widget.profile, isUserProfilePic: true, height: 42, width: 42, loaderSize: 10),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: !widget.isSubComment ? MediaQuery.of(context).size.width - 74 : MediaQuery.of(context).size.width - 120,
                    padding: EdgeInsets.only(left: 10, top: 0, bottom: 5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Color(0xffebedf0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              child: SizedBox(height: 4, child: Icon(Icons.more_horiz_rounded, size: 20, color: Colors.black)),
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
                                                        onTap: widget.onMoreMenu,
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
                            SizedBox(width: 6),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: GestureDetector(
                              onTap: widget.onTap, child: AppText(widget.name, fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black, fontFamily: 'Roboto')),
                        ),
                        AppText(widget.comment, maxLines: 14, color: Colors.black, fontSize: 14, fontFamily: 'Roboto'),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: !widget.isSubComment ? MediaQuery.of(context).size.width - 80 : MediaQuery.of(context).size.width - 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            /* likeState == true
                                ? Container(height: 8, width: 8, margin: EdgeInsets.symmetric(horizontal: 14), alignment: Alignment.center, child: kProgressIndicatorThin)
                                : */
                            GestureDetector(
                              child: AppText(
                                widget.isLiked == false ? ' Like ' : ' Liked ',
                                fontWeight: FontWeight.bold,
                                color: widget.isLiked == false ? Colors.black : Color(0xff4c7ff7),
                                fontSize: 11,
                              ),
                              onTap: widget.onLike,
                            ),
                            !widget.isSubComment ? Icon(Icons.fiber_manual_record, size: 3, color: Colors.grey) : Container(),
                            GestureDetector(
                                child: AppText(!widget.isSubComment ? ' Reply ' : '', fontWeight: FontWeight.bold, color: Colors.black, fontSize: 11), onTap: widget.onComment),
                            userid == userID && widget.isSubEditComment ? Icon(Icons.fiber_manual_record, size: 3, color: Colors.grey) : Container(),
                            userid == userID
                                ? GestureDetector(
                                    child: AppText(widget.isSubEditComment ? ' Edit ' : '', fontWeight: FontWeight.bold, color: Colors.black, fontSize: 11), onTap: widget.onEdit)
                                : Container(),
                            !widget.isSubComment
                                ? widget.lengthReply == 0
                                    ? Container()
                                    : GestureDetector(
                                        onTap: widget.viewReply,
                                        child: Row(
                                          children: [
                                            Icon(
                                              widget.countReply > 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                              size: 15.0,
                                              color: Color(0xff4c7ff7),
                                            ),
                                            AppText(
                                              widget.countReply > 0
                                                  ? widget.lengthReply == 1
                                                      ? 'Hide reply'
                                                      : 'Hide replies'
                                                  : widget.lengthReply == 1
                                                      ? 'View ${widget.lengthReply} reply'
                                                      : 'View ${widget.lengthReply} replies',
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff4c7ff7),
                                              fontSize: 11,
                                            ),
                                          ],
                                        ),
                                      )
                                : Container(),
                          ],
                        ),
                        widget.totalLikeCount == 0
                            ? Container()
                            : Row(
                                children: [
                                  Image.asset('$ICON_URL/Like Icon.png', height: 18, width: 18),
                                  AppText(widget.likeCounts, fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10),
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
      ],
    );
  }
}
