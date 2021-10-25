import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/constants/common_value.dart';

// void gpsNullPopup(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           // title:  Text("사진에 위치 정보가 없습니다."),
//           content:  Text("위치 검색 후 진행할 수 있습니다."),
//           actions: <Widget>[
//              InkWell(
//                onTap: (){
//                  Get.to
//                },
//                child: Text("위치 검색 하기", style: TextStyle(fontSize : ScreenUtil().setSp(16))))
//           ],
//         );
//       },
//     );
//   }

savePostPopup(BuildContext context, Function saveDataCallback) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
            // insetPadding: EdgeInsets.zero,
            // contentPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setSp(20)),
              child: Container(
                width: ScreenUtil().setSp(320),
                // height: ScreenUtil().setSp(100),
                child: Text(
                  "임시저장 하시겠습니까?\n다음 게시물 작성 시 불러올 수 있습니다.",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    letterSpacing: -0.4,
                  ),
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
            actions: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setSp(14),
                  vertical: ScreenUtil().setSp(10),
                ),
                child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      "취소",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(16),
                        letterSpacing: -0.4,
                        fontWeight: FontWeight.bold,
                        color: app_font_grey,
                      ),
                    )),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setSp(14),
                  vertical: ScreenUtil().setSp(10),
                ),
                child: InkWell(
                    onTap: () {
                      saveDataCallback();
                      Get.back();
                    },
                    child: Text(
                      "확인",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(16),
                        letterSpacing: -0.4,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
            ],
          ));
}

callSaveDataPopup(BuildContext context, Function callSaveDataCallback) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Container(
              width: ScreenUtil().setSp(336),
              height: ScreenUtil().setSp(348),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Text(
                    "이전에 임시저장했던 게시물이 있습니다.\n이어서 작성하시겠습니까?",
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      letterSpacing: -0.4,
                      height: 1.4,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                  SizedBox(height: ScreenUtil().setSp(30)),
                  Text(
                    "새롭게 작성하게 되면 임시저장된 게시물은\n초기화됩니다.",
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      letterSpacing: -0.4,
                      color: app_font_grey,
                      height: 1.4,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                  SizedBox(height: ScreenUtil().setSp(40)),
                  InkWell(
                    onTap: () {
                      callSaveDataCallback();
                      Get.back();
                    },
                    child: Container(
                      width: ScreenUtil().setSp(296),
                      height: ScreenUtil().setSp(44),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: app_blue,
                      ),
                      child: Center(
                        child: Text(
                          "네, 이어서 작성할게요.",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(14),
                            letterSpacing: -0.35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setSp(10)),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: ScreenUtil().setSp(296),
                      height: ScreenUtil().setSp(44),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: ScreenUtil().setSp(1),
                          color: app_font_grey,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "아니요, 새롭게 작성할게요.",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(14),
                            letterSpacing: -0.35,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ));
}
