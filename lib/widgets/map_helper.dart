import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:bitmap/bitmap.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsgotrip/widgets/map_marker.dart';

class MapHelper {
  static Future<BitmapDescriptor> getMarkerImageFromUrl(String url) async {
    File markerImageFile;
    markerImageFile = await DefaultCacheManager().getSingleFile(url);
    return convertImageFileToBitmapDescriptor(markerImageFile);
  }

  static Future<BitmapDescriptor> convertImageFileToBitmapDescriptor(
      File imageFile) async {
    try {
      // if (imageFile != null) {
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);

      int size = 120;

      Paint paint = Paint();
      paint.color = Colors.white;

      final rect = Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble());
      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(10)), paint);

      //paintImage
      final Uint8List imageUint8List = await imageFile.readAsBytes();
      // final Uint8List imageUint8ListBig = await _resizeImageBytes(imageUint8List, 100);
      final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List,
          targetWidth: size - 15, targetHeight: size - 15);
      final ui.FrameInfo imageFI = await codec.getNextFrame();
      paintImage(
          canvas: canvas,
          rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
          image: imageFI.image,
          alignment: Alignment.center);

      //convert canvas as PNG bytes
      final _image = await pictureRecorder.endRecording().toImage(size, size);
      final data = await _image.toByteData(format: ui.ImageByteFormat.png);

      //convert PNG bytes as BitmapDescriptor
      return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
    } catch (error) {
      print("🚨 map helper error : $error");
      return null;
    }
  }

  static Future<Fluster<MapMarker>> initClusterManager(
    List<MapMarker> markers,
    int minZoom,
    int maxZoom,
    String imageUrl,
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
        imageUrl: imageUrl,
      ),
    );
  }

  /// Gets a list of markers and clusters that reside within the visible bounding box for
  /// the given [currentZoom]. For more info check [Fluster.clusters].
  static Future<List<Marker>> getClusterMarkers(
    Fluster<MapMarker> clusterManager,
    double currentZoom,
    // int clusterWidth,
  ) {
    if (clusterManager == null) return Future.value([]);

    return Future.wait(clusterManager.clusters(
      [-180, -85, 180, 85],
      currentZoom.toInt(),
    ).map((mapMarker) async {
      if (mapMarker.isCluster) {
        mapMarker.icon = await _getClusterMarker(mapMarker);
        // mapMarker.icon = mapMarker.icon;
      }

      return mapMarker.toMarker();
    }).toList());
  }

  static Future<BitmapDescriptor> _getClusterMarker(MapMarker mapMarker) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.blue;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final double radius = 40;

    // //
    File markerImageFile;
    markerImageFile =
        await DefaultCacheManager().getSingleFile(mapMarker.imageUrl);
    int size = 120;
    paint.color = Colors.white;

    final rect = Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble());
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(10)), paint);

    //paintImage
    final Uint8List imageUint8List = await markerImageFile.readAsBytes();
    // final Uint8List imageUint8ListBig = await _resizeImageBytes(imageUint8List, 100);
    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List,
        targetWidth: size - 15, targetHeight: size - 15);
    final ui.FrameInfo imageFI = await codec.getNextFrame();
    paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        image: imageFI.image,
        alignment: Alignment.center);
    // //

    paint.color = Colors.blue;

    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      paint,
    );

    textPainter.text = TextSpan(
      text: mapMarker.pointsSize.toString(),
      style: TextStyle(
        fontSize: radius - 5,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(radius - textPainter.width / 2, radius - textPainter.height / 2),
    );

    final image = await pictureRecorder.endRecording().toImage(
          // radius.toInt() * 2,
          // radius.toInt() * 2,
          120, 120,
        );
    final data = await image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }
}
