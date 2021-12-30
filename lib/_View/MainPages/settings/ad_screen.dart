import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:letsgotrip/_View/MainPages/settings/ad_post_list_screen.dart';
import 'package:letsgotrip/_View/MainPages/settings/ad_post_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';

class AdScreen extends StatelessWidget {
  final int customerId;
  const AdScreen({Key key, @required this.customerId}) : super(key: key);

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().setSp(44),
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
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
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setSp(side_gap)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ScreenUtil().setSp(28)),
                  Text(
                    "게시물 관리",
                    style: TextStyle(
                      fontFamily: "NotoSansCJKkrBold",
                      fontSize: ScreenUtil().setSp(font_xs),
                      letterSpacing: ScreenUtil().setSp(letter_spacing_small),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setSp(10)),
                  InkWell(
                    onTap: () {
                      Get.to(() => AdPostScreen());
                    },
                    child: Container(
                      width: ScreenUtil().screenWidth,
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setSp(10)),
                      child: Text(
                        "홍보 게시물 작성하기",
                        style: TextStyle(
                          fontFamily: "NotoSansCJKkrRegular",
                          fontSize: ScreenUtil().setSp(font_s),
                          letterSpacing: ScreenUtil().setSp(letter_spacing),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setSp(10)),
                  InkWell(
                    onTap: () {
                      seeValue("customerId").then((customerId) {
                        Get.to(() => AdPostListScreen(
                            customerId: int.parse(customerId)));
                      });
                    },
                    child: Container(
                      width: ScreenUtil().screenWidth,
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setSp(10)),
                      child: Text(
                        "내 게시물 관리하기",
                        style: TextStyle(
                          fontFamily: "NotoSansCJKkrRegular",
                          fontSize: ScreenUtil().setSp(font_s),
                          letterSpacing: ScreenUtil().setSp(letter_spacing),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setSp(54)),
                  Text(
                    "잔여금액",
                    style: TextStyle(
                      fontFamily: "NotoSansCJKkrBold",
                      fontSize: ScreenUtil().setSp(font_xs),
                      letterSpacing: ScreenUtil().setSp(letter_spacing_small),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setSp(20)),
                  Query(
                      options: QueryOptions(
                        document: gql(Queries.customerPoint),
                        variables: {"customer_id": customerId},
                      ),
                      builder: (result, {refetch, fetchMore}) {
                        if (!result.isLoading) {
                          // print("🚨 customerPoint : $result");
                          int point = result.data["customer_point"]["point"];

                          var format = NumberFormat('###,###,###,###');
                          String pointValue = format.format(point);

                          return Text(
                            "$pointValue 원",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrRegular",
                              fontSize: ScreenUtil().setSp(font_s),
                              letterSpacing: ScreenUtil().setSp(letter_spacing),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
