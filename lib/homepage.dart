import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letsgotrip/View/MainPages/map/map_screen.dart';
import 'package:letsgotrip/View/MainPages/profile/profile_screen.dart';
import 'package:letsgotrip/View/MainPages/store/store_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BottomNavigationBarItem> btmNavItems = [
    BottomNavigationBarItem(
        activeIcon: Image.asset(
          "assets/images/navigation_store.png",
          width: ScreenUtil().setSp(54),
        ),
        icon: Image.asset(
          "assets/images/navigation_store_grey.png",
          width: ScreenUtil().setSp(54),
        )),
    BottomNavigationBarItem(
        activeIcon: Image.asset(
          "assets/images/navigation_location.png",
          width: ScreenUtil().setSp(54),
        ),
        icon: Image.asset(
          "assets/images/navigation_location_grey.png",
          width: ScreenUtil().setSp(54),
        )),
    BottomNavigationBarItem(
        activeIcon: Image.asset(
          "assets/images/navigation_profile.png",
          width: ScreenUtil().setSp(54),
        ),
        icon: Image.asset(
          "assets/images/navigation_profile_grey.png",
          width: ScreenUtil().setSp(54),
        )),
  ];

  int _selectedIndex = 1;

  @override
  void initState() {
    // setState(() {
    //   _selectedIndex = widget.screenNum;
    // });
    super.initState();
  }

  static List<Widget> _screens = <Widget>[
    StoreScreen(),
    MapScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: btmNavItems,
          currentIndex: _selectedIndex,
          onTap: _onBtmItemClick,
          showUnselectedLabels: true,
          elevation: 0,
        ));
  }

  void _onBtmItemClick(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
