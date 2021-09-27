import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/_Controller/permission_controller.dart';
import 'package:letsgotrip/_View/MainPages/map/map_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/homepage.dart';

class MapAroundScreen extends StatefulWidget {
  const MapAroundScreen({
    Key key,
  }) : super(key: key);

  @override
  _MapAroundScreenState createState() => _MapAroundScreenState();
}

class _MapAroundScreenState extends State<MapAroundScreen> {
  bool isPermission = true;
  bool isMapLoading = false;

  @override
  void initState() {
    checkLocationPermission().then((permission) {
      setState(() {
        isPermission = permission;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: ScreenUtil().setHeight(20)),
                Container(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().setHeight(46),
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setSp(8),
                      horizontal: ScreenUtil().setSp(20)),
                  child: Row(
                    children: [
                      Image.asset("assets/images/hamburger_button.png",
                          width: ScreenUtil().setSp(28),
                          height: ScreenUtil().setSp(28)),
                      SizedBox(width: ScreenUtil().setWidth(56)),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                width: ScreenUtil().setSp(78),
                                height: ScreenUtil().setSp(24),
                                child: Center(
                                  child: Text("지도",
                                      style: TextStyle(
                                          color: app_font_grey,
                                          fontSize: ScreenUtil().setSp(16),
                                          fontWeight: FontWeight.w700,
                                          letterSpacing:
                                              ScreenUtil().setSp(-0.4))),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(8)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                              width: ScreenUtil().setSp(78),
                              height: ScreenUtil().setSp(24),
                              child: Center(
                                child: Text("둘러보기",
                                    style: TextStyle(
                                        color: app_font_black,
                                        fontSize: ScreenUtil().setSp(16),
                                        fontWeight: FontWeight.w700,
                                        letterSpacing:
                                            ScreenUtil().setSp(-0.4))),
                              )),
                          Container(
                            color: app_blue,
                            width: ScreenUtil().setSp(60),
                            height: ScreenUtil().setSp(3),
                          )
                        ],
                      ),
                      SizedBox(width: ScreenUtil().setWidth(59)),
                      InkWell(
                        onTap: () {},
                        child: Image.asset(
                            "assets/images/locationTap/calender_button.png",
                            width: ScreenUtil().setSp(28),
                            height: ScreenUtil().setSp(28)),
                      ),
                    ],
                  ),
                ),
                isPermission
                    ? Visibility(
                        visible: isMapLoading ? false : true,
                        child: Expanded(
                            child: Container(
                          child: Text("data"),
                        )))
                    : Expanded(
                        child: Container(child: Text("위치 권한 허용 후 이용가능합니다."))),
                isMapLoading
                    ? Expanded(
                        child: Center(
                          child: Container(
                              width: ScreenUtil().setSp(40),
                              height: ScreenUtil().setSp(40),
                              child:
                                  CircularProgressIndicator(color: app_blue)),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            items: btmNavItems,
            showUnselectedLabels: true,
            currentIndex: 1,
            onTap: _onBtmItemClick,
            elevation: 0,
          )),
    );
  }

  List<BottomNavigationBarItem> btmNavItems = [
    BottomNavigationBarItem(
        icon: Image.asset(
          "assets/images/nav_store_grey.png",
          width: ScreenUtil().setSp(30),
          height: ScreenUtil().setSp(30),
        ),
        label: "스토어"),
    BottomNavigationBarItem(
        activeIcon: Image.asset(
          "assets/images/nav_location.png",
          width: ScreenUtil().setSp(30),
          height: ScreenUtil().setSp(30),
        ),
        icon: Image.asset(
          "assets/images/nav_location_grey.png",
          width: ScreenUtil().setSp(30),
          height: ScreenUtil().setSp(30),
        ),
        label: "장소"),
    BottomNavigationBarItem(
        icon: Image.asset(
          "assets/images/nav_profile_grey.png",
          width: ScreenUtil().setSp(30),
          height: ScreenUtil().setSp(30),
        ),
        label: "마이페이지"),
  ];
  void _onBtmItemClick(int index) {
    Get.off(() => HomePage(), arguments: index);
  }
}
