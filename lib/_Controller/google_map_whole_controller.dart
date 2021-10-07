import 'dart:developer';

import 'package:get/get.dart';
import 'package:letsgotrip/widgets/map_marker.dart';

class GoogleMapWholeController extends GetxController {
  List<MapMarker> mapMarkers = [];

  Future addMapMarkers(List markers) async {
    List mapMarkersList = markers;
    mapMarkers = mapMarkersList;
    update();
  }
}
