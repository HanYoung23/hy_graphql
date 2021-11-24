import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letsgotrip/constants/common_value.dart';

class LocationUnableScreen extends StatelessWidget {
  const LocationUnableScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "위치 서비스가 꺼져있습니다.\n설정에서 변경 후 이용 가능합니다.",
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontFamily: "NotoSansCJKkrBold",
                fontSize: ScreenUtil().setSp(16),
                letterSpacing: letter_spacing_small),
          ),
          SizedBox(height: ScreenUtil().setSp(40)),
          InkWell(
            onTap: () {
              AppSettings.openLocationSettings();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(18),
                vertical: ScreenUtil().setSp(14),
              ),
              decoration: BoxDecoration(
                  color: app_blue,
                  borderRadius: BorderRadius.circular(ScreenUtil().setSp(10))),
              child: Text(
                "설정으로 가기",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: "NotoSansCJKkrBold",
                    fontSize: ScreenUtil().setSp(16),
                    color: Colors.white,
                    letterSpacing: letter_spacing_small),
              ),
            ),
          )
        ],
      ),
    );
  }
}
