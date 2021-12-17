import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_View/MainPages/settings/ad_post_mine_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/homepage.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';

class AdPostDoneScreen extends StatelessWidget {
  final String promotionId;
  const AdPostDoneScreen({Key key, @required this.promotionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        padding: EdgeInsets.all(ScreenUtil().setSp(side_gap)),
        child: Column(
          children: [
            Spacer(),
            Image.asset(
              "assets/images/check.png",
              width: ScreenUtil().setSp(30),
              height: ScreenUtil().setSp(30),
            ),
            SizedBox(height: ScreenUtil().setSp(20)),
            Text(
              "접수되었습니다.",
              style: TextStyle(
                fontSize: ScreenUtil().setSp(20),
                fontFamily: "NotoSansCJKKRBold",
                letterSpacing: ScreenUtil().setSp(-0.5),
              ),
            ),
            SizedBox(height: ScreenUtil().setSp(10)),
            Text(
              "심사 승인 후 노출이 시작됩니다.",
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
                fontFamily: "NotoSansCJKKRRegular",
                letterSpacing: ScreenUtil().setSp(letter_spacing),
                color: app_grey_dark,
              ),
            ),
            SizedBox(height: ScreenUtil().setSp(26)),
            InkWell(
              onTap: () {
                seeValue("customerId").then((customerId) {
                  Get.to(() => Query(
                      options: QueryOptions(
                        document: gql(Queries.myPromotionsList),
                        variables: {"customer_id": int.parse(customerId)},
                      ),
                      builder: (result, {refetch, fetchMore}) {
                        if (!result.isLoading && result.data != null) {
                          // print("🚨 myPromotionsList result : $result");
                          Map resultData = result.data["my_promotions_list"]
                              [result.data["my_promotions_list"].length - 1];
                          return AdPostMineScreen(
                            paramData: resultData,
                            // customerId: int.parse(customerId),
                          );
                        } else {
                          return Container();
                        }
                      }));
                });
              },
              child: Container(
                width: ScreenUtil().setSp(180),
                height: ScreenUtil().setSp(40),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: app_grey,
                  borderRadius: BorderRadius.circular(ScreenUtil().setSp(5)),
                ),
                child: Text(
                  "진행 내역 확인",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    fontFamily: "NotoSansCJKKRBold",
                    letterSpacing: ScreenUtil().setSp(letter_spacing_small),
                  ),
                ),
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Get.offAll(() => HomePage());
              },
              child: Container(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().setSp(50),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().setSp(10)),
                      color: app_blue),
                  alignment: Alignment.center,
                  child: Text(
                    "확인",
                    style: TextStyle(
                      fontFamily: "NotoSansCJKkrBold",
                      fontSize: ScreenUtil().setSp(16),
                      letterSpacing: ScreenUtil().setSp(letter_spacing),
                      color: Colors.white,
                    ),
                  )),
            ),
            SizedBox(height: ScreenUtil().setSp(14)),
          ],
        ),
      ),
    );
  }
}
