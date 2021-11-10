import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/_View/InitPages/walkthrough_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';

class AuthorityScreen extends StatelessWidget {
  const AuthorityScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: ScreenUtil().screenHeight -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(),
              Container(
                width: ScreenUtil().screenWidth,
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setSp(side_gap)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        // margin:
                        //     EdgeInsets.only(top: ScreenUtil().setHeight(94)),
                        child: Image.asset("assets/images/authority_title.png",
                            width: ScreenUtil().setSp(226),
                            height: ScreenUtil().setSp(36))),
                    Container(
                        margin: EdgeInsets.only(
                            top: ScreenUtil().setSp(10),
                            bottom: ScreenUtil().setSp(42)),
                        child: Image.asset(
                            "assets/images/authority_content.png",
                            width: ScreenUtil().setSp(272),
                            height: ScreenUtil().setSp(60))),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin:
                              EdgeInsets.only(right: ScreenUtil().setSp(10)),
                          child: Image.asset(
                              "assets/images/authority_device.png",
                              width: ScreenUtil().setSp(48),
                              height: ScreenUtil().setSp(48)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.only(
                                    bottom: ScreenUtil().setSp(4)),
                                child: Image.asset(
                                    "assets/images/authority_device_title.png",
                                    width: ScreenUtil().setSp(130),
                                    height: ScreenUtil().setSp(24))),
                            Image.asset(
                                "assets/images/authority_device_content.png",
                                width: ScreenUtil().setSp(256),
                                height: ScreenUtil().setSp(40))
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setSp(20)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin:
                              EdgeInsets.only(right: ScreenUtil().setSp(10)),
                          child: Image.asset(
                              "assets/images/authority_location.png",
                              width: ScreenUtil().setSp(48),
                              height: ScreenUtil().setSp(48)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.only(
                                    bottom: ScreenUtil().setSp(4)),
                                child: Image.asset(
                                    "assets/images/authority_location_title.png",
                                    width: ScreenUtil().setSp(72),
                                    height: ScreenUtil().setSp(24))),
                            Image.asset(
                                "assets/images/authority_location_content.png",
                                width: ScreenUtil().setSp(256),
                                height: ScreenUtil().setSp(40))
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setSp(20)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin:
                              EdgeInsets.only(right: ScreenUtil().setSp(10)),
                          child: Image.asset(
                              "assets/images/authority_gallery.png",
                              width: ScreenUtil().setSp(48),
                              height: ScreenUtil().setSp(48)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.only(
                                    bottom: ScreenUtil().setSp(4)),
                                child: Image.asset(
                                    "assets/images/authority_gallery_title.png",
                                    width: ScreenUtil().setSp(102),
                                    height: ScreenUtil().setSp(24))),
                            Image.asset(
                                "assets/images/authority_gallery_content.png",
                                width: ScreenUtil().setSp(256),
                                height: ScreenUtil().setSp(40)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setSp(30)),
              Spacer(),
              InkWell(
                onTap: () {
                  Get.offAll(() => WalkthroughScreen());
                },
                child: Container(
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().setSp(54),
                    color: app_blue,
                    child: Center(
                      child: Text(
                        "확인",
                        style: TextStyle(
                          fontFamily: "NotoSansCJKkrBold",
                          fontSize: ScreenUtil().setSp(16),
                          color: Colors.white,
                          letterSpacing: letter_spacing,
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
