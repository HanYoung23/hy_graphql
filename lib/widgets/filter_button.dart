import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/_Controller/floating_button_controller.dart';

class FilterBtn extends StatelessWidget {
  final String isActive;
  const FilterBtn({Key key, @required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FloatingButtonController floatingBtnController =
        Get.put(FloatingButtonController());

    return Positioned(
        bottom: ScreenUtil().setSp(10),
        left: ScreenUtil().setSp(10),
        child: InkWell(
          onTap: () {
            floatingBtnController.filterBtnOnClick();
          },
          child: Image.asset(
            isActive == "active"
                ? "assets/images/filter_button_active.png"
                : "assets/images/filter_button.png",
            width: ScreenUtil().setSp(56),
            height: ScreenUtil().setSp(56),
          ),
        ));
  }
}

class FilterBtnOptions extends StatelessWidget {
  final String title;
  const FilterBtnOptions({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // func();
      },
      child: Container(
        width: ScreenUtil().setSp(82),
        height: ScreenUtil().setSp(42),
        alignment: Alignment.centerLeft,
        child: Text(
          "$title",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(16),
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: ScreenUtil().setSp(-0.45),
          ),
        ),
      ),
    );
  }
}
