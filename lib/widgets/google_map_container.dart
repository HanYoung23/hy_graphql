import 'dart:async';
import 'package:fluster/fluster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_Controller/google_map_whole_controller.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';
import 'package:letsgotrip/widgets/map_helper.dart';

import 'map_marker.dart';

class GoogleMapContainer extends StatefulWidget {
  final Position userPosition;
  const GoogleMapContainer({Key key, @required this.userPosition})
      : super(key: key);

  @override
  _GoogleMapContainerState createState() => _GoogleMapContainerState();
}

class _GoogleMapContainerState extends State<GoogleMapContainer> {
  Completer<GoogleMapController> _mapController = Completer();
  GoogleMapWholeController gmWholeImages = Get.find();
  final GoogleMapWholeController gmWholeController =
      Get.put(GoogleMapWholeController());

  final Set<Marker> _markers = Set();
  final int _minClusterZoom = 2;
  final int _maxClusterZoom = 19;
  Fluster<MapMarker> _clusterManager;
  double _currentZoom = 13;

  List<Map> photoMapList = [];
  int markerNum = -1;
  bool isQuery = false;

  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
    gmWholeImages.addMapCoord(_mapController).then((value) {
      setState(() {
        isQuery = true;
      });
    });

    // if (markerNum == -1) {
    //   Timer.periodic(Duration(milliseconds: 1000), (timer) {
    //     if (markerNum == gmWholeImages.categoryMap.length && markerNum != 0) {
    //       print("🚨 timer canceled");
    //       timer.cancel();
    //     }
    //     print("🚨 marker : $markerNum");
    //     print("🚨 images : ${gmWholeImages.categoryMap.length}");
    //     setState(() {
    //       markerNum = gmWholeImages.categoryMap.length;
    //     });
    //     _initMarkers(categoryMap);
    //   });
    // }
    List nullMap = [];
    _initMarkers(nullMap);
  }

  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  _initMarkers(List categoryMap) async {
    List<MapMarker> markers = [];
    print("🚨 $categoryMap");
    print("🚨 ${categoryMap.length}");

    if (categoryMap.length > 0) {
      categoryMap.map((data) {
        MapHelper.getMarkerImageFromUrl("${data["imageLink"][0]}")
            .then((markerImage) {
          markers.add(
            MapMarker(
              id: "${data["contentsId"]}",
              position: LatLng(data["latitude"], data["longitude"]),
              icon: markerImage,
            ),
          );
        });
      });
    }
    if (markers.length > 0) {
      _clusterManager = await MapHelper.initClusterManager(
        markers,
        _minClusterZoom,
        _maxClusterZoom,
      );
    }
    await _updateMarkers();
  }

  Future<void> _updateMarkers([double updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;
    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      80,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {
      isQuery = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: GoogleMap(
            mapToolbarEnabled: false,
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: false,
            myLocationEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  widget.userPosition.latitude, widget.userPosition.longitude),
              // target: LatLng(34.960710, 127.590889),
              zoom: _currentZoom,
            ),
            markers: _markers,
            // markers: createMarker(),
            onMapCreated: (controller) => _onMapCreated(controller),
            onCameraMove: (position) => _updateMarkers(position.zoom),
          ),
        ),
        Positioned(
            child: isQuery
                ? Obx(() => Query(
                    options: QueryOptions(
                      document: gql(Queries.photoListMap),
                      variables: {
                        "latitude1": "${gmWholeImages.latlngBounds["swLat"]}",
                        "latitude2": "${gmWholeImages.latlngBounds["neLat"]}",
                        "longitude1": "${gmWholeImages.latlngBounds["swLng"]}",
                        "longitude2": "${gmWholeImages.latlngBounds["neLng"]}",
                      },
                    ),
                    builder: (result, {refetch, fetchMore}) {
                      if (result.isNotLoading) {
                        if (result.data != null) {
                          for (Map resultData
                              in result.data["photo_list_map"]) {
                            int customerId =
                                int.parse("${resultData["customer_id"]}");
                            int contentId =
                                int.parse("${resultData["contents_id"]}");
                            int categoryId =
                                int.parse("${resultData["category_id"]}");
                            List<String> imageLink =
                                ("${resultData["image_link"]}").split(",");
                            List<String> tags =
                                ("${resultData["tags"]}").split(",");
                            List<int> starRating = [
                              resultData["star_rating1"],
                              resultData["star_rating2"],
                              resultData["star_rating3"],
                              resultData["star_rating4"]
                            ];
                            double latitude =
                                double.parse("${resultData["latitude"]}");
                            double longitude =
                                double.parse("${resultData["longitude"]}");

                            Map<dynamic, dynamic> photoDataMap = {
                              "customerId": customerId,
                              "contentsId": contentId,
                              "categoryId": categoryId,
                              "contentsTitle":
                                  "${resultData["contents_title"]}",
                              "locationLink": "${resultData["location_link"]}",
                              "imageLink": imageLink,
                              "mainText": "${resultData["main_text"]}",
                              "tags": tags,
                              "starRating": starRating,
                              "latitude": latitude,
                              "longitude": longitude,
                            };

                            photoMapList.add(photoDataMap);
                          }
                          gmWholeController.setPhotoListMap(photoMapList);
                          _initMarkers(gmWholeImages.categoryMap);
                        }
                      }
                      return Container(
                          width: 100,
                          height: 100,
                          color: Colors.red.withOpacity(0.3));
                    }))
                : Container())
      ],
    );
  }
}

// createMarker() {
//   return [
//     Marker(
//       draggable: false,
//       markerId: MarkerId("marker_1"),
//       // position: photoLatLng,
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
//     )
//   ].toSet();
// }