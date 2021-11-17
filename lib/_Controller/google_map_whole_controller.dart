import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsgotrip/functions/get_map_coord.dart';

class GoogleMapWholeController extends GetxController {
  var latlngBounds = {}.obs;

  Future addMapCoord(Completer<GoogleMapController> mapCoordController) async {
    await getMapCoord(mapCoordController).then((latlngMap) {
      latlngBounds.value = latlngMap;
    });
  }

  var currentCameraPosition = CameraPosition(
          bearing: 0.0,
          target: LatLng(37.55985294417329, 126.9875580444932),
          tilt: 0.0,
          zoom: 12)
      .obs;

  setCameraPosition(CameraPosition cameraPosition) {
    currentCameraPosition.value = cameraPosition;
  }

  var isMarkerLoading = false.obs;

  setIsMarkerLoading(bool isloading) {
    isMarkerLoading.value = isloading;
  }
}
