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

/////////////////////
  RxMap latlngBounds = {}.obs;

  Future addMapCoord(Completer<GoogleMapController> mapCoordController) async {
    await getMapCoord(mapCoordController).then((latlngMap) {
      latlngBounds.value = latlngMap;
    });
  }

/////////////////////
  RxList photoListMap = [].obs; // 전체 사진 데이터
  RxList categoryMap = [].obs;

  setPhotoListMap(List queryData) {
    photoListMap.value = queryData;
    categoryMap.value = queryData;
  }

  setCategoryMap(int categoryId) {
    List filteredList = [];
    photoListMap.map((data) {
      if (data["categoryId"] == categoryId) {
        filteredList.add(data);
      }
    }).toList();
    categoryMap.value = filteredList;
  }
}
