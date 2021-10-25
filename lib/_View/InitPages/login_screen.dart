import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:letsgotrip/_View/InitPages/profile_set_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/constants/keys.dart';
import 'package:letsgotrip/functions/apple_login.dart';
import 'package:letsgotrip/functions/kakao_login.dart';
import 'package:letsgotrip/functions/naver_login.dart';
import 'package:letsgotrip/homepage.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key key,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String loginId;
  String loginType;

  @override
  void initState() {
    KakaoContext.clientId = "$kakaoAppKey";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
            document: gql(Mutations.createCustomer),
            update: (GraphQLDataProxy proxy, QueryResult result) {},
            onCompleted: (dynamic resultData) async {
              print("🚨 login result : $resultData");
              if (resultData["createCustomer"]["result"]) {
                String customerId = "${resultData["createCustomer"]["msg2"]}";
                await storeUserData("customerId", customerId);
                String userId = await storage.read(key: "userId");
                String loginType = await storage.read(key: "loginType");
                Get.to(() =>
                    ProfileSetScreen(userId: userId, loginType: loginType));
              } else if (resultData["createCustomer"]["msg"] ==
                  "이미 가입된 아이디입니다.") {
                String customerId = "${resultData["createCustomer"]["msg2"]}";
                await storeUserData("customerId", customerId);
                // String userId = await storage.read(key: "userId");
                // String loginType = await storage.read(key: "loginType");
                // Get.to(() =>
                //     ProfileSetScreen(userId: userId, loginType: loginType));
                Get.to(() => HomePage());
              } else {
                Get.snackbar("error", "${resultData["createCustomer"]["msg"]}");
              }
            }),
        builder: (RunMutation runMutation, QueryResult queryResult) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(common_side_gap),
                    vertical: ScreenUtil().setHeight(94)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                        image: AssetImage("assets/images/logo_mark.png"),
                        width: ScreenUtil().setSp(27),
                        height: ScreenUtil().setSp(36)),
                    Image(
                        image: AssetImage("assets/images/logo_text.png"),
                        width: ScreenUtil().setSp(300),
                        height: ScreenUtil().setSp(42)),
                    Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(18)),
                      child: Image(
                          image:
                              AssetImage("assets/images/logo_under_text.png"),
                          width: ScreenUtil().setSp(222),
                          height: ScreenUtil().setSp(20)),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(70)),
                    Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(46)),
                      child: Image(
                          image: AssetImage("assets/images/sns_login_text.png"),
                          width: ScreenUtil().setSp(255),
                          height: ScreenUtil().setSp(18)),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        kakaoLogin().then((userId) {
                          if (userId != null) {
                            setState(() {
                              loginType = "kakao";
                            });
                            runMutation({
                              "login_link": "$userId",
                              "login_type": "kakao",
                            });
                          } else {
                            print("🚨 login canceled");
                          }
                        });
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(305),
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(13),
                            horizontal: ScreenUtil().setWidth(16)),
                        margin: EdgeInsets.only(
                            top: ScreenUtil().setHeight(10),
                            bottom: ScreenUtil().setHeight(5)),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(2554, 229, 0, 1),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: ScreenUtil().setSp(19.8),
                              height: ScreenUtil().setSp(18.6),
                              child:
                                  Image.asset("assets/images/kakao_logo.png"),
                            ),
                            Text(
                              "카카오 계정으로 로그인",
                              style:
                                  TextStyle(fontSize: ScreenUtil().setSp(16)),
                            ),
                            Container(
                              width: ScreenUtil().setSp(19.8),
                              height: ScreenUtil().setSp(18.6),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        naverLogin().then((userId) {
                          print("🐸 userId : $userId");
                          if (userId.length > 1) {
                            setState(() {
                              loginType = "naver";
                            });
                            runMutation({
                              "login_link": "$userId",
                              "login_type": "naver",
                            });
                          } else {
                            print("🚨 login canceled");
                          }
                        });
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(305),
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(13),
                            horizontal: ScreenUtil().setWidth(16)),
                        margin: EdgeInsets.only(
                            top: ScreenUtil().setHeight(12),
                            bottom: ScreenUtil().setHeight(5)),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(3, 199, 90, 1),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: ScreenUtil().setSp(19.8),
                              height: ScreenUtil().setSp(18.6),
                              child:
                                  Image.asset("assets/images/naver_logo.png"),
                            ),
                            Text(
                              "네이버 계정으로 로그인",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(16),
                                  color: Colors.white),
                            ),
                            Container(
                              width: ScreenUtil().setSp(19.8),
                              height: ScreenUtil().setSp(18.6),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        appleLogin(context).then((userId) {
                          if (userId != null) {
                            setState(() {
                              loginType = "apple";
                            });
                            runMutation({
                              "login_link": "$userId",
                              "login_type": "apple",
                            });
                          } else {
                            print("🚨 login canceled");
                          }
                        });
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(305),
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(13),
                            horizontal: ScreenUtil().setWidth(16)),
                        margin: EdgeInsets.only(
                            top: ScreenUtil().setHeight(10),
                            bottom: ScreenUtil().setHeight(5)),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: ScreenUtil().setSp(19.8),
                              height: ScreenUtil().setSp(18.6),
                              child:
                                  Image.asset("assets/images/apple_logo.png"),
                            ),
                            Text(
                              "애플 계정으로 로그인",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(16),
                                  color: Colors.white),
                            ),
                            Container(
                              width: ScreenUtil().setSp(19.8),
                              height: ScreenUtil().setSp(18.6),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
