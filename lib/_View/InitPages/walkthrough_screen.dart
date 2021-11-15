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
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
        ),
        body: Container(
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
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
                letterSpacing: ScreenUtil().setSp(letter_spacing),
              ),
            ),
          )
        ]),
        SizedBox(height: ScreenUtil().setHeight(40)),
        Image.asset("assets/images/walkthroughFirst/dot.png",
            width: ScreenUtil().setSp(40), height: ScreenUtil().setSp(8)),
        SizedBox(height: ScreenUtil().setHeight(14)),
        Text(
          "내가 다녀온 곳을 기록해요",
          style: TextStyle(
            fontFamily: "NotoSansCJKkrBold",
            fontSize: ScreenUtil().setSp(22),
            letterSpacing: ScreenUtil().setSp(-0.55),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: ScreenUtil().setHeight(10)),
        Text(
          "SNS와 GPS 위치 기반이 만나\n지도에서 한번에 장소별 게시물 확인 가능!",
          style: TextStyle(
            fontFamily: "NotoSansCJKkrRegular",
            fontSize: ScreenUtil().setSp(16),
            letterSpacing: ScreenUtil().setSp(letter_spacing),
            color: app_grey_login,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: ScreenUtil().setHeight(48)),
        Container(
            // width: ScreenUtil().setSp(340),
            // height: ScreenUtil().setSp(190),
            child: Image.asset(
          "assets/images/walkthroughFirst/photo.png",
          fit: BoxFit.contain,
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
                      letterSpacing: ScreenUtil().setSp(letter_spacing),
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
                    letterSpacing: ScreenUtil().setSp(letter_spacing),
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
        Text(
          "포인트로 상품과 교환할 수 있어요",
          style: TextStyle(
            fontFamily: "NotoSansCJKkrBold",
            fontSize: ScreenUtil().setSp(22),
            letterSpacing: ScreenUtil().setSp(-0.55),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: ScreenUtil().setHeight(10)),
        Text(
          "무료 포인트 적립으로 희망하는 제품과\n언제든지 교환할 수 있어요!",
          style: TextStyle(
            fontFamily: "NotoSansCJKkrRegular",
            fontSize: ScreenUtil().setSp(16),
            letterSpacing: ScreenUtil().setSp(letter_spacing),
            color: app_grey_login,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: ScreenUtil().setHeight(48)),
        Container(
            child: Image.asset(
          "assets/images/walkthroughSecond/photo.png",
          // width: ScreenUtil().setSp(375),
          height: ScreenUtil().setSp(234),
          fit: BoxFit.cover,
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
                      letterSpacing: ScreenUtil().setSp(letter_spacing),
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
        Text(
          "카테고리 별 게시물 노출",
          style: TextStyle(
            fontFamily: "NotoSansCJKkrBold",
            fontSize: ScreenUtil().setSp(22),
            letterSpacing: ScreenUtil().setSp(-0.55),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: ScreenUtil().setHeight(10)),
        Text(
          "관심 있는 게시물만 확인할 수도 있어요\n비슷한 관심사를 가진 사람들의\n게시물을 확인해보세요",
          style: TextStyle(
            fontFamily: "NotoSansCJKkrRegular",
            fontSize: ScreenUtil().setSp(16),
            letterSpacing: ScreenUtil().setSp(letter_spacing),
            color: app_grey_login,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: ScreenUtil().setHeight(28)),
        Container(
            width: ScreenUtil().setSp(300),
            // height: ScreenUtil().setSp(250),
            child: Image.asset(
              "assets/images/walkthroughThird/photo.png",
              fit: BoxFit.contain,
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
                    letterSpacing: ScreenUtil().setSp(letter_spacing),
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
