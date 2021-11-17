import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/_Controller/floating_button_controller.dart';
import 'package:letsgotrip/_View/MainPages/map/map_screen.dart';
import 'package:letsgotrip/_View/MainPages/profile/profile_screen.dart';
import 'package:letsgotrip/_View/MainPages/store/store_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FloatingButtonController floatingBtn;

  List<BottomNavigationBarItem> btmNavItems = [
    BottomNavigationBarItem(
      activeIcon: Image.asset(
        "assets/images/nav_store.png",
        width: ScreenUtil().setSp(30),
        height: ScreenUtil().setSp(30),
      ),
      icon: Image.asset(
        "assets/images/nav_store_grey.png",
        width: ScreenUtil().setSp(30),
        height: ScreenUtil().setSp(30),
      ),
      label: "스토어",
    ),
    BottomNavigationBarItem(
        activeIcon: Image.asset(
          "assets/images/nav_location.png",
          width: ScreenUtil().setSp(30),
          height: ScreenUtil().setSp(30),
        ),
        icon: Image.asset(
          "assets/images/nav_location_grey.png",
          width: ScreenUtil().setSp(30),
          height: ScreenUtil().setSp(30),
        ),
        label: "장소"),
    BottomNavigationBarItem(
        activeIcon: Image.asset(
          "assets/images/nav_profile.png",
          width: ScreenUtil().setSp(30),
          height: ScreenUtil().setSp(30),
        ),
        icon: Image.asset(
          "assets/images/nav_profile_grey.png",
          width: ScreenUtil().setSp(30),
          height: ScreenUtil().setSp(30),
        ),
        label: "마이페이지"),
  ];

  int _selectedIndex = 1;

  @override
  void initState() {
    if (Get.arguments == 0 || Get.arguments == 2) {
      setState(() {
        _selectedIndex = Get.arguments;
      });
    }
    Get.lazyPut(() => FloatingButtonController());
    floatingBtn = Get.find();

    super.initState();
  }

  static List<Widget> _screens = <Widget>[
    StoreScreen(),
    MapScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: Obx(
          () {
            return Scaffold(
                appBar: AppBar(
                  toolbarHeight: 0,
                  elevation: 0,
                  backgroundColor: floatingBtn.isFilterActive.value ||
                          floatingBtn.isAddActive.value
                      ? Colors.black.withOpacity(0.7)
                      : Colors.white,
                  brightness: floatingBtn.isFilterActive.value ||
                          floatingBtn.isAddActive.value
                      ? Brightness.dark
                      : Brightness.light,
                ),
                body: IndexedStack(
                  index: _selectedIndex,
                  children: _screens,
                ),
                bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: floatingBtn.isFilterActive.value ||
                          floatingBtn.isAddActive.value
                      ? Colors.black.withOpacity(0.7)
                      : Colors.white,
                  type: BottomNavigationBarType.fixed,
                  fixedColor: floatingBtn.isFilterActive.value ||
                          floatingBtn.isAddActive.value
                      ? app_blue.withOpacity(0.3)
                      : app_blue,
                  items: [
                    BottomNavigationBarItem(
                      activeIcon: Image.asset(
                        "assets/images/nav_store.png",
                        width: ScreenUtil().setSp(30),
                        height: ScreenUtil().setSp(30),
                      ),
                      icon: Image.asset(
                        "assets/images/nav_store_grey.png",
                        width: ScreenUtil().setSp(30),
                        height: ScreenUtil().setSp(30),
                        color: floatingBtn.isFilterActive.value ||
                                floatingBtn.isAddActive.value
                            ? Colors.black.withOpacity(0.7)
                            : Colors.grey,
                      ),
                      label: "스토어",
                    ),
                    BottomNavigationBarItem(
                        activeIcon: Image.asset(
                          "assets/images/nav_location.png",
                          width: ScreenUtil().setSp(30),
                          height: ScreenUtil().setSp(30),
                          color: floatingBtn.isFilterActive.value ||
                                  floatingBtn.isAddActive.value
                              ? app_blue.withOpacity(0.3)
                              : app_blue,
                        ),
                        icon: Image.asset(
                          "assets/images/nav_location_grey.png",
                          width: ScreenUtil().setSp(30),
                          height: ScreenUtil().setSp(30),
                        ),
                        label: "장소"),
                    BottomNavigationBarItem(
                        activeIcon: Image.asset(
                          "assets/images/nav_profile.png",
                          width: ScreenUtil().setSp(30),
                          height: ScreenUtil().setSp(30),
                        ),
                        icon: Image.asset(
                          "assets/images/nav_profile_grey.png",
                          width: ScreenUtil().setSp(30),
                          height: ScreenUtil().setSp(30),
                          color: floatingBtn.isFilterActive.value ||
                                  floatingBtn.isAddActive.value
                              ? Colors.black.withOpacity(0.7)
                              : Colors.grey,
                        ),
                        label: "마이페이지"),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: floatingBtn.isFilterActive.value ||
                          floatingBtn.isAddActive.value
                      ? null
                      : _onBtmItemClick,
                  showSelectedLabels: true,
                  elevation: 0,
                  selectedLabelStyle: TextStyle(
                    fontFamily: "NotoSansCJKkrMedium",
                    fontSize: ScreenUtil().setSp(10),
                    letterSpacing: ScreenUtil().setSp(-0.25),
                    color: Colors.red,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontFamily: "NotoSansCJKkrMedium",
                    fontSize: ScreenUtil().setSp(10),
                    letterSpacing: ScreenUtil().setSp(-0.25),
                  ),
                ));
          },
        ));
  }

  void _onBtmItemClick(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
