// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui';
// import 'dart:ui' as ui;
// import 'package:fluster/fluster.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:letsgotrip/widgets/map_marker.dart';
// import 'package:intl/intl.dart' as intl;

// class MapHelper {
//   static Future<BitmapDescriptor> getMarkerImageFromUrl(String url) async {
//     File markerImageFile;
//     markerImageFile = await DefaultCacheManager().getSingleFile(url);
//     return convertImageFileToBitmapDescriptor(markerImageFile);
//   }

//   static Future<BitmapDescriptor> convertImageFileToBitmapDescriptor(
//       File imageFile) async {
//     final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
//     final Canvas canvas = Canvas(pictureRecorder);

//     int size = ScreenUtil().setSp(120).toInt();
//     int whitePadding = ScreenUtil().setSp(8).toInt();

//     Paint paint = Paint();
//     paint.color = Colors.white;

//     final rect =
//         Rect.fromLTWH(0, 0, ScreenUtil().setSp(120), ScreenUtil().setSp(120));
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(rect, Radius.circular(ScreenUtil().setSp(10))),
//         paint);
//     final Uint8List imageUint8List = await imageFile.readAsBytes();
//     final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List,
//         targetWidth: size - whitePadding, targetHeight: size - whitePadding);
//     final ui.FrameInfo imageFI = await codec.getNextFrame();
//     paintImage(
//         canvas: canvas,
//         rect: Rect.fromLTWH(
//             0, 0, ScreenUtil().setSp(120), ScreenUtil().setSp(120)),
//         image: imageFI.image,
//         alignment: Alignment.center);

//     final _image = await pictureRecorder.endRecording().toImage(size, size);
//     final data = await _image.toByteData(format: ui.ImageByteFormat.png);

//     return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
//   }

//   static Future<Fluster<MapMarker>> initClusterManager(
//     List<MapMarker> markers,
//     int minZoom,
//     int maxZoom,
//   ) async {
//     return Fluster<MapMarker>(
//       minZoom: minZoom,
//       maxZoom: maxZoom,
//       // radius: 150,
//       radius: ScreenUtil().setSp(250).toInt(),
//       extent: ScreenUtil().setSp(2048).toInt(),
//       nodeSize: ScreenUtil().setSp(64).toInt(),
//       points: markers,
//       createCluster: (
//         BaseCluster cluster,
//         double lng,
//         double lat,
//       ) =>
//           MapMarker(
//         id: cluster.id.toString(),
//         position: LatLng(lat, lng),
//         isCluster: cluster.isCluster,
//         clusterId: cluster.id,
//         pointsSize: cluster.pointsSize,
//         childMarkerId: cluster.childMarkerId,
//       ),
//     );
//   }

//   /// Gets a list of markers and clusters that reside within the visible bounding box for
//   /// the given [currentZoom]. For more info check [Fluster.clusters].
//   static Future<List<Marker>> getClusterMarkers(
//     Fluster<MapMarker> clusterManager,
//     double currentZoom,
//     // int clusterWidth,
//   ) {
//     if (clusterManager == null) return Future.value([]);

//     return Future.wait(clusterManager.clusters(
//       [-180, -85, 180, 85],
//       currentZoom.toInt(),
//     ).map((mapMarker) async {
//       if (mapMarker.isCluster) {
//         mapMarker.icon = await _getClusterMarker(mapMarker);
//       }

//       return mapMarker.toMarker();
//     }).toList());
//   }

//   static Future<BitmapDescriptor> _getClusterMarker(MapMarker mapMarker) async {
//     final PictureRecorder pictureRecorder = PictureRecorder();
//     final Canvas canvas = Canvas(pictureRecorder);
//     final Paint paint = Paint()..color = Colors.blue;
//     final TextPainter textPainter = TextPainter(
//       textDirection: TextDirection.ltr,
//     );
//     // final DecorationImagePainter

//     // //
//     String imageUrl = mapMarker.childMarkerId.substring(
//         mapMarker.childMarkerId.indexOf(",") + 1,
//         mapMarker.childMarkerId.length);

//     File markerImageFile;
//     markerImageFile = await DefaultCacheManager().getSingleFile(imageUrl);
//     int size = ScreenUtil().setSp(120).toInt();
//     int whitePadding = ScreenUtil().setSp(8).toInt();
//     paint.color = Colors.white;

//     final rect = Rect.fromLTWH(0, ScreenUtil().setSp(80),
//         ScreenUtil().setSp(120), ScreenUtil().setSp(120));
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(rect, Radius.circular(ScreenUtil().setSp(10))),
//         paint);

//     final Uint8List imageUint8List = await markerImageFile.readAsBytes();

//     final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List,
//         targetWidth: size - whitePadding,
//         targetHeight: size - whitePadding - ScreenUtil().setSp(4).toInt());
//     final ui.FrameInfo imageFI = await codec.getNextFrame();
//     paintImage(
//       canvas: canvas,
//       rect: Rect.fromLTWH(0, ScreenUtil().setSp(80), ScreenUtil().setSp(120),
//           ScreenUtil().setSp(120)),
//       image: imageFI.image,
//       alignment: Alignment.center,
//     );
//     // //
//     paint.color = Colors.blue;

//     String textNum = mapMarker.pointsSize.toString();
//     if (textNum.length > 3) {
//       textNum = intl.NumberFormat.compactCurrency(
//         decimalDigits: 2,
//         symbol: '',
//       ).format(int.parse(textNum));
//     }

//     int textLength = textNum.length;
//     final double radius = ScreenUtil().setSp(44);

//     double blueBoxWidth = textLength * ScreenUtil().setSp(16) + radius;
//     double blueBoxHeight = ScreenUtil().setSp(16) + radius;
//     double offsetX = size - blueBoxWidth / 2 - whitePadding / 2;

//     canvas.drawRRect(
//         RRect.fromRectAndRadius(
//             Rect.fromLTWH(offsetX, blueBoxHeight - whitePadding, blueBoxWidth,
//                 blueBoxHeight),
//             Radius.circular(ScreenUtil().setSp(50))),
//         paint);

//     double textSize = ScreenUtil().setSp(34);

//     textPainter.text = TextSpan(
//       text: textNum,
//       style: TextStyle(
//         fontSize: textSize,
//         fontWeight: FontWeight.bold,
//         color: Colors.white,
//         // backgroundColor: Colors.blue,
//       ),
//     );

//     textPainter.layout();
//     textPainter.paint(
//       canvas,
//       // Offset(radius - textPainter.width / 2 + textSize * 2 + whitePadding,
//       //     radius - textPainter.height / 2 + textSize + whitePadding),
//       Offset(offsetX + blueBoxWidth / 2 - textPainter.width / 2,
//           blueBoxHeight - whitePadding + textPainter.height / 4),
//     );

//     final image = await pictureRecorder.endRecording().toImage(
//           ScreenUtil().setSp(200).toInt(),
//           ScreenUtil().setSp(200).toInt(),
//         );
//     final data = await image.toByteData(format: ImageByteFormat.png);

//     return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
//   }
// }
