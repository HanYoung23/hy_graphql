import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:letsgotrip/_View/MainPages/map/place_detail_screen.dart';
import 'package:letsgotrip/storage/storage.dart';

/// [Fluster] can only handle markers that conform to the [Clusterable] abstract class.
///
/// You can customize this class by adding more parameters that might be needed for
/// your use case. For instance, you can pass an onTap callback or add an
/// [InfoWindow] to your marker here, then you can use the [toMarker] method to convert
/// this to a proper [Marker] that the [GoogleMap] can read.
class MapMarker extends Clusterable {
  final String id;
  final LatLng position;
  // final String imageUrl;
  BitmapDescriptor icon;

  MapMarker(
      {Key key,
      @required this.id,
      @required this.position,
      // @required this.imageUrl,
      this.icon,
      isCluster = false,
      clusterId,
      pointsSize,
      childMarkerId})
      : super(
          markerId: id,
          latitude: position.latitude,
          longitude: position.longitude,
          isCluster: isCluster,
          clusterId: clusterId,
          pointsSize: pointsSize,
          childMarkerId: childMarkerId,
        );

  Marker toMarker() => Marker(
      markerId: MarkerId(id),
      position: LatLng(
        position.latitude,
        position.longitude,
      ),
      icon: icon,
      onTap: () {
        seeValue("customerId").then((value) {
          int contentsId;
          if (id.contains(",")) {
            contentsId = int.parse(id.substring(0, id.indexOf(",")));
          } else {
            contentsId = int.parse(value);
          }
          // print("🚨 contentsId : $contentsId");
          Get.to(() => PlaceDetailScreen(
              contentsId: contentsId, customerId: int.parse(value)));
        });
      });
}
