import 'dart:async';
import 'package:fluster/fluster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsgotrip/_Controller/google_map_whole_controller.dart';
import 'package:letsgotrip/widgets/map_helper.dart';

import 'map_marker.dart';

class GoogleMapContainer extends StatefulWidget {
  final Position userPosition;
  final List<MapMarker> mapMarkers;
  final int category;
  const GoogleMapContainer(
      {Key key,
      @required this.userPosition,
      @required this.mapMarkers,
      @required this.category})
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
  int markerNum = -1;

  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
    if (markerNum == -1) {
      Timer.periodic(Duration(milliseconds: 1000), (timer) {
        if (markerNum == gmWholeImages.mapMarkerList.length && markerNum != 0) {
          print("🚨 timer canceled");
          timer.cancel();
        }
        print("🚨 marker : $markerNum");
        print("🚨 images : ${gmWholeImages.mapMarkerList.length}");
        setState(() {
          markerNum = gmWholeImages.mapMarkerList.length;
        });
        _initMarkers();
      });
    }
    _initMarkers();
  }

  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  _initMarkers() async {
    _clusterManager = await MapHelper.initClusterManager(
      gmWholeImages.mapMarkerList,
      _minClusterZoom,
      _maxClusterZoom,
    );
    await _updateMarkers();
  }

  Future<void> _updateMarkers([double updatedZoom]) async {
    gmWholeImages.addMapCoord(_mapController);
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
    setState(() {});
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
    return GoogleMap(
      mapToolbarEnabled: false,
      zoomGesturesEnabled: true,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      zoomControlsEnabled: false,
      initialCameraPosition: CameraPosition(
        target:
            LatLng(widget.userPosition.latitude, widget.userPosition.longitude),
        zoom: _currentZoom,
      ),
      markers: _markers,
      onMapCreated: (controller) => _onMapCreated(controller),
      onCameraMove: (position) => _updateMarkers(position.zoom),
    );
  }
}
