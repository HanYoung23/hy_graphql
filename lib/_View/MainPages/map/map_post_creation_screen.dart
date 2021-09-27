import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/homepage.dart';
import 'package:letsgotrip/widgets/map_post_creation_bottom_sheet.dart';

class MapPostCreationScreen extends StatefulWidget {
  const MapPostCreationScreen({
    Key key,
  }) : super(key: key);

  @override
  _MapPostCreationScreenState createState() => _MapPostCreationScreenState();
}

class _MapPostCreationScreenState extends State<MapPostCreationScreen> {
  final nicknameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String category = "";

  categoryCallback(String categoryName) {
    setState(() {
      category = categoryName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: Container(
            margin: EdgeInsets.all(ScreenUtil().setSp(20)),
            child: Column(
              children: [
                Container(
                  width: ScreenUtil().setWidth(375),
                  height: ScreenUtil().setHeight(44),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          // width: ScreenUtil().setSp(appbar_title_size * 3),
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Icons.arrow_back,
                              size: ScreenUtil().setSp(arrow_back_size),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "게시물 작성",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(appbar_title_size),
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "임시저장",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(appbar_title_size),
                                color: app_font_grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (_) => MapPostCreationBottomSheet(
                            callback: (category) =>
                                categoryCallback(category)));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(8)),
                    alignment: Alignment.centerLeft,
                    child: Text(category == "" ? "카테고리 설정" : "$category",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(14),
                            color:
                                category == "" ? app_font_grey : Colors.black)),
                  ),
                ),
                Container(
                    color: app_grey,
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().setSp(3)),
                SizedBox(height: ScreenUtil().setHeight(18)),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("이미지를 첨부해보세요\n(0/10)",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          color: app_font_grey)),
                ),
                SizedBox(height: ScreenUtil().setHeight(15)),
                Row(
                  children: [
                    Container(
                      width: ScreenUtil().setSp(58),
                      height: ScreenUtil().setSp(58),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromRGBO(241, 241, 245, 1)),
                      child: Icon(
                        Icons.add,
                        size: ScreenUtil().setSp(40),
                        color: Color.fromRGBO(188, 192, 193, 1),
                      ),
                    ),
                    Container(
                      width: ScreenUtil().setSp(58),
                      height: ScreenUtil().setSp(58),
                      margin: EdgeInsets.only(left: ScreenUtil().setSp(10)),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromRGBO(241, 241, 245, 1)),
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(8)),
                Container(
                    color: app_grey,
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().setSp(3)),
                SizedBox(height: ScreenUtil().setHeight(18)),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("내용을 입력해주세요.\n(정책을 위반한 글은 무통보 삭제 처리될 수 있습니다.)",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          color: app_font_grey),
                      maxLines: 3,
                      overflow: TextOverflow.clip),
                ),
                SizedBox(height: ScreenUtil().setHeight(114)),
                Container(
                    color: app_grey,
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().setSp(3)),
                SizedBox(height: ScreenUtil().setHeight(23)),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("태그를 입력할 수 있습니다 (ex. 바다)",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          color: app_font_grey)),
                ),
                SizedBox(height: ScreenUtil().setHeight(8)),
                Container(
                    color: app_grey,
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().setSp(3)),
                Spacer(),
                InkWell(
                    onTap: () {
                      // Get.offAll(() => HomePage());
                    },
                    child: Image.asset(
                        "assets/images/walkthroughFirst/next_button.png")),
                SizedBox(height: ScreenUtil().setHeight(14)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
