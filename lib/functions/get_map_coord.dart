import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Map> getMapCoord(
    Completer<GoogleMapController> mapCoordController) async {
  final GoogleMapController controller = await mapCoordController.future;

  Map latlngBounds;

  await controller.getVisibleRegion().then((latlng) {
    // print("🚨 southwest.latitude: " + latlng.southwest.latitude.toString());
    // print("🚨 southwest.longitude: " + latlng.southwest.longitude.toString());
    // print("🚨 northeast.latitude: " + latlng.northeast.latitude.toString());
    // print("🚨 northeast.longitude: " + latlng.northeast.longitude.toString());
    latlngBounds = {
      "swLat": "${latlng.southwest.latitude.toString()}",
      "swLng": "${latlng.southwest.longitude.toString()}",
      "neLat": "${latlng.northeast.latitude.toString()}",
      "neLng": "${latlng.northeast.longitude.toString()}"
    };
  });
  return latlngBounds;
}
