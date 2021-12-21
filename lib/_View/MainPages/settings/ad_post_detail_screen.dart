import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/payment.dart';

class AdPostDetailScreen extends StatefulWidget {
  final Map paramMap;
  const AdPostDetailScreen({Key key, @required this.paramMap})
      : super(key: key);

  @override
  _AdPostDetailScreenState createState() => _AdPostDetailScreenState();
}

class _AdPostDetailScreenState extends State<AdPostDetailScreen>
    with WidgetsBindingObserver {
  Completer gmapCompleter = Completer();

  final locationTextController = TextEditingController();
  BitmapDescriptor icon;
  LatLng photoLatLng;
  bool isAllFilled = false;
  String address = "";
  List rangeList = ["500m", "1km", "2km", "3km", "5km", "6km", "8km"];
  List countList = ["50회", "100회", "200회", "300회", "500회", "700회", "1000회"];
  String range = "0km";
  double rangeNum = 0.5;
  String count = "0회";
  int money;
  String cost;

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
                        updateCamera(index);
                      } else {
                        var format = NumberFormat('###,###,###,###');
                        String selectedValue = countList[index];
                        int moneyValue =
                            int.parse(selectedValue.replaceAll("회", "")) * 100;
                        setState(() {
                          count = countList[index];
                          cost = format.format(moneyValue);
                          money = moneyValue;
                        });
                      }
                    },
                    useMagnifier: true,
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

  Future updateCamera(int index) async {
    String range = rangeList[index];
    int km = int.parse(range.substring(0, 1));
    if (index == 0) {
      km = 0;
    }
    double zoom = 14.0;
    switch (km) {
      case 0:
        zoom = 14.0;
        break;
      case 1:
        zoom = 13.0;
        break;
      case 2:
        zoom = 12.0;
        break;
      case 3:
        zoom = 11.5;
        break;
      case 5:
        zoom = 11.0;
        break;
      case 6:
        zoom = 10.5;
        break;
      case 8:
        zoom = 10.0;
        break;
      default:
    }
    final GoogleMapController controller = await gmapCompleter.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: photoLatLng, zoom: zoom)));
  }

  @override
  void initState() {
    setState(() {
      photoLatLng = LatLng(widget.paramMap["lat"], widget.paramMap["lng"]);
    });
    WidgetsBinding.instance.addObserver(this);
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'assets/images/location_dot.png')
        .then((value) {
      setState(() {
        icon = value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    locationTextController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
          body: Container(
            // height: ScreenUtil().screenHeight,
            // padding:
            //     EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(side_gap)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: ScreenUtil().setSp(side_gap)),
                  Container(
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().setSp(44),
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setSp(side_gap)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
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
                          "게시물 상세설정",
                          style: TextStyle(
                            fontFamily: "NotoSansCJKkrBold",
                            fontSize: ScreenUtil().setSp(appbar_title_size),
                            letterSpacing: ScreenUtil().setSp(letter_spacing),
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
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setSp(side_gap)),
                    child: GoogleMap(
                      compassEnabled: false,
                      mapToolbarEnabled: false,
                      rotateGesturesEnabled: false,
                      scrollGesturesEnabled: false,
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: false,
                      liteModeEnabled: false,
                      tiltGesturesEnabled: false,
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: photoLatLng,
                        zoom: 14,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        gmapCompleter.complete(controller);
                        controller.animateCamera(
                            CameraUpdate.newLatLngZoom(photoLatLng, 14));
                      },
                      markers: [
                        icon != null
                            ? Marker(
                                draggable: false,
                                markerId: MarkerId("marker_1"),
                                position: photoLatLng,
                                icon: icon,
                                anchor: Offset(0.5, 0.5),
                              )
                            : null
                      ].toSet(),
                      circles: Set.from([
                        Circle(
                          circleId: CircleId("1"),
                          center: LatLng(
                              widget.paramMap["lat"], widget.paramMap["lng"]),
                          radius: range == "500m" || range == "0km"
                              ? 500.0
                              : double.parse(range.substring(0, 1)) * 1000,
                          fillColor: app_blue.withOpacity(0.16),
                          strokeColor: app_blue,
                          strokeWidth: ScreenUtil().setSp(1).round(),
                        )
                      ]),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setSp(20)),
                  contentTitle("희망지역"),
                  SizedBox(height: ScreenUtil().setSp(6)),
                  Container(
                    width: ScreenUtil().screenWidth,
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setSp(side_gap)),
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
                      if (range == "0km") {
                        setState(() {
                          range = "500m";
                        });
                      }
                    },
                    child: Container(
                      width: ScreenUtil().screenWidth,
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setSp(side_gap)),
                      child: Text(
                        "반경 $range",
                        style: TextStyle(
                          fontFamily: "NotoSansCJKkrBold",
                          letterSpacing: ScreenUtil().setSp(letter_spacing),
                          fontSize: ScreenUtil().setSp(16),
                          color: range != "0km" ? Colors.black : app_font_grey,
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
                      if (count == "0회") {
                        setState(() {
                          count = "50회";
                          cost = "5,000";
                          money = 5000;
                        });
                      }
                    },
                    child: Container(
                      width: ScreenUtil().screenWidth,
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setSp(side_gap)),
                      child: Text(
                        count == "0회" ? "횟수 설정하기" : "$count",
                        style: TextStyle(
                          fontFamily: "NotoSansCJKkrBold",
                          letterSpacing: ScreenUtil().setSp(letter_spacing),
                          fontSize: ScreenUtil().setSp(16),
                          color: count != "0회" ? Colors.black : app_font_grey,
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
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setSp(side_gap)),
                    child: TextFormField(
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
                  ),
                  SizedBox(height: ScreenUtil().setSp(60)),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "결제완료 후 심사가 시작됩니다.\n최대 48시간이 소요되며, 승인 후 개제 됩니다.",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(14),
                        fontFamily: "NotoSansCJKkrRegular",
                        letterSpacing: ScreenUtil().setSp(letter_spacing_small),
                        color: app_font_grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setSp(10)),
                  InkWell(
                    onTap: () {
                      if (range != "0km" &&
                          count != "0회" &&
                          locationTextController.text.length > 0) {
                        seeValue("customerId").then((value) {
                          Map payMap = {
                            "titleText": widget.paramMap["titleText"],
                            "phoneText": widget.paramMap["phoneText"],
                            "contentText": widget.paramMap["contentText"],
                            "imageLink": widget.paramMap["imageLink"],
                            "address": widget.paramMap["address"],
                            "lat": widget.paramMap["lat"],
                            "lng": widget.paramMap["lng"],
                            //
                            "range": range == "500m" || range == "0km"
                                ? 500
                                : int.parse(range.substring(0, 1)) * 1000,
                            "count": int.parse(count.replaceAll("회", "")),
                            "businessName": locationTextController.text,
                            "customerId": int.parse(value),
                            "amount": money,
                            "buyerName": "customer $value",
                          };
                          Get.to(() => Payment(paramData: payMap));
                        });
                      }
                    },
                    child: Container(
                        width: ScreenUtil().screenWidth,
                        height: ScreenUtil().setSp(50),
                        margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setSp(side_gap)),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setSp(10)),
                          color: (range != "0km" &&
                                  count != "0회" &&
                                  locationTextController.text.length > 0)
                              ? app_blue
                              : app_blue_light_button,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          count == "0회" ? "결제하기" : "$cost원 결제하기",
                          style: TextStyle(
                            fontFamily: "NotoSansCJKkrBold",
                            fontSize: ScreenUtil().setSp(16),
                            letterSpacing: ScreenUtil().setSp(letter_spacing),
                            color: Colors.white,
                          ),
                        )),
                  ),
                  // SizedBox(height: ScreenUtil().setSp(14)),
                  // SizedBox(height: ScreenUtil().setSp(side_gap)),
                ],
              ),
            ),
          )),
    );
  }

  Container contentTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(side_gap)),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: "NotoSansCJKkrBold",
          letterSpacing: ScreenUtil().setSp(letter_spacing),
          fontSize: ScreenUtil().setSp(16),
        ),
      ),
    );
  }

  // createMarker() {
  //   return [
  //     Marker(
  //       draggable: false,
  //       markerId: MarkerId("marker_1"),
  //       position: photoLatLng,
  //       icon: icon,
  //     )
  //   ].toSet();
  // }
}
