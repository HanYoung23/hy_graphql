import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letsgotrip/constants/common_value.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

    return Scaffold(
      body: Container(
        color: Colors.white,
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        child: Column(
          children: [
            SizedBox(height: ScreenUtil().setSp(20)),
            Container(
              width: ScreenUtil().setWidth(375),
              height: ScreenUtil().setHeight(44),
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                          onTap: () {
                            scaffoldKey.currentState.openDrawer();
                          },
                          child: Image.asset(
                              "assets/images/hamburger_button.png",
                              width: ScreenUtil().setSp(28),
                              height: ScreenUtil().setSp(28))),
                    ),
                  ),
                  Text(
                    "스토어",
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(appbar_title_size),
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Image.asset(
                      "assets/images/hamburger_button.png",
                      width: ScreenUtil().setSp(28),
                      height: ScreenUtil().setSp(28),
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "서비스 오픈 전 입니다",
                      style: TextStyle(
                        color: app_font_grey,
                        fontSize: ScreenUtil().setSp(16),
                        letterSpacing: -0.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: ScreenUtil().setSp(4),
                    ),
                    Text(
                      "좋은 서비스로 찾아오겠습니다 :)",
                      style: TextStyle(
                        color: app_font_grey,
                        fontSize: ScreenUtil().setSp(16),
                        letterSpacing: -0.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
