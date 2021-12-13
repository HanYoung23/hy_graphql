import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_View/MainPages/settings/service_policy_screen.dart';
import 'package:letsgotrip/_View/MainPages/settings/signout_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/functions/device_info.dart';
import 'package:letsgotrip/functions/material_popup.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';

class SettingsScreen extends StatefulWidget {
  final int customerId;
  final String loginType;

  const SettingsScreen(
      {Key key, @required this.customerId, @required this.loginType})
      : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String appVersion;
  String appOs;

  @override
  void initState() {
    getDeviceInfo().then((value) {
      appOs = value["osName"];
      appVersion = value["appVersion"];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ScreenUtil().setSp(20)),
              Container(
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().setSp(44),
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
                                height: ScreenUtil().setSp(arrow_back_size))),
                      ),
                    ),
                    Text(
                      "설정",
                      style: TextStyle(
                          fontFamily: "NotoSansCJKkrBold",
                          fontSize: ScreenUtil().setSp(appbar_title_size),
                          letterSpacing:
                              ScreenUtil().setSp(letter_spacing_small)),
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
              SizedBox(height: ScreenUtil().setSp(20)),
              Text("기타",
                  style: TextStyle(
                    fontFamily: "NotoSansCJKkrBold",
                    fontSize: ScreenUtil().setSp(14),
                    letterSpacing: ScreenUtil().setSp(letter_spacing_small),
                  )),
              SizedBox(height: ScreenUtil().setSp(10)),
              InkWell(
                onTap: () {
                  Get.to(() => ServicePolicyScreen());
                },
                child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: ScreenUtil().setSp(16)),
                    child: Text("이용약관 및 정책",
                        style: TextStyle(
                          fontFamily: "NotoSansCJKkrRegular",
                          fontSize: ScreenUtil().setSp(16),
                          letterSpacing: ScreenUtil().setSp(letter_spacing),
                        ))),
              ),
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: ScreenUtil().setSp(16)),
                    child: Text("언어 설정",
                        style: TextStyle(
                          fontFamily: "NotoSansCJKkrRegular",
                          fontSize: ScreenUtil().setSp(16),
                          letterSpacing: ScreenUtil().setSp(letter_spacing),
                        )),
                  ),
                  Spacer(),
                  Text(
                    "한국어",
                    style: TextStyle(
                      fontFamily: "NotoSansCJKkrRegular",
                      fontSize: ScreenUtil().setSp(16),
                      letterSpacing: ScreenUtil().setSp(letter_spacing),
                      color: app_blue,
                    ),
                  )
                ],
              ),
              Query(
                  options: QueryOptions(
                    document: gql(Queries.versionCheck),
                    variables: {},
                  ),
                  builder: (result, {refetch, fetchMore}) {
                    if (!result.isLoading && result.data != null) {
                      // print(
                      //     "🚨 version result : ${result.data["version_check"]}");
                      Map resultData = result.data["version_check"][0];
                      String queryVersion = resultData["$appOs"];

                      return Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setSp(16)),
                            child: Text("버전정보",
                                style: TextStyle(
                                  fontFamily: "NotoSansCJKkrRegular",
                                  fontSize: ScreenUtil().setSp(16),
                                  letterSpacing:
                                      ScreenUtil().setSp(letter_spacing),
                                )),
                          ),
                          Spacer(),
                          appVersion != queryVersion
                              ? Container(
                                  width: ScreenUtil().setSp(130),
                                  height: ScreenUtil().setSp(32),
                                  decoration: BoxDecoration(
                                    color: app_blue,
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setSp(100)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text("새로운 버전이 있습니다",
                                      style: TextStyle(
                                          fontFamily: "NotoSansCJKkrBold",
                                          fontSize: ScreenUtil().setSp(12),
                                          letterSpacing: ScreenUtil()
                                              .setSp(letter_spacing_x_small),
                                          color: Colors.white)),
                                )
                              : Container(),
                          SizedBox(width: ScreenUtil().setSp(10)),
                          Text(
                            appVersion != null ? "$appVersion" : "",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrRegular",
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing: ScreenUtil().setSp(letter_spacing),
                              color: app_blue,
                            ),
                          )
                        ],
                      );
                    } else {
                      return Container();
                    }
                  }),
              InkWell(
                onTap: () {
                  logOutPopup(context);
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: ScreenUtil().setSp(16)),
                  child: Text("로그아웃",
                      style: TextStyle(
                        fontFamily: "NotoSansCJKkrRegular",
                        fontSize: ScreenUtil().setSp(16),
                        letterSpacing: ScreenUtil().setSp(letter_spacing),
                      )),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => SignOutScreen());
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: ScreenUtil().setSp(16)),
                  child: Text("회원탈퇴",
                      style: TextStyle(
                        fontFamily: "NotoSansCJKkrRegular",
                        fontSize: ScreenUtil().setSp(16),
                        letterSpacing: ScreenUtil().setSp(letter_spacing),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
