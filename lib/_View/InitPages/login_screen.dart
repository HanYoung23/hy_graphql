import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:letsgotrip/_View/InitPages/profile_set_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/constants/keys.dart';
import 'package:letsgotrip/functions/apple_login.dart';
import 'package:letsgotrip/functions/kakao_login.dart';
import 'package:letsgotrip/functions/naver_login.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';

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
              // print("🚨 login result : $resultData");
              if (resultData["createCustomer"]["result"]) {
                String customerId = "${resultData["createCustomer"]["msg2"]}";
                await storeUserData("customerId", customerId);
                String userId = await storage.read(key: "userId");
                String loginType = await storage.read(key: "loginType");
                Get.offAll(() => ProfileSetScreen(
                      userId: userId,
                      loginType: loginType,
                    ));
              } else if (resultData["createCustomer"]["msg"] ==
                  "이미 가입된 아이디입니다.") {
                String customerId = "${resultData["createCustomer"]["msg2"]}";
                await storeUserData("customerId", customerId);
                String userId = await storage.read(key: "userId");
                String loginType = await storage.read(key: "loginType");
                Get.offAll(() => Query(
                    options: QueryOptions(
                      document: gql(Queries.mypage),
                      variables: {"customer_id": int.parse(customerId)},
                    ),
                    builder: (result, {refetch, fetchMore}) {
                      if (!result.isLoading && result.data != null) {
                        Map resultData = result.data["mypage"][0];
                        // print("🚨 mypage result : $resultData");
                        String nickname = resultData["nick_name"];
                        String profilePhotoLink =
                            resultData["profile_photo_link"];

                        return ProfileSetScreen(
                          userId: userId,
                          loginType: loginType,
                          nickname: nickname,
                          photoUrl: profilePhotoLink,
                        );
                      } else {
                        return Container();
                      }
                    }));
              } else {
                Get.snackbar("error", "${resultData["createCustomer"]["msg"]}");
              }
            }),
        builder: (RunMutation runMutation, QueryResult queryResult) {
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
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().screenHeight,
                margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setSp(side_gap),
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
                      child: Text(
                        "SNS와 위치기반을 융합한 여행사진지도",
                        style: TextStyle(
                          fontFamily: "NotoSansCJKkrRegular",
                          fontSize: ScreenUtil().setSp(14),
                          letterSpacing:
                              ScreenUtil().setSp(letter_spacing_small),
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(70)),
                    Padding(
                        padding:
                            EdgeInsets.only(top: ScreenUtil().setHeight(46)),
                        child: Text("SNS 주소로 간편로그인 하기",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrRegular",
                              fontSize: ScreenUtil().setSp(12),
                              letterSpacing:
                                  ScreenUtil().setSp(letter_spacing_small),
                              color: app_grey_login,
                            ))),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        kakaoLogin().then((userId) {
                          if (userId.length > 1) {
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
                        width: ScreenUtil().setSp(305),
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(13),
                            horizontal: ScreenUtil().setSp(16)),
                        margin: EdgeInsets.only(
                            top: ScreenUtil().setHeight(10),
                            bottom: ScreenUtil().setHeight(5)),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(2554, 229, 0, 1),
                            borderRadius:
                                BorderRadius.circular(ScreenUtil().setSp(5))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Container(
                            //   width: ScreenUtil().setSp(19.8),
                            //   height: ScreenUtil().setSp(18.6),
                            //   child: Image.asset(
                            //     "assets/images/kakao_logo.png",
                            //     fit: BoxFit.fill,
                            //   ),
                            // ),
                            Container(
                              width: ScreenUtil().setSp(19.8),
                              height: ScreenUtil().setSp(18.6),
                              child: SvgPicture.asset(
                                "assets/images/kakao_logo.svg",
                                fit: BoxFit.fill,
                              ),
                            ),
                            Text(
                              "카카오 계정으로 로그인",
                              style: TextStyle(
                                fontFamily: "NotoSansCJKkrRegular",
                                fontSize: ScreenUtil().setSp(16),
                                color: Color.fromRGBO(25, 25, 25, 1),
                              ),
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
                        width: ScreenUtil().setSp(305),
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(13),
                            horizontal: ScreenUtil().setSp(16)),
                        margin: EdgeInsets.only(
                            top: ScreenUtil().setHeight(12),
                            bottom: ScreenUtil().setHeight(5)),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(3, 199, 90, 1),
                            borderRadius:
                                BorderRadius.circular(ScreenUtil().setSp(5))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Container(
                            //   width: ScreenUtil().setSp(19.8),
                            //   height: ScreenUtil().setSp(18.6),
                            //   child: Image.asset(
                            //     "assets/images/naver_logo.png",
                            //     fit: BoxFit.fill,
                            //   ),
                            // ),
                            Container(
                              width: ScreenUtil().setSp(19.8),
                              height: ScreenUtil().setSp(18.6),
                              child: SvgPicture.asset(
                                "assets/images/naver_logo.svg",
                                fit: BoxFit.fill,
                              ),
                            ),
                            Text(
                              "네이버 계정으로 로그인",
                              style: TextStyle(
                                fontFamily: "NotoSansCJKkrRegular",
                                fontSize: ScreenUtil().setSp(16),
                                color: Colors.white,
                              ),
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
                        if (!Platform.isAndroid) {
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
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                '서비스 준비 중 입니다.',
                                style: TextStyle(
                                  fontFamily: "NotoSansCJKkrRegular",
                                  fontSize: ScreenUtil().setSp(14),
                                  letterSpacing:
                                      ScreenUtil().setSp(letter_spacing_small),
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              elevation: 0,
                              duration: Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setSp(50)),
                              ),
                              backgroundColor: Color(0xffb5b5b5),
                              margin: EdgeInsets.only(
                                  bottom: ScreenUtil().setSp(90),
                                  left: ScreenUtil().setSp(80),
                                  right: ScreenUtil().setSp(80))));
                        }
                      },
                      child: Container(
                        width: ScreenUtil().setSp(305),
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(13),
                            horizontal: ScreenUtil().setSp(16)),
                        margin: EdgeInsets.only(
                            top: ScreenUtil().setHeight(10),
                            bottom: ScreenUtil().setHeight(5)),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.circular(ScreenUtil().setSp(5))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Container(
                            //   width: ScreenUtil().setSp(19.8),
                            //   height: ScreenUtil().setSp(18.6),
                            //   child: Image.asset(
                            //     "assets/images/apple_logo.png",
                            //     fit: BoxFit.fill,
                            //   ),
                            // ),
                            Container(
                              width: ScreenUtil().setSp(19.8),
                              height: ScreenUtil().setSp(22.4),
                              child: SvgPicture.asset(
                                "assets/images/apple_logo.svg",
                                fit: BoxFit.fill,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Apple로 로그인",
                              style: TextStyle(
                                fontFamily: "NotoSansCJKkrRegular",
                                fontSize: ScreenUtil().setSp(16),
                                color: Colors.white,
                              ),
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
