import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:letsgotrip/_View/InitPages/profile_set_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/constants/keys.dart';
import 'package:letsgotrip/functions/kakao_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key key,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // KakaoContext.clientId = kakaoAppKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(common_side_gap),
              vertical: ScreenUtil().setHeight(94)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                  image: AssetImage("assets/images/logo_mark.png"),
                  width: ScreenUtil().setSp(27),
                  height: ScreenUtil().setSp(36)),
              Image(
                  image: AssetImage("assets/images/logo_text.png"),
                  width: ScreenUtil().setSp(300),
                  height: ScreenUtil().setSp(42)),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(18)),
                child: Image(
                    image: AssetImage("assets/images/logo_under_text.png"),
                    width: ScreenUtil().setSp(222),
                    height: ScreenUtil().setSp(20)),
              ),
              SizedBox(height: ScreenUtil().setHeight(70)),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(46)),
                child: Image(
                    image: AssetImage("assets/images/sns_login_text.png"),
                    width: ScreenUtil().setSp(255),
                    height: ScreenUtil().setSp(18)),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  kakaoLogin();
                },
                child: Container(
                  width: ScreenUtil().setWidth(305),
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(13),
                      horizontal: ScreenUtil().setWidth(16)),
                  margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(10),
                      bottom: ScreenUtil().setHeight(5)),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(2554, 229, 0, 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: ScreenUtil().setSp(19.8),
                        height: ScreenUtil().setSp(18.6),
                        color: Colors.black,
                      ),
                      Text(
                        "카카오 계정으로 로그인",
                        style: TextStyle(fontSize: ScreenUtil().setSp(16)),
                      ),
                      Container(
                        width: ScreenUtil().setSp(19.8),
                        height: ScreenUtil().setSp(18.6),
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => ProfileSetScreen());
                },
                child: Container(
                  width: ScreenUtil().setWidth(305),
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(13),
                      horizontal: ScreenUtil().setWidth(16)),
                  margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(12),
                      bottom: ScreenUtil().setHeight(5)),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(3, 199, 90, 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: ScreenUtil().setSp(19.8),
                        height: ScreenUtil().setSp(18.6),
                        color: Colors.black,
                      ),
                      Text(
                        "네이버 계정으로 로그인",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            color: Colors.white),
                      ),
                      Container(
                        width: ScreenUtil().setSp(19.8),
                        height: ScreenUtil().setSp(18.6),
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => ProfileSetScreen());
                },
                child: Container(
                  width: ScreenUtil().setWidth(305),
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(13),
                      horizontal: ScreenUtil().setWidth(16)),
                  margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(10),
                      bottom: ScreenUtil().setHeight(5)),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: ScreenUtil().setSp(19.8),
                        height: ScreenUtil().setSp(18.6),
                        color: Colors.white,
                      ),
                      Text(
                        "애플 계정으로 로그인",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            color: Colors.white),
                      ),
                      Container(
                        width: ScreenUtil().setSp(19.8),
                        height: ScreenUtil().setSp(18.6),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
