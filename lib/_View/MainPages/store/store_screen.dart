import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letsgotrip/_View/MainPages/settings/store_menu_drawer_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/storage/storage.dart';

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
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isDrawerOpen = true;
                                  });
                                },
                                child: Image.asset(
                                    "assets/images/hamburger_button.png",
                                    width: ScreenUtil().setSp(28),
                                    height: ScreenUtil().setSp(28))),
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
                    onHorizontalDragStart: (_) {
                      closeCallback();
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
