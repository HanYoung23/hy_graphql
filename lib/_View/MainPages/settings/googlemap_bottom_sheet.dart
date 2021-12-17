import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:letsgotrip/constants/common_value.dart';

class GooglemapBottomSheet extends StatefulWidget {
  final String title;
  final String address;
  final LatLng latlng;
  const GooglemapBottomSheet({
    Key key,
    @required this.title,
    @required this.address,
    @required this.latlng,
  }) : super(key: key);

  @override
  _GooglemapBottomSheetState createState() => _GooglemapBottomSheetState();
}

class _GooglemapBottomSheetState extends State<GooglemapBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().screenHeight * 0.86,
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(20), vertical: ScreenUtil().setSp(40)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.title}",
            style: TextStyle(
              fontFamily: "NotoSansCJKkrBold",
              fontSize: ScreenUtil().setSp(18),
              letterSpacing: ScreenUtil().setSp(letter_spacing_big),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          SizedBox(height: ScreenUtil().setSp(10)),
          Text(
            "${widget.address}",
            style: TextStyle(
                fontFamily: "NotoSansCJKkrRegular",
                fontSize: ScreenUtil().setSp(16),
                letterSpacing: ScreenUtil().setSp(letter_spacing)),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          SizedBox(height: ScreenUtil().setSp(30)),
          Expanded(
            child: Container(
                // width: ScreenUtil().screenWidth,
                // height: ScreenUtil().setSp(200),
                child: ClipRRect(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
              child: GoogleMap(
                mapToolbarEnabled: false,
                zoomGesturesEnabled: true,
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: widget.latlng,
                  zoom: 18,
                ),
              ),
            )),
          ),
          SizedBox(height: ScreenUtil().setSp(30)),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().setSp(50),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
                    color: app_blue),
                alignment: Alignment.center,
                child: Text(
                  "닫기",
                  style: TextStyle(
                    fontFamily: "NotoSansCJKkrBold",
                    fontSize: ScreenUtil().setSp(16),
                    letterSpacing: ScreenUtil().setSp(letter_spacing),
                    color: Colors.white,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
