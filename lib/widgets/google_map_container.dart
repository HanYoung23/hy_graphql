import 'dart:async';
import 'dart:io';
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
import 'package:letsgotrip/functions/get_map_coord.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';
import 'package:letsgotrip/widgets/map_helper.dart';

import 'map_marker.dart';

class GoogleMapContainer extends StatefulWidget {
  // final List<Map> photoMapList;
  final Position userPosition;
  final CameraPosition currentCameraPosition;
  final int category;
  final String dateStart;
  final String dateEnd;
  final Function refetchCallback;
  final Map queryParams;
  const GoogleMapContainer({
    Key key,
    // @required this.photoMapList,
    @required this.userPosition,
    @required this.currentCameraPosition,
    @required this.category,
    @required this.dateStart,
    @required this.dateEnd,
    this.refetchCallback,
    @required this.queryParams,
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
  List<Map> photoMapList = [];
  List<MapMarker> mapMarkerList = [];
  List currentItemList = [];
  //
  int customerId;
  //
  CameraPosition currentPosition;
  double currentZoom;
  //
  bool isRefreshButton = false;

  void _onMapCreated(
      GoogleMapController controller, Function runMutation) async {
    getMapCoord(_mapController).then((latlngBounds) {
      runMutation(
        {
          "latitude1": "${latlngBounds["swLat"]}",
          "latitude2": "${latlngBounds["neLat"]}",
          "longitude1": "${latlngBounds["swLng"]}",
          "longitude2": "${latlngBounds["neLng"]}",
          "category_id": widget.queryParams["category_id"],
          "date1": widget.queryParams["date1"],
          "date2": widget.queryParams["date2"],
        },
      );
    });
    gmWholeImages.addMapCoord(_mapController);
    // setMapMarker(photoMapList);
    _mapController.complete(controller);
  }

  setMapMarker(List dataList) async {
    gmWholeController.isMarkerLoading(true);
    if (Platform.isAndroid) {
      gmWholeController.setMarkerNum(dataList.length);
    }
    // print("🚨 photomaplist : ${dataList.length}");

    List<MapMarker> mapMarkers = [];
    if (dataList.length > 0) {
      for (Map data in dataList) {
        await MapHelper.getMarkerImageFromUrl(
                "${data["imageLink"][0]}",
                ScreenUtil().screenHeight -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom)
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
        // gmWholeController.isMarkerLoading(false);
        await _initMarkers();
      }
    }
    if (this.mounted) {
      gmWholeController.isMarkerLoading(false);
      // await _updateMarkers(
      //     gmWholeController.currentCameraPosition.value.zoom - 0.000001,
      //     gmWholeController.currentCameraPosition.value);
    }
  }

  _initMarkers() async {
    _clusterManager = await MapHelper.initClusterManager(
      mapMarkerList,
      _minClusterZoom,
      _maxClusterZoom,
    );
    await _updateMarkers(
        gmWholeController.currentCameraPosition.value.zoom - 0.000001,
        gmWholeController.currentCameraPosition.value);
  }

  Future<void> _updateMarkers(
      [double updatedZoom,
      CameraPosition cameraPosition,
      Function runMutation]) async {
    if (runMutation != null) {
      getMapCoord(_mapController).then((latlngBounds) {
        runMutation(
          {
            "latitude1": "${latlngBounds["swLat"]}",
            "latitude2": "${latlngBounds["neLat"]}",
            "longitude1": "${latlngBounds["swLng"]}",
            "longitude2": "${latlngBounds["neLng"]}",
            "category_id": widget.queryParams["category_id"],
            "date1": widget.queryParams["date1"],
            "date2": widget.queryParams["date2"],
          },
        );
        // runMutation(latlngBounds);
      });
    }
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
      ScreenUtil().screenHeight -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom,
    );
    _markers
      ..clear()
      ..addAll(updatedMarkers);
    if (this.mounted) {
      setState(() {});
    }
  }

  onCameraMove(double zoom, CameraPosition position) {
    setState(() {
      currentPosition = position;
      currentZoom = zoom;
      isRefreshButton = true;
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
    return Mutation(
        options: MutationOptions(
            onError: (e) {
              // print("🚨 error : $e");
            },
            document: gql(Mutations.photoListMap),
            update: (GraphQLDataProxy proxy, QueryResult result) {},
            onCompleted: (dynamic resultData) {
              // print("🚨 resultData : ${resultData.length}");
              print("🚨 resultData : ${resultData["photo_list_map"]}");
              if (resultData != null &&
                  resultData["photo_list_map"].length > 0) {
                List<Map> newPhotoMapList = [];
                List queryItemList = [];
                for (Map resultData in resultData["photo_list_map"]
                    ["results"]) {
                  int customerId = int.parse("${resultData["customer_id"]}");
                  int contentsId = int.parse("${resultData["contents_id"]}");
                  List<String> imageLink =
                      ("${resultData["image_link"]}").split(",");
                  double latitude = double.parse("${resultData["latitude"]}");
                  double longitude = double.parse("${resultData["longitude"]}");

                  Map<dynamic, dynamic> photoDataMap = {
                    "customerId": customerId,
                    "contentsId": contentsId,
                    "imageLink": imageLink,
                    "latitude": latitude,
                    "longitude": longitude,
                  };

                  if (!currentItemList.contains("$imageLink")) {
                    newPhotoMapList.add(photoDataMap);
                    queryItemList.add("$imageLink");
                  }
                }

                if (newPhotoMapList.length > 0) {
                  List previousList = photoMapList;
                  List previousItemList = currentItemList;
                  newPhotoMapList.map((e) {
                    previousList.add(e);
                    int index = newPhotoMapList.indexOf(e);
                    previousItemList.add(queryItemList[index]);
                  }).toList();
                  setState(() {
                    photoMapList = previousList;
                    currentItemList = previousItemList;
                  });
                  // print("🚨 photomaplist : ${photoMapList.length}");
                  // print("🚨 currentItemList 2 : ${currentItemList.length}");
                  setMapMarker(photoMapList);
                }
              }
              // getMapCoord(_mapController);
            }),
        builder: (RunMutation runMutation, QueryResult queryResult) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                child: GoogleMap(
                  compassEnabled: true,
                  mapToolbarEnabled: false,
                  zoomGesturesEnabled: true,
                  myLocationButtonEnabled: false,
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
                  onMapCreated: (controller) =>
                      _onMapCreated(controller, runMutation),
                  onCameraMove: (position) =>
                      onCameraMove(position.zoom, position),
                  onCameraIdle: () => _updateMarkers(
                    currentZoom,
                    currentPosition,
                    runMutation,
                  ),
                ),
              ),
              isRefreshButton
                  ? Positioned(
                      top: ScreenUtil().setSp(10),
                      child: InkWell(
                          onTap: () {
                            gmWholeController.isMarkerLoading(true);
                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              gmWholeController.isMarkerLoading(false);
                            });
                            getMapCoord(_mapController).then((latlngBounds) {
                              runMutation(
                                {
                                  "latitude1": "${latlngBounds["swLat"]}",
                                  "latitude2": "${latlngBounds["neLat"]}",
                                  "longitude1": "${latlngBounds["swLng"]}",
                                  "longitude2": "${latlngBounds["neLng"]}",
                                  "category_id":
                                      widget.queryParams["category_id"],
                                  "date1": widget.queryParams["date1"],
                                  "date2": widget.queryParams["date2"],
                                },
                              );
                            });
                            setState(() {
                              isRefreshButton = false;
                            });
                            // widget.refetchCallback();
                          },
                          child: Image.asset(
                            "assets/images/map_refresh_button.png",
                            width: ScreenUtil().setSp(120),
                          )),
                    )
                  : Container(),
              widget.userPosition != null
                  ? Positioned(
                      top: ScreenUtil().setSp(20),
                      right: Platform.isAndroid ? ScreenUtil().setSp(20) : null,
                      left: Platform.isIOS ? ScreenUtil().setSp(20) : null,
                      child: InkWell(
                        onTap: () async {
                          final GoogleMapController controller =
                              await _mapController.future;

                          controller.animateCamera(CameraUpdate.newLatLngZoom(
                              LatLng(widget.userPosition.latitude,
                                  widget.userPosition.longitude),
                              13));
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
        });
  }
}
