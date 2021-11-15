import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/_View/MainPages/settings/service_personal_policy_screen.dart';
import 'package:letsgotrip/_View/MainPages/settings/service_tos_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';

class ServicePolicyScreen extends StatefulWidget {
  const ServicePolicyScreen({Key key}) : super(key: key);

  @override
  _ServicePolicyScreenState createState() => _ServicePolicyScreenState();
}

class _ServicePolicyScreenState extends State<ServicePolicyScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ScreenUtil().setSp(20)),
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
                                height: ScreenUtil().setSp(arrow_back_size))),
                      ),
                    ),
                    Text(
                      "이용약관 및 정책",
                      style: TextStyle(
                          fontFamily: "NotoSansCJKkrBold",
                          fontSize: ScreenUtil().setSp(appbar_title_size),
                          letterSpacing:
                              ScreenUtil().setSp(letter_spacing_small)),
                    ),
                    Expanded(
                      child: Image.asset("assets/images/arrow_back.png",
                          color: Colors.transparent,
                          width: ScreenUtil().setSp(arrow_back_size),
                          height: ScreenUtil().setSp(arrow_back_size)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setSp(24)),
              InkWell(
                onTap: () {
                  Get.to(() => ServiceTosScreen());
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: ScreenUtil().setSp(16)),
                  child: Text("서비스 이용약관",
                      style: TextStyle(
                        fontFamily: "NotoSansCJKkrRegular",
                        fontSize: ScreenUtil().setSp(16),
                        letterSpacing: ScreenUtil().setSp(letter_spacing),
                      )),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => ServicePersonalPolicyScreen());
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: ScreenUtil().setSp(16)),
                  child: Text("개인정보 처리방침",
                      style: TextStyle(
                        fontFamily: "NotoSansCJKkrRegular",
                        fontSize: ScreenUtil().setSp(16),
                        letterSpacing: ScreenUtil().setSp(letter_spacing),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
