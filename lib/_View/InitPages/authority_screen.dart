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
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
        ),
        body: Container(
          width: ScreenUtil().screenWidth,
          height:
              ScreenUtil().screenHeight - MediaQuery.of(context).padding.bottom,
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
                        child: Image.asset(
                            "assets/images/authority/authority_title.png",
                            width: ScreenUtil().setSp(226),
                            height: ScreenUtil().setSp(36))),
                    Container(
                        margin: EdgeInsets.only(
                            top: ScreenUtil().setSp(10),
                            bottom: ScreenUtil().setSp(42)),
                        child: Image.asset(
                            "assets/images/authority/authority_content.png",
                            width: ScreenUtil().setSp(272),
                            height: ScreenUtil().setSp(60))),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin:
                              EdgeInsets.only(right: ScreenUtil().setSp(10)),
                          child: Image.asset(
                              "assets/images/authority/authority_device.png",
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
                                    "assets/images/authority/authority_device_title.png",
                                    width: ScreenUtil().setSp(130),
                                    height: ScreenUtil().setSp(24))),
                            Image.asset(
                                "assets/images/authority/authority_device_content.png",
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
                              "assets/images/authority/authority_location.png",
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
                                    "assets/images/authority/authority_location_title.png",
                                    width: ScreenUtil().setSp(72),
                                    height: ScreenUtil().setSp(24))),
                            Image.asset(
                                "assets/images/authority/authority_location_content.png",
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
                              "assets/images/authority/authority_gallery.png",
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
                                    "assets/images/authority/authority_gallery_title.png",
                                    width: ScreenUtil().setSp(102),
                                    height: ScreenUtil().setSp(24))),
                            Image.asset(
                                "assets/images/authority/authority_gallery_content.png",
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
              Container(
                height:
                    ScreenUtil().setSp(MediaQuery.of(context).padding.bottom),
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
