import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsgotrip/functions/get_map_coord.dart';

class GoogleMapWholeController extends GetxController {
  var latlngBounds = {
    // "swLat": "0",
    // "swLng": "0",
    // "neLat": "0",
    // "neLng": "0",
    // "swLat": "-87.71179927260242",
    // "swLng": "-180",
    // "neLat": "89.45016124669523",
    // "neLng": "180",
  }.obs;

  // "latitude1": "-87.71179927260242",
  //               "latitude2": "89.45016124669523",
  //               "longitude1": "-180",
  //               "longitude2": "180",

  // latlngBounds = ;

  Future addMapCoord(Completer<GoogleMapController> mapCoordController) async {
    print("🚨 add map coord");
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

  var markerNum = 0.obs;

  setMarkerNum(int num) {
    markerNum.value = num;
  }
}
