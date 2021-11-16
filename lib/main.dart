import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_View/InitPages/authority_screen.dart';
import 'package:letsgotrip/_View/InitPages/login_screen.dart';
import 'package:letsgotrip/_View/InitPages/profile_set_screen.dart';
import 'package:letsgotrip/amplifyconfiguration.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphql_config.dart';

import 'homepage.dart';

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
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
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
      theme: ThemeData(primaryColor: Colors.white),
    ),
  ));
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
              future: Future.delayed(Duration(seconds: 3)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ScreenFilter();
                } else {
                  return Splash();
                }
              },
            ));
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
  String nextScreen;
  String userId;
  String loginType;

  Future initAWS() async {
    if (!Amplify.isConfigured) {
      AmplifyStorageS3 storage = new AmplifyStorageS3();
      AmplifyAuthCognito auth = new AmplifyAuthCognito();
      await Amplify.addPlugins([auth, storage]);
      await Amplify.configure(amplifyconfig);
    }
  }

  @override
  void initState() {
    initAWS();
    seeValue("isWalkThrough").then((value) {
      if (value == "true") {
        seeValue("customerId").then((value) {
          if (value != null) {
            seeValue("isProfileSet").then((value) {
              if (value == "true") {
                setState(() {
                  nextScreen = "homepage";
                });
              } else {
                seeValue("userId").then((value) {
                  setState(() {
                    userId = value;
                  });
                });
                seeValue("loginType").then((value) {
                  setState(() {
                    loginType = value;
                  });
                });
                setState(() {
                  nextScreen = "profileSetScreen";
                });
              }
            });
          } else {
            setState(() {
              nextScreen = "loginScreen";
            });
          }
        });
      } else {
        setState(() {
          nextScreen = "walkThroughScreen";
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return nextScreen == "walkThroughScreen"
        ? AuthorityScreen()
        : nextScreen == "loginScreen"
            ? LoginScreen()
            : nextScreen == "homepage"
                ? HomePage()
                : nextScreen == "profileSetScreen"
                    ? ProfileSetScreen(userId: userId, loginType: loginType)
                    : Container();
    // return ProfileSetScreen(userId: userId, loginType: loginType);
    // return LoginScreen();
    // return HomePage();
    // return Splash();
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
        color: Colors.white,
        child: Center(
          child: Image.asset(
            "assets/images/splash.png",
            width: ScreenUtil().setSp(170),
            height: ScreenUtil().setSp(170),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
