import 'dart:async';
import 'dart:typed_data';
import 'package:fluster/fluster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/functions/google_map_functions.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';
import 'package:letsgotrip/widgets/map_helper.dart';
import 'package:http/http.dart' as http;

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
  // GoogleMapController mapController;
  LatLngBounds latlngBounds;
  BitmapDescriptor icon;
  List networkImage = [];

  //
  final Set<Marker> _markers = Set();
  final int _minClusterZoom = 2;
  final int _maxClusterZoom = 19;
  Fluster<MapMarker> _clusterManager;
  double _currentZoom = 8;
  // bool _isMapLoading = true;
  // bool _areMarkersLoading = true;
  final Color _clusterColor = Colors.blue;
  final Color _clusterTextColor = Colors.white;

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
  void _initMarkers() async {
    final List<MapMarker> markers = [];

    for (LatLng markerLocation in _markerLocations) {
      int index = _markerLocations.indexOf(markerLocation);

      final BitmapDescriptor markerImage =
          await MapHelper.getMarkerImageFromUrl("${networkImage[0]}");

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
      _clusterColor,
      _clusterTextColor,
      80,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);
  }

  @override
  void initState() {
    getMapCoord().then((value) {
      setState(() {
        latlngBounds = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(Queries.mapPhotos),
        variables: {
          "latitude1": "33.2200505873032",
          "latitude2": "38.479807266878815",
          "longitude1": "125.27173485606909",
          "longitude2": "129.98494371771812"
        },
      ),
      builder: (result, {refetch, fetchMore}) {
        if (result.hasException) return Text(result.exception.toString());
        if (result.isLoading) return Text('Loading');

        for (Map resultData in result.data["photo_list_map"]) {
          // int markerId =
          //     int.parse("${result.data["photo_list_map"][i]["contents_id"]}");
          // double markerLat =
          //     double.parse("${result.data["photo_list_map"][i]["latitude"]}");
          // double markerLng =
          //     double.parse("${result.data["photo_list_map"][i]["longitude"]}");
          // String imageUrl = "${result.data["photo_list_map"][i]["image_link"]}";
          // List<String> imageList = imageUrl.split(",");
          // networkImage.add(imageList[1]);
          // _markerLocations.add(LatLng(markerLat, markerLng));

          int markerId = int.parse("${resultData["contents_id"]}");
          double markerLat = double.parse("${resultData["latitude"]}");
          double markerLng = double.parse("${resultData["longitude"]}");
          String imageUrl = "${resultData["image_link"]}";
          List<String> imageList = imageUrl.split(",");
          networkImage.add(imageList[0]);
          _markerLocations.add(LatLng(markerLat, markerLng));
          print("🚨 resultData : $resultData");
        }

        return GoogleMap(
          mapToolbarEnabled: false,
          zoomGesturesEnabled: true,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
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
      },
    );
  }
}
