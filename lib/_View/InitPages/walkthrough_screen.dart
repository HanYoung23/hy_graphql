import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/_Controller/permission_controller.dart';
import 'package:letsgotrip/_View/InitPages/login_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';

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
            margin: EdgeInsets.symmetric(
                horizontal:
                    currentScreenIndex != 2 ? ScreenUtil().setWidth(20) : 0,
                vertical: ScreenUtil().setHeight(30)),
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
          Icon(Icons.arrow_back,
              size: ScreenUtil().setSp(arrow_back_size),
              color: Colors.transparent),
          Spacer(),
          InkWell(
            onTap: () {
              Get.to(() => LoginScreen());
            },
            child: Image.asset("assets/images/walkthroughFirst/skip_button.png",
                width: ScreenUtil().setWidth(58),
                height: ScreenUtil().setHeight(24)),
          )
        ]),
        SizedBox(height: ScreenUtil().setHeight(40)),
        Image.asset("assets/images/walkthroughFirst/dot.png",
            width: ScreenUtil().setWidth(40),
            height: ScreenUtil().setHeight(8)),
        SizedBox(height: ScreenUtil().setHeight(14)),
        Image.asset("assets/images/walkthroughFirst/title.png",
            width: ScreenUtil().setWidth(335),
            height: ScreenUtil().setHeight(33)),
        SizedBox(height: ScreenUtil().setHeight(10)),
        Image.asset("assets/images/walkthroughFirst/content.png",
            width: ScreenUtil().setWidth(300),
            height: ScreenUtil().setHeight(54)),
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
            child: Image.asset(
              "assets/images/walkthroughFirst/next_button.png",
              width: ScreenUtil().setWidth(335),
              height: ScreenUtil().setHeight(50),
            ))
      ],
    );
  }

  Column secondScreen() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      currentScreenIndex = 1;
                    });
                  },
                  child: Icon(Icons.arrow_back,
                      size: ScreenUtil().setSp(arrow_back_size))),
              Spacer(),
              InkWell(
                onTap: () {
                  Get.to(() => LoginScreen());
                },
                child: Image.asset(
                    "assets/images/walkthroughSecond/skip_button.png",
                    width: ScreenUtil().setWidth(58),
                    height: ScreenUtil().setHeight(24)),
              ),
            ],
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(40)),
        Image.asset("assets/images/walkthroughSecond/dot.png",
            width: ScreenUtil().setWidth(40),
            height: ScreenUtil().setHeight(8)),
        SizedBox(height: ScreenUtil().setHeight(14)),
        Image.asset("assets/images/walkthroughSecond/title.png",
            width: ScreenUtil().setWidth(335),
            height: ScreenUtil().setHeight(33)),
        SizedBox(height: ScreenUtil().setHeight(10)),
        Image.asset("assets/images/walkthroughSecond/content.png",
            width: ScreenUtil().setWidth(300),
            height: ScreenUtil().setHeight(80)),
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
          margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
          child: InkWell(
            onTap: () {
              setState(() {
                currentScreenIndex = 3;
              });
            },
            child: Image.asset(
                "assets/images/walkthroughSecond/next_button.png",
                width: ScreenUtil().setWidth(335),
                height: ScreenUtil().setHeight(50)),
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
                child: Icon(Icons.arrow_back,
                    size: ScreenUtil().setSp(arrow_back_size))),
            Spacer(),
          ],
        ),
        SizedBox(height: ScreenUtil().setHeight(40)),
        Image.asset("assets/images/walkthroughThird/dot.png",
            width: ScreenUtil().setWidth(40),
            height: ScreenUtil().setHeight(8)),
        SizedBox(height: ScreenUtil().setHeight(14)),
        Image.asset("assets/images/walkthroughThird/title.png",
            width: ScreenUtil().setWidth(335),
            height: ScreenUtil().setHeight(33)),
        SizedBox(height: ScreenUtil().setHeight(10)),
        Image.asset("assets/images/walkthroughThird/content.png",
            width: ScreenUtil().setWidth(300),
            height: ScreenUtil().setHeight(102)),
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
            setState(() {
              Get.to(() => LoginScreen());
            });
          },
          child: Image.asset("assets/images/walkthroughThird/start_button.png",
              width: ScreenUtil().setWidth(335),
              height: ScreenUtil().setHeight(50)),
        ),
      ],
    );
  }
}
