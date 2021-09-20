import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<LatLngBounds> getMapCoord() async {
  Completer<GoogleMapController> _controller = Completer();
  final GoogleMapController controller = await _controller.future;

  LatLngBounds latlngBounds;

  await controller.getVisibleRegion().then((latlng) {
    print("🚨 southwest.latitude: " + latlng.southwest.latitude.toString());
    print("🚨 southwest.longitude: " + latlng.southwest.longitude.toString());
    print("🚨 northeast.latitude: " + latlng.northeast.latitude.toString());
    print("🚨 northeast.longitude: " + latlng.northeast.longitude.toString());
    latlngBounds = latlng;
  });

  return latlngBounds;
}
