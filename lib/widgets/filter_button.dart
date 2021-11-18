import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/_Controller/floating_button_controller.dart';
import 'package:letsgotrip/constants/common_value.dart';

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
            width: ScreenUtil().setSp(60),
            height: ScreenUtil().setSp(60),
            fit: BoxFit.cover,
          ),
        ));
  }
}

class FilterBtnOptions extends StatelessWidget {
  final String title;
  final Function callback;
  const FilterBtnOptions(
      {Key key, @required this.title, @required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // GoogleMapWholeController gmCategoryMapController =
    //     Get.put(GoogleMapWholeController());
    FloatingButtonController floatingBtnController =
        Get.put(FloatingButtonController());
    FloatingButtonController categoryValue = Get.find();
    String currentCategory;
    switch (categoryValue.category.value) {
      case 0:
        currentCategory = "전체";

        break;
      case 1:
        currentCategory = "관광지";

        break;
      case 2:
        currentCategory = "액티비티";

        break;
      case 3:
        currentCategory = "맛집";

        break;
      case 4:
        currentCategory = "숙소";

        break;
      default:
    }

    return InkWell(
        onTap: () {
          switch (title) {
            case "전체":
              // gmCategoryMapController.setCategoryMap(1);
              floatingBtnController.categoryUpdate(0);
              // callback(1);
              callback();
              floatingBtnController.allBtnCancel();
              break;
            case "관광지":
              // gmCategoryMapController.setCategoryMap(2);
              floatingBtnController.categoryUpdate(1);
              // callback(2);
              callback();
              floatingBtnController.allBtnCancel();
              break;
            case "액티비티":
              // gmCategoryMapController.setCategoryMap(3);
              floatingBtnController.categoryUpdate(2);
              // callback(3);
              callback();
              floatingBtnController.allBtnCancel();
              break;
            case "맛집":
              // gmCategoryMapController.setCategoryMap(4);
              floatingBtnController.categoryUpdate(3);
              // callback(4);
              callback();
              floatingBtnController.allBtnCancel();
              break;
            case "숙소":
              // gmCategoryMapController.setCategoryMap(5);
              floatingBtnController.categoryUpdate(4);
              // callback(5);
              callback();
              floatingBtnController.allBtnCancel();
              break;
            default:
          }
        },
        child: Container(
          width: ScreenUtil().setSp(90),
          height: ScreenUtil().setSp(44),
          alignment: Alignment.centerLeft,
          child: Text(
            "$title",
            style: TextStyle(
                fontFamily: "NotoSansCJKkrBold",
                fontSize: ScreenUtil().setSp(16),
                color: Colors.white,
                letterSpacing: ScreenUtil().setSp(letter_spacing_big),
                decoration: title == currentCategory
                    ? TextDecoration.underline
                    : TextDecoration.none),
          ),
        ));
  }
}
