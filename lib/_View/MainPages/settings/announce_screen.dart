import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_View/MainPages/settings/announce_detail_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';

class AnnounceScreen extends StatefulWidget {
  final int customerId;
  final Function refetchCallback;
  const AnnounceScreen(
      {Key key, @required this.customerId, @required this.refetchCallback})
      : super(key: key);

  @override
  _AnnounceScreenState createState() => _AnnounceScreenState();
}

class _AnnounceScreenState extends State<AnnounceScreen> {
  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(Queries.noticeList),
          variables: {
            "customer_id": widget.customerId,
          },
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading && result.data != null) {
            // print("🚨 noticeList : $result");
            List noticeList = result.data["notice_list"];

            return SafeArea(
              top: false,
              bottom: false,
              child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: 0,
                  elevation: 0,
                  backgroundColor: Colors.white,
                  brightness: Brightness.light,
                ),
                body: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(height: ScreenUtil().setSp(20)),
                      Container(
                        width: ScreenUtil().screenWidth,
                        height: ScreenUtil().setSp(44),
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
                                fontFamily: "NotoSansCJKkrBold",
                                fontSize: ScreenUtil().setSp(appbar_title_size),
                                letterSpacing:
                                    ScreenUtil().setSp(letter_spacing),
                              ),
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
                                  int checkId = item["check_id"];
                                  int noticeId = item["notice_id"];
                                  String noticeTitle = item["notice_title"];
                                  String date = item["regist_date"];
                                  if (date != null) {
                                    date = date
                                        .substring(0, 10)
                                        .replaceAll(RegExp(r'-'), ".");
                                  }
                                  // int check = item["check"];

                                  return Mutation(
                                      options: MutationOptions(
                                          document: gql(Mutations.changeCheck),
                                          update: (GraphQLDataProxy proxy,
                                              QueryResult result) {},
                                          onCompleted:
                                              (dynamic resultData) async {
                                            // print(
                                            //     "🚨 changeCheck result : $resultData");
                                            if (resultData["change_check"]
                                                ["result"]) {
                                              widget.refetchCallback();
                                              Get.to(() => AnnounceDetailScreen(
                                                    noticeId: noticeId,
                                                  ));
                                            }
                                          }),
                                      builder: (RunMutation runMutation,
                                          QueryResult queryResult) {
                                        return Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                runMutation({
                                                  "type": "notice",
                                                  "check_id": checkId,
                                                });
                                              },
                                              child: Container(
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
                                                        height: ScreenUtil()
                                                            .setSp(4)),
                                                    Text(
                                                      noticeTitle,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "NotoSansCJKkrRegular",
                                                          fontSize: ScreenUtil()
                                                              .setSp(16),
                                                          letterSpacing:
                                                              ScreenUtil().setSp(
                                                                  letter_spacing)),
                                                      overflow:
                                                          TextOverflow.clip,
                                                      maxLines: 2,
                                                    ),
                                                    SizedBox(
                                                        height: ScreenUtil()
                                                            .setSp(6)),
                                                    Text(date,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "NotoSansCJKkrRegular",
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(14),
                                                            color:
                                                                app_font_grey,
                                                            letterSpacing:
                                                                ScreenUtil().setSp(
                                                                    letter_spacing_small))),
                                                    SizedBox(
                                                        height: ScreenUtil()
                                                            .setSp(4)),
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
                          : Expanded(
                              child: Center(
                                child: Text(
                                  "공지사항이 없습니다.",
                                  style: TextStyle(
                                      fontFamily: "NotoSansCJKkrRegular",
                                      fontSize: ScreenUtil().setSp(14),
                                      color: app_font_grey,
                                      letterSpacing: ScreenUtil()
                                          .setSp(letter_spacing_small)),
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            )
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
