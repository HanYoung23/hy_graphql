import 'package:get/get.dart';
import 'package:letsgotrip/widgets/map_marker.dart';

class GoogleMapWholeController extends GetxController {
  List<MapMarker> mapMarkers = [];

  void addMapMarkers(List markers) {
    mapMarkers = markers;
    update();
  }
}
