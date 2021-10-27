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
import 'package:letsgotrip/_View/MainPages/map/place_detail_screen.dart';
import 'package:letsgotrip/functions/get_map_coord.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';
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

  final Set<Marker> _markers = Set();
  final int _minClusterZoom = 2;
  final int _maxClusterZoom = 19;
  Fluster<MapMarker> _clusterManager;
  double _currentZoom = 13;
  int markerNum = -1;
  //
  List<MapMarker> mapMarkerList = [];
  //
  int customerId;

  void _onMapCreated(GoogleMapController controller, Function runMutation) {
    _mapController.complete(controller);
    if (markerNum == -1) {
      Timer.periodic(Duration(milliseconds: 2000), (timer) {
        if (markerNum == mapMarkerList.length) {
          print("🚨 timer canceled");
          timer.cancel();
        }
        print("🚨 marker : $markerNum");
        print("🚨 images : ${mapMarkerList.length}");
        setState(() {
          markerNum = mapMarkerList.length;
        });
        _initMarkers();
      });
    }
    getMapCoord(_mapController).then((latlng) {
      runMutation({
        "latitude1": latlng["swLat"],
        "latitude2": latlng["neLat"],
        "longitude1": latlng["swLng"],
        "longitude2": latlng["neLng"],
      });
    });
    _initMarkers();
  }

  _initMarkers() async {
    _clusterManager = await MapHelper.initClusterManager(
      mapMarkerList,
      _minClusterZoom,
      _maxClusterZoom,
    );
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
  }

  setMapMarker(List dataList) {
    List<MapMarker> mapMarkers = [];
    if (dataList.length > 0) {
      for (Map data in dataList) {
        MapHelper.getMarkerImageFromUrl("${data["imageLink"][0]}")
            .then((markerImage) {
          mapMarkers.add(
            // Marker(
            //   markerId: MarkerId("${data["contentsId"]}"),
            //   position: LatLng(data["latitude"], data["longitude"]),
            //   icon: markerImage,
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => PlaceDetailScreen(
            //               contentsId: data["contentsId"],
            //               customerId: customerId)),
            //     );
            //   },
            // ),
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
  }

  @override
  void initState() {
    seeValue("customerId").then((customerId) {
      setState(() {
        customerId = int.parse(customerId);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
            onError: (error) {
              print(
                  "🚨 error : ${error.graphqlErrors}, ${error.linkException}");
            },
            errorPolicy: ErrorPolicy.ignore,
            document: gql(Mutations.photoListMap),
            update: (GraphQLDataProxy proxy, QueryResult result) {},
            onCompleted: (dynamic resultData) {
              print("🚨 resultData : ${resultData.length}");
              if (resultData != null &&
                  resultData["photo_list_map"].length > 0) {
                List<Map> photoMapList = [];
                for (Map resultData in resultData["photo_list_map"]) {
                  int customerId = int.parse("${resultData["customer_id"]}");
                  int contentsId = int.parse("${resultData["contents_id"]}");
                  int categoryId = int.parse("${resultData["category_id"]}");
                  List<String> imageLink =
                      ("${resultData["image_link"]}").split(",");
                  List<String> tags = ("${resultData["tags"]}").split(",");
                  List<int> starRating = [
                    resultData["star_rating1"],
                    resultData["star_rating2"],
                    resultData["star_rating3"],
                    resultData["star_rating4"]
                  ];
                  double latitude = double.parse("${resultData["latitude"]}");
                  double longitude = double.parse("${resultData["longitude"]}");

                  Map<dynamic, dynamic> photoDataMap = {
                    "customerId": customerId,
                    "contentsId": contentsId,
                    "categoryId": categoryId,
                    "contentsTitle": "${resultData["contents_title"]}",
                    "locationLink": "${resultData["location_link"]}",
                    "imageLink": imageLink,
                    "mainText": "${resultData["main_text"]}",
                    "tags": tags,
                    "starRating": starRating,
                    "latitude": latitude,
                    "longitude": longitude,
                    "registDate": "${resultData["regist_date"]}"
                  };

                  photoMapList.add(photoDataMap);
                }
                setMapMarker(photoMapList);
              }
            }),
        builder: (RunMutation runMutation, QueryResult queryResult) {
          if (queryResult.hasException) {
            print("🚨 google map error : ${queryResult.exception}");
          }
          return GoogleMap(
            mapToolbarEnabled: false,
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: false,
            myLocationEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  widget.userPosition.latitude, widget.userPosition.longitude),
              zoom: _currentZoom,
            ),
            markers: _markers,
            onMapCreated: (controller) =>
                _onMapCreated(controller, runMutation),
            onCameraIdle: () {
              getMapCoord(_mapController).then((latlng) {
                runMutation({
                  "latitude1": latlng["swLat"],
                  "latitude2": latlng["neLat"],
                  "longitude1": latlng["swLng"],
                  "longitude2": latlng["neLng"],
                });
              });
              _initMarkers();
            },
            onCameraMove: (position) => _updateMarkers(position.zoom),
          );
        });
  }
}
