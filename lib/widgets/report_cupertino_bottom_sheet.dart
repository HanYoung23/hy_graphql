import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/functions/material_popup.dart';

class ReportCupertinoBottomSheet extends StatelessWidget {
  final int contentsId;
  const ReportCupertinoBottomSheet({
    Key key,
    @required this.contentsId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: Text(
              "신고하기",
              style: TextStyle(
                fontSize: ScreenUtil().setSp(20),
                letterSpacing: -0.48,
                color: app_red_cupertino,
              ),
            ),
            onPressed: () {
              Get.back();
              reportPostPopup(context, contentsId);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            "취소",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(20),
              letterSpacing: -0.48,
              color: app_blue_cupertino_cancel,
            ),
          ),
          onPressed: () {
            Get.back();
          },
        ));
  }
}
