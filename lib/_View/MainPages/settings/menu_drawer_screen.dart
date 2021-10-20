import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/_View/MainPages/settings/settings_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/storage/storage.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(ScreenUtil().setSp(20)),
            width: ScreenUtil().screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Image.asset(
                        "assets/images/settings/close_button.png",
                        width: ScreenUtil().setSp(28),
                        height: ScreenUtil().setSp(28),
                      ),
                    ),
                    SizedBox(width: ScreenUtil().setSp(10)),
                    InkWell(
                      onTap: () async {
                        String customerId =
                            await storage.read(key: "customerId");
                        String loginType = await storage.read(key: "loginType");
                        Get.to(() => SettingsScreen(
                            customerId: int.parse(customerId),
                            loginType: loginType));
                      },
                      child: Image.asset(
                        "assets/images/settings/settings_button.png",
                        width: ScreenUtil().setSp(28),
                        height: ScreenUtil().setSp(28),
                      ),
                    ),
                    Spacer(),
                    Image.asset(
                      "assets/images/settings/alarm_button.png",
                      width: ScreenUtil().setSp(22),
                      height: ScreenUtil().setSp(22),
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setSp(20)),
                Container(
                  width: ScreenUtil().setSp(52),
                  height: ScreenUtil().setSp(52),
                  decoration: BoxDecoration(
                      color: app_grey_dark,
                      border: Border.all(width: ScreenUtil().setSp(0.5)),
                      borderRadius: BorderRadius.circular(50)),
                ),
                SizedBox(height: ScreenUtil().setSp(8)),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        "nickname",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(18),
                            letterSpacing: -0.45,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: ScreenUtil().setSp(2)),
                    Text(
                      "님",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          letterSpacing: -0.35),
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setSp(4)),
                Image.asset(
                  "assets/images/settings/welcome_text.png",
                  width: ScreenUtil().setSp(128),
                  height: ScreenUtil().setSp(20),
                )
              ],
            ),
          ),
          Container(
            color: app_grey_light,
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().setSp(10),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                width: ScreenUtil().screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: ScreenUtil().screenWidth,
                      height: ScreenUtil().setSp(48),
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        "assets/images/settings/post_text.png",
                        width: ScreenUtil().setSp(44),
                        height: ScreenUtil().setSp(24),
                      ),
                    ),
                    // SizedBox(height: ScreenUtil().setSp(24)),
                    Container(
                      width: ScreenUtil().screenWidth,
                      height: ScreenUtil().setSp(48),
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        "assets/images/settings/post_enterprise_text.png",
                        width: ScreenUtil().setSp(104),
                        height: ScreenUtil().setSp(24),
                      ),
                    ),
                    // SizedBox(height: ScreenUtil().setSp(24)),
                    Container(
                      width: ScreenUtil().screenWidth,
                      height: ScreenUtil().setSp(48),
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        "assets/images/settings/notification_text.png",
                        width: ScreenUtil().setSp(56),
                        height: ScreenUtil().setSp(24),
                      ),
                    ),
                    // SizedBox(height: ScreenUtil().setSp(24)),
                    Container(
                      width: ScreenUtil().screenWidth,
                      height: ScreenUtil().setSp(48),
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        "assets/images/settings/counsel_text.png",
                        width: ScreenUtil().setSp(82),
                        height: ScreenUtil().setSp(24),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
            color: app_grey_light,
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().setSp(10),
          ),
        ],
      ),
    );
  }
}
