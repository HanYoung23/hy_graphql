import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsgotrip/_Controller/permission_controller.dart';
import 'package:letsgotrip/_View/MainPages/map/map_post_review_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/functions/user_location.dart';

class MapPostCreationDetailScreen extends StatefulWidget {
  final Float64List latLng;
  const MapPostCreationDetailScreen({Key key, @required this.latLng})
      : super(key: key);

  @override
  _MapPostCreationDetailScreenState createState() =>
      _MapPostCreationDetailScreenState();
}

class _MapPostCreationDetailScreenState
    extends State<MapPostCreationDetailScreen> {
  final locationTextController = TextEditingController();
  Position userPosition;
  bool isAllFilled = false;

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

  @override
  void initState() {
    checkLocationPermission().then((permission) {
      getUserLocation().then((latlng) {
        setState(() {
          userPosition = latlng;
        });
      });
    });
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
                              child: Icon(
                                Icons.arrow_back,
                                size: ScreenUtil().setSp(arrow_back_size),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "장소 설정",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(appbar_title_size),
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Icon(
                            Icons.arrow_back,
                            size: ScreenUtil().setSp(arrow_back_size),
                            color: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(10)),
                  Container(
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().setHeight(240),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: userPosition != null
                        ? GoogleMap(
                            mapToolbarEnabled: false,
                            zoomGesturesEnabled: true,
                            myLocationButtonEnabled: false,
                            myLocationEnabled: false,
                            zoomControlsEnabled: false,
                            initialCameraPosition: CameraPosition(
                              target: widget.latLng != null
                                  ? LatLng(widget.latLng[0], widget.latLng[1])
                                  : LatLng(userPosition.latitude,
                                      userPosition.longitude),
                              zoom: 14,
                            ),
                            markers: createMarker(),
                          )
                        : CircularProgressIndicator(color: app_blue),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(10)),
                  Text(
                      "위치가 다른 경우 지도에서 직접 선택할 수 있습니다.\n(GPS 정보 값이 존재하는 경우 자동으로 지정됩니다.)",
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
                  locationTextController.text.length > 0
                      ? InkWell(
                          onTap: () {
                            Get.to(() => MapPostReviewScreen(),
                                arguments: "${locationTextController.text}");
                          },
                          child: Image.asset(
                            "assets/images/next_button.png",
                            width: ScreenUtil().setWidth(335),
                            height: ScreenUtil().setHeight(50),
                          ))
                      : InkWell(
                          onTap: () {
                            Get.to(() => MapPostReviewScreen(),
                                arguments: "${locationTextController.text}");
                          },
                          child: Image.asset(
                            "assets/images/next_button_grey.png",
                            width: ScreenUtil().setWidth(335),
                            height: ScreenUtil().setHeight(50),
                          ),
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
        position: widget.latLng != null
            ? LatLng(widget.latLng[0], widget.latLng[1])
            : LatLng(userPosition.latitude, userPosition.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      )
    ].toSet();
  }
}
