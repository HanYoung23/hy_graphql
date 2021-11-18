import 'dart:async';
import 'package:fluster/fluster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsgotrip/_Controller/google_map_whole_controller.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/map_helper.dart';

import 'map_marker.dart';

class GoogleMapContainer extends StatefulWidget {
  final List<Map> photoMapList;
  final Position userPosition;
  final CameraPosition currentCameraPosition;
  final int category;
  final String dateStart;
  final String dateEnd;
  final Function refetchCallback;
  const GoogleMapContainer({
    Key key,
    @required this.photoMapList,
    @required this.userPosition,
    @required this.currentCameraPosition,
    @required this.category,
    @required this.dateStart,
    @required this.dateEnd,
    this.refetchCallback,
  }) : super(key: key);
  @override
  _GoogleMapContainerState createState() => _GoogleMapContainerState();
}

class _GoogleMapContainerState extends State<GoogleMapContainer> {
  Completer<GoogleMapController> _mapController = Completer();

  GoogleMapWholeController gmWholeImages = Get.find();
  GoogleMapWholeController gmUpdate = Get.find();
  final GoogleMapWholeController gmWholeController =
      Get.put(GoogleMapWholeController());

  final Set<Marker> _markers = Set();
  final int _minClusterZoom = 2;
  final int _maxClusterZoom = 19;
  Fluster<MapMarker> _clusterManager;
  double _currentZoom = 13;
  //
  List<MapMarker> mapMarkerList = [];
  //
  int customerId;
  //
  CameraPosition currentPosition;
  double currentZoom;

  void _onMapCreated(GoogleMapController controller) {
    setMapMarker(widget.photoMapList);
    _mapController.complete(controller);
  }

  setMapMarker(List dataList) async {
    gmWholeController.isMarkerLoading(true);
    gmWholeController.setMarkerNum(dataList.length);
    print("🚨 photomaplist : ${dataList.length}");

    List<MapMarker> mapMarkers = [];
    if (dataList.length > 0) {
      for (Map data in dataList) {
        await MapHelper.getMarkerImageFromUrl("${data["imageLink"][0]}")
            .then((markerImage) {
          mapMarkers.add(
            MapMarker(
              id: "${data["contentsId"]},${data["imageLink"][0]}",
              position: LatLng(data["latitude"], data["longitude"]),
              icon: markerImage,
            ),
          );
        });
      }
      if (this.mounted) {
        setState(() {
          mapMarkerList = mapMarkers;
        });
        gmWholeController.isMarkerLoading(false);
        await _initMarkers();
      }
    }
    if (this.mounted) {
      await _updateMarkers(
          gmWholeController.currentCameraPosition.value.zoom - 0.000001,
          gmWholeController.currentCameraPosition.value);
    }
  }

  _initMarkers() async {
    _clusterManager = await MapHelper.initClusterManager(
      mapMarkerList,
      _minClusterZoom,
      _maxClusterZoom,
    );
    setState(() {});
    await _updateMarkers();
  }

  Future<void> _updateMarkers(
      [double updatedZoom, CameraPosition cameraPosition]) async {
    await gmWholeImages.addMapCoord(_mapController);
    if (cameraPosition != null) {
      gmWholeImages.setCameraPosition(cameraPosition);
    }

    if (_clusterManager == null || updatedZoom == _currentZoom) return;
    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }
    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
    );
    _markers
      ..clear()
      ..addAll(updatedMarkers);
    setState(() {});
  }

  onCameraMove(double zoom, CameraPosition position) {
    setState(() {
      currentPosition = position;
      currentZoom = zoom;
    });
  }

  @override
  void dispose() {
    // gmWholeController.dispose();
    super.dispose();
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
    // return Mutation(
    //     options: MutationOptions(
    //         onError: (error) {
    //           print(
    //               "🚨 error : ${error.graphqlErrors}, ${error.linkException}");
    //         },
    //         errorPolicy: ErrorPolicy.ignore,
    //         document: gql(Mutations.photoListMap),
    //         update: (GraphQLDataProxy proxy, QueryResult result) {},
    //         onCompleted: (dynamic resultData) {
    //           print("🚨 resultData : ${resultData.length}");
    //           if (resultData != null &&
    //               resultData["photo_list_map"].length > 0) {
    //             List<Map> photoMapList = [];
    //             for (Map resultData in resultData["photo_list_map"]) {
    //               int customerId = int.parse("${resultData["customer_id"]}");
    //               int contentsId = int.parse("${resultData["contents_id"]}");
    //               int categoryId = int.parse("${resultData["category_id"]}");
    //               List<String> imageLink =
    //                   ("${resultData["image_link"]}").split(",");
    //               List<String> tags = ("${resultData["tags"]}").split(",");
    //               List<int> starRating = [
    //                 resultData["star_rating1"],
    //                 resultData["star_rating2"],
    //                 resultData["star_rating3"],
    //                 resultData["star_rating4"]
    //               ];
    //               double latitude = double.parse("${resultData["latitude"]}");
    //               double longitude = double.parse("${resultData["longitude"]}");

    //               Map<dynamic, dynamic> photoDataMap = {
    //                 "customerId": customerId,
    //                 "contentsId": contentsId,
    //                 "categoryId": categoryId,
    //                 "contentsTitle": "${resultData["contents_title"]}",
    //                 "locationLink": "${resultData["location_link"]}",
    //                 "imageLink": imageLink,
    //                 "mainText": "${resultData["main_text"]}",
    //                 "tags": tags,
    //                 "starRating": starRating,
    //                 "latitude": latitude,
    //                 "longitude": longitude,
    //                 "registDate": "${resultData["regist_date"]}"
    //               };

    //               photoMapList.add(photoDataMap);
    //             }
    //             setMapMarker(photoMapList);
    //           }
    //           getMapCoord(_mapController);
    //         }),
    //     builder: (RunMutation runMutation, QueryResult queryResult) {
    //       if (queryResult.hasException) {
    //         print("🚨 google map error : ${queryResult.exception}");
    //       }
    return Stack(
      children: [
        Positioned(
          child: GoogleMap(
            compassEnabled: true,
            mapToolbarEnabled: false,
            zoomGesturesEnabled: true,
            // myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition:
                widget.currentCameraPosition.target.latitude ==
                            37.55985294417329 &&
                        widget.userPosition != null // inital latitude
                    ? CameraPosition(
                        target: LatLng(widget.userPosition.latitude,
                            widget.userPosition.longitude),
                        zoom: _currentZoom,
                      )
                    : CameraPosition(
                        target: widget.currentCameraPosition.target,
                        zoom: widget.currentCameraPosition.zoom,
                      ),
            markers: _markers,
            onMapCreated: (controller) => _onMapCreated(controller),
            onCameraMove: (position) => onCameraMove(position.zoom, position),
            onCameraIdle: () => _updateMarkers(currentZoom, currentPosition),
          ),
        ),
        widget.userPosition != null
            ? Positioned(
                top: ScreenUtil().setSp(20),
                right: ScreenUtil().setSp(20),
                child: InkWell(
                  onTap: () async {
                    final GoogleMapController controller =
                        await _mapController.future;

                    controller.animateCamera(CameraUpdate.newLatLngZoom(
                        LatLng(widget.userPosition.latitude,
                            widget.userPosition.longitude),
                        currentZoom));
                  },
                  child: Container(
                    width: ScreenUtil().setSp(40),
                    height: ScreenUtil().setSp(40),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        border: Border.all(
                            width: ScreenUtil().setSp(1),
                            color: Colors.grey.withOpacity(0.4)),
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setSp(5))),
                    child: Icon(
                      Icons.my_location,
                      size: ScreenUtil().setSp(24),
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ))
            : Container()
      ],
    );
    // });
  }
}
