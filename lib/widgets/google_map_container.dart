import 'dart:async';
import 'package:fluster/fluster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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

  Map mapBounds = {
    "swLat": "",
    "swLng": "",
    "neLat": "",
    "neLng": "",
  };
  List networkImage = [];

  //
  final Set<Marker> _markers = Set();
  final int _minClusterZoom = 2;
  final int _maxClusterZoom = 19;
  Fluster<MapMarker> _clusterManager;
  double _currentZoom = 13;
  bool isPin = false;

  /// Example marker coordinates
  final List<LatLng> _markerLocations = [
    // LatLng(34.96071, 127.590889),
    // LatLng(34.62597, 127.762969),
    // LatLng(34.746191, 127.138382),
    // LatLng(35.143573, 126.865573),
    // LatLng(35.187839, 128.980312),
  ];
  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
    _initMarkers();
  }

  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  _initMarkers() async {
    final List<MapMarker> markers = [];
    String clusterImageUrl;

    for (LatLng markerLocation in _markerLocations) {
      final BitmapDescriptor markerImage =
          await MapHelper.getMarkerImageFromUrl("${networkImage[0]}");

      clusterImageUrl = "${networkImage[0]}";

      markers.add(
        MapMarker(
          id: _markerLocations.indexOf(markerLocation).toString(),
          position: markerLocation,
          icon: markerImage,
          // icon: BitmapDescriptor.fromBytes(bytes.buffer.asUint8List())
        ),
      );
    }

    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers(null, clusterImageUrl);
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers(
      double updatedZoom, String clusterImageUrl) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;
    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      80,
      clusterImageUrl,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(Queries.mapPhotos),
        variables: {
          "latitude1": "-87.71179927260242",
          "latitude2": "89.45016124669523",
          "longitude1": "-180",
          "longitude2": "180",
        },
      ),
      builder: (result, {refetch, fetchMore}) {
        if (result.hasException) return Text(result.exception.toString());
        if (result.isLoading) return Text('Loading');

        for (Map resultData in result.data["photo_list_map"]) {
          int markerId = int.parse("${resultData["contents_id"]}");
          double markerLat = double.parse("${resultData["latitude"]}");
          double markerLng = double.parse("${resultData["longitude"]}");
          String imageUrl = "${resultData["image_link"]}";
          List<String> imageList = imageUrl.split(",");
          networkImage.add(imageList[0]);
          _markerLocations.add(LatLng(markerLat, markerLng));
        }

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
          onCameraMove: (position) => _updateMarkers(position.zoom, null),
        );
      },
    );
  }
}
