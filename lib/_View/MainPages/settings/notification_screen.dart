import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/constants/common_value.dart';

class NotificationScreen extends StatefulWidget {
  final List checkList;
  const NotificationScreen({Key key, @required this.checkList})
      : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: ScreenUtil().setSp(20)),
              Container(
                width: ScreenUtil().setWidth(375),
                height: ScreenUtil().setHeight(44),
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Image.asset("assets/images/arrow_back.png",
                          width: ScreenUtil().setSp(arrow_back_size),
                          height: ScreenUtil().setSp(arrow_back_size)),
                    ),
                    Text(
                      "알림",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(appbar_title_size),
                          letterSpacing: -0.4,
                          fontWeight: appbar_title_weight),
                    ),
                    Image.asset("assets/images/arrow_back.png",
                        color: Colors.transparent,
                        width: ScreenUtil().setSp(arrow_back_size),
                        height: ScreenUtil().setSp(arrow_back_size)),
                  ],
                ),
              ),
              widget.checkList.length != 0
                  ? Expanded(
                      child: ListView(
                        children: widget.checkList.map((item) {
                          String type = item["type"];
                          String date = item["regist_date"];
                          String month;
                          String time;
                          String ampm;
                          if (date != null) {
                            month = date
                                .substring(5, 10)
                                .replaceAll(RegExp(r'-'), "월 ");

                            if (month[0] == "0") {
                              month = month.substring(1, month.length);
                              print("🚨 $month");
                            }

                            time = date.substring(11, 16);
                            if (int.parse(time.substring(0, 2)) > 11) {
                              ampm = "PM";
                            } else {
                              ampm = "AM";
                            }
                          }
                          int check = item["check"];

                          return Column(
                            children: [
                              Container(
                                color:
                                    check == 1 ? app_blue_light : Colors.white,
                                width: ScreenUtil().screenWidth,
                                padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: ScreenUtil().setSp(4)),
                                    Text(
                                        type == "notice"
                                            ? "새로운 공지사항이 있습니다"
                                            : "게시물에 새로운 댓글이 달렸습니다",
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(16),
                                            letterSpacing: -0.4)),
                                    SizedBox(height: ScreenUtil().setSp(6)),
                                    date != null
                                        ? Text("$month일 $ampm $time",
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(14),
                                                color: app_font_grey,
                                                letterSpacing: -0.35))
                                        : Text("null",
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(14),
                                                color: app_font_grey,
                                                letterSpacing: -0.35)),
                                    SizedBox(height: ScreenUtil().setSp(4)),
                                  ],
                                ),
                              ),
                              Container(
                                color: app_grey,
                                height: ScreenUtil().setSp(1),
                              )
                            ],
                          );
                        }).toList(),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
