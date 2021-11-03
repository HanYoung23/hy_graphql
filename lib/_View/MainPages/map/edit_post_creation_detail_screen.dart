import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsgotrip/_Controller/permission_controller.dart';
import 'package:letsgotrip/_View/MainPages/map/edit_post_review_screen.dart';
import 'package:letsgotrip/_View/MainPages/map/map_post_review_screen.dart';
import 'package:letsgotrip/functions/material_popup.dart';
import 'package:letsgotrip/widgets/loading_indicator.dart';
import 'package:letsgotrip/widgets/postal.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/constants/keys.dart';
import 'package:letsgotrip/functions/user_location.dart';
import 'package:http/http.dart' as http;

class EditPostCreationDetailScreen extends StatefulWidget {
  final Map paramMap;
  final Map mapData;
  const EditPostCreationDetailScreen(
      {Key key, @required this.paramMap, @required this.mapData})
      : super(key: key);

  @override
  _EditPostCreationDetailScreenState createState() =>
      _EditPostCreationDetailScreenState();
}

class _EditPostCreationDetailScreenState
    extends State<EditPostCreationDetailScreen> {
  GoogleMapController mapController;
  final locationTextController = TextEditingController();
  // Position userPosition;
  LatLng photoLatLng;
  // bool isCoord = false;
  bool isAllFilled = false;
  String address = "";

  checkIsAllFilled() {
    if (locationTextController.text.length > 0) {
      setState(() {
        isAllFilled = true;
      });
    } else {
      setState(() {
        isAllFilled = false;
      });
    }
  }

  callBackAddress(Map callbackAddress) {
    setState(() {
      address = callbackAddress["address"];
      photoLatLng = LatLng(callbackAddress["lat"], callbackAddress["lng"]);
    });
    mapController.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(callbackAddress["lat"], callbackAddress["lng"]), 14));
    setState(() {});
  }

  Future getPlaceInfo() async {
    if (widget.paramMap["imageLatLngList"].length > 0) {
      double lat = widget.paramMap["imageLatLngList"][0].latitude;
      double lng = widget.paramMap["imageLatLngList"][0].longitude;

      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleWebKey&language=ko');
      final response = await http.get(url);

      String addressJSON = await jsonDecode(response.body.toString())['results']
              [0]['formatted_address']
          .replaceAll("대한민국 ", "");

      setState(() {
        // isCoord = true;
        photoLatLng = widget.paramMap["imageLatLngList"][0];
        address = addressJSON;
      });
    }
  }

  setPreviousData() {
    locationTextController.text = widget.mapData["contentsTitle"];
  }

  @override
  void initState() {
    checkLocationPermission().then((permission) {
      if (permission) {
        getUserLocation().then((latlng) {
          if (latlng != null) {
            setState(() {
              photoLatLng = LatLng(latlng.latitude, latlng.longitude);
            });
          }
        });
      } else {
        permissionPopup(context, "위치 검색이 허용되어있지 않습니다.\n설정에서 허용 후 이용가능합니다.");
      }
    });
    getPlaceInfo();
    setPreviousData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              height: ScreenUtil().screenHeight * 0.9,
              margin: EdgeInsets.all(ScreenUtil().setSp(20)),
              child: Column(
                children: [
                  Container(
                    width: ScreenUtil().setWidth(375),
                    height: ScreenUtil().setHeight(44),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            // width: ScreenUtil().setSp(appbar_title_size * 3),
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Image.asset(
                                    "assets/images/arrow_back.png",
                                    width: ScreenUtil().setSp(arrow_back_size),
                                    height:
                                        ScreenUtil().setSp(arrow_back_size))),
                          ),
                        ),
                        Text(
                          "장소 설정",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(appbar_title_size),
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                Get.to(() => PostalWeb(
                                      callback: (address) =>
                                          callBackAddress(address),
                                    ));
                              },
                              child: Text(
                                "위치 검색",
                                style: TextStyle(
                                    color: app_font_grey,
                                    fontSize:
                                        ScreenUtil().setSp(appbar_title_size),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(10)),
                  Container(
                      width: ScreenUtil().screenWidth,
                      height: ScreenUtil().setHeight(240),
                      child: photoLatLng != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GoogleMap(
                                mapToolbarEnabled: false,
                                zoomGesturesEnabled: true,
                                myLocationButtonEnabled: false,
                                myLocationEnabled: false,
                                zoomControlsEnabled: false,
                                initialCameraPosition: CameraPosition(
                                  target: photoLatLng,
                                  zoom: 13,
                                ),
                                onMapCreated: (GoogleMapController controller) {
                                  mapController = controller;
                                  setState(() {});
                                  createMarker();
                                },
                                markers: createMarker(),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LoadingIndicator(),
                                // : Container(
                                //     child: Text(
                                //         "사진의 GPS값을 불러올 수 없습니다.\n위치를 검색해주세요.",
                                //         style: TextStyle(
                                //           fontSize: ScreenUtil().setSp(14),
                                //           color: app_font_grey,
                                //         ),
                                //         textAlign: TextAlign.center))
                              ],
                            )),
                  SizedBox(height: ScreenUtil().setHeight(4)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          address != "" ? "위치 : $address" : "위치가 설정되어 있지 않습니다.",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              color: address != "" ? Colors.black : Colors.red),
                          overflow: TextOverflow.fade),
                    ],
                  ),
                  SizedBox(height: ScreenUtil().setHeight(8)),
                  Text(
                      "선택된 위치가 다른 경우 직접 선택할 수 있습니다.\n(GPS 정보 값이 존재하는 경우 자동으로 지정됩니다.)",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          color: app_font_grey)),
                  SizedBox(height: ScreenUtil().setHeight(24)),
                  Row(
                    children: [
                      Text("장소명 입력",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(14),
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: ScreenUtil().setHeight(5)),
                  TextFormField(
                      keyboardType: TextInputType.text,
                      controller: locationTextController,
                      minLines: 1,
                      maxLines: 1,
                      onChanged: (String value) {
                        checkIsAllFilled();
                      },
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          color: Colors.black),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: app_grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          hintText: "해당 장소명을 남겨주세요.",
                          hintStyle: TextStyle(
                              color: app_font_grey,
                              fontSize: ScreenUtil().setSp(14)))),
                  Spacer(),
                  (locationTextController.text.length > 0 && address != "")
                      ? InkWell(
                          onTap: () {
                            widget.paramMap["locationLink"] = address;
                            widget.paramMap["latitude"] = photoLatLng.latitude;
                            widget.paramMap["longitude"] =
                                photoLatLng.longitude;
                            widget.paramMap["contentsTitle"] =
                                "${locationTextController.text}";
                            // print("🚨 map : ${widget.paramMap}");

                            Get.to(() => EditPostReviewScreen(
                                  paramMap: widget.paramMap,
                                  mapData: widget.mapData,
                                ));
                          },
                          child: Image.asset(
                            "assets/images/next_button.png",
                            width: ScreenUtil().setWidth(335),
                            height: ScreenUtil().setHeight(50),
                          ))
                      : Image.asset(
                          "assets/images/next_button_grey.png",
                          width: ScreenUtil().setWidth(335),
                          height: ScreenUtil().setHeight(50),
                        ),
                  SizedBox(height: ScreenUtil().setHeight(14)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  createMarker() {
    return [
      Marker(
        draggable: true,
        markerId: MarkerId("marker_1"),
        position: photoLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      )
    ].toSet();
  }
}
