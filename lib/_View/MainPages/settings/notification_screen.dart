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
  List checkList = [];

  reArrangeList() {
    checkList = widget.checkList;
    checkList.map((item) {
      int index = checkList.indexOf(item);
      String timeValues = item["regist_date"];
      String numberValues = timeValues
          .replaceAll("-", "")
          .replaceAll("T", "")
          .replaceAll(":", "")
          .replaceAll(".", "")
          .replaceAll("Z", "")
          .removeAllWhitespace;
      checkList[index]["arrangeNum"] = numberValues;
    }).toList();
    checkList.sort((a, b) => b["arrangeNum"].compareTo(a["arrangeNum"]));
  }

  @override
  void initState() {
    reArrangeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: ScreenUtil().setSp(20)),
              Container(
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().setSp(44),
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
                          fontFamily: "NotoSansCJKkrBold",
                          fontSize: ScreenUtil().setSp(appbar_title_size),
                          letterSpacing: ScreenUtil().setSp(letter_spacing)),
                    ),
                    Image.asset("assets/images/arrow_back.png",
                        color: Colors.transparent,
                        width: ScreenUtil().setSp(arrow_back_size),
                        height: ScreenUtil().setSp(arrow_back_size)),
                  ],
                ),
              ),
              checkList.length != 0
                  ? Expanded(
                      child: ListView(
                        children: checkList.map((item) {
                          String type = item["type"];
                          int checkId = item["check_id"];
                          int check = item["check"];
                          int id = item["id"];
                          String date = item["regist_date"];
                          String month;
                          String time;
                          String ampm;
                          //
                          int index = checkList.indexOf(item);
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
                          //
                          print("🚨 arrange : ${item["arrangeNum"]}");

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
                                                    fontFamily:
                                                        "NotoSansCJKkrRegular",
                                                    fontSize:
                                                        ScreenUtil().setSp(16),
                                                    letterSpacing: ScreenUtil()
                                                        .setSp(
                                                            letter_spacing))),
                                            SizedBox(
                                                height: ScreenUtil().setSp(6)),
                                            Text("$month일 $ampm $time",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "NotoSansCJKkrRegular",
                                                    fontSize:
                                                        ScreenUtil().setSp(14),
                                                    color: app_font_grey,
                                                    letterSpacing: ScreenUtil()
                                                        .setSp(
                                                            letter_spacing_small))),
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
