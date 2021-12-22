import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:letsgotrip/_View/MainPages/settings/ad_post_done_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/functions/aws_upload.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';

class Payment extends StatelessWidget {
  final Map paramData;

  const Payment({
    Key key,
    @required this.paramData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
            document: gql(Mutations.newPromotions),
            update: (GraphQLDataProxy proxy, QueryResult result) {},
            onCompleted: (dynamic resultData) {
              print("🚨 new promotions resultData : $resultData");
              if (resultData["new_promotions"]["result"]) {
                Get.to(() => AdPostDoneScreen(
                    promotionId: "${resultData["new_promotions"]["msg"]}"));
              }
            }),
        builder: (RunMutation runMutation, QueryResult queryResult) {
          return IamportPayment(
            appBar: AppBar(
              title: Text(
                "결제",
                style: TextStyle(
                  fontFamily: "NotoSansCJKkrBold",
                  fontSize: ScreenUtil().setSp(appbar_title_size),
                  letterSpacing: ScreenUtil().setSp(letter_spacing),
                ),
              ),
              elevation: 0,
              centerTitle: true,
            ),
            /* 웹뷰 로딩 컴포넌트 */
            initialChild: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/spinner.gif',
                      width: ScreenUtil().setSp(40),
                      height: ScreenUtil().setSp(40),
                    ),
                    SizedBox(height: ScreenUtil().setSp(30)),
                    Container(
                      child: Text('잠시만 기다려주세요...',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(20),
                              fontFamily: "NotoSansCJKkrRegular",
                              letterSpacing:
                                  ScreenUtil().setSp(letter_spacing_small),
                              color: app_font_grey)),
                    ),
                  ],
                ),
              ),
            ),
            /* [필수입력] 가맹점 식별코드 */
            userCode: 'iamport',
            /* [필수입력] 결제 데이터 */
            data: PaymentData.fromJson({
              'pg': 'html5_inicis', // PG사
              // 'payMethod': 'card', // 결제수단
              'name': '아임포트 결제데이터 분석', // 주문명
              'merchantUid':
                  'mid_${DateTime.now().millisecondsSinceEpoch}', // 주문번호
              // 'amount': paramData["amount"], // 결제금액
              'amount': 100, // 결제금액
              'buyerName': paramData["buyerName"], // 구매자 이름
              'buyerTel': paramData["phoneText"], // 구매자 연락처
              'buyerEmail': "", // 구매자 이메일
              'buyerAddr': paramData["address"], // 구매자 주소
              'buyerPostcode': "", // 구매자 우편번호
              'appScheme': 'iamport', // 앱 URL scheme
              'display': {
                'cardQuota': [2, 3] //결제창 UI 내 할부개월수 제한
              }
            }),
            /* [필수입력] 콜백 함수 */
            callback: (Map<String, String> result) async {
              print("🚨 payment result : $result");
              if (result["imp_success"] == "true") {
                List awsUrlList = [];
                await uploadAWS(paramData["imageLink"]).then((awsLinks) {
                  for (String photoUrl in awsLinks) {
                    awsUrlList.add(photoUrl);
                  }
                });
                String thumbnail = awsUrlList[0];
                awsUrlList.removeAt(0);
                String imageLink = awsUrlList.join(",");

                runMutation({
                  "title": "${paramData["titleText"]}",
                  "thumbnail": "$thumbnail",
                  "image_link": "$imageLink",
                  "main_text": "${paramData["contentText"]}",
                  "location_link": "${paramData["address"]}",
                  "phone": "${paramData["phoneText"]}",
                  "customer_id": paramData["customerId"],
                  "ranges": paramData["range"],
                  "promotions_count_total": paramData["count"],
                  "business_name": "${paramData["businessName"]}",
                  "point_total": paramData["amount"],
                  "latitude": "${paramData["lat"]}",
                  "longitude": "${paramData["lng"]}",
                });
              } else {
                Get.back();
              }
            },
          );
        });
  }
}
