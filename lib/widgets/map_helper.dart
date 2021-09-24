import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_utils_class/image_utils_class.dart';
import 'package:letsgotrip/widgets/map_marker.dart';

class MapHelper {
  static Future<BitmapDescriptor> getMarkerImageFromUrl(
    String url, {
    int targetWidth,
  }) async {
    final File markerImageFile = await DefaultCacheManager().getSingleFile(url);

    Uint8List markerImageBytes = await markerImageFile.readAsBytes();

    // int imageSize = ScreenUtil().setSp(75).round();

    markerImageBytes = await _resizeImageBytes(
      markerImageBytes,
      // targetWidth,
      125,
    );
    return convertImageFileToBitmapDescriptor(markerImageFile,
        size: targetWidth);
    // return BitmapDescriptor.fromBytes(markerImageBytes);
  }

  static Future<BitmapDescriptor> convertImageFileToBitmapDescriptor(
      File imageFile,
      {int size = 100,
      bool addBorder = false,
      Color borderColor = Colors.white,
      double borderSize = 10}) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    final double radius = size / 2;

    //make canvas clip path to prevent image drawing over the circle
    final Path clipPath = Path();
    clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        Radius.circular(100)));
    clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(size / 2.toDouble(), size + 20.toDouble(), 10, 10),
        Radius.circular(100)));
    canvas.clipPath(clipPath);

    //paintImage
    final Uint8List imageUint8List = await imageFile.readAsBytes();
    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec.getNextFrame();
    paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        image: imageFI.image);

    //convert canvas as PNG bytes
    final _image = await pictureRecorder
        .endRecording()
        .toImage(size, (size * 1.1).toInt());
    final data = await _image.toByteData(format: ui.ImageByteFormat.png);

    //convert PNG bytes as BitmapDescriptor
    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> getMarkerImageFromAsset() async {
    final ByteData bytes =
        await rootBundle.load('assets/images/locationTap/map_pin.png');
    final Uint8List markerImageBytes = bytes.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(markerImageBytes);
  }

  /// Draw a [clusterColor] circle with the [clusterSize] text inside that is [width] wide.
  ///
  /// Then it will convert the canvas to an image and generate the [BitmapDescriptor]
  /// to be used on the cluster marker icons.
  static Future<BitmapDescriptor> _getClusterMarker(
    int clusterSize,
    Color clusterColor,
    Color textColor,
    int width,
  ) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = clusterColor;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final double radius = width / 2;

    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      paint,
    );

    textPainter.text = TextSpan(
      text: clusterSize.toString(),
      style: TextStyle(
        fontSize: radius - 5,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(radius - textPainter.width / 2, radius - textPainter.height / 2),
    );

    final image = await pictureRecorder.endRecording().toImage(
          radius.toInt() * 2,
          radius.toInt() * 2,
        );
    final data = await image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  /// Resizes the given [imageBytes] with the [targetWidth].
  ///
  /// We don't want the marker image to be too big so we might need to resize the image.
  static Future<Uint8List> _resizeImageBytes(
    Uint8List imageBytes,
    int targetWidth,
  ) async {
    final Codec imageCodec = await instantiateImageCodec(
      imageBytes,
      targetWidth: targetWidth,
      targetHeight: targetWidth,
    );

    final FrameInfo frameInfo = await imageCodec.getNextFrame();

    final data = await frameInfo.image.toByteData(format: ImageByteFormat.png);

    return data.buffer.asUint8List();
  }

  /// Inits the cluster manager with all the [MapMarker] to be displayed on the map.
  /// Here we're also setting up the cluster marker itself, also with an [clusterImageUrl].
  ///
  /// For more info about customizing your clustering logic check the [Fluster] constructor.
  static Future<Fluster<MapMarker>> initClusterManager(
    List<MapMarker> markers,
    int minZoom,
    int maxZoom,
  ) async {
    return Fluster<MapMarker>(
      minZoom: minZoom,
      maxZoom: maxZoom,
      radius: 150,
      extent: 2048,
      nodeSize: 64,
      points: markers,
      createCluster: (
        BaseCluster cluster,
        double lng,
        double lat,
      ) =>
          MapMarker(
        id: cluster.id.toString(),
        position: LatLng(lat, lng),
        isCluster: cluster.isCluster,
        clusterId: cluster.id,
        pointsSize: cluster.pointsSize,
        childMarkerId: cluster.childMarkerId,
      ),
    );
  }

  /// Gets a list of markers and clusters that reside within the visible bounding box for
  /// the given [currentZoom]. For more info check [Fluster.clusters].
  static Future<List<Marker>> getClusterMarkers(
    Fluster<MapMarker> clusterManager,
    double currentZoom,
    Color clusterColor,
    Color clusterTextColor,
    int clusterWidth,
  ) {
    if (clusterManager == null) return Future.value([]);

    return Future.wait(clusterManager.clusters(
      [-180, -85, 180, 85],
      currentZoom.toInt(),
    ).map((mapMarker) async {
      if (mapMarker.isCluster) {
        mapMarker.icon = await _getClusterMarker(
          mapMarker.pointsSize,
          clusterColor,
          clusterTextColor,
          clusterWidth,
        );
      }

      return mapMarker.toMarker();
    }).toList());
  }
}
