import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/constants/common_value.dart';

class ProfileEditIntroductionScreen extends StatefulWidget {
  final String introduction;
  final Function setIntroduction;

  const ProfileEditIntroductionScreen(
      {Key key, @required this.introduction, @required this.setIntroduction})
      : super(key: key);

  @override
  _ProfileEditIntroductionScreenState createState() =>
      _ProfileEditIntroductionScreenState();
}

class _ProfileEditIntroductionScreenState
    extends State<ProfileEditIntroductionScreen> {
  final contentTextController = TextEditingController();

  int textLength = 0;

  countText() {
    setState(() {
      textLength = contentTextController.text.length;
    });
  }

  setPreviousText() {
    contentTextController.text = widget.introduction;
    setState(() {
      textLength = widget.introduction.length;
    });
  }

  @override
  void initState() {
    setPreviousText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(ScreenUtil().setSp(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().setSp(44),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Image.asset("assets/images/arrow_back.png",
                                width: ScreenUtil().setSp(arrow_back_size),
                                height: ScreenUtil().setSp(arrow_back_size)),
                          ),
                        ),
                      ),
                      Text(
                        "소개",
                        style: TextStyle(
                            fontFamily: "NotoSansCJKkrBold",
                            fontSize: ScreenUtil().setSp(appbar_title_size),
                            letterSpacing: ScreenUtil().setSp(letter_spacing)),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            widget.setIntroduction(contentTextController.text);
                            Get.back();
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "완료",
                              style: TextStyle(
                                  fontFamily: "NotoSansCJKkrBold",
                                  fontSize:
                                      ScreenUtil().setSp(appbar_title_size),
                                  letterSpacing:
                                      ScreenUtil().setSp(letter_spacing)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().setSp(30)),
                Container(
                  width: ScreenUtil().setSp(92),
                  height: ScreenUtil().setSp(30),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${150 - textLength}",
                    style: TextStyle(
                      fontFamily: "NotoSansCJKkrRegular",
                      fontSize: ScreenUtil().setSp(18),
                      letterSpacing: ScreenUtil().setSp(-0.45),
                    ),
                  ),
                ),
                // SizedBox(height: ScreenUtil().setSp(10)),
                TextField(
                    controller: contentTextController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (_) {
                      countText();
                    },
                    maxLength: 150,
                    style: TextStyle(
                        fontFamily: "NotoSansCJKkrRegular",
                        fontSize: ScreenUtil().setSp(14),
                        letterSpacing:
                            ScreenUtil().setSp(letter_spacing_small)),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "프로필을 소개해보세요",
                        hintStyle: TextStyle(
                            fontFamily: "NotoSansCJKkrRegular",
                            letterSpacing:
                                ScreenUtil().setSp(letter_spacing_small),
                            color: app_font_grey,
                            fontSize: ScreenUtil().setSp(14)),
                        counterText: ""))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
