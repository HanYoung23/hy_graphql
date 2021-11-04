import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_View/MainPages/map/place_detail_screen.dart';
import 'package:letsgotrip/_View/MainPages/settings/announce_detail_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';

class NotificationScreen extends StatefulWidget {
  final List checkList;
  final Function refetchCallback;
  const NotificationScreen(
      {Key key, @required this.checkList, @required this.refetchCallback})
      : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List clickedIndex = [];

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
                          int checkId = item["check_id"];
                          int check = item["check"];
                          int id = item["id"];
                          String date = item["regist_date"];
                          String month;
                          String time;
                          String ampm;
                          //
                          int index = widget.checkList.indexOf(item);
                          if (date != null) {
                            month = date
                                .substring(5, 10)
                                .replaceAll(RegExp(r'-'), "월 ");

                            if (month[0] == "0") {
                              month = month.substring(1, month.length);
                            }

                            time = date.substring(11, 16);
                            if (int.parse(time.substring(0, 2)) > 11) {
                              ampm = "PM";
                            } else {
                              ampm = "AM";
                            }
                          }

                          return Mutation(
                              options: MutationOptions(
                                  document: gql(Mutations.changeCheck),
                                  update: (GraphQLDataProxy proxy,
                                      QueryResult result) {},
                                  onCompleted: (dynamic resultData) async {
                                    print("🚨 login result : $resultData");
                                    if (resultData["change_check"]["result"]) {
                                      widget.refetchCallback();
                                      if (type == "notice") {
                                        Get.to(() =>
                                            AnnounceDetailScreen(noticeId: id));
                                      } else {
                                        seeValue("customerId")
                                            .then((customerId) {
                                          Get.to(() => PlaceDetailScreen(
                                              contentsId: id,
                                              customerId:
                                                  int.parse(customerId)));
                                        });
                                      }
                                    }
                                  }),
                              builder: (RunMutation runMutation,
                                  QueryResult queryResult) {
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        List indexList = clickedIndex;
                                        indexList.add(index);
                                        setState(() {
                                          clickedIndex = indexList;
                                        });

                                        runMutation({
                                          "type": type,
                                          "check_id": checkId,
                                        });
                                      },
                                      child: Container(
                                        color: check != 1 ||
                                                clickedIndex.contains(index)
                                            ? Colors.white
                                            : app_blue_light,
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
                                                type == "notice"
                                                    ? "새로운 공지사항이 있습니다"
                                                    : "게시물에 새로운 댓글이 달렸습니다",
                                                style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(16),
                                                    letterSpacing: -0.4)),
                                            SizedBox(
                                                height: ScreenUtil().setSp(6)),
                                            date != null
                                                ? Text("$month일 $ampm $time",
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
                                    ),
                                    Container(
                                      color: app_grey,
                                      height: ScreenUtil().setSp(1),
                                    )
                                  ],
                                );
                              });
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
