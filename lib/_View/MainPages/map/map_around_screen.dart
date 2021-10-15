import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_Controller/floating_button_controller.dart';
import 'package:letsgotrip/_Controller/google_map_whole_controller.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/homepage.dart';
import 'package:letsgotrip/widgets/add_button.dart';
import 'package:letsgotrip/widgets/filter_button.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';
import 'package:letsgotrip/widgets/loading_indicator.dart';

class MapAroundScreen extends StatefulWidget {
  const MapAroundScreen({
    Key key,
  }) : super(key: key);

  @override
  _MapAroundScreenState createState() => _MapAroundScreenState();
}

class _MapAroundScreenState extends State<MapAroundScreen> {
  FloatingButtonController floatingBtnController =
      Get.put(FloatingButtonController());
  FloatingButtonController floatingBtn = Get.find();

  bool isMapLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GoogleMapWholeController gmWholeLatLng = Get.find();
    return Query(
        options: QueryOptions(
          document: gql(Queries.photoListMap),
          variables: {
            "latitude1": "${gmWholeLatLng.latlngBounds["swLat"]}",
            "latitude2": "${gmWholeLatLng.latlngBounds["neLat"]}",
            "longitude1": "${gmWholeLatLng.latlngBounds["swLng"]}",
            "longitude2": "${gmWholeLatLng.latlngBounds["neLng"]}",
          },
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading) {
            List<Map> imageMaps = [];
            for (Map resultData in result.data["photo_list_map"]) {
              int contentsId = int.parse("${resultData["contents_id"]}");
              String imageUrl = "${resultData["image_link"]}";
              List urlList = imageUrl.split(",");
              for (String url in urlList) {
                Map mapData = {
                  "id": contentsId,
                  "url": url,
                };
                imageMaps.add(mapData);
              }
            }
            print("🚨 imageMaps : ${imageMaps.length}");
            // print("🚨 result : $result");
            return GestureDetector(
              onTap: () {
                floatingBtnController.allBtnCancel();
              },
              child: SafeArea(
                child: Scaffold(
                    body: Stack(
                      children: [
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
                                      Image.asset(
                                          "assets/images/hamburger_button.png",
                                          width: ScreenUtil().setSp(28),
                                          height: ScreenUtil().setSp(28)),
                                      SizedBox(
                                          width: ScreenUtil().setWidth(56)),
                                      InkWell(
                                        onTap: () {
                                          Get.back();
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
                                                          color: app_font_grey,
                                                          fontSize: ScreenUtil()
                                                              .setSp(16),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          letterSpacing:
                                                              ScreenUtil()
                                                                  .setSp(
                                                                      -0.4))),
                                                )),
                                            Container()
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: ScreenUtil().setWidth(8)),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                              width: ScreenUtil().setSp(78),
                                              height: ScreenUtil().setSp(24),
                                              child: Center(
                                                child: Text("둘러보기",
                                                    style: TextStyle(
                                                        color: app_font_black,
                                                        fontSize: ScreenUtil()
                                                            .setSp(16),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        letterSpacing:
                                                            ScreenUtil()
                                                                .setSp(-0.4))),
                                              )),
                                          Container(
                                            color: app_blue,
                                            width: ScreenUtil().setSp(60),
                                            height: ScreenUtil().setSp(3),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                          width: ScreenUtil().setWidth(59)),
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
                                imageMaps.length > 0
                                    ? Expanded(
                                        child: Container(
                                          child: GridView.builder(
                                              itemCount: imageMaps.length,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                childAspectRatio: 1,
                                                mainAxisSpacing:
                                                    ScreenUtil().setSp(1),
                                                crossAxisSpacing:
                                                    ScreenUtil().setSp(1),
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Image.network(
                                                  imageMaps[index]["url"],
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return CupertinoActivityIndicator();
                                                  },
                                                );
                                              }),
                                        ),
                                      )
                                    : Expanded(
                                        child: Center(
                                            child: Image.asset(
                                          "assets/images/map_around_content.png",
                                          width: ScreenUtil().setSp(260),
                                          height: ScreenUtil().setSp(48),
                                        )),
                                      )
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
                                    FilterBtnOptions(title: '전체'),
                                    FilterBtnOptions(title: '바닷가'),
                                    FilterBtnOptions(title: '액티비티'),
                                    FilterBtnOptions(title: '맛집'),
                                    FilterBtnOptions(title: '숙소'),
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
                      ],
                    ),
                    bottomNavigationBar: Obx(() {
                      return Stack(
                        children: [
                          Positioned(
                            child: BottomNavigationBar(
                              backgroundColor: Colors.white,
                              type: BottomNavigationBarType.fixed,
                              items: btmNavItems,
                              showUnselectedLabels: true,
                              currentIndex: 1,
                              onTap: _onBtmItemClick,
                              elevation: 0,
                            ),
                          ),
                          floatingBtn.isFilterActive.value ||
                                  floatingBtn.isAddActive.value
                              ? Positioned(
                                  child: Container(
                                  width: ScreenUtil().screenWidth,
                                  height: ScreenUtil().setSp(60),
                                  color: Colors.black.withOpacity(0.7),
                                ))
                              : SizedBox()
                        ],
                      );
                    })),
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
        });
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
