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
  List pages = [1];

  bool onNotification(ScrollEndNotification t) {
    if (t.metrics.pixels > 0 && t.metrics.atEdge && this.mounted) {
      List newPages = pages;
      int lastPage = newPages.length;
      newPages.add(lastPage + 1);
      setState(() {
        pages = newPages;
      });
      // print("🚨 ${pages.length}");
    } else {
      // print('I am at the start');
    }
    return true;
  }

  @override
  void dispose() {
    // floatingBtnController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Query(
        options: QueryOptions(
          document: gql(Queries.photoListMapCount),
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
          int categoryId = fliterValue.category.value;
          String dateLeft = fliterValue.dateStart.value;
          String dateRight = fliterValue.dateEnd.value;

          if (!result.isLoading && result.data != null) {
            int pageCount = result.data["photo_list_map"]["count"];

            return GestureDetector(
                onTap: () {
                  floatingBtnController.allBtnCancel();
                },
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: NotificationListener(
                    onNotification:
                        pages.length != pageCount ? onNotification : null,
                    child: Obx(() {
                      return Scaffold(
                        key: scaffoldKey,
                        appBar: AppBar(
                          toolbarHeight: 0,
                          elevation: 0,
                          backgroundColor: floatingBtn.isFilterActive.value ||
                                  floatingBtn.isAddActive.value
                              ? Colors.black.withOpacity(0.7)
                              : Colors.white,
                          brightness: floatingBtn.isFilterActive.value ||
                                  floatingBtn.isAddActive.value
                              ? Brightness.dark
                              : Brightness.light,
                        ),
                        body: Stack(
                          children: [
                            Positioned(
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    SizedBox(height: ScreenUtil().setSp(20)),
                                    Container(
                                      width: ScreenUtil().screenWidth,
                                      height: ScreenUtil().setSp(46),
                                      padding: EdgeInsets.symmetric(
                                          vertical: ScreenUtil().setSp(8),
                                          horizontal: ScreenUtil().setSp(20)),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              scaffoldKey.currentState
                                                  .openDrawer();
                                            },
                                            child: Image.asset(
                                                "assets/images/hamburger_button.png",
                                                width: ScreenUtil().setSp(28),
                                                height: ScreenUtil().setSp(28)),
                                          ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                    width:
                                                        ScreenUtil().setSp(78),
                                                    height:
                                                        ScreenUtil().setSp(24),
                                                    child: Center(
                                                      child: Text("지도",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "NotoSansCJKkrBold",
                                                              color:
                                                                  app_font_grey,
                                                              fontSize: ScreenUtil()
                                                                  .setSp(
                                                                      appbar_title_size),
                                                              letterSpacing:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          letter_spacing))),
                                                    )),
                                                Container(
                                                  width: ScreenUtil().setSp(60),
                                                  height: ScreenUtil().setSp(3),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              width: ScreenUtil().setSp(8)),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                  width: ScreenUtil().setSp(78),
                                                  height:
                                                      ScreenUtil().setSp(24),
                                                  child: Center(
                                                    child: Text("둘러보기",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "NotoSansCJKkrBold",
                                                            color:
                                                                app_font_black,
                                                            fontSize: ScreenUtil()
                                                                .setSp(
                                                                    appbar_title_size),
                                                            letterSpacing:
                                                                ScreenUtil().setSp(
                                                                    letter_spacing))),
                                                  )),
                                              Container(
                                                color: app_blue,
                                                width: ScreenUtil().setSp(60),
                                                height: ScreenUtil().setSp(3),
                                              )
                                            ],
                                          ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder: (_) =>
                                                      CalendarBottomSheet(
                                                          refetchCallback: () =>
                                                              refetch),
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
                                    pageCount > 0
                                        ? Query(
                                            options: QueryOptions(
                                              document:
                                                  gql(Queries.promotionsList),
                                              variables: {
                                                "latitude1": latitudeFirst,
                                                "latitude2": latitudeSecond,
                                                "longitude1": longitudeOne,
                                                "longitude2": longitudeSecond,
                                              },
                                            ),
                                            builder: (result,
                                                {refetch, fetchMore}) {
                                              if (!result.isLoading &&
                                                  result.data != null) {
                                                // print(
                                                //     "🚨 promotionslist result : ${result.data["promotions_list"]}");
                                                List adMapList = [];

                                                for (Map resultData in result
                                                    .data["promotions_list"]) {
                                                  int promotionsId = int.parse(
                                                      "${resultData["promotions_id"]}");
                                                  String adImageUrl =
                                                      "${resultData["image_link"]}";
                                                  List adUrlList =
                                                      adImageUrl.split(",");
                                                  String adMainText =
                                                      "${resultData["main_text"]}";
                                                  String adLocationLink =
                                                      "${resultData["location_link"]}";
                                                  Map adMapData = {
                                                    "promotionsId":
                                                        promotionsId,
                                                    "imageLink": adUrlList,
                                                    "mainText": adMainText,
                                                    "locationLink":
                                                        adLocationLink,
                                                    "isAd": true,
                                                  };
                                                  adMapList.add(adMapData);
                                                }

                                                // adMapList.sublist(1, 3);

                                                return photoQuery(
                                                  latitudeFirst,
                                                  latitudeSecond,
                                                  longitudeOne,
                                                  longitudeSecond,
                                                  categoryId,
                                                  dateLeft,
                                                  dateRight,
                                                  adMapList,
                                                );
                                              } else {
                                                return Container();
                                              }
                                            })
                                        : Expanded(
                                            child: Center(
                                                child: Text(
                                              "조건에 맞는 게시물이 없습니다.\n다른 조건으로 검색해보시는건 어떠세요?",
                                              style: TextStyle(
                                                fontFamily:
                                                    "NotoSansCJKkrRegular",
                                                fontSize:
                                                    ScreenUtil().setSp(16),
                                                letterSpacing: ScreenUtil()
                                                    .setSp(letter_spacing),
                                                color: Color.fromRGBO(
                                                    185, 185, 185, 1),
                                              ),
                                              overflow: TextOverflow.fade,
                                              textAlign: TextAlign.center,
                                            )),
                                          ),
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
                        bottomNavigationBar: BottomNavigationBar(
                          backgroundColor: floatingBtn.isFilterActive.value ||
                                  floatingBtn.isAddActive.value
                              ? Colors.black.withOpacity(0.7)
                              : Colors.white,
                          type: BottomNavigationBarType.fixed,
                          fixedColor: floatingBtn.isFilterActive.value ||
                                  floatingBtn.isAddActive.value
                              ? app_blue.withOpacity(0.3)
                              : app_blue,
                          items: [
                            BottomNavigationBarItem(
                              activeIcon: Image.asset(
                                "assets/images/nav_store.png",
                                width: ScreenUtil().setSp(30),
                                height: ScreenUtil().setSp(30),
                              ),
                              icon: Image.asset(
                                "assets/images/nav_store_grey.png",
                                width: ScreenUtil().setSp(30),
                                height: ScreenUtil().setSp(30),
                                color: floatingBtn.isFilterActive.value ||
                                        floatingBtn.isAddActive.value
                                    ? Colors.black.withOpacity(0.7)
                                    : Colors.grey,
                              ),
                              label: "스토어",
                            ),
                            BottomNavigationBarItem(
                                activeIcon: Image.asset(
                                  "assets/images/nav_location.png",
                                  width: ScreenUtil().setSp(30),
                                  height: ScreenUtil().setSp(30),
                                  color: floatingBtn.isFilterActive.value ||
                                          floatingBtn.isAddActive.value
                                      ? app_blue.withOpacity(0.3)
                                      : app_blue,
                                ),
                                icon: Image.asset(
                                  "assets/images/nav_location_grey.png",
                                  width: ScreenUtil().setSp(30),
                                  height: ScreenUtil().setSp(30),
                                ),
                                label: "장소"),
                            BottomNavigationBarItem(
                                activeIcon: Image.asset(
                                  "assets/images/nav_profile.png",
                                  width: ScreenUtil().setSp(30),
                                  height: ScreenUtil().setSp(30),
                                ),
                                icon: Image.asset(
                                  "assets/images/nav_profile_grey.png",
                                  width: ScreenUtil().setSp(30),
                                  height: ScreenUtil().setSp(30),
                                  color: floatingBtn.isFilterActive.value ||
                                          floatingBtn.isAddActive.value
                                      ? Colors.black.withOpacity(0.7)
                                      : Colors.grey,
                                ),
                                label: "마이페이지"),
                          ],
                          currentIndex: 1,
                          onTap: floatingBtn.isFilterActive.value ||
                                  floatingBtn.isAddActive.value
                              ? null
                              : _onBtmItemClick,
                          showSelectedLabels: true,
                          elevation: 0,
                          selectedLabelStyle: TextStyle(
                            fontFamily: "NotoSansCJKkrMedium",
                            fontSize: ScreenUtil().setSp(10),
                            letterSpacing: ScreenUtil().setSp(-0.25),
                            color: Colors.red,
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontFamily: "NotoSansCJKkrMedium",
                            fontSize: ScreenUtil().setSp(10),
                            letterSpacing: ScreenUtil().setSp(-0.25),
                          ),
                        ),
                        drawer: MenuDrawer(customerId: widget.customerId),
                      );
                    }),
                  ),
                ));
          } else {
            return SafeArea(
              top: false,
              bottom: false,
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  toolbarHeight: 0,
                  elevation: 0,
                  backgroundColor: Colors.white,
                  brightness: Brightness.light,
                ),
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

  Flexible photoQuery(
    String latitudeFirst,
    String latitudeSecond,
    String longitudeOne,
    String longitudeSecond,
    int categoryId,
    String dateLeft,
    String dateRight,
    List adMapList,
  ) {
    return Flexible(
      child: ListView(
        shrinkWrap: true,
        children: pages.map((page) {
          return Query(
              options: QueryOptions(
                document: gql(Queries.photoListMap),
                variables: {
                  "latitude1": latitudeFirst,
                  "latitude2": latitudeSecond,
                  "longitude1": longitudeOne,
                  "longitude2": longitudeSecond,
                  "category_id": categoryId,
                  "date1": dateLeft,
                  "date2": dateRight,
                  "page": page
                },
              ),
              builder: (result, {refetch, fetchMore}) {
                if (!result.isLoading && result.data != null) {
                  List<Map> imageMaps = [];
                  for (Map resultData in result.data["photo_list_map"]
                      ["results"]) {
                    int contentsId = int.parse("${resultData["contents_id"]}");
                    String imageUrl = "${resultData["image_link"]}";
                    List urlList = imageUrl.split(",");
                    Map mapData = {
                      "contentsId": contentsId,
                      "imageLink": urlList[0],
                      "isAd": false,
                    };
                    imageMaps.add(mapData);
                  }

                  int num = (page - 1) * 10;
                  for (int i = 0; i < 10; i++) {
                    if (imageMaps.length > (num + i) * 10 - 1 &&
                        adMapList.length > (num + i)) {
                      imageMaps.insert((num + i) * 10, adMapList[num + i]);
                    }
                  }

                  int length = imageMaps.length;
                  if ((length % 3) != 0 && length > 89) {
                    for (int i = 0; i < 3 - length % 3; i++) {
                      imageMaps.add(imageMaps[i + 1]);
                    }
                  }

                  return gridBuilder(imageMaps, page);
                } else {
                  return Container();
                }
              });
        }).toList(),
      ),
    );
  }

  Wrap gridBuilder(List<Map<dynamic, dynamic>> imageMaps, int page) {
    return Wrap(
        spacing: ScreenUtil().setSp(1),
        runSpacing: ScreenUtil().setSp(1),
        direction: Axis.horizontal,
        children: imageMaps.map((item) {
          int index = imageMaps.indexOf(item);
          return !imageMaps[index]["isAd"]
              ? InkWell(
                  onTap: () {
                    Get.to(() => PlaceDetailScreen(
                          contentsId: imageMaps[index]["contentsId"],
                          customerId: widget.customerId,
                        ));
                  },
                  child: CachedNetworkImage(
                    width: ScreenUtil().screenWidth / 3 - ScreenUtil().setSp(2),
                    height:
                        ScreenUtil().screenWidth / 3 - ScreenUtil().setSp(2),
                    imageUrl: imageMaps[index]["imageLink"],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                )
              : InkWell(
                  onTap: () {
                    Map mapData = {
                      "promotionsId": imageMaps[index]["promotionsId"],
                      "imageLink": imageMaps[index]["imageLink"],
                      "mainText": imageMaps[index]["mainText"],
                      "locationLink": imageMaps[index]["locationLink"],
                    };
                    Get.to(() => PlaceDetailAdScreen(
                          mapData: mapData,
                        ));
                  },
                  child: Stack(
                    children: [
                      Positioned(
                        child: CachedNetworkImage(
                          width: ScreenUtil().screenWidth / 3 -
                              ScreenUtil().setSp(2),
                          height: ScreenUtil().screenWidth / 3 -
                              ScreenUtil().setSp(2),
                          imageUrl: imageMaps[index]["imageLink"][0],
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
                                BorderRadius.circular(ScreenUtil().setSp(50)),
                          ),
                          child: Center(
                            child: Text(
                              "AD",
                              style: TextStyle(
                                fontFamily: "NotoSansCJKkrRegular",
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(12),
                                letterSpacing:
                                    ScreenUtil().setSp(letter_spacing_small),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
        }).toList());
  }

  // List<BottomNavigationBarItem> btmNavItems = [
  //   BottomNavigationBarItem(
  //       icon: Image.asset(
  //         "assets/images/nav_store_grey.png",
  //         width: ScreenUtil().setSp(30),
  //         height: ScreenUtil().setSp(30),
  //       ),
  //       label: "스토어"),
  //   BottomNavigationBarItem(
  //       activeIcon: Image.asset(
  //         "assets/images/nav_location.png",
  //         width: ScreenUtil().setSp(30),
  //         height: ScreenUtil().setSp(30),
  //       ),
  //       icon: Image.asset(
  //         "assets/images/nav_location_grey.png",
  //         width: ScreenUtil().setSp(30),
  //         height: ScreenUtil().setSp(30),
  //       ),
  //       label: "장소"),
  //   BottomNavigationBarItem(
  //       icon: Image.asset(
  //         "assets/images/nav_profile_grey.png",
  //         width: ScreenUtil().setSp(30),
  //         height: ScreenUtil().setSp(30),
  //       ),
  //       label: "마이페이지"),
  // ];
  void _onBtmItemClick(int index) {
    if (this.mounted) {
      Get.off(() => HomePage(),
          arguments: index, transition: Transition.noTransition);
    }
  }
}
