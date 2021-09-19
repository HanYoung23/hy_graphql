import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:letsgotrip/View/InitPages/authority_screen.dart';
import 'package:letsgotrip/View/InitPages/login_screen.dart';
import 'package:letsgotrip/homepage.dart';

void main() {
  runApp(GetMaterialApp(
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
      theme: ThemeData(primaryColor: Colors.white, fontFamily: 'Oxygen')));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); //가로 기능 비활성
    return ScreenUtilInit(
        designSize: Size(375, 667),
        // allowFontScaling: false,
        builder: () => FutureBuilder(
              future: Future.delayed(Duration(seconds: 5)),
              builder: (context, snapshot) {
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return Splash();
                // } else {
                return ScreenFilter();
                // }
              },
            ));
  }
}

class ScreenFilter extends StatefulWidget {
  const ScreenFilter({Key key}) : super(key: key);

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
    //   return AuthorityScreen();
    // } else if (isAuth == "") {
    //   return LoginScreen();
    // } else if (isAuth != "") {
    //   return HomePage();
    // } else {
    //   return Splash();
    // }
    return HomePage();
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
