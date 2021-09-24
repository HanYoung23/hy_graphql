import 'dart:async';
import 'dart:typed_data';
import 'package:fluster/fluster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  // GoogleMapController mapController;
  LatLngBounds latlngBounds;
  BitmapDescriptor icon;

  //
  /// Set of displayed markers and cluster markers on the map
  final Set<Marker> _markers = Set();

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker> _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 8;

  /// Map loading flag
  bool _isMapLoading = true;

  /// Markers loading flag
  bool _areMarkersLoading = true;

  /// Url image used on normal markers
  // final String _markerImageUrl =
  //     'https://img.icons8.com/office/80/000000/marker.png';

  /// Color of the cluster circle
  final Color _clusterColor = Colors.blue;

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;

  /// Example marker coordinates
  final List<LatLng> _markerLocations = [
    LatLng(34.96071, 127.590889),
    LatLng(34.62597, 127.762969),
    LatLng(34.746191, 127.138382),
    LatLng(35.143573, 126.865573),
    LatLng(35.187839, 128.980312),
  ];

  /// Called when the Google Map widget is created. Updates the map loading state
  /// and inits the markers.
  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);

    setState(() {
      _isMapLoading = false;
    });

    _initMarkers();
  }

  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  void _initMarkers() async {
    final List<MapMarker> markers = [];

    for (LatLng markerLocation in _markerLocations) {
      // final BitmapDescriptor markerImage =
      //     await MapHelper.getMarkerImageFromUrl(_markerImageUrl);

      final BitmapDescriptor markerImage =
          await MapHelper.getMarkerImageFromAsset();

      markers.add(
        MapMarker(
          id: _markerLocations.indexOf(markerLocation).toString(),
          position: markerLocation,
          icon: markerImage,
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

    setState(() {
      _areMarkersLoading = true;
    });

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

    setState(() {
      _areMarkersLoading = false;
    });
  }

  @override
  void initState() {
    getMapCoord().then((value) {
      setState(() {
        latlngBounds = value;
      });
    });
    // BitmapDescriptor.fromAssetImage(
    //         ImageConfiguration(), 'assets/images/locationTap/map_pin.png')
    //     .then((value) {
    //   setState(() {
    //     icon = value;
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final CameraPosition initPosition = CameraPosition(
    //   target:
    //       LatLng(widget.userPosition.latitude, widget.userPosition.longitude),
    //   zoom: 10,
    // );

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

        // List<Marker> mapMarkers = [];
        // for (int i = 0; i < result.data["photo_list_map"].length; i++) {
        for (int i = 0; i < 10; i++) {
          // int markerId =
          //     int.parse("${result.data["photo_list_map"][i]["contents_id"]}");
          double markerLat =
              double.parse("${result.data["photo_list_map"][i]["latitude"]}");
          double markerLng =
              double.parse("${result.data["photo_list_map"][i]["longitude"]}");
          // String imageUrl = "${result.data["photo_list_map"][i]["image_link"]}";
          // List<String> imageList = imageUrl.split(",");
          // _markerLocations.add(LatLng(markerLat, markerLng));
          // imageToByte(imageList[0]).then((imageByte) {
          //   print("🚨 asdf : $imageByte");
          //   mapMarkers.add(Marker(
          //       markerId: MarkerId("$markerId"),
          //       position: LatLng(markerLat, markerLng),
          //       icon: BitmapDescriptor.fromBytes(imageByte)));
          // });
        }

        // return GoogleMap(
        //   mapType: MapType.normal,
        //   myLocationButtonEnabled: false,
        //   initialCameraPosition: initPosition,
        //   onMapCreated: (mapController) {
        //     _mapController.complete(mapController);
        //   },
        //   markers: Set.from(mapMarkers),
        // );

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

// Future imageToByte(String imageUrl) async {
//   Uint8List bytes =
//       (await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl))
//           .buffer
//           .asUint8List();
//   print("🚨 $bytes");
//   return bytes;

//   // http.Response response = await http.get(Uri.parse("${imageList[0]}"));
//   // print("🚨🚨🚨 ${response.bodyBytes}");
//   // return response.bodyBytes;
// }

// String southwestLat = widget.latlngBounds.southwest.latitude.toString();
// String southwestLng = widget.latlngBounds.southwest.longitude.toString();
// String northeastLat = widget.latlngBounds.northeast.latitude.toString();
// String northeastLng = widget.latlngBounds.northeast.longitude.toString();
