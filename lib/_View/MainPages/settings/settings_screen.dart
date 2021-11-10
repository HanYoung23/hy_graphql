import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
          margin: EdgeInsets.only(top: ScreenUtil().setSp(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: ScreenUtil().setWidth(375),
                height: ScreenUtil().setHeight(44),
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
                          fontSize: ScreenUtil().setSp(appbar_title_size),
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.35),
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
              Container(
                padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(16)),
                child: Image.asset("assets/images/settings/policy_text.png",
                    width: ScreenUtil().setSp(108),
                    height: ScreenUtil().setSp(24)),
              ),
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: ScreenUtil().setSp(16)),
                    child: Image.asset(
                        "assets/images/settings/language_text.png",
                        width: ScreenUtil().setSp(62),
                        height: ScreenUtil().setSp(24)),
                  ),
                  Spacer(),
                  Text(
                    "한국어",
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      letterSpacing: -0.4,
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
                            child: Image.asset(
                                "assets/images/settings/version_text.png",
                                width: ScreenUtil().setSp(58),
                                height: ScreenUtil().setSp(24)),
                          ),
                          Spacer(),
                          appVersion != queryVersion
                              ? Image.asset(
                                  "assets/images/settings/new_version_text.png",
                                  width: ScreenUtil().setSp(130),
                                  height: ScreenUtil().setSp(32))
                              : Container(),
                          SizedBox(width: ScreenUtil().setSp(10)),
                          Text(
                            appVersion != null ? "$appVersion" : "",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing: -0.4,
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
                  child: Image.asset("assets/images/settings/logout_text.png",
                      width: ScreenUtil().setSp(58),
                      height: ScreenUtil().setSp(24)),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => SignOutScreen());
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: ScreenUtil().setSp(16)),
                  child: Image.asset("assets/images/settings/signout_text.png",
                      width: ScreenUtil().setSp(58),
                      height: ScreenUtil().setSp(24)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
