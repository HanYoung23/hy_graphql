import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/constants/common_value.dart';

class ProfileEditIntroductionScreen extends StatefulWidget {
  final String introduction;
  const ProfileEditIntroductionScreen({Key key, @required this.introduction})
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
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(ScreenUtil().setSp(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: ScreenUtil().setWidth(375),
                  height: ScreenUtil().setHeight(44),
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
                            child: Icon(
                              Icons.arrow_back,
                              size: ScreenUtil().setSp(arrow_back_size),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "소개",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(appbar_title_size),
                            letterSpacing: -0.4,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "완료",
                              style: TextStyle(
                                  fontSize:
                                      ScreenUtil().setSp(appbar_title_size),
                                  letterSpacing: -0.4,
                                  fontWeight: FontWeight.bold),
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
                      fontSize: ScreenUtil().setSp(18),
                      letterSpacing: -0.45,
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
                        fontSize: ScreenUtil().setSp(14), color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "프로필을 소개해보세요",
                        hintStyle: TextStyle(
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
