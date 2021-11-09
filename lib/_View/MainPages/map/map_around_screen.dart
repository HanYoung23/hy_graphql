import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_Controller/floating_button_controller.dart';
import 'package:letsgotrip/_Controller/google_map_whole_controller.dart';
import 'package:letsgotrip/_View/MainPages/map/place_detail_ad_screen.dart';
import 'package:letsgotrip/_View/MainPages/map/place_detail_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/homepage.dart';
import 'package:letsgotrip/widgets/add_button.dart';
import 'package:letsgotrip/widgets/calendar_bottom_sheet.dart';
import 'package:letsgotrip/widgets/filter_button.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';
import 'package:letsgotrip/widgets/loading_indicator.dart';
import 'package:letsgotrip/_View/MainPages/settings/menu_drawer_screen.dart';

class MapAroundScreen extends StatefulWidget {
  final int customerId;
  const MapAroundScreen({Key key, @required this.customerId}) : super(key: key);

  @override
  _MapAroundScreenState createState() => _MapAroundScreenState();
}

class _MapAroundScreenState extends State<MapAroundScreen> {
  GoogleMapWholeController gmWholeLatLng = Get.find();
  FloatingButtonController floatingBtnController =
      Get.put(FloatingButtonController());
  FloatingButtonController floatingBtn = Get.find();
  FloatingButtonController fliterValue = Get.find();

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isMapLoading = true;

  int start = 0, limit = 10;
  int page = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Query(
        options: QueryOptions(
          document: gql(Queries.photoListMap),
          variables: {
            "latitude1": "${gmWholeLatLng.latlngBounds["swLat"]}",
            "latitude2": "${gmWholeLatLng.latlngBounds["neLat"]}",
            "longitude1": "${gmWholeLatLng.latlngBounds["swLng"]}",
            "longitude2": "${gmWholeLatLng.latlngBounds["neLng"]}",
            "category_id": fliterValue.category.value,
            "date1": fliterValue.dateStart.value,
            "date2": fliterValue.dateEnd.value,
            "page": 1
          },
        ),
        builder: (result, {refetch, fetchMore}) {
          String latitudeFirst = "${gmWholeLatLng.latlngBounds["swLat"]}";
          String latitudeSecond = "${gmWholeLatLng.latlngBounds["neLat"]}";
          String longitudeOne = "${gmWholeLatLng.latlngBounds["swLng"]}";
          String longitudeSecond = "${gmWholeLatLng.latlngBounds["neLng"]}";

          if (!result.isLoading && result.data != null) {
            List<Map> imageMaps = [];
            for (Map resultData in result.data["photo_list_map"]) {
              int contentsId = int.parse("${resultData["contents_id"]}");
              String imageUrl = "${resultData["image_link"]}";
              List urlList = imageUrl.split(",");
              Map mapData = {
                "contentsId": contentsId,
                "imageLink": urlList[0],
                "isAd": false,
              };
              imageMaps.add(mapData);
              // for (String url in urlList) {
              //   Map mapData = {
              //     "contentsId": contentsId,
              //     "imageLink": url,
              //   };
              //   imageMaps.add(mapData);
              // }
            }
            FetchMoreOptions opts = FetchMoreOptions(
              variables: {
                "latitude1": "${gmWholeLatLng.latlngBounds["swLat"]}",
                "latitude2": "${gmWholeLatLng.latlngBounds["neLat"]}",
                "longitude1": "${gmWholeLatLng.latlngBounds["swLng"]}",
                "longitude2": "${gmWholeLatLng.latlngBounds["neLng"]}",
                "category_id": fliterValue.category.value,
                "date1": fliterValue.dateStart.value,
                "date2": fliterValue.dateEnd.value,
                "page": 1 + page
              },
              updateQuery: (previousResultData, fetchMoreResultData) {
                final List<dynamic> allPosts = [
                  ...previousResultData['photo_list_map'] as List<dynamic>,
                  ...fetchMoreResultData['photo_list_map'] as List<dynamic>
                ];
                fetchMoreResultData['photo_list_map'] = allPosts;
                print("🚨 fetch more : $page, ${allPosts.length}");
                return fetchMoreResultData;
              },
            );

            // print(
            //     "🚨 photomaplist around : ${result.data["photo_list_map"].length}");
            return GestureDetector(
              onTap: () {
                floatingBtnController.allBtnCancel();
              },
              child: SafeArea(
                child: Scaffold(
                  key: scaffoldKey,
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
                                                                .setSp(-0.4))),
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
                                    SizedBox(width: ScreenUtil().setWidth(59)),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (_) => CalendarBottomSheet(
                                                refetchCallback: () => refetch),
                                            isScrollControlled: true);
                                      },
                                      child: Image.asset(
                                          "assets/images/locationTap/calender_button.png",
                                          width: ScreenUtil().setSp(28),
                                          height: ScreenUtil().setSp(28)),
                                    ),
                                  ],
                                ),
                              ),
                              // InkWell(
                              //   onTap: () {
                              //     fetchMore(opts);
                              //   },
                              //   child: Container(
                              //     width: ScreenUtil().screenWidth,
                              //     height: ScreenUtil().setSp(50),
                              //     color: Colors.red,
                              //   ),
                              // ),
                              imageMaps.length > 0
                                  ? gridBuilder(latitudeFirst, latitudeSecond,
                                      longitudeOne, longitudeSecond, imageMaps)
                                  : Expanded(
                                      child: Center(
                                          child: Image.asset(
                                        "assets/images/map_around_content.png",
                                        width: ScreenUtil().setSp(260),
                                        height: ScreenUtil().setSp(48),
                                      )),
                                    ),
                              InkWell(
                                onTap: () {
                                  // fetchMore(opts);
                                  // setState(() {
                                  //   page = page + 1;
                                  // });
                                },
                                child: Container(
                                  width: ScreenUtil().screenWidth,
                                  height: ScreenUtil().setSp(50),
                                  color: Colors.red,
                                ),
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
                                  FilterBtnOptions(
                                    title: '전체',
                                    callback: () => refetch(),
                                  ),
                                  FilterBtnOptions(
                                    title: '바닷가',
                                    callback: () => refetch(),
                                  ),
                                  FilterBtnOptions(
                                    title: '액티비티',
                                    callback: () => refetch(),
                                  ),
                                  FilterBtnOptions(
                                    title: '맛집',
                                    callback: () => refetch(),
                                  ),
                                  FilterBtnOptions(
                                    title: '숙소',
                                    callback: () => refetch(),
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
                  }),
                  drawer: MenuDrawer(customerId: widget.customerId),
                ),
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

  Expanded gridBuilder(
      String latitudeFirst,
      String latitudeSecond,
      String longitudeOne,
      String longitudeSecond,
      List<Map<dynamic, dynamic>> imageMaps) {
    return Expanded(
        child: Query(
            options: QueryOptions(
              document: gql(Queries.promotionsList),
              variables: {
                "latitude1": latitudeFirst,
                "latitude2": latitudeSecond,
                "longitude1": longitudeOne,
                "longitude2": longitudeSecond,
              },
            ),
            builder: (result, {refetch, fetchMore}) {
              int i = 0;
              if (!result.isLoading && result.data != null) {
                // print(
                //     "🚨 promotionslist result : ${result.data["promotions_list"]}");

                for (Map resultData in result.data["promotions_list"]) {
                  int promotionsId =
                      int.parse("${resultData["promotions_id"]}");
                  String adImageUrl = "${resultData["image_link"]}";
                  List adUrlList = adImageUrl.split(",");
                  String adMainText = "${resultData["main_text"]}";
                  String adLocationLink = "${resultData["location_link"]}";
                  Map adMapData = {
                    "promotionsId": promotionsId,
                    "imageLink": adUrlList,
                    "mainText": adMainText,
                    "locationLink": adLocationLink,
                    "isAd": true,
                  };

                  if (imageMaps.length > i * 10 - 1) {
                    imageMaps.insert(i * 10, adMapData);
                  }
                  i++;
                }

                return Container(
                  child: GridView.builder(
                      itemCount: imageMaps.length,
                      physics: ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        mainAxisSpacing: ScreenUtil().setSp(1),
                        crossAxisSpacing: ScreenUtil().setSp(1),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return !imageMaps[index]["isAd"]
                            ? InkWell(
                                onTap: () {
                                  Get.to(() => PlaceDetailScreen(
                                        contentsId: imageMaps[index]
                                            ["contentsId"],
                                        customerId: widget.customerId,
                                      ));
                                },
                                child: CachedNetworkImage(
                                  imageUrl: imageMaps[index]["imageLink"],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      CupertinoActivityIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  Map mapData = {
                                    "promotionsId": imageMaps[index]
                                        ["promotionsId"],
                                    "imageLink": imageMaps[index]["imageLink"],
                                    "mainText": imageMaps[index]["mainText"],
                                    "locationLink": imageMaps[index]
                                        ["locationLink"],
                                  };
                                  Get.to(() => PlaceDetailAdScreen(
                                        mapData: mapData,
                                      ));
                                },
                                child: Stack(
                                  children: [
                                    Positioned(
                                      child: CachedNetworkImage(
                                        width: ScreenUtil().screenWidth,
                                        height: ScreenUtil().screenHeight,
                                        imageUrl: imageMaps[index]["imageLink"]
                                            [0],
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            CupertinoActivityIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                    Positioned(
                                      top: ScreenUtil().setSp(4),
                                      right: ScreenUtil().setSp(4),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: ScreenUtil().setSp(8),
                                          vertical: ScreenUtil().setSp(2),
                                        ),
                                        decoration: BoxDecoration(
                                          color: app_blue,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "AD",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(12),
                                              letterSpacing: -0.35,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                      }),
                );
              } else {
                return Container();
              }
            }));
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
    if (this.mounted) {
      Get.off(() => HomePage(),
          arguments: index, transition: Transition.noTransition);
    }
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomePage()),
    // );
  }
}
