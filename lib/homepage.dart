import 'package:flowing/constants/common_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screen_util.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BottomNavigationBarItem> btmNavItems = [
    BottomNavigationBarItem(
        activeIcon: SvgPicture.asset(
          "assets/images/home_filled.svg",
          width: ScreenUtil().setSp(40),
        ),
        icon: SvgPicture.asset(
          "assets/images/home.svg",
          color: flowing_grey,
          width: ScreenUtil().setSp(40),
        ),
        label: ("홈")),
    BottomNavigationBarItem(
        activeIcon: SvgPicture.asset(
          "assets/images/search.svg",
          color: flowing_color,
          width: ScreenUtil().setSp(40),
        ),
        icon: SvgPicture.asset(
          "assets/images/search.svg",
          color: flowing_grey,
          width: ScreenUtil().setSp(40),
        ),
        label: ("검색")),
    BottomNavigationBarItem(
        activeIcon: SvgPicture.asset(
          "assets/images/basket_filled.svg",
          width: ScreenUtil().setSp(40),
        ),
        icon: SvgPicture.asset(
          "assets/images/basket.svg",
          color: flowing_grey,
          width: ScreenUtil().setSp(40),
        ),
        label: ("장바구니")),
    BottomNavigationBarItem(
        activeIcon: SvgPicture.asset(
          "assets/images/profile_filled.svg",
          width: ScreenUtil().setSp(40),
        ),
        icon: SvgPicture.asset(
          "assets/images/profile.svg",
          color: flowing_grey,
          width: ScreenUtil().setSp(40),
        ),
        label: ("마이페이지")),
  ];

  int _selectedIndex = 0;

  @override
  void initState() {
    setState(() {
      _selectedIndex = widget.screenNum;
    });
    super.initState();
  }

  static List<Widget> _screens = <Widget>[
    MainScreen(),
    SearchScreen(),
    CartScreen(),
    ProfileScreen(),
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
          unselectedItemColor: Colors.black26,
          selectedItemColor: flowing_color,
          selectedFontSize: ScreenUtil().setSp(font_xxs),
          unselectedFontSize: ScreenUtil().setSp(font_xxs),
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
