import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/constants/common_value.dart';

class PhoneCallCupertinoBottomSheet extends StatelessWidget {
  final String phone;
  const PhoneCallCupertinoBottomSheet({
    Key key,
    @required this.phone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: Row(
              children: [
                SizedBox(width: ScreenUtil().setSp(8)),
                Image.asset(
                  "assets/images/phone_icon.png",
                  width: ScreenUtil().setSp(20),
                  height: ScreenUtil().setSp(20),
                ),
                SizedBox(width: ScreenUtil().setSp(14)),
                Text(
                  "통화 $phone",
                  style: TextStyle(
                    fontFamily: "NotoSansCJKkrRegular",
                    fontSize: ScreenUtil().setSp(20),
                    letterSpacing: ScreenUtil().setSp(letter_spacing_bottom),
                    color: app_blue_cupertino,
                  ),
                ),
              ],
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            "취소",
            style: TextStyle(
              fontFamily: "NotoSansCJKkrRegular",
              fontSize: ScreenUtil().setSp(20),
              letterSpacing: ScreenUtil().setSp(letter_spacing_bottom),
              color: app_blue_cupertino_cancel,
            ),
          ),
          onPressed: () {
            Get.back();
          },
        ));
  }
}
