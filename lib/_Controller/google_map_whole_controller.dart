import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsgotrip/functions/get_map_coord.dart';
import 'package:letsgotrip/widgets/map_helper.dart';
import 'package:letsgotrip/widgets/map_marker.dart';

class GoogleMapWholeController extends GetxController {
  // List<MapMarker> mapMarkers = [];

  // Future addMapMarkers(List markers) async {
  //   List mapMarkersList = markers;
  //   mapMarkers = mapMarkersList;
  //   update();
  // }

/////////////////////
  RxMap latlngBounds = {}.obs;

  Future addMapCoord(Completer<GoogleMapController> mapCoordController) async {
    await getMapCoord(mapCoordController).then((latlngMap) {
      latlngBounds.value = latlngMap;
    });
  }

/////////////////////
  List photoListMap = []; // 전체 사진 데이터
  List categoryMap = [];
  List<MapMarker> mapMarkerList = [];

  setPhotoListMap(List queryData) {
    photoListMap = queryData;
    categoryMap = queryData;
    print("🚨 queryData : ${categoryMap.length}");

    setMapMarker(photoListMap);

    update();
  }

  setCategoryMap(int categoryId) {
    List filteredList = [];
    print("🚨 categoryId : $categoryId");

    for (Map data in categoryMap) {
      if (data["categoryId"] == categoryId) {
        filteredList.add(data);
      }
    }
    categoryMap = filteredList;

    setMapMarker(categoryMap);

    update();
  }

  setMapMarker(List dataList) {
    List<MapMarker> mapMarkers = [];
    if (dataList.length > 0) {
      for (Map data in dataList) {
        MapHelper.getMarkerImageFromUrl("${data["imageLink"][0]}")
            .then((markerImage) {
          mapMarkers.add(
            MapMarker(
              id: "${data["contentsId"]}",
              position: LatLng(data["latitude"], data["longitude"]),
              icon: markerImage,
            ),
          );
        });
      }
    }
    mapMarkerList = mapMarkers;
    update();
  }
}
