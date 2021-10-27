import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsgotrip/widgets/map_marker.dart';

class MapHelper {
  static Future<BitmapDescriptor> getMarkerImageFromUrl(
    String url, {
    int targetWidth,
  }) async {
    File markerImageFile;
    try {
      markerImageFile = await DefaultCacheManager().getSingleFile(url);
      return convertImageFileToBitmapDescriptor(markerImageFile);
    } catch (error) {
      print("🚨 map helper file error url : $url");
      print("🚨 map helper file error : $error");
      markerImageFile = await DefaultCacheManager().getSingleFile(
          "https://travelmapimageflutter140446-dev.s3.ap-northeast-2.amazonaws.com/public/2021-10-26+17%3A58%3A06.350087.png");
      return convertImageFileToBitmapDescriptor(markerImageFile);
    }
  }

  Future loadUiImage() async {
    // final ByteData _data =
    // await rootBundle.load("assets/images/locationTap/map_pin.png");
    // final bytes = _data.buffer.asUint8List();
    // final image = await decodeImageFromList(bytes);
    // canvas.drawImage(image, Offset(0, 0), paint);
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

  static Future<BitmapDescriptor> _getClusterMarker(
      int clusterSize, int width) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.blue;
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
        color: Colors.white,
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

    // final File markerImageFile =
    //     await DefaultCacheManager().getSingleFile(clusterImageUrl);
    // return convertImageFileToBitmapDescriptor(markerImageFile);
  }

  // static Future<Uint8List> _resizeImageBytes(
  //   Uint8List imageBytes,
  //   int targetWidth,
  // ) async {
  //   final Codec imageCodec = await instantiateImageCodec(
  //     imageBytes,
  //     targetWidth: targetWidth,
  //     targetHeight: targetWidth,
  //   );

  //   final FrameInfo frameInfo = await imageCodec.getNextFrame();

  //   final data = await frameInfo.image.toByteData(format: ImageByteFormat.png);

  //   return data.buffer.asUint8List();
  // }

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
          clusterWidth,
        );
      }

      return mapMarker.toMarker();
    }).toList());
  }
}
