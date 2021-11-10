import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/functions/material_popup.dart';
import 'package:letsgotrip/widgets/channeltalk_bottom_sheet.dart';

class SignOutScreen extends StatelessWidget {
  const SignOutScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
        ),
        body: Container(
          margin: EdgeInsets.all(ScreenUtil().setSp(20)),
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().screenHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: ScreenUtil().setWidth(375),
                height: ScreenUtil().setHeight(44),
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
                      "회원탈퇴",
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
              SizedBox(height: ScreenUtil().setSp(68)),
              Text(
                "떠나시는건가요?",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(20),
                  letterSpacing: -0.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ScreenUtil().setSp(16)),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      enableDrag: false,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (_) => ChanneltalkBottomSheet(),
                      isScrollControlled: true);
                },
                child: RichText(
                    text: TextSpan(
                        text:
                            "앱 서비스를 이용하시면서 불편하셨던 점이나 이를 보완할 수 있는 방안을 알려주시면 서비스 개선에 적극적으로 반영하도록 하겠습니다. ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(14),
                          letterSpacing: -0.35,
                        ),
                        children: [
                      TextSpan(
                        text: "1:1 고객문의",
                        style: TextStyle(
                          color: app_blue,
                          fontSize: ScreenUtil().setSp(14),
                          letterSpacing: -0.35,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ])),
              ),
              SizedBox(height: ScreenUtil().setSp(60)),
              Text(
                "여행사진지도 내에서 활동했던 모든 활동이 삭제됩니다.\n삭제된 정보는 다시 복구할 수 없습니다.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: ScreenUtil().setSp(14),
                  letterSpacing: -0.35,
                ),
              ),
              SizedBox(height: ScreenUtil().setSp(180)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "여행사진지도를 이용해주셔서 감사합니다.",
                    style: TextStyle(
                      color: app_font_grey,
                      fontSize: ScreenUtil().setSp(14),
                      letterSpacing: -0.35,
                    ),
                  ),
                ],
              ),
              Spacer(),
              // Mutation(
              //     options: MutationOptions(
              //         document: gql(Mutations.secession),
              //         update: (GraphQLDataProxy proxy, QueryResult result) {},
              //         onCompleted: (dynamic resultData) async {
              //           print("🚨 signout result : $resultData");
              //         }),
              //     builder: (RunMutation runMutation, QueryResult queryResult) {

              // seeValue("customerId").then((customerId) {
              //           runMutation({"customer_id": int.parse(customerId)});
              //         });
              InkWell(
                onTap: () {
                  signOutPopupFirst(context);
                },
                child: Container(
                  width: ScreenUtil().setSp(336),
                  height: ScreenUtil().setSp(50),
                  decoration: BoxDecoration(
                    color: app_blue,
                    borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
                  ),
                  child: Center(
                    child: Text("회원탈퇴",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          letterSpacing: -0.4,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ),
              // }),
              SizedBox(height: ScreenUtil().setSp(14)),
            ],
          ),
        ),
      ),
    );
  }
}
