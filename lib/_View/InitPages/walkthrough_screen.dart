import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/_Controller/permission_controller.dart';
import 'package:letsgotrip/_View/InitPages/login_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/storage/storage.dart';

class WalkthroughScreen extends StatefulWidget {
  const WalkthroughScreen({
    Key key,
  }) : super(key: key);

  @override
  _WalkthroughScreenState createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {
  int currentScreenIndex = 1;

  @override
  void initState() {
    checkNotificationPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
            margin: EdgeInsets.symmetric(
                horizontal:
                    currentScreenIndex != 2 ? ScreenUtil().setSp(20) : 0),
            padding: EdgeInsets.only(
              top: ScreenUtil().setSp(30),
              bottom: ScreenUtil().setSp(34),
            ),
            child: currentScreenIndex == 1
                ? firstScreen()
                : currentScreenIndex == 2
                    ? secondScreen()
                    : thirdScreen()),
      ),
    );
  }

  Column firstScreen() {
    return Column(
      children: [
        Row(children: [
          Image.asset("assets/images/arrow_back.png",
              color: Colors.transparent,
              width: ScreenUtil().setSp(arrow_back_size),
              height: ScreenUtil().setSp(arrow_back_size)),
          Spacer(),
          InkWell(
            onTap: () {
              Get.to(() => LoginScreen());
            },
            child: Text(
              "건너뛰기",
              style: TextStyle(
                fontFamily: "NotoSansCJKkrBold",
                fontSize: ScreenUtil().setSp(16),
                color: app_font_grey,
                letterSpacing: letter_spacing,
              ),
            ),
          )
        ]),
        SizedBox(height: ScreenUtil().setHeight(40)),
        Image.asset("assets/images/walkthroughFirst/dot.png",
            width: ScreenUtil().setSp(40), height: ScreenUtil().setSp(8)),
        SizedBox(height: ScreenUtil().setHeight(14)),
        Image.asset("assets/images/walkthroughFirst/title.png",
            width: ScreenUtil().setSp(335), height: ScreenUtil().setSp(33)),
        SizedBox(height: ScreenUtil().setHeight(10)),
        Image.asset("assets/images/walkthroughFirst/content.png",
            width: ScreenUtil().setSp(300), height: ScreenUtil().setSp(54)),
        SizedBox(height: ScreenUtil().setHeight(47)),
        Container(
            width: ScreenUtil().setSp(340),
            height: ScreenUtil().setSp(190),
            child: Image.asset(
              "assets/images/walkthroughFirst/photo.png",
              fit: BoxFit.fill,
            )),
        Spacer(),
        InkWell(
            onTap: () {
              setState(() {
                currentScreenIndex = 2;
              });
            },
            child: Container(
                width: ScreenUtil().setSp(336),
                height: ScreenUtil().setSp(50),
                decoration: BoxDecoration(
                    color: app_blue,
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setSp(10))),
                child: Center(
                  child: Text(
                    "다음",
                    style: TextStyle(
                      fontFamily: "NotoSansCJKkrBold",
                      fontSize: ScreenUtil().setSp(16),
                      color: Colors.white,
                      letterSpacing: letter_spacing,
                    ),
                  ),
                )))
      ],
    );
  }

  Column secondScreen() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      currentScreenIndex = 1;
                    });
                  },
                  child: Image.asset("assets/images/arrow_back.png",
                      width: ScreenUtil().setSp(arrow_back_size),
                      height: ScreenUtil().setSp(arrow_back_size))),
              Spacer(),
              InkWell(
                onTap: () {
                  Get.to(() => LoginScreen());
                },
                child: Text(
                  "건너뛰기",
                  style: TextStyle(
                    fontFamily: "NotoSansCJKkrBold",
                    fontSize: ScreenUtil().setSp(16),
                    color: app_font_grey,
                    letterSpacing: letter_spacing,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(40)),
        Image.asset("assets/images/walkthroughSecond/dot.png",
            width: ScreenUtil().setSp(40), height: ScreenUtil().setSp(8)),
        SizedBox(height: ScreenUtil().setHeight(14)),
        Image.asset("assets/images/walkthroughSecond/title.png",
            width: ScreenUtil().setSp(335), height: ScreenUtil().setSp(33)),
        SizedBox(height: ScreenUtil().setHeight(10)),
        Image.asset("assets/images/walkthroughSecond/content.png",
            width: ScreenUtil().setSp(300), height: ScreenUtil().setSp(80)),
        SizedBox(height: ScreenUtil().setHeight(10)),
        Container(
            child: Image.asset(
          "assets/images/walkthroughSecond/photo.png",
          width: ScreenUtil().setSp(375),
          // width: ScreenUtil().screenWidth,
          height: ScreenUtil().setSp(220),
          fit: BoxFit.fill,
        )),
        Spacer(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
          child: InkWell(
            onTap: () {
              setState(() {
                currentScreenIndex = 3;
              });
            },
            child: Container(
                width: ScreenUtil().setSp(336),
                height: ScreenUtil().setSp(50),
                decoration: BoxDecoration(
                    color: app_blue,
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setSp(10))),
                child: Center(
                  child: Text(
                    "다음",
                    style: TextStyle(
                      fontFamily: "NotoSansCJKkrBold",
                      fontSize: ScreenUtil().setSp(16),
                      color: Colors.white,
                      letterSpacing: letter_spacing,
                    ),
                  ),
                )),
          ),
        ),
      ],
    );
  }

  Column thirdScreen() {
    return Column(
      children: [
        Row(
          children: [
            InkWell(
                onTap: () {
                  setState(() {
                    currentScreenIndex = 2;
                  });
                },
                child: Image.asset("assets/images/arrow_back.png",
                    width: ScreenUtil().setSp(arrow_back_size),
                    height: ScreenUtil().setSp(arrow_back_size))),
            Spacer(),
          ],
        ),
        SizedBox(height: ScreenUtil().setHeight(40)),
        Image.asset("assets/images/walkthroughThird/dot.png",
            width: ScreenUtil().setSp(40), height: ScreenUtil().setSp(8)),
        SizedBox(height: ScreenUtil().setHeight(14)),
        Image.asset("assets/images/walkthroughThird/title.png",
            width: ScreenUtil().setSp(335), height: ScreenUtil().setSp(33)),
        SizedBox(height: ScreenUtil().setHeight(10)),
        Image.asset("assets/images/walkthroughThird/content.png",
            width: ScreenUtil().setSp(300), height: ScreenUtil().setSp(102)),
        Container(
            width: ScreenUtil().setSp(305),
            height: ScreenUtil().setSp(250),
            child: Image.asset(
              "assets/images/walkthroughThird/photo.png",
              fit: BoxFit.fill,
            )),
        Spacer(),
        InkWell(
          onTap: () {
            storeUserData("isWalkThrough", "true").then((value) {
              Get.to(() => LoginScreen());
            });
          },
          child: Container(
              width: ScreenUtil().setSp(336),
              height: ScreenUtil().setSp(50),
              decoration: BoxDecoration(
                  color: app_blue,
                  borderRadius: BorderRadius.circular(ScreenUtil().setSp(10))),
              child: Center(
                child: Text(
                  "시작하기",
                  style: TextStyle(
                    fontFamily: "NotoSansCJKkrBold",
                    fontSize: ScreenUtil().setSp(16),
                    color: Colors.white,
                    letterSpacing: letter_spacing,
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
