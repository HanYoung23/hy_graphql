import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/widgets/map_marker.dart';
import 'package:intl/intl.dart' as intl;

class MapHelper {
  double largeRatio = 0.35;
  double smallRatio = 0.24;

  static Future<BitmapDescriptor> getMarkerImageFromUrl(
      String url, double markerSize, String type) async {
    File markerImageFile;
    markerImageFile = await DefaultCacheManager().getSingleFile(url);
    return convertImageFileToBitmapDescriptor(
        markerImageFile, markerSize, type);
  }

  static Future<BitmapDescriptor> convertImageFileToBitmapDescriptor(
      File imageFile, double markerSize, String type) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    int size = (markerSize * 0.24).toInt();
    int whitePadding = ScreenUtil().setSp(8).toInt();

    Paint paint = Paint();
    paint.color = Colors.white;

    final rect = Rect.fromLTWH(0, 0, (markerSize * 0.24), (markerSize * 0.24));
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(ScreenUtil().setSp(10))),
        paint);
    final Uint8List imageUint8List = await imageFile.readAsBytes();
    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List,
        targetWidth: size - whitePadding, targetHeight: size - whitePadding);
    final ui.FrameInfo imageFI = await codec.getNextFrame();

    paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, (markerSize * 0.24), (markerSize * 0.24)),
        image: imageFI.image,
        alignment: Alignment.center);

    // AD
    if (type == "promotions") {
      print("🚨 type : $type");
      final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
      );
      paint.color = Colors.blue;
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(markerSize * 0.008, markerSize * 0.006,
                  markerSize * 0.1, markerSize * 0.06),
              Radius.circular(ScreenUtil().setSp(50))),
          paint);

      textPainter.text = TextSpan(
        text: "AD",
        style: TextStyle(
          fontSize: ScreenUtil().setSp(24),
          fontFamily: "NotoSansCJKkrBold",
          color: Colors.white,
          letterSpacing: ScreenUtil().setSp(letter_spacing_small),
          // backgroundColor: Colors.blue,
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        // Offset(
        //     markerSize * 0.008 + textPainter.width * 0.5, markerSize * 0.006),
        Offset(
            markerSize * 0.1 / 2 - textPainter.width * 0.5 + markerSize * 0.008,
            markerSize * 0.06 - textPainter.height - markerSize * 0.006),
      );
    }
    final _image = await pictureRecorder.endRecording().toImage(size, size);
    final data = await _image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  static Future<Fluster<MapMarker>> initClusterManager(
    List<MapMarker> markers,
    int minZoom,
    int maxZoom,
  ) async {
    return Fluster<MapMarker>(
      minZoom: minZoom,
      maxZoom: maxZoom,
      // radius: 150,
      radius: ScreenUtil().setSp(250).toInt(),
      extent: ScreenUtil().setSp(2048).toInt(),
      nodeSize: ScreenUtil().setSp(64).toInt(),
      points: markers,
      createCluster: (
        BaseCluster cluster,
        double lng,
        double lat,
      ) {
        // print("🚨 cluster child marker id : ${cluster.childMarkerId}");
        // print("🚨 cluster id : ${cluster.id}");
        // print("🚨 cluster marekr id : ${cluster.markerId}");
        return MapMarker(
          id: cluster.id.toString(),
          position: LatLng(lat, lng),
          isCluster: cluster.isCluster,
          clusterId: cluster.id,
          pointsSize: cluster.pointsSize,
          childMarkerId: cluster.childMarkerId,
        );
      },
    );
  }

  /// Gets a list of markers and clusters that reside within the visible bounding box for
  /// the given [currentZoom]. For more info check [Fluster.clusters].
  static Future<List<Marker>> getClusterMarkers(
      Fluster<MapMarker> clusterManager,
      double currentZoom,
      double markerSize) {
    if (clusterManager == null) return Future.value([]);

    return Future.wait(clusterManager.clusters(
      [-180, -85, 180, 85],
      currentZoom.toInt(),
    ).map((mapMarker) async {
      if (mapMarker.isCluster) {
        mapMarker.icon = await _getClusterMarker(mapMarker, markerSize);
      }

      return mapMarker.toMarker();
    }).toList());
  }

  static Future<BitmapDescriptor> _getClusterMarker(
      MapMarker mapMarker, double markerSize) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.blue;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    // final DecorationImagePainter
//
    // paint.color = Colors.red;
    // final redrect = Rect.fromLTWH(0, 0, (markerSize * 0.34),
    //     (markerSize * 0.34));
    // canvas.drawRRect(
    //     RRect.fromRectAndRadius(
    //         redrect, Radius.circular(ScreenUtil().setSp(10))),
    //     paint);
//
    //
    String imageUrl = mapMarker.childMarkerId.substring(
        mapMarker.childMarkerId.indexOf(",") + 1,
        mapMarker.childMarkerId.length);

    File markerImageFile;
    markerImageFile = await DefaultCacheManager().getSingleFile(imageUrl);
    int size = (markerSize * 0.24).toInt();
    int whitePadding = ScreenUtil().setSp(8).toInt();
    paint.color = Colors.white;

    final rect = Rect.fromLTWH(
        0, markerSize * 0.06, (markerSize * 0.24), (markerSize * 0.24));
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(ScreenUtil().setSp(10))),
        paint);

    final Uint8List imageUint8List = await markerImageFile.readAsBytes();

    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List,
        targetWidth: size - whitePadding,
        targetHeight: size - whitePadding - ScreenUtil().setSp(4).toInt());
    final ui.FrameInfo imageFI = await codec.getNextFrame();
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(
          0, markerSize * 0.06, (markerSize * 0.24), (markerSize * 0.24)),
      image: imageFI.image,
      alignment: Alignment.center,
    );
    //
    paint.color = Colors.blue;

    String textNum = mapMarker.pointsSize.toString();
    if (textNum.length > 3) {
      textNum = intl.NumberFormat.compactCurrency(
        decimalDigits: 2,
        symbol: '',
      ).format(int.parse(textNum));
    }

    int textLength = textNum.length;
    final double radius = ScreenUtil().setSp(40);

    double blueBoxWidth = textLength * markerSize * 0.03 + radius;
    double blueBoxHeight = markerSize * 0.03 + radius;
    double offsetX = size - blueBoxWidth / 2 - whitePadding / 2;

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(offsetX, markerSize * 0.015 + whitePadding,
                blueBoxWidth, blueBoxHeight),
            Radius.circular(ScreenUtil().setSp(50))),
        paint);

    double textSize = ScreenUtil().setSp(34);

    textPainter.text = TextSpan(
      text: textNum,
      style: TextStyle(
        fontSize: textSize,
        // fontWeight: FontWeight.bold,
        fontFamily: "NotoSansCJKkrBold",
        color: Colors.white,
        letterSpacing: ScreenUtil().setSp(letter_spacing),
        // backgroundColor: Colors.blue,
      ),
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      // Offset(radius - textPainter.width / 2 + textSize * 2 + whitePadding,
      //     radius - textPainter.height / 2 + textSize + whitePadding),
      Offset(
          offsetX + blueBoxWidth / 2 - textPainter.width / 2,
          markerSize * 0.015 -
              textPainter.height / 2 +
              blueBoxHeight / 2 +
              whitePadding),
    );

    final image = await pictureRecorder.endRecording().toImage(
          (markerSize * 0.34).toInt(),
          (markerSize * 0.34).toInt(),
        );
    final data = await image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }
}
