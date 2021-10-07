import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_Controller/google_map_whole_controller.dart';
import 'package:letsgotrip/_View/MainPages/map/map_screen.dart';
import 'package:letsgotrip/_View/MainPages/profile/profile_screen.dart';
import 'package:letsgotrip/_View/MainPages/store/store_screen.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';
import 'package:letsgotrip/widgets/map_helper.dart';
import 'package:letsgotrip/widgets/map_marker.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        label: "스토어"),
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
    super.initState();
  }

  static List<Widget> _screens = <Widget>[
    StoreScreen(),
    MapScreen(),
    ProfileScreen(),
  ];

  final GoogleMapWholeController gmWholeController =
      Get.put(GoogleMapWholeController());

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(Queries.photoListMap),
          variables: {
            "latitude1": "-87.71179927260242",
            "latitude2": "89.45016124669523",
            "longitude1": "-180",
            "longitude2": "180",
          },
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading) {
            List<MapMarker> markers = [];
            List<String> markerImages = [];

            for (Map resultData in result.data["photo_list_map"]) {
              int markerId = int.parse("${resultData["contents_id"]}");
              double markerLat = double.parse("${resultData["latitude"]}");
              double markerLng = double.parse("${resultData["longitude"]}");
              String imageUrl = "${resultData["image_link"]}";
              List<String> imageList = imageUrl.split(",");
              markerImages.add("${imageList[0]}");

              MapHelper.getMarkerImageFromUrl("${imageList[0]}")
                  .then((markerImage) {
                markers.add(
                  MapMarker(
                    id: "$markerId",
                    position: LatLng(markerLat, markerLng),
                    icon: markerImage,
                  ),
                );
              });
            }
            gmWholeController.addMapMarkers(markers);
          }
          return Scaffold(
              backgroundColor: Colors.white,
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
        });
  }

  void _onBtmItemClick(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
