import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsgotrip/_Controller/permission_controller.dart';
import 'package:letsgotrip/_View/MainPages/map/map_post_review_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/functions/user_location.dart';
import 'package:letsgotrip/widgets/location_unable_screen.dart';

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
  List rangeList = ["500m", "1km", "2km", "3km", "5km", "6km", "8km"];
  List countList = ["50회", "100회", "200회", "300회", "500회", "700회", "1000회"];
  String range = "0km";
  String count = "0회";

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

  showPicker(String title) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: ScreenUtil().setSp(262),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().setSp(44),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.all(ScreenUtil().setSp(12)),
                    child: Text(
                      "Done",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          // fontFamily: "NotoSansCJKkrRegular",
                          fontWeight: FontWeight.w600,
                          color: app_blue_cupertino),
                    ),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    backgroundColor: Colors.white,
                    onSelectedItemChanged: (index) {
                      if (title == "range") {
                        setState(() {
                          range = rangeList[index];
                        });
                      } else {
                        setState(() {
                          count = countList[index];
                        });
                      }
                    },
                    itemExtent: 32.0,
                    diameterRatio: 1,
                    children: title == "range"
                        ? rangeList.map((e) {
                            return Text(
                              "$e",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(22),
                              ),
                            );
                          }).toList()
                        : countList.map((e) {
                            return Text(
                              "$e",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(22),
                              ),
                            );
                          }).toList(),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    setState(() {
      photoLatLng = LatLng(widget.paramMap["lat"], widget.paramMap["lng"]);
    });
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
                child: Container(
                  padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              child: Container(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setSp(10)),
                      Container(
                          width: ScreenUtil().screenWidth,
                          height: ScreenUtil().setSp(240),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(ScreenUtil().setSp(10)),
                            child: GoogleMap(
                              mapToolbarEnabled: false,
                              zoomGesturesEnabled: true,
                              myLocationButtonEnabled: false,
                              myLocationEnabled: true,
                              zoomControlsEnabled: false,
                              initialCameraPosition: CameraPosition(
                                target: photoLatLng,
                                zoom: 15,
                              ),
                              onMapCreated: (GoogleMapController controller) {
                                mapCompleter.complete(controller);
                                controller.animateCamera(
                                    CameraUpdate.newLatLngZoom(
                                        photoLatLng, 15));
                                // createMarker(photoLatLng);
                              },
                              // markers: createMarker(photoLatLng),
                            ),
                          )),
                      SizedBox(height: ScreenUtil().setSp(20)),
                      contentTitle("희망지역"),
                      SizedBox(height: ScreenUtil().setSp(6)),
                      Container(
                        width: ScreenUtil().screenWidth,
                        child: Text(
                          widget.paramMap["address"],
                          style: TextStyle(
                              fontFamily: "NotoSansCJKkrRegular",
                              letterSpacing: ScreenUtil().setSp(letter_spacing),
                              fontSize: ScreenUtil().setSp(16),
                              color: Colors.black),
                          overflow: TextOverflow.fade,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setSp(20)),
                      contentTitle("도달범위"),
                      SizedBox(height: ScreenUtil().setSp(6)),
                      InkWell(
                        onTap: () {
                          showPicker("range");
                        },
                        child: Container(
                          width: ScreenUtil().screenWidth,
                          child: Text(
                            "반경 $range",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrBold",
                              letterSpacing: ScreenUtil().setSp(letter_spacing),
                              fontSize: ScreenUtil().setSp(16),
                              color:
                                  range != "0km" ? Colors.black : app_font_grey,
                              decoration: TextDecoration.underline,
                            ),
                            overflow: TextOverflow.fade,
                            maxLines: 2,
                          ),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setSp(20)),
                      contentTitle("게시물 클릭 횟수"),
                      SizedBox(height: ScreenUtil().setSp(6)),
                      InkWell(
                        onTap: () {
                          showPicker("count");
                        },
                        child: Container(
                          width: ScreenUtil().screenWidth,
                          child: Text(
                            count == "0회" ? "횟수 설정하기" : "$count",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrBold",
                              letterSpacing: ScreenUtil().setSp(letter_spacing),
                              fontSize: ScreenUtil().setSp(16),
                              color:
                                  count != "0회" ? Colors.black : app_font_grey,
                              decoration: TextDecoration.underline,
                            ),
                            overflow: TextOverflow.fade,
                            maxLines: 2,
                          ),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setSp(20)),
                      Row(
                        children: [contentTitle("장소(상호)명 입력")],
                      ),
                      SizedBox(height: ScreenUtil().setSp(10)),
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
                      // Spacer(),
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

  Text contentTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: "NotoSansCJKkrBold",
        letterSpacing: ScreenUtil().setSp(letter_spacing),
        fontSize: ScreenUtil().setSp(16),
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
