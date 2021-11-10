import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_View/MainPages/map/map_post_creation_screen.dart';
import 'package:letsgotrip/_View/MainPages/settings/announce_screen.dart';
import 'package:letsgotrip/_View/MainPages/settings/notification_screen.dart';
import 'package:letsgotrip/_View/MainPages/settings/settings_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/channeltalk_bottom_sheet.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';

class MenuDrawer extends StatelessWidget {
  final int customerId;
  const MenuDrawer({Key key, @required this.customerId}) : super(key: key);

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
                        String loginType = await storage.read(key: "loginType");
                        Get.to(() => SettingsScreen(
                            customerId: customerId, loginType: loginType));
                      },
                      child: Image.asset(
                        "assets/images/settings/settings_button.png",
                        width: ScreenUtil().setSp(28),
                        height: ScreenUtil().setSp(28),
                      ),
                    ),
                    Spacer(),
                    Query(
                        options: QueryOptions(
                          document: gql(Queries.checkList),
                          variables: {"customer_id": customerId},
                        ),
                        builder: (result, {refetch, fetchMore}) {
                          if (!result.isLoading && result.data != null) {
                            print(
                                "🧾 settings result : ${result.data["check_list"]}");
                            List resultData = result.data["check_list"];
                            bool isNewNoti = false;

                            for (Map checkListMap in resultData) {
                              if (checkListMap["check"] == 1) {
                                isNewNoti = true;
                              }
                            }
                            return InkWell(
                              onTap: () {
                                Get.to(() => NotificationScreen(
                                    checkList: resultData,
                                    refetchCallback: () => refetch()));
                              },
                              child: Image.asset(
                                !isNewNoti
                                    ? "assets/images/settings/alarm_button.png"
                                    : "assets/images/settings/alarm_button_active.png",
                                width: !isNewNoti
                                    ? ScreenUtil().setSp(22)
                                    : ScreenUtil().setSp(28),
                                height: !isNewNoti
                                    ? ScreenUtil().setSp(22)
                                    : ScreenUtil().setSp(28),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ],
                ),
                SizedBox(height: ScreenUtil().setSp(20)),
                Query(
                    options: QueryOptions(
                      document: gql(Queries.mypage),
                      variables: {"customer_id": customerId},
                    ),
                    builder: (result, {refetch, fetchMore}) {
                      if (!result.isLoading && result.data != null) {
                        // print("🚨 mypage query : $result");
                        Map resultData = result.data["mypage"][0];
                        String nickname = resultData["nick_name"];
                        String profilePhotoLink =
                            resultData["profile_photo_link"];
                        // int language = resultData["language"];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: ScreenUtil().setSp(52),
                              height: ScreenUtil().setSp(52),
                              decoration: profilePhotoLink == null
                                  ? BoxDecoration(
                                      color: app_grey_dark,
                                      border: Border.all(
                                          width: ScreenUtil().setSp(0.5)),
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setSp(100)),
                                    )
                                  : BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(profilePhotoLink),
                                          fit: BoxFit.cover),
                                      border: Border.all(
                                          width: ScreenUtil().setSp(0.5)),
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setSp(100)),
                                    ),
                            ),
                            SizedBox(height: ScreenUtil().setSp(8)),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    nickname,
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
                          ],
                        );
                      } else {
                        return Container();
                      }
                    }),
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
                    InkWell(
                      onTap: () {
                        Get.to(() => MapPostCreationScreen());
                      },
                      child: Container(
                        width: ScreenUtil().screenWidth,
                        height: ScreenUtil().setSp(48),
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          "assets/images/settings/post_text.png",
                          width: ScreenUtil().setSp(44),
                          height: ScreenUtil().setSp(24),
                        ),
                      ),
                    ),
                    // InkWell(
                    //   onTap:(){
                    //     Get.to(()=>PostPromotionScreen());
                    //   },
                    //   child: Container(
                    //     width: ScreenUtil().screenWidth,
                    //     height: ScreenUtil().setSp(48),
                    //     alignment: Alignment.centerLeft,
                    //     child: Image.asset(
                    //       "assets/images/settings/post_enterprise_text.png",
                    //       width: ScreenUtil().setSp(104),
                    //       height: ScreenUtil().setSp(24),
                    //     ),
                    //   ),
                    // ),
                    Query(
                        options: QueryOptions(
                          document: gql(Queries.checkList),
                          variables: {"customer_id": customerId},
                        ),
                        builder: (result, {refetch, fetchMore}) {
                          if (!result.isLoading && result.data != null) {
                            // print("🧾 settings result : $result");
                            List resultData = result.data["check_list"];
                            bool isNewNoti = false;

                            for (Map checkListMap in resultData) {
                              if (checkListMap["check"] == 1 &&
                                  checkListMap["type"] == "notice") {
                                isNewNoti = true;
                              }
                            }
                            return InkWell(
                              onTap: () {
                                Get.to(() => AnnounceScreen(
                                      customerId: customerId,
                                      refetchCallback: () => refetch(),
                                    ));
                              },
                              child: Container(
                                width: ScreenUtil().screenWidth,
                                height: ScreenUtil().setSp(48),
                                alignment: Alignment.centerLeft,
                                child: Image.asset(
                                  !isNewNoti
                                      ? "assets/images/settings/notification_text.png"
                                      : "assets/images/settings/notification_text_active.png",
                                  width: !isNewNoti
                                      ? ScreenUtil().setSp(56)
                                      : ScreenUtil().setSp(70),
                                  height: ScreenUtil().setSp(24),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            enableDrag: false,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (_) => ChanneltalkBottomSheet(),
                            isScrollControlled: true);
                      },
                      child: Container(
                        width: ScreenUtil().screenWidth,
                        height: ScreenUtil().setSp(48),
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          "assets/images/settings/counsel_text.png",
                          width: ScreenUtil().setSp(82),
                          height: ScreenUtil().setSp(24),
                        ),
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

// Query(
//                   options: QueryOptions(
//           document: gql(Queries.login),
//           variables: {
            
//           },
//         ),
//                   builder: (result, {refetch, fetchMore}) {
//           if (!result.isLoading && result.data != null) {}}
//                   ),