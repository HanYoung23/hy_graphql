import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddBtn extends StatelessWidget {
  final String isActive;
  final Function addBtnOnClick;
  const AddBtn({Key key, @required this.isActive, @required this.addBtnOnClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: ScreenUtil().setSp(10),
        right: ScreenUtil().setSp(10),
        child: InkWell(
          onTap: () {
            isActive == "" ? addBtnOnClick() : null;
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
