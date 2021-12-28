import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/functions/search_place.dart';

class PlaceSearchScreen extends StatefulWidget {
  final Function callback;
  const PlaceSearchScreen({Key key, @required this.callback}) : super(key: key);

  @override
  _PlaceSearchScreenState createState() => _PlaceSearchScreenState();
}

class _PlaceSearchScreenState extends State<PlaceSearchScreen> {
  final searchTextController = TextEditingController();

  List queryList;

  setQueryList(List result) {
    // print("🚨 callback : $result");
    setState(() {
      queryList = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.white,
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().screenHeight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: ScreenUtil().setSp(side_gap)),
                Container(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().setSp(44),
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setSp(side_gap)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Image.asset("assets/images/arrow_back.png",
                                  width: ScreenUtil().setSp(arrow_back_size),
                                  height: ScreenUtil().setSp(arrow_back_size))),
                        ),
                      ),
                      Text(
                        "장소명으로 검색",
                        style: TextStyle(
                          fontFamily: "NotoSansCJKkrBold",
                          fontSize: ScreenUtil().setSp(appbar_title_size),
                          letterSpacing: ScreenUtil().setSp(letter_spacing),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(ScreenUtil().setSp(side_gap)),
                    padding: EdgeInsets.only(left: ScreenUtil().setSp(8)),
                    decoration: BoxDecoration(
                      border: Border.all(width: ScreenUtil().setSp(0.5)),
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().setSp(5)),
                    ),
                    child: TextField(
                      controller: searchTextController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: InkWell(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              kakaoSearch("${searchTextController.text}")
                                  .then((value) {
                                setQueryList(value);
                              });
                            },
                            child: Container(
                              width: ScreenUtil().setSp(56),
                              height: ScreenUtil().setSp(34),
                              margin: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setSp(5),
                                  horizontal: ScreenUtil().setSp(8)),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setSp(5)),
                                  color: app_blue),
                              child: Center(
                                  child: Text(
                                "확인",
                                style: TextStyle(
                                    fontFamily: "NotoSansCJKkrBold",
                                    fontSize: ScreenUtil().setSp(14),
                                    letterSpacing: ScreenUtil()
                                        .setSp(letter_spacing_small),
                                    color: Colors.white),
                              )),
                            ),
                          )),
                    )),
                SizedBox(height: ScreenUtil().setSp(10)),
                queryList != null
                    ? queryList.length != 0
                        ? Column(
                            children: queryList.map((map) {
                              int index = queryList.indexOf(map);
                              Map queryMap = {
                                "address":
                                    "${map["address_name"]}, (${map["place_name"]})",
                                "lng": double.parse("${map["x"]}"),
                                "lat": double.parse("${map["y"]}"),
                              };
                              return InkWell(
                                onTap: () {
                                  Get.back();
                                  widget.callback(queryMap);
                                },
                                child: Container(
                                  width: ScreenUtil().screenWidth,
                                  // height: ScreenUtil().setSp(40),
                                  color: index.isEven ? app_grey : Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setSp(side_gap),
                                    vertical: ScreenUtil().setSp(side_gap),
                                  ),
                                  child: Text(
                                    "• ${map["address_name"]}\n  (${map["place_name"]})",
                                    style: TextStyle(
                                      fontFamily: "NotoSansCJKkrRegular",
                                      fontSize: ScreenUtil().setSp(14),
                                      letterSpacing: ScreenUtil()
                                          .setSp(letter_spacing_small),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        : Container(child: Text("검색 결과가 없습니다."))
                    : Container(),
                SizedBox(height: ScreenUtil().setSp(side_gap)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
