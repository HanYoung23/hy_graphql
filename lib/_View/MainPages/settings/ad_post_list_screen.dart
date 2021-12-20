import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:letsgotrip/_View/MainPages/settings/ad_post_mine_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';

class AdPostListScreen extends StatelessWidget {
  final int customerId;
  const AdPostListScreen({
    Key key,
    @required this.customerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().screenHeight,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().setSp(44),
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
                margin: EdgeInsets.only(top: ScreenUtil().setSp(20)),
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
                              height: ScreenUtil().setSp(arrow_back_size)),
                        ),
                      ),
                    ),
                    Text(
                      "게시물 홍보하기",
                      style: TextStyle(
                        fontFamily: "NotoSansCJKkrBold",
                        fontSize: ScreenUtil().setSp(appbar_title_size),
                        letterSpacing: ScreenUtil().setSp(letter_spacing),
                      ),
                    ),
                    Expanded(
                      child: Image.asset("assets/images/arrow_back.png",
                          color: Colors.transparent,
                          width: ScreenUtil().setSp(arrow_back_size),
                          height: ScreenUtil().setSp(arrow_back_size)),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                    child: Query(
                        options: QueryOptions(
                          document: gql(Queries.myPromotionsList),
                          variables: {"customer_id": customerId},
                        ),
                        builder: (result, {refetch, fetchMore}) {
                          if (!result.isLoading && result.data != null) {
                            // print("🚨 myPromotionsList result : $result");
                            List resultData = result.data["my_promotions_list"];
                            return ListView(
                              children: resultData.map((post) {
                                String dateString = post["regist_date"];
                                if (post["edit_date"] != null) {
                                  dateString = post["edit_date"];
                                }
                                String dateFormat = DateFormat("yyyy.MM.dd")
                                    .format(DateTime.parse(dateString));

                                String promotionState;
                                switch (post["promotions_state"]) {
                                  case 1:
                                    promotionState = "심사 대기중";
                                    break;
                                  case 2:
                                    promotionState = "승인 반려됨";
                                    break;
                                  case 3:
                                    promotionState = "진행중";
                                    break;
                                  case 4:
                                    promotionState = "중지됨";
                                    break;
                                  case 5:
                                    promotionState = "완료";
                                    break;
                                  case 6:
                                    promotionState = "삭제됨";
                                    break;
                                  default:
                                }

                                return InkWell(
                                  onTap: () {
                                    Get.to(() => AdPostMineScreen(
                                        paramData: post,
                                        refetchCallback: refetch));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: ScreenUtil().screenWidth,
                                        padding: EdgeInsets.all(
                                            ScreenUtil().setSp(side_gap)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("$dateFormat",
                                                style: TextStyle(
                                                  fontFamily:
                                                      "NotoSansCJKkrBold",
                                                  fontSize:
                                                      ScreenUtil().setSp(18),
                                                  letterSpacing: ScreenUtil()
                                                      .setSp(
                                                          letter_spacing_big),
                                                )),
                                            SizedBox(
                                                height: ScreenUtil().setSp(20)),
                                            Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          ScreenUtil()
                                                              .setSp(10)),
                                                  child: Image.network(
                                                    "${post["image_link"]}"
                                                        .split(",")[0],
                                                    fit: BoxFit.cover,
                                                    width:
                                                        ScreenUtil().setSp(94),
                                                    height:
                                                        ScreenUtil().setSp(94),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width:
                                                        ScreenUtil().setSp(10)),
                                                Flexible(
                                                  child: Container(
                                                    height:
                                                        ScreenUtil().setSp(94),
                                                    // width: ScreenUtil()
                                                    //         .screenWidth -
                                                    //     ScreenUtil().setSp(
                                                    //         105 + side_gap * 2),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${post["title"]}",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "NotoSansCJKkrRegular",
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(14),
                                                            letterSpacing:
                                                                ScreenUtil().setSp(
                                                                    letter_spacing_small),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          "$promotionState",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "NotoSansCJKkrBold",
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(14),
                                                            letterSpacing:
                                                                ScreenUtil().setSp(
                                                                    letter_spacing_small),
                                                            color: app_blue,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                        SizedBox(
                                                            height: ScreenUtil()
                                                                .setSp(2)),
                                                        Text(
                                                          "(${post["promotions_count"]}/${post["promotions_count_total"]})",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "NotoSansCJKkrRegular",
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(14),
                                                            letterSpacing:
                                                                ScreenUtil().setSp(
                                                                    letter_spacing_small),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                                height: ScreenUtil().setSp(20)),
                                            Row(
                                              children: [
                                                SizedBox(
                                                    width:
                                                        ScreenUtil().setSp(8)),
                                                Image.asset(
                                                  "assets/images/phone_icon.png",
                                                  width: ScreenUtil().setSp(14),
                                                  height:
                                                      ScreenUtil().setSp(14),
                                                ),
                                                SizedBox(
                                                    width:
                                                        ScreenUtil().setSp(8)),
                                                Text(
                                                  "${post["phone"]}",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "NotoSansCJKkrRegular",
                                                    fontSize:
                                                        ScreenUtil().setSp(14),
                                                    letterSpacing: ScreenUtil()
                                                        .setSp(
                                                            letter_spacing_small),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height: ScreenUtil().setSp(10)),
                                            Row(
                                              children: [
                                                SizedBox(
                                                    width:
                                                        ScreenUtil().setSp(8)),
                                                Image.asset(
                                                  "assets/images/location_icon.png",
                                                  width: ScreenUtil().setSp(14),
                                                  height:
                                                      ScreenUtil().setSp(14),
                                                ),
                                                SizedBox(
                                                    width:
                                                        ScreenUtil().setSp(8)),
                                                Text(
                                                  "${post["location_link"]}",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "NotoSansCJKkrRegular",
                                                    fontSize:
                                                        ScreenUtil().setSp(14),
                                                    letterSpacing: ScreenUtil()
                                                        .setSp(
                                                            letter_spacing_small),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                            // SizedBox(height: ScreenUtil().setSp(20)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: ScreenUtil().screenWidth,
                                        height: ScreenUtil().setSp(8),
                                        color: app_grey,
                                      )
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          } else {
                            return Container();
                          }
                        })),
              ),
            ],
          )),
    );
  }
}
