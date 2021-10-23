import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';

class AnnounceScreen extends StatefulWidget {
  const AnnounceScreen({Key key}) : super(key: key);

  @override
  _AnnounceScreenState createState() => _AnnounceScreenState();
}

class _AnnounceScreenState extends State<AnnounceScreen> {
  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(Queries.noticeList),
          variables: {},
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading) {
            print("🚨 noticeList : $result");
            List noticeList = result.data["notice_list"];

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
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setSp(20)),
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
                              "공지사항",
                              style: TextStyle(
                                  fontSize:
                                      ScreenUtil().setSp(appbar_title_size),
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
                      noticeList.length != 0
                          ? Expanded(
                              child: ListView(
                                children: noticeList.map((item) {
                                  //               notice_id
                                  // notice_title
                                  // image_link
                                  // notice_text
                                  // regist_date
                                  // edit_date

                                  int noticeId = item["notice_id"];
                                  String noticeTitle = item["notice_title"];
                                  String imageLink = item["image_link"];
                                  String noticeText = item["notice_text"];
                                  String date = item["regist_date"];
                                  String editDate = item["edit_date"];
                                  if (date != null) {
                                    date = date
                                        .substring(0, 10)
                                        .replaceAll(RegExp(r'-'), ".");
                                  }
                                  // int check = item["check"];

                                  return Column(
                                    children: [
                                      Container(
                                        // color: check == 1 ? app_blue_light : Colors.white,
                                        color: Colors.white,
                                        width: ScreenUtil().screenWidth,
                                        padding: EdgeInsets.all(
                                            ScreenUtil().setSp(20)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                height: ScreenUtil().setSp(4)),
                                            Text(
                                              noticeTitle,
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(16),
                                                  letterSpacing: -0.4),
                                              overflow: TextOverflow.clip,
                                              maxLines: 2,
                                            ),
                                            SizedBox(
                                                height: ScreenUtil().setSp(6)),
                                            date != null
                                                ? Text(date,
                                                    style: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(14),
                                                        color: app_font_grey,
                                                        letterSpacing: -0.35))
                                                : Text("null",
                                                    style: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(14),
                                                        color: app_font_grey,
                                                        letterSpacing: -0.35)),
                                            SizedBox(
                                                height: ScreenUtil().setSp(4)),
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
          } else {
            return Container();
          }
        });
  }
}
