import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/_View/InitPages/walkthrough_screen.dart';

class AuthorityScreen extends StatelessWidget {
  const AuthorityScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var safePadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      // backgroundColor: Color.fromRGBO(5, 138, 221, 1),
      // backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Expanded(child: Container(color: Colors.white)),
            Container(
              width: ScreenUtil().screenWidth,
              color: Colors.white,
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(
                          top: ScreenUtil().setHeight(safePadding + 93)),
                      child: Image.asset("assets/images/authority_title.png",
                          width: ScreenUtil().setSp(225),
                          height: ScreenUtil().setSp(36))),
                  Container(
                      margin: EdgeInsets.only(
                          top: ScreenUtil().setHeight(10),
                          bottom: ScreenUtil().setHeight(41)),
                      child: Image.asset("assets/images/authority_content.png",
                          width: ScreenUtil().setSp(271),
                          height: ScreenUtil().setSp(60))),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                        child: Image.asset("assets/images/authority_device.png",
                            width: ScreenUtil().setSp(47),
                            height: ScreenUtil().setSp(47)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                  bottom: ScreenUtil().setHeight(3)),
                              child: Image.asset(
                                  "assets/images/authority_device_title.png",
                                  width: ScreenUtil().setSp(139),
                                  height: ScreenUtil().setSp(24))),
                          Image.asset(
                              "assets/images/authority_device_content.png",
                              width: ScreenUtil().setSp(256),
                              height: ScreenUtil().setSp(40))
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: ScreenUtil().setHeight(20)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                        child: Image.asset(
                            "assets/images/authority_location.png",
                            width: ScreenUtil().setSp(47),
                            height: ScreenUtil().setSp(47)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                  bottom: ScreenUtil().setHeight(3)),
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
                  SizedBox(height: ScreenUtil().setHeight(20)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                        child: Image.asset(
                            "assets/images/authority_gallery.png",
                            width: ScreenUtil().setSp(47),
                            height: ScreenUtil().setSp(47)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                  bottom: ScreenUtil().setHeight(3)),
                              child: Image.asset(
                                  "assets/images/authority_gallery_title.png",
                                  width: ScreenUtil().setSp(101),
                                  height: ScreenUtil().setSp(24))),
                          Image.asset(
                              "assets/images/authority_gallery_content.png",
                              width: ScreenUtil().setSp(256),
                              height: ScreenUtil().setSp(40))
                        ],
                      )
                    ],
                  ),
                  // SizedBox(height: ScreenUtil().setHeight(111)),
                ],
              ),
            ),
            Expanded(child: Container(color: Colors.white)),
            InkWell(
              onTap: () {
                Get.offAll(() => WalkthroughScreen());
              },
              child: Container(
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().setHeight(54),
                color: Color.fromRGBO(5, 138, 221, 1),
                child: Image.asset(
                  "assets/images/authority_confirm_button.png",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
