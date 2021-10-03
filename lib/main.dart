import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_Controller/google_map_whole_controller.dart';
import 'package:letsgotrip/_View/InitPages/authority_screen.dart';
import 'package:letsgotrip/_View/InitPages/login_screen.dart';
import 'package:letsgotrip/_View/InitPages/walkthrough_screen.dart';
import 'package:letsgotrip/homepage.dart';
import 'package:letsgotrip/widgets/graphql_config.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';
import 'package:letsgotrip/widgets/map_helper.dart';
import 'package:letsgotrip/widgets/map_marker.dart';

void main() {
  runApp(GraphQLProvider(
    client: GraphQlConfig.initClient(),
    child: GetMaterialApp(
        builder: (context, child) {
          return MediaQuery(
            child: child,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        }, // text size fix
        localizationsDelegates: [
          //  LocalizationsDelegateClass(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ], // for datepicker korean
        supportedLocales: [
          const Locale('ko', 'KO'),
          const Locale('en', 'US'),
        ], // for datepicker korean
        debugShowCheckedModeBanner: false,
        // navigatorObservers: [
        //   FirebaseAnalyticsObserver(analytics: analytics),
        // ],
        home: MyApp(),
        theme: ThemeData(primaryColor: Colors.white, fontFamily: 'Oxygen')),
  ));
}

class MyApp extends StatelessWidget {
  final GoogleMapWholeController gmWholeController =
      Get.put(GoogleMapWholeController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); //가로 기능 비활성

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
          return ScreenUtilInit(
              designSize: Size(375, 667),
              // allowFontScaling: false,
              builder: () => FutureBuilder(
                    future: Future.delayed(Duration(seconds: 1)),
                    builder: (context, snapshot) {
                      // if (snapshot.connectionState == ConnectionState.waiting) {
                      //   return Splash();
                      // } else {
                      return ScreenFilter();
                      // }
                    },
                  ));
        });
  }
}

class ScreenFilter extends StatefulWidget {
  const ScreenFilter({
    Key key,
  }) : super(key: key);

  @override
  _ScreenFilterState createState() => _ScreenFilterState();
}

class _ScreenFilterState extends State<ScreenFilter> {
  String isAuth = "";
  bool isFirstTime = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (!isFirstTime) {
    // return AuthorityScreen();
    // } else if (isAuth == "") {
    // return LoginScreen();
    // } else if (isAuth != "") {
    //   return HomePage();
    // } else {
    //   return Splash();
    // }
    return HomePage();
    // return WalkthroughScreen();
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage("assets/images/splash.png"))),
      ),
    );
  }
}
