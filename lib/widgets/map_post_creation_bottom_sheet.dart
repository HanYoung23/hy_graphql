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
  List categoryList = ["관광지", "액티비티", "맛집", "숙소"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        height: ScreenUtil().setSp(280),
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(40)),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(
                    top: ScreenUtil().setSp(20),
                    bottom: ScreenUtil().setSp(20)),
                child: Text(
                  "카테고리 설정",
                  style: TextStyle(
                    fontFamily: "NotoSansCJKkrBold",
                    fontSize: ScreenUtil().setSp(16),
                    letterSpacing: ScreenUtil().setSp(letter_spacing),
                  ),
                )),
            Column(
                children: categoryList.map((category) {
              return categoryItem(category);
            }).toList())
            // categoryItem()
          ],
        ),
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
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(10)),
        child: Text(
          "$title",
          style: TextStyle(
              fontFamily: "NotoSansCJKkrRegular",
              fontSize: ScreenUtil().setSp(16),
              letterSpacing: ScreenUtil().setSp(letter_spacing),
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
