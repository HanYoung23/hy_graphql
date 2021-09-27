import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:letsgotrip/_Controller/permission_controller.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/functions/google_map_functions.dart';
import 'package:letsgotrip/functions/user_location.dart';
import 'package:letsgotrip/widgets/google_map_container.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key key,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool isLeftTap = true;
  bool isPermission = true;
  bool isMapLoading = true;
  Position userPosition;

  @override
  void initState() {
    checkLocationPermission().then((permission) {
      setState(() {
        isPermission = permission;
      });
      getUserLocation().then((latlng) {
        setState(() {
          userPosition = latlng;
          isMapLoading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
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
                      setState(() {
                        isLeftTap = true;
                      });
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
                                      color: isLeftTap
                                          ? app_font_black
                                          : app_font_grey,
                                      fontSize: ScreenUtil().setSp(16),
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: ScreenUtil().setSp(-0.4))),
                            )),
                        // Spacer(),
                        isLeftTap
                            ? Container(
                                color: app_blue,
                                width: ScreenUtil().setSp(30),
                                height: ScreenUtil().setSp(3),
                              )
                            : Container()
                      ],
                    ),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(8)),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isLeftTap = false;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            width: ScreenUtil().setSp(78),
                            height: ScreenUtil().setSp(24),
                            child: Center(
                              child: Text("둘러보기",
                                  style: TextStyle(
                                      color: !isLeftTap
                                          ? app_font_black
                                          : app_font_grey,
                                      fontSize: ScreenUtil().setSp(16),
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: ScreenUtil().setSp(-0.4))),
                            )),
                        !isLeftTap
                            ? Container(
                                color: app_blue,
                                width: ScreenUtil().setSp(60),
                                height: ScreenUtil().setSp(3),
                              )
                            : Container()
                      ],
                    ),
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
                    visible: isMapLoading
                        ? false
                        : isLeftTap
                            ? true
                            : false,
                    child: Expanded(
                        child: GoogleMapContainer(userPosition: userPosition)))
                : Expanded(
                    child: Container(child: Text("위치 권한 허용 후 이용가능합니다."))),
            isPermission
                ? Visibility(
                    visible: isMapLoading
                        ? false
                        : !isLeftTap
                            ? true
                            : false,
                    child: Expanded(child: Text("data")))
                : Expanded(
                    child: Container(child: Text("위치 권한 허용 후 이용가능합니다."))),
            isMapLoading
                ? Expanded(
                    child: Center(
                      child: Container(
                          width: ScreenUtil().setSp(40),
                          height: ScreenUtil().setSp(40),
                          child: CircularProgressIndicator(color: app_blue)),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
