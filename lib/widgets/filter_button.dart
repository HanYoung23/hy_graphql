import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterBtn extends StatelessWidget {
  final String isActive;
  final Function filterBtnOnClick;
  const FilterBtn(
      {Key key, @required this.isActive, @required this.filterBtnOnClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: ScreenUtil().setSp(10),
        left: ScreenUtil().setSp(10),
        child: InkWell(
          onTap: () {
            isActive == "" ? filterBtnOnClick() : null;
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
