import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letsgotrip/constants/common_value.dart';

class MapPostCreationBottomSheet extends StatefulWidget {
  final Function callback;
  const MapPostCreationBottomSheet({Key key, @required this.callback})
      : super(key: key);

  @override
  _MapPostCreationBottomSheetState createState() =>
      _MapPostCreationBottomSheetState();
}

class _MapPostCreationBottomSheetState
    extends State<MapPostCreationBottomSheet> {
  String currentCategory;
  List categoryList = ["바닷가", "액티비티", "맛집", "숙소"];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().screenHeight * 0.4,
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(20),
                  bottom: ScreenUtil().setHeight(20)),
              child: Text(
                "카테고리 설정",
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    fontWeight: FontWeight.bold),
              )),
          Column(
              children: categoryList.map((category) {
            return categoryItem(category);
          }).toList())
          // categoryItem()
        ],
      ),
    );
  }

  InkWell categoryItem(String title) {
    return InkWell(
      onTap: () {
        categoryUpdate(title);
      },
      child: Container(
        width: ScreenUtil().screenWidth,
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(14)),
        child: Text(
          "$title",
          style: TextStyle(
              fontSize: ScreenUtil().setSp(16),
              color: currentCategory == "$title" ? Colors.black : app_font_grey,
              fontWeight: currentCategory == "$title"
                  ? FontWeight.bold
                  : FontWeight.normal),
        ),
      ),
    );
  }

  void categoryUpdate(String title) {
    setState(() {
      currentCategory = "$title";
    });
    widget.callback(title);
  }
}
