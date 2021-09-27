import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsgotrip/widgets/map_marker.dart';

class GoogleMapWholeController extends GetxController {
  List<MapMarker> mapMarkers = [];

  void addMapMarkers(List markers) {
    mapMarkers = markers;
    update();
  }
}
