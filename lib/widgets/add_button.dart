import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/_Controller/floating_button_controller.dart';
import 'package:letsgotrip/_View/MainPages/map/map_post_creation_screen.dart';

class AddBtn extends StatelessWidget {
  final String isActive;
  const AddBtn({Key key, @required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FloatingButtonController addBtnController =
        Get.put(FloatingButtonController());
    return Positioned(
        bottom: ScreenUtil().setSp(10),
        right: ScreenUtil().setSp(10),
        child: InkWell(
          onTap: () {
            addBtnController.addBtnOnClick();
          },
          child: Image.asset(
            isActive == "active"
                ? "assets/images/add_button_active.png"
                : "assets/images/add_button.png",
            width: ScreenUtil().setSp(56),
            height: ScreenUtil().setSp(56),
          ),
        ));
  }
}

class AddBtnOptions extends StatelessWidget {
  final String title;
  const AddBtnOptions({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FloatingButtonController floatingBtnController =
        Get.put(FloatingButtonController());

    return InkWell(
      onTap: () {
        Get.to(() => MapPostCreationScreen());
        // floatingBtnController.allBtnCancel();
      },
      child: Container(
        width: ScreenUtil().setSp(82),
        height: ScreenUtil().setSp(42),
        alignment: Alignment.centerRight,
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
