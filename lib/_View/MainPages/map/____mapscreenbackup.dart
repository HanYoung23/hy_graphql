// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:letsgotrip/_Controller/floating_button_controller.dart';
// import 'package:letsgotrip/_Controller/google_map_whole_controller.dart';
// import 'package:letsgotrip/_Controller/notification_controller.dart';
// import 'package:letsgotrip/_Controller/permission_controller.dart';
// import 'package:letsgotrip/_View/MainPages/map/map_around_screen.dart';
// import 'package:letsgotrip/constants/common_value.dart';
// import 'package:letsgotrip/functions/user_location.dart';
// import 'package:letsgotrip/storage/storage.dart';
// import 'package:letsgotrip/widgets/add_button.dart';
// import 'package:letsgotrip/widgets/calendar_bottom_sheet.dart';
// import 'package:letsgotrip/widgets/filter_button.dart';
// import 'package:letsgotrip/widgets/google_map_container.dart';
// import 'package:letsgotrip/widgets/graphql_query.dart';
// import 'package:letsgotrip/widgets/loading_indicator.dart';
// import 'package:letsgotrip/_View/MainPages/settings/menu_drawer_screen.dart';
// import 'package:letsgotrip/widgets/location_unable_screen.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({
//     Key key,
//   }) : super(key: key);

//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
//   GoogleMapWholeController gmWholeController =
//       Get.put(GoogleMapWholeController());
//   // GoogleMapWholeController gmWholeImages = Get.find();
//   // GoogleMapWholeController gmWholeLatLng = Get.find();
//   GoogleMapWholeController gmPosition = Get.find();
//   GoogleMapWholeController gmUpdate = Get.find();
//   GoogleMapWholeController gmWholeLatLng = Get.find();

//   FloatingButtonController floatingBtnController =
//       Get.put(FloatingButtonController());
//   FloatingButtonController floatingBtn = Get.find();
//   FloatingButtonController fliterValue = Get.find();

//   NotificationContoller notificationContoller =
//       Get.put(NotificationContoller());
//   NotificationContoller globalNotification = Get.find();

//   final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

//   bool isPermission = true;
//   bool isMapLoading = true;
//   Position userPosition;
//   int customerId;

//   filterBtnCallback(int callbackInt) {
//     setState(() {
//       isMapLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     checkLocationPermission().then((permission) {
//       // print("🚨 permission $permission");
//       if (permission) {
//         getUserLocation().then((latlng) {
//           if (latlng != null) {
//             setState(() {
//               userPosition = latlng;
//               isMapLoading = false;
//               isPermission = permission;
//             });
//           }
//         });
//       } else {
//         setState(() {
//           isMapLoading = false;
//           isPermission = permission;
//         });
//         // permissionPopup(context, "위치 검색이 허용되어있지 않습니다.\n설정에서 허용 후 이용가능합니다.");
//       }
//     });
//     // didChangeAppLifecycleState(state);
//     seeValue("customerId").then((value) {
//       setState(() {
//         customerId = int.parse(value);
//       });
//     });
//     WidgetsBinding.instance.addObserver(this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     // print("🚨 state $state");
//     if (!isPermission) {
//       if (state == AppLifecycleState.resumed) {
//         checkLocationPermission().then((permission) {
//           // print("🚨 permission $permission");
//           if (permission) {
//             getUserLocation().then((latlng) {
//               if (latlng != null) {
//                 setState(() {
//                   userPosition = latlng;
//                   isMapLoading = false;
//                   isPermission = permission;
//                 });
//               }
//             });
//           } else {
//             setState(() {
//               isMapLoading = false;
//               isPermission = permission;
//             });
//             // permissionPopup(context, "위치 검색이 허용되어있지 않습니다.\n설정에서 허용 후 이용가능합니다.");
//           }
//         });
//       }
//     } else {
//       // WidgetsBinding.instance.removeObserver(this);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isPermission
//         ? Obx(() => Query(
//             options: QueryOptions(
//               document: gql(Queries.photoListMap),
//               variables: {
//                 // "latitude1": "${gmWholeLatLng.latlngBounds["swLat"]}",
//                 // "latitude2": "${gmWholeLatLng.latlngBounds["neLat"]}",
//                 // "longitude1": "${gmWholeLatLng.latlngBounds["swLng"]}",
//                 // "longitude2": "${gmWholeLatLng.latlngBounds["neLng"]}",
//                 "latitude1": "0",
//                 "latitude2": "0",
//                 "longitude1": "0",
//                 "longitude2": "0",
//                 "category_id": fliterValue.category.value,
//                 "date1": fliterValue.dateStart.value,
//                 "date2": fliterValue.dateEnd.value,
//                 "page": 0,
//               },
//             ),
//             builder: (result, {refetch, fetchMore}) {
//               Map queryParams = {
//                 "category_id": fliterValue.category.value,
//                 "date1": fliterValue.dateStart.value,
//                 "date2": fliterValue.dateEnd.value,
//               };

//               if (!result.isLoading && result.data != null) {
//                 List<Map> photoMapMarkerList = [];
//                 // print(
//                 // "🚨 result photo : ${result.data["photo_list_map"]["results"]}");
//                 // "🚨 result photo : ${result.data["photo_list_map"]["results"]}");

//                 // print(
//                 // "🚨 map screen length : ${result.data["photo_list_map"]["results"].length}");

//                 // if (gmUpdate.isGmUpdate.value) {
//                 //   gmWholeController.setIsGmUpdate(false);
//                 //   refetch();
//                 // }

//                 // WidgetsBinding.instance.addPostFrameCallback((_) {
//                 //   if (gmUpdate.markerNum !=
//                 //           result.data["photo_list_map"]["results"].length &&
//                 //       gmUpdate.markerNum.value != 0 &&
//                 //       Platform.isAndroid) {
//                 //     refetch();
//                 //   }
//                 // });

//                 if (result.data != null) {
//                   if (result.data["photo_list_map"]["results"].length > 0) {
//                     for (Map resultData in result.data["photo_list_map"]
//                         ["results"]) {
//                       int customerId =
//                           int.parse("${resultData["customer_id"]}");
//                       int contentsId =
//                           int.parse("${resultData["contents_id"]}");
//                       int categoryId =
//                           int.parse("${resultData["category_id"]}");
//                       List<String> imageLink =
//                           ("${resultData["image_link"]}").split(",");
//                       List<String> tags = ("${resultData["tags"]}").split(",");
//                       List<int> starRating = [
//                         resultData["star_rating1"],
//                         resultData["star_rating2"],
//                         resultData["star_rating3"],
//                         resultData["star_rating4"],
//                       ];
//                       double latitude =
//                           double.parse("${resultData["latitude"]}");
//                       double longitude =
//                           double.parse("${resultData["longitude"]}");

//                       Map<dynamic, dynamic> photoDataMap = {
//                         "customerId": customerId,
//                         "contentsId": contentsId,
//                         "categoryId": categoryId,
//                         "contentsTitle": "${resultData["contents_title"]}",
//                         "locationLink": "${resultData["location_link"]}",
//                         "imageLink": imageLink,
//                         "mainText": "${resultData["main_text"]}",
//                         "tags": tags,
//                         "starRating": starRating,
//                         "latitude": latitude,
//                         "longitude": longitude,
//                         "registDate": "${resultData["regist_date"]}"
//                       };

//                       photoMapMarkerList.add(photoDataMap);
//                     }
//                   }
//                 }

//                 return Scaffold(
//                   key: scaffoldKey,
//                   body: Stack(children: [
//                     Positioned(
//                       child: Container(
//                         color: Colors.white,
//                         width: ScreenUtil().screenWidth,
//                         height: ScreenUtil().screenHeight -
//                             MediaQuery.of(context).padding.top -
//                             MediaQuery.of(context).padding.bottom,
//                         child: Column(
//                           children: [
//                             SizedBox(height: ScreenUtil().setSp(20)),
//                             Container(
//                               width: ScreenUtil().screenWidth,
//                               height: ScreenUtil().setSp(46),
//                               padding: EdgeInsets.symmetric(
//                                   vertical: ScreenUtil().setSp(8),
//                                   horizontal: ScreenUtil().setSp(20)),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Query(
//                                       options: QueryOptions(
//                                         document: gql(Queries.checkList),
//                                         variables: {"customer_id": customerId},
//                                       ),
//                                       builder: (result, {refetch, fetchMore}) {
//                                         if (!result.isLoading &&
//                                             result.data != null) {
//                                           // print(
//                                           //     "🧾 settings result : ${result.data["check_list"]}");
//                                           List resultData =
//                                               result.data["check_list"];
//                                           bool isNoti = false;
//                                           for (Map checkListMap in resultData) {
//                                             if (checkListMap["check"] == 1) {
//                                               WidgetsBinding.instance
//                                                   .addPostFrameCallback((_) =>
//                                                       notificationContoller
//                                                           .updateIsNotification(
//                                                               true));
//                                               isNoti = true;
//                                             }
//                                           }
//                                           if (!isNoti) {
//                                             WidgetsBinding.instance
//                                                 .addPostFrameCallback((_) =>
//                                                     notificationContoller
//                                                         .updateIsNotification(
//                                                             false));
//                                           }
//                                           return InkWell(
//                                             onTap: () {
//                                               scaffoldKey.currentState
//                                                   .openDrawer();
//                                             },
//                                             child: Obx(() => Image.asset(
//                                                 !globalNotification
//                                                         .isNotification.value
//                                                     ? "assets/images/hamburger_button.png"
//                                                     : "assets/images/hamburger_button_active.png",
//                                                 width: ScreenUtil().setSp(28),
//                                                 height:
//                                                     ScreenUtil().setSp(28))),
//                                           );
//                                         } else {
//                                           return InkWell(
//                                             onTap: () {
//                                               scaffoldKey.currentState
//                                                   .openDrawer();
//                                             },
//                                             child: Image.asset(
//                                                 "assets/images/hamburger_button.png",
//                                                 width: ScreenUtil().setSp(28),
//                                                 height: ScreenUtil().setSp(28)),
//                                           );
//                                         }
//                                       }),
//                                   Spacer(),
//                                   InkWell(
//                                     // onTap: () {
//                                     //   setState(() {
//                                     //     isLeftTap = true;
//                                     //   });
//                                     // },
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceAround,
//                                       children: [
//                                         Container(
//                                             width: ScreenUtil().setSp(78),
//                                             height: ScreenUtil().setSp(24),
//                                             child: Center(
//                                               child: Text("지도",
//                                                   style: TextStyle(
//                                                       fontFamily:
//                                                           "NotoSansCJKkrBold",
//                                                       color:
//                                                           // isLeftTap
//                                                           //     ?
//                                                           app_font_black,
//                                                       // : app_font_grey,
//                                                       fontSize: ScreenUtil()
//                                                           .setSp(16),
//                                                       letterSpacing:
//                                                           letter_spacing)),
//                                             )),
//                                         // isLeftTap
//                                         //     ?
//                                         Container(
//                                           color: app_blue,
//                                           width: ScreenUtil().setSp(30),
//                                           height: ScreenUtil().setSp(3),
//                                         )
//                                         // : Container()
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(width: ScreenUtil().setSp(8)),
//                                   InkWell(
//                                     onTap: () {
//                                       if (this.mounted) {
//                                         Get.to(
//                                             () => MapAroundScreen(
//                                                 customerId: customerId),
//                                             transition:
//                                                 Transition.noTransition);
//                                       }
//                                     },
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceAround,
//                                       children: [
//                                         Container(
//                                             width: ScreenUtil().setSp(78),
//                                             height: ScreenUtil().setSp(24),
//                                             child: Center(
//                                               child: Text("둘러보기",
//                                                   style: TextStyle(
//                                                       fontFamily:
//                                                           "NotoSansCJKkrBold",
//                                                       color:
//                                                           // isLeftTap
//                                                           //     ?
//                                                           app_font_grey,
//                                                       // : app_font_black,
//                                                       fontSize: ScreenUtil()
//                                                           .setSp(16),
//                                                       letterSpacing:
//                                                           letter_spacing)),
//                                             )),
//                                         // !isLeftTap
//                                         //     ? Container(
//                                         //         color: app_blue,
//                                         //         width: ScreenUtil().setSp(60),
//                                         //         height: ScreenUtil().setSp(3),
//                                         //       )
//                                         //     :
//                                         Container(
//                                           width: ScreenUtil().setSp(60),
//                                           height: ScreenUtil().setSp(3),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   Spacer(),
//                                   InkWell(
//                                     onTap: () {
//                                       showModalBottomSheet(
//                                           backgroundColor: Colors.transparent,
//                                           context: context,
//                                           builder: (_) => CalendarBottomSheet(
//                                               refetchCallback: () => refetch),
//                                           isScrollControlled: true);
//                                     },
//                                     child: Image.asset(
//                                         "assets/images/locationTap/calender_button.png",
//                                         width: ScreenUtil().setSp(28),
//                                         height: ScreenUtil().setSp(28)),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Visibility(
//                                 visible: isMapLoading ? false : true,
//                                 child: Expanded(
//                                   child: Obx(() => Stack(
//                                         alignment: Alignment.center,
//                                         children: [
//                                           Positioned(
//                                             child: (gmUpdate.markerNum.value != 0 &&
//                                                     gmUpdate.markerNum.value !=
//                                                         result
//                                                             .data["photo_list_map"]
//                                                                 ["results"]
//                                                             .length)
//                                                 ? GoogleMapContainer(
//                                                     // photoMapList:
//                                                     //     photoMapMarkerList,
//                                                     userPosition: userPosition,
//                                                     currentCameraPosition:
//                                                         gmPosition
//                                                             .currentCameraPosition
//                                                             .value,
//                                                     category: fliterValue
//                                                         .category.value,
//                                                     dateStart: fliterValue
//                                                         .dateStart.value,
//                                                     dateEnd: fliterValue
//                                                         .dateEnd.value,
//                                                     queryParams: queryParams,
//                                                     refetchCallback: refetch)
//                                                 : GoogleMapContainer(
//                                                     // photoMapList:
//                                                     //     photoMapMarkerList,
//                                                     userPosition: userPosition,
//                                                     currentCameraPosition:
//                                                         gmPosition
//                                                             .currentCameraPosition
//                                                             .value,
//                                                     category: fliterValue
//                                                         .category.value,
//                                                     dateStart: fliterValue
//                                                         .dateStart.value,
//                                                     dateEnd: fliterValue
//                                                         .dateEnd.value,
//                                                     queryParams: queryParams,
//                                                     refetchCallback: refetch),
//                                           ),
//                                           gmWholeController
//                                                   .isMarkerLoading.value
//                                               ? Positioned(
//                                                   child: Image.asset(
//                                                   "assets/images/spinner.gif",
//                                                   width: ScreenUtil().setSp(50),
//                                                   height:
//                                                       ScreenUtil().setSp(50),
//                                                 ))
//                                               : Container()
//                                         ],
//                                       )),
//                                 )),
//                             // : Expanded(
//                             //     child: Container(
//                             //         child: Text("위치 권한 허용 후 이용가능합니다."))),
//                             isMapLoading
//                                 ? Expanded(
//                                     child: Center(
//                                       child: LoadingIndicator(),
//                                     ),
//                                   )
//                                 : Container(),
//                           ],
//                         ),
//                       ),
//                     ),
//                     FilterBtn(isActive: ""),
//                     AddBtn(isActive: ""),
//                     Obx(() => floatingBtn.isFilterActive.value ||
//                             floatingBtn.isAddActive.value
//                         ? Positioned(
//                             child: InkWell(
//                             onTap: () {
//                               floatingBtnController.allBtnCancel();
//                             },
//                             child: Container(
//                               width: ScreenUtil().screenWidth,
//                               height: ScreenUtil().screenHeight,
//                               color: Colors.black.withOpacity(0.7),
//                             ),
//                           ))
//                         : Container()),
//                     Obx(() => floatingBtn.isFilterActive.value
//                         ? Positioned(
//                             bottom: ScreenUtil().setSp(80),
//                             left: ScreenUtil().setSp(18),
//                             child: Column(
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     setState(() {
//                                       isMapLoading = true;
//                                     });
//                                   },
//                                   child: FilterBtnOptions(
//                                       title: '전체', callback: () => refetch()),
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     setState(() {
//                                       isMapLoading = true;
//                                     });
//                                   },
//                                   child: FilterBtnOptions(
//                                       title: '관광지', callback: () => refetch()),
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     setState(() {
//                                       isMapLoading = true;
//                                     });
//                                   },
//                                   child: FilterBtnOptions(
//                                       title: '액티비티', callback: () => refetch()),
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     setState(() {
//                                       isMapLoading = true;
//                                     });
//                                   },
//                                   child: FilterBtnOptions(
//                                       title: '맛집', callback: () => refetch()),
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     setState(() {
//                                       isMapLoading = true;
//                                     });
//                                   },
//                                   child: FilterBtnOptions(
//                                       title: '숙소', callback: () => refetch()),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : Container()),
//                     Obx(() => floatingBtn.isAddActive.value
//                         ? Positioned(
//                             bottom: ScreenUtil().setSp(80),
//                             right: ScreenUtil().setSp(18),
//                             child: AddBtnOptions(title: '글쓰기'),
//                           )
//                         : Container()),
//                     Obx(() => floatingBtn.isFilterActive.value
//                         ? FilterBtn(isActive: "active")
//                         : Container()),
//                     Obx(() => floatingBtn.isAddActive.value
//                         ? AddBtn(isActive: "active")
//                         : Container()),
//                   ]),
//                   drawer: MenuDrawer(customerId: customerId),
//                 );
//               } else {
//                 return SafeArea(
//                   top: false,
//                   bottom: false,
//                   child: Scaffold(
//                     backgroundColor: Colors.white,
//                     appBar: AppBar(
//                       toolbarHeight: 0,
//                       elevation: 0,
//                       backgroundColor: Colors.white,
//                       brightness: Brightness.light,
//                     ),
//                     body: Container(
//                         width: ScreenUtil().screenWidth,
//                         height: ScreenUtil().screenHeight,
//                         child: Center(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               LoadingIndicator(),
//                             ],
//                           ),
//                         )),
//                   ),
//                 );
//               }
//             }))
//         : LocationUnableScreen();
//   }
// }
