import 'dart:async';
import 'package:fluster/fluster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_Controller/google_map_whole_controller.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/functions/google_map_functions.dart';
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
  final GoogleMapWholeController gmWholeImages = Get.find();
  //
  final Set<Marker> _markers = Set();
  final int _minClusterZoom = 2;
  final int _maxClusterZoom = 19;
  Fluster<MapMarker> _clusterManager;
  double _currentZoom = 13;
  //
  List<MapMarker> markers = [];
  bool isPin = false;

  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
    _initMarkers();
  }

  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  _initMarkers() async {
    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers();
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
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
      isPin = true;
    });
  }

  @override
  void initState() {
    setState(() {
      markers = gmWholeImages.mapMarkers;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapToolbarEnabled: false,
      zoomGesturesEnabled: isPin ? true : false,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      zoomControlsEnabled: false,
      initialCameraPosition: CameraPosition(
        // target: LatLng(
        //     widget.userPosition.latitude, widget.userPosition.longitude),
        target: LatLng(34.960710, 127.590889),
        zoom: _currentZoom,
      ),
      markers: _markers,
      onMapCreated: (controller) => _onMapCreated(controller),
      onCameraMove: (position) => _updateMarkers(position.zoom),
    );
  }
}

// return Query(
//       options: QueryOptions(
//         document: gql(Queries.mapPhotos),
//         variables: {
//           "latitude1": "-87.71179927260242",
//           "latitude2": "89.45016124669523",
//           "longitude1": "-180",
//           "longitude2": "180",
//         },
//       ),
//       builder: (result, {refetch, fetchMore}) {
//         if (result.hasException) return Text(result.exception.toString());
//         if (result.isLoading) return Text('Loading');

//         for (Map resultData in result.data["photo_list_map"]) {
//           // int markerId = int.parse("${resultData["contents_id"]}");
//           double markerLat = double.parse("${resultData["latitude"]}");
//           double markerLng = double.parse("${resultData["longitude"]}");
//           String imageUrl = "${resultData["image_link"]}";
//           List<String> imageList = imageUrl.split(",");
//           markerImagesList.add(imageList[0]);
//           markerLatLngsList.add(LatLng(markerLat, markerLng));
//         });

// LatLng(34.96071, 127.590889),
// LatLng(34.62597, 127.762969),
// LatLng(34.746191, 127.138382),
// LatLng(35.143573, 126.865573),
// LatLng(35.187839, 128.980312),
