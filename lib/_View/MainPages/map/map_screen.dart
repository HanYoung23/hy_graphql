import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_Controller/floating_button_controller.dart';
import 'package:letsgotrip/_Controller/google_map_whole_controller.dart';
import 'package:letsgotrip/_Controller/permission_controller.dart';
import 'package:letsgotrip/_View/MainPages/map/__maparoundscreenbackup.dart';
import 'package:letsgotrip/_View/MainPages/map/map_around_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/functions/user_location.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/add_button.dart';
import 'package:letsgotrip/widgets/calendar_bottom_sheet.dart';
import 'package:letsgotrip/widgets/filter_button.dart';
import 'package:letsgotrip/widgets/google_map_container.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';
import 'package:letsgotrip/widgets/loading_indicator.dart';
import 'package:letsgotrip/widgets/map_marker.dart';
import 'package:letsgotrip/_View/MainPages/settings/menu_drawer_screen.dart';

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
  GoogleMapWholeController gmWholeLatLng = Get.find();
  GoogleMapWholeController gmPosition = Get.find();

  FloatingButtonController floatingBtnController =
      Get.put(FloatingButtonController());
  FloatingButtonController floatingBtn = Get.find();
  FloatingButtonController fliterValue = Get.find();

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isLeftTap = true;
  bool isPermission = true;
  bool isMapLoading = true;
  Position userPosition;
  // int currentCategory = 1;
  int customerId;
  List<MapMarker> mapMarkers = [];

  filterBtnCallback(int callbackInt) {
    setState(() {
      // currentCategory = callbackInt;
      isMapLoading = false;
    });
  }

  @override
  void initState() {
    checkLocationPermission().then((permission) {
      setState(() {
        isPermission = permission;
      });
      getUserLocation().then((latlng) {
        if (latlng != null) {
          setState(() {
            userPosition = latlng;
            isMapLoading = false;
          });
        }
      });
    });
    seeValue("customerId").then((value) {
      setState(() {
        customerId = int.parse(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Query(
        options: QueryOptions(
          document: gql(Queries.photoListMap),
          variables: {
            "latitude1": "-87.71179927260242",
            "latitude2": "89.45016124669523",
            "longitude1": "-180",
            "longitude2": "180",
            "category_id": fliterValue.category.value,
            "date1": fliterValue.dateStart.value,
            "date2": fliterValue.dateEnd.value,
          },
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading) {
            List<Map> photoMapMarkerList = [];
            // List<Map> photoMapImageList = [];
            // print(
            //     "🚨 photomaplist parent : ${result.data["photo_list_map"].length}");
            // print("🚨 category : ${fliterValue.category.value}");
            // print("🚨 date1 : ${fliterValue.dateStart.value}");
            // print("🚨 date2 : ${fliterValue.dateEnd.value}");

            for (Map resultData in result.data["photo_list_map"]) {
              int customerId = int.parse("${resultData["customer_id"]}");
              int contentsId = int.parse("${resultData["contents_id"]}");
              int categoryId = int.parse("${resultData["category_id"]}");
              List<String> imageLink =
                  ("${resultData["image_link"]}").split(",");
              List<String> tags = ("${resultData["tags"]}").split(",");
              List<int> starRating = [
                resultData["star_rating1"],
                resultData["star_rating2"],
                resultData["star_rating3"],
                resultData["star_rating4"]
              ];
              double latitude = double.parse("${resultData["latitude"]}");
              double longitude = double.parse("${resultData["longitude"]}");

              Map<dynamic, dynamic> photoDataMap = {
                "customerId": customerId,
                "contentsId": contentsId,
                "categoryId": categoryId,
                "contentsTitle": "${resultData["contents_title"]}",
                "locationLink": "${resultData["location_link"]}",
                "imageLink": imageLink,
                "mainText": "${resultData["main_text"]}",
                "tags": tags,
                "starRating": starRating,
                "latitude": latitude,
                "longitude": longitude,
                "registDate": "${resultData["regist_date"]}"
              };

              photoMapMarkerList.add(photoDataMap);
            }

            return SafeArea(
              child: Scaffold(
                key: scaffoldKey,
                body: Stack(children: [
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
                                InkWell(
                                  onTap: () {
                                    scaffoldKey.currentState.openDrawer();
                                  },
                                  child: Image.asset(
                                      "assets/images/hamburger_button.png",
                                      width: ScreenUtil().setSp(28),
                                      height: ScreenUtil().setSp(28)),
                                ),
                                SizedBox(width: ScreenUtil().setWidth(56)),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isLeftTap = true;
                                    });
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
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
                                                    fontSize:
                                                        ScreenUtil().setSp(16),
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: ScreenUtil()
                                                        .setSp(-0.4))),
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
                                    // Get.to(() => MapAroundScreen(),
                                    //     transition: Transition.noTransition);

                                    if (this.mounted) {
                                      // Navigator.push(
                                      //   context,
                                      //   PageRouteBuilder(
                                      //       pageBuilder: (context, _, __) =>
                                      //           MapAroundScreen(
                                      //               customerId: customerId),
                                      //       transitionDuration: Duration.zero),
                                      // );
                                      Get.to(
                                          () => MapAroundScreen(
                                              customerId: customerId),
                                          transition: Transition.noTransition);
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
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
                                                    fontSize:
                                                        ScreenUtil().setSp(16),
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: ScreenUtil()
                                                        .setSp(-0.4))),
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
                                  onTap: () {
                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (_) => CalendarBottomSheet(),
                                        isScrollControlled: true);
                                  },
                                  child: Image.asset(
                                      "assets/images/locationTap/calender_button.png",
                                      width: ScreenUtil().setSp(28),
                                      height: ScreenUtil().setSp(28)),
                                )
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
                                    child: Obx(() => GoogleMapContainer(
                                          photoMapList: photoMapMarkerList,
                                          userPosition: userPosition,
                                          currentCameraPosition: gmPosition
                                              .currentCameraPosition.value,
                                          category: fliterValue.category.value,
                                          dateStart:
                                              fliterValue.dateStart.value,
                                          dateEnd: fliterValue.dateEnd.value,
                                        )),
                                  ))
                              : Expanded(
                                  child: Container(
                                      child: Text("위치 권한 허용 후 이용가능합니다."))),
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
                  Obx(() => floatingBtn.isFilterActive.value ||
                          floatingBtn.isAddActive.value
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
                                    // callback: (int) => filterBtnCallback(int)),
                                    callback: () => refetch()),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isMapLoading = true;
                                  });
                                },
                                child: FilterBtnOptions(
                                    title: '바닷가',
                                    // callback: (int) => filterBtnCallback(int)),
                                    callback: () => refetch()),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isMapLoading = true;
                                  });
                                },
                                child: FilterBtnOptions(
                                    title: '액티비티',
                                    // callback: (int) => filterBtnCallback(int)),
                                    callback: () => refetch()),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isMapLoading = true;
                                  });
                                },
                                child: FilterBtnOptions(
                                    title: '맛집',
                                    // callback: (int) => filterBtnCallback(int)),
                                    callback: () => refetch()),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isMapLoading = true;
                                  });
                                },
                                child: FilterBtnOptions(
                                    title: '숙소',
                                    // callback: (int) => filterBtnCallback(int)),
                                    callback: () => refetch()),
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
                drawer: MenuDrawer(customerId: customerId),
              ),
            );
          } else {
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Container(
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().screenHeight,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadingIndicator(),
                        ],
                      ),
                    )),
              ),
            );
          }
        }));
  }
}
