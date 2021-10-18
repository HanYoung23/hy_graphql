import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsgotrip/_Controller/floating_button_controller.dart';
import 'package:letsgotrip/_Controller/google_map_whole_controller.dart';
import 'package:letsgotrip/_Controller/permission_controller.dart';
import 'package:letsgotrip/_View/MainPages/map/map_around_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/functions/user_location.dart';
import 'package:letsgotrip/widgets/add_button.dart';
import 'package:letsgotrip/widgets/filter_button.dart';
import 'package:letsgotrip/widgets/google_map_container.dart';
import 'package:letsgotrip/widgets/loading_indicator.dart';
import 'package:letsgotrip/widgets/map_helper.dart';
import 'package:letsgotrip/widgets/map_marker.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key key,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapWholeController gmWholeController =
      Get.put(GoogleMapWholeController());
  GoogleMapWholeController gmWholeImages = Get.find();

  FloatingButtonController floatingBtnController =
      Get.put(FloatingButtonController());
  FloatingButtonController floatingBtn = Get.find();

  bool isLeftTap = true;
  bool isPermission = true;
  bool isMapLoading = true;
  Position userPosition;
  int currentCategory = 1;
  List<MapMarker> mapMarkers = [];

  filterBtnCallback(int callbackInt) {
    setState(() {
      currentCategory = callbackInt;
      isMapLoading = false;
    });
  }

  // setCategoryMap(int categoryId) {
  //   List filteredList = [];
  //   print("🚨 categoryId : $categoryId");

  //   for (Map data in categoryMap) {
  //     if (data["categoryId"] == categoryId) {
  //       filteredList.add(data);
  //     }
  //   }
  //   categoryMap = filteredList;

  //   setMapMarker(categoryMap);

  //   update();
  // }

  // setMapMarker(List dataList) {
  //   List<MapMarker> mapMarkers = [];
  //   if (dataList.length > 0) {
  //     for (Map data in dataList) {
  //       MapHelper.getMarkerImageFromUrl("${data["imageLink"][0]}")
  //           .then((markerImage) {
  //         mapMarkers.add(
  //           MapMarker(
  //             id: "${data["contentsId"]}",
  //             position: LatLng(data["latitude"], data["longitude"]),
  //             icon: markerImage,
  //           ),
  //         );
  //       });
  //     }
  //   }
  //   print("🚨 mapMarkerList ${mapMarkers.length}");
  //   // mapMarkerList = mapMarkers;
  // }

  @override
  void initState() {
    checkLocationPermission().then((permission) {
      setState(() {
        isPermission = permission;
      });
      getUserLocation().then((latlng) {
        print("🚨 latlng : $latlng");
        if (latlng != null) {
          setState(() {
            userPosition = latlng;
            isMapLoading = false;
          });
        }
      });
    });
    // filterBtnCallback(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        floatingBtnController.allBtnCancel();
      },
      child: SafeArea(
        child: Stack(children: [
          Positioned(
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
                                            letterSpacing:
                                                ScreenUtil().setSp(-0.4))),
                                  )),
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
                            Get.to(() => MapAroundScreen(),
                                transition: Transition.noTransition);
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
                                            letterSpacing:
                                                ScreenUtil().setSp(-0.4))),
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
                              child: GoogleMapContainer(
                            userPosition: userPosition,
                            mapMarkers: mapMarkers,
                            category: currentCategory,
                          )))
                      : Expanded(
                          child: Container(child: Text("위치 권한 허용 후 이용가능합니다."))),
                  isMapLoading
                      ? Expanded(
                          child: Center(
                            child: LoadingIndicator(),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          FilterBtn(isActive: ""),
          AddBtn(isActive: ""),
          Obx(() =>
              floatingBtn.isFilterActive.value || floatingBtn.isAddActive.value
                  ? Positioned(
                      child: Container(
                      width: ScreenUtil().screenWidth,
                      height: ScreenUtil().screenHeight,
                      color: Colors.black.withOpacity(0.7),
                    ))
                  : Container()),
          Obx(() => floatingBtn.isFilterActive.value
              ? Positioned(
                  bottom: ScreenUtil().setSp(80),
                  left: ScreenUtil().setSp(18),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            isMapLoading = true;
                          });
                        },
                        child: FilterBtnOptions(
                            title: '전체',
                            callback: (int) => filterBtnCallback(int)),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isMapLoading = true;
                          });
                        },
                        child: FilterBtnOptions(
                            title: '바닷가',
                            callback: (int) => filterBtnCallback(int)),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isMapLoading = true;
                          });
                        },
                        child: FilterBtnOptions(
                            title: '액티비티',
                            callback: (int) => filterBtnCallback(int)),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isMapLoading = true;
                          });
                        },
                        child: FilterBtnOptions(
                            title: '맛집',
                            callback: (int) => filterBtnCallback(int)),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isMapLoading = true;
                          });
                        },
                        child: FilterBtnOptions(
                            title: '숙소',
                            callback: (int) => filterBtnCallback(int)),
                      ),
                    ],
                  ),
                )
              : Container()),
          Obx(() => floatingBtn.isAddActive.value
              ? Positioned(
                  bottom: ScreenUtil().setSp(80),
                  right: ScreenUtil().setSp(18),
                  child: AddBtnOptions(title: '글쓰기'),
                )
              : Container()),
          Obx(() => floatingBtn.isFilterActive.value
              ? FilterBtn(isActive: "active")
              : Container()),
          Obx(() => floatingBtn.isAddActive.value
              ? AddBtn(isActive: "active")
              : Container()),
        ]),
      ),
    );
  }
}
