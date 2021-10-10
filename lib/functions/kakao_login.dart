// import 'package:kakao_flutter_sdk/auth.dart';
// import 'package:kakao_flutter_sdk/user.dart';

// kakaoLogin() async {
//   final installed = await isKakaoTalkInstalled();
//   if (installed) {
//     print("🚨 kakako1");
//     kakaoNativeLogin();
//   } else {
//     print("🚨 kakako2");
//     kakaoNativeLogin();
//   }
// }

// kakaoNativeLogin() async {
//   try {
//     // var code = await AuthCodeClient.instance.requestWithTalk();
//     var token = await UserApi.instance.loginWithKakaoTalk();
//     print("🚨 kakako : $token");

//     // await issueAccessToken(code);
//   } catch (e) {
//     print(e);
//   }
// }

// kakaoAccountLogin() async {
//   try {
//     // var code = await AuthCodeClient.instance.request();
//     // await issueAccessToken(code);
//   } catch (e) {
//     print(e);
//   }
// }
