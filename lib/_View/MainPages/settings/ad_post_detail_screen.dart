import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsgotrip/_Controller/permission_controller.dart';
import 'package:letsgotrip/_View/MainPages/map/map_post_review_screen.dart';
import 'package:letsgotrip/widgets/loading_indicator.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/constants/keys.dart';
import 'package:letsgotrip/functions/user_location.dart';
import 'package:http/http.dart' as http;
import 'package:letsgotrip/widgets/location_unable_screen.dart';
import 'package:letsgotrip/widgets/postal.dart';

class AdPostDetailScreen extends StatefulWidget {
  final Map paramMap;
  const AdPostDetailScreen({Key key, @required this.paramMap})
      : super(key: key);

  @override
  _AdPostDetailScreenState createState() => _AdPostDetailScreenState();
}

class _AdPostDetailScreenState extends State<AdPostDetailScreen>
    with WidgetsBindingObserver {
  Completer mapCompleter = Completer();

  final locationTextController = TextEditingController();
  LatLng photoLatLng;
  bool isAllFilled = false;
  bool isPermission = true;
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

  callBackAddress(Map callbackAddress) async {
    final GoogleMapController mapController = await mapCompleter.future;
    await mapController.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(callbackAddress["lat"], callbackAddress["lng"]), 14));
    setState(() {
      address = callbackAddress["address"];
      photoLatLng = LatLng(callbackAddress["lat"], callbackAddress["lng"]);
    });
    // mapCompleter.complete(mapController);
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
        photoLatLng = widget.paramMap["imageLatLngList"][0];
        address = addressJSON;
      });
    }
  }

  @override
  void initState() {
    if (widget.paramMap["imageLatLngList"].length > 0) {
      getPlaceInfo();
      checkLocationPermission().then((permission) {
        setState(() {
          isPermission = permission;
        });
      });
    } else {
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
          // permissionPopup(context, "위치 검색이 허용되어있지 않습니다.\n설정에서 허용 후 이용가능합니다.");
        }
        setState(() {
          isPermission = permission;
        });
      });
    }
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    locationTextController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // print("🚨 state $state");
    if (!isPermission) {
      if (state == AppLifecycleState.resumed) {
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
            // permissionPopup(context, "위치 검색이 허용되어있지 않습니다.\n설정에서 허용 후 이용가능합니다.");
          }
          setState(() {
            isPermission = permission;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
        ),
        body: isPermission
            ? SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Container(
                  height: ScreenUtil().screenHeight -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                  padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                  child: Column(
                    children: [
                      Container(
                        width: ScreenUtil().screenWidth,
                        height: ScreenUtil().setSp(44),
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
                                        width:
                                            ScreenUtil().setSp(arrow_back_size),
                                        height: ScreenUtil()
                                            .setSp(arrow_back_size))),
                              ),
                            ),
                            Text(
                              "게시물 상세설정",
                              style: TextStyle(
                                fontFamily: "NotoSansCJKkrBold",
                                fontSize: ScreenUtil().setSp(appbar_title_size),
                                letterSpacing:
                                    ScreenUtil().setSp(letter_spacing),
                              ),
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
                                      fontFamily: "NotoSansCJKkrBold",
                                      fontSize:
                                          ScreenUtil().setSp(appbar_title_size),
                                      letterSpacing:
                                          ScreenUtil().setSp(letter_spacing),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setSp(10)),
                      Container(
                          width: ScreenUtil().screenWidth,
                          height: ScreenUtil().setSp(240),
                          child: photoLatLng != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setSp(10)),
                                  child: GoogleMap(
                                    mapToolbarEnabled: false,
                                    zoomGesturesEnabled: true,
                                    myLocationButtonEnabled: false,
                                    myLocationEnabled: true,
                                    zoomControlsEnabled: false,
                                    initialCameraPosition: CameraPosition(
                                      target: photoLatLng,
                                      zoom: 13,
                                    ),
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      mapCompleter.complete(controller);
                                      controller.animateCamera(
                                          CameraUpdate.newLatLngZoom(
                                              photoLatLng, 14));
                                      // createMarker(photoLatLng);
                                    },
                                    markers: createMarker(photoLatLng),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    LoadingIndicator(),
                                  ],
                                )),
                      SizedBox(height: ScreenUtil().setSp(4)),
                      Container(
                        width: ScreenUtil().screenWidth,
                        child: Text(
                          address != "" ? "위치 : $address" : "위치가 설정되어 있지 않습니다.",
                          style: TextStyle(
                              fontFamily: "NotoSansCJKkrRegular",
                              letterSpacing:
                                  ScreenUtil().setSp(letter_spacing_small),
                              fontSize: ScreenUtil().setSp(12),
                              color: address != "" ? Colors.black : Colors.red),
                          overflow: TextOverflow.fade,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setSp(8)),
                      Text(
                          "선택된 위치가 다른 경우 직접 선택할 수 있습니다.\n(GPS 정보 값이 존재하는 경우 자동으로 지정됩니다.)",
                          style: TextStyle(
                            fontFamily: "NotoSansCJKkrRegular",
                            letterSpacing:
                                ScreenUtil().setSp(letter_spacing_small),
                            fontSize: ScreenUtil().setSp(14),
                            color: app_font_grey,
                          ),
                          overflow: TextOverflow.fade),
                      SizedBox(height: ScreenUtil().setSp(24)),
                      Row(
                        children: [
                          Text("장소명 입력",
                              style: TextStyle(
                                  fontFamily: "NotoSansCJKkrBold",
                                  letterSpacing:
                                      ScreenUtil().setSp(letter_spacing_small),
                                  fontSize: ScreenUtil().setSp(14),
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: ScreenUtil().setSp(5)),
                      TextFormField(
                          keyboardType: TextInputType.text,
                          controller: locationTextController,
                          minLines: 1,
                          maxLines: 1,
                          onChanged: (String value) {
                            checkIsAllFilled();
                          },
                          style: TextStyle(
                              fontFamily: "NotoSansCJKkrRegular",
                              letterSpacing:
                                  ScreenUtil().setSp(letter_spacing_small),
                              fontSize: ScreenUtil().setSp(14),
                              color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: app_grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              hintText: "해당 장소명을 남겨주세요.",
                              hintStyle: TextStyle(
                                  fontFamily: "NotoSansCJKkrRegular",
                                  letterSpacing:
                                      ScreenUtil().setSp(letter_spacing_small),
                                  color: app_font_grey,
                                  fontSize: ScreenUtil().setSp(14)))),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          if (locationTextController.text.length > 0 &&
                              address != "") {
                            widget.paramMap["locationLink"] = address;
                            widget.paramMap["latitude"] = photoLatLng.latitude;
                            widget.paramMap["longitude"] =
                                photoLatLng.longitude;
                            widget.paramMap["contentsTitle"] =
                                "${locationTextController.text}";
                            // print("🚨 map : ${widget.paramMap}");

                            Get.to(() =>
                                MapPostReviewScreen(paramMap: widget.paramMap));
                          }
                        },
                        child: Container(
                            width: ScreenUtil().screenWidth,
                            height: ScreenUtil().setSp(50),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(ScreenUtil().setSp(10)),
                              color: (locationTextController.text.length > 0 &&
                                      address != "")
                                  ? app_blue
                                  : app_blue_light_button,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "다음",
                              style: TextStyle(
                                fontFamily: "NotoSansCJKkrBold",
                                fontSize: ScreenUtil().setSp(16),
                                letterSpacing:
                                    ScreenUtil().setSp(letter_spacing),
                                color: Colors.white,
                              ),
                            )),
                      ),
                      SizedBox(height: ScreenUtil().setSp(14)),
                    ],
                  ),
                ),
              )
            : LocationUnableScreen(),
      ),
    );
  }

  createMarker(LatLng position) {
    return [
      Marker(
        draggable: false,
        markerId: MarkerId("marker_1"),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      )
    ].toSet();
  }
}
