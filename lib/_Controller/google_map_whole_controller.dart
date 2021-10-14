import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsgotrip/functions/get_map_coord.dart';
import 'package:letsgotrip/widgets/map_marker.dart';

class GoogleMapWholeController extends GetxController {
  List<MapMarker> mapMarkers = [];

  Future addMapMarkers(List markers) async {
    List mapMarkersList = markers;
    mapMarkers = mapMarkersList;
    update();
  }

  Map latlngBounds;

  Future addMapCoord(Completer<GoogleMapController> mapCoordController) async {
    await getMapCoord(mapCoordController).then((latlngMap) {
      latlngBounds = latlngMap;
    });
    update();
  }
}
