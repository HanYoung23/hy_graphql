// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:letsgotrip/_Controller/floating_button_controller.dart';
// import 'package:letsgotrip/_Controller/google_map_whole_controller.dart';
// import 'package:letsgotrip/_View/MainPages/map/place_detail_screen.dart';
// import 'package:letsgotrip/widgets/graphql_query.dart';

// class MapAroundScreen extends StatefulWidget {
//   // final List imageMaps;
//   final int customerId;
//   const MapAroundScreen(
//       {Key key,
//       // @required this.imageMaps,
//       @required this.customerId})
//       : super(key: key);

//   @override
//   _MapAroundScreenState createState() => _MapAroundScreenState();
// }

// class _MapAroundScreenState extends State<MapAroundScreen> {
//   GoogleMapWholeController gmWholeController =
//       Get.put(GoogleMapWholeController());
//   GoogleMapWholeController gmWholeLatLng = Get.find();

//   FloatingButtonController floatingBtnController =
//       Get.put(FloatingButtonController());
//   FloatingButtonController fliterValue = Get.find();
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Query(
//         options: QueryOptions(
//           document: gql(Queries.photoListMap),
//           variables: {
//             "latitude1": "${gmWholeLatLng.latlngBounds["swLat"]}",
//             "latitude2": "${gmWholeLatLng.latlngBounds["neLat"]}",
//             "longitude1": "${gmWholeLatLng.latlngBounds["swLng"]}",
//             "longitude2": "${gmWholeLatLng.latlngBounds["neLng"]}",
//             "category_id": fliterValue.category.value,
//             "date1": fliterValue.dateStart.value,
//             "date2": fliterValue.dateEnd.value,
//           },
//         ),
//         builder: (result, {refetch, fetchMore}) {
//           if (!result.isLoading) {
//             List<Map> photoMapImageList = [];
//             for (Map resultData in result.data["photo_list_map"]) {
//               int contentsId = int.parse("${resultData["contents_id"]}");
//               String imageUrl = "${resultData["image_link"]}";
//               List urlList = imageUrl.split(",");
//               Map mapData = {
//                 "contentsId": contentsId,
//                 "imageLink": urlList[0],
//               };
//               photoMapImageList.add(mapData);
//             }
//             return photoMapImageList.length > 0
//                 ? Container(
//                     width: ScreenUtil().screenWidth,
//                     height: ScreenUtil().screenHeight * 0.5,
//                     color: Colors.red,
//                     child: GridView.builder(
//                         itemCount: photoMapImageList.length,
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3,
//                           childAspectRatio: 1,
//                           mainAxisSpacing: ScreenUtil().setSp(1),
//                           crossAxisSpacing: ScreenUtil().setSp(1),
//                         ),
//                         itemBuilder: (BuildContext context, int index) {
//                           return InkWell(
//                             onTap: () {
//                               // Get.to(() =>
//                               //     PlaceDetailScreen(
//                               //       contentsId:
//                               //           photoMapImageList[index]
//                               //               ["contentsId"],
//                               //       customerId: customerId,
//                               //     ));

//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => PlaceDetailScreen(
//                                           contentsId: photoMapImageList[index]
//                                               ["contentsId"],
//                                           customerId: widget.customerId,
//                                         )),
//                               );
//                             },
//                             child: Image.network(
//                               photoMapImageList[index]["imageLink"],
//                               fit: BoxFit.cover,
//                               loadingBuilder:
//                                   (context, child, loadingProgress) {
//                                 if (loadingProgress == null) return child;
//                                 return CupertinoActivityIndicator();
//                               },
//                             ),
//                           );
//                         }),
//                   )
//                 : Center(
//                     child: Image.asset(
//                     "assets/images/map_around_content.png",
//                     width: ScreenUtil().setSp(260),
//                     height: ScreenUtil().setSp(48),
//                   ));
//           } else {
//             return Container();
//           }
//         });
//   }
// }
