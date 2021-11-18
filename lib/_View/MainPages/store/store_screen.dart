import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_Controller/notification_controller.dart';
import 'package:letsgotrip/_View/MainPages/settings/store_menu_drawer_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({
    Key key,
  }) : super(key: key);

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  int customerId;
  bool isDrawerOpen = false;
  NotificationContoller notificationContoller =
      Get.put(NotificationContoller());
  NotificationContoller globalNotification = Get.find();

  closeCallback() {
    setState(() {
      isDrawerOpen = false;
    });
  }

  @override
  void initState() {
    seeValue("customerId").then((value) {
      setState(() {
        customerId = int.parse(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: GestureDetector(
              onTap: () {
                if (isDrawerOpen) {
                  closeCallback();
                }
              },
              child: Container(
                color: Colors.white,
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().screenHeight,
                child: Column(
                  children: [
                    SizedBox(height: ScreenUtil().setSp(20)),
                    Container(
                      width: ScreenUtil().screenWidth,
                      height: ScreenUtil().setSp(44),
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setSp(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Query(
                                options: QueryOptions(
                                  document: gql(Queries.checkList),
                                  variables: {"customer_id": customerId},
                                ),
                                builder: (result, {refetch, fetchMore}) {
                                  if (!result.isLoading &&
                                      result.data != null) {
                                    // print(
                                    //     "🧾 settings result : ${result.data["check_list"]}");
                                    List resultData = result.data["check_list"];
                                    bool isNoti = false;
                                    for (Map checkListMap in resultData) {
                                      if (checkListMap["check"] == 1) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) =>
                                                notificationContoller
                                                    .updateIsNotification(
                                                        true));
                                        isNoti = true;
                                      }
                                    }
                                    if (!isNoti) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) =>
                                              notificationContoller
                                                  .updateIsNotification(false));
                                    }

                                    // Timer(Duration(seconds: 2), () {
                                    //   refetch();
                                    // });

                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          isDrawerOpen = true;
                                        });
                                      },
                                      child: Obx(() => Image.asset(
                                          !globalNotification
                                                  .isNotification.value
                                              ? "assets/images/hamburger_button.png"
                                              : "assets/images/hamburger_button_active.png",
                                          width: ScreenUtil().setSp(28),
                                          height: ScreenUtil().setSp(28))),
                                    );
                                  } else {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          isDrawerOpen = true;
                                        });
                                      },
                                      child: Image.asset(
                                          "assets/images/hamburger_button.png",
                                          width: ScreenUtil().setSp(28),
                                          height: ScreenUtil().setSp(28)),
                                    );
                                  }
                                }),
                          ),
                          Text(
                            "스토어",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrBold",
                              fontSize: ScreenUtil().setSp(appbar_title_size),
                              letterSpacing: ScreenUtil().setSp(letter_spacing),
                            ),
                          ),
                          Image.asset(
                            "assets/images/hamburger_button.png",
                            width: ScreenUtil().setSp(28),
                            height: ScreenUtil().setSp(28),
                            color: Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "서비스 오픈 전 입니다\n좋은 서비스로 찾아오겠습니다 :)",
                          style: TextStyle(
                            fontFamily: "NotoSansCJKkrRegular",
                            color: app_font_grey,
                            fontSize: ScreenUtil().setSp(16),
                            letterSpacing: ScreenUtil().setSp(letter_spacing),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              child: Visibility(
                  visible: isDrawerOpen,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      // print("🚨 details: $details");
                      if (details.delta.dx > 0) {}
                      if (details.delta.dx < -5) {
                        closeCallback();
                      }
                    },
                    child: StoreMenuDrawer(
                        customerId: customerId,
                        closeCallback: () => closeCallback()),
                  )))
        ],
      ),
    );
  }
}
