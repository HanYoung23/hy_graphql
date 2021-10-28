// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:letsgotrip/_View/MainPages/map/place_detail_screen.dart';

// class MapAroundScreen extends StatefulWidget {
//   final List imageMaps;
//   final int customerId;
//   const MapAroundScreen(
//       {Key key, @required this.imageMaps, @required this.customerId})
//       : super(key: key);

//   @override
//   _MapAroundScreenState createState() => _MapAroundScreenState();
// }

// class _MapAroundScreenState extends State<MapAroundScreen> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("🚨 images : ${widget.imageMaps}");
//     return widget.imageMaps.length > 0
//         ? Container(
//             width: ScreenUtil().screenWidth,
//             height: ScreenUtil().screenHeight * 0.5,
//             color: Colors.red,
//             child: GridView.builder(
//                 itemCount: widget.imageMaps.length,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   childAspectRatio: 1,
//                   mainAxisSpacing: ScreenUtil().setSp(1),
//                   crossAxisSpacing: ScreenUtil().setSp(1),
//                 ),
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap: () {
//                       // Get.to(() =>
//                       //     PlaceDetailScreen(
//                       //       contentsId:
//                       //           widget.imageMaps[index]
//                       //               ["contentsId"],
//                       //       customerId: customerId,
//                       //     ));

//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => PlaceDetailScreen(
//                                   contentsId: widget.imageMaps[index]
//                                       ["contentsId"],
//                                   customerId: widget.customerId,
//                                 )),
//                       );
//                     },
//                     child: Image.network(
//                       widget.imageMaps[index]["imageLink"],
//                       fit: BoxFit.cover,
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return CupertinoActivityIndicator();
//                       },
//                     ),
//                   );
//                 }),
//           )
//         : Center(
//             child: Image.asset(
//             "assets/images/map_around_content.png",
//             width: ScreenUtil().setSp(260),
//             height: ScreenUtil().setSp(48),
//           ));
//   }
// }
