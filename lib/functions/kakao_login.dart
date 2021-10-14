import 'package:letsgotrip/storage/storage.dart';
import 'package:kakao_flutter_sdk/all.dart';

Future kakaoLogin() async {
  final installed = await isKakaoTalkInstalled();
  String token = "";
  if (installed) {
    print("🐤 kakako native login");
    token = await kakaoNativeLogin();
  } else {
    print("🐤 kakako account login");
    token = await kakaoAccountLogin();
  }

  return token;
}

kakaoNativeLogin() async {
  UserApi.instance.loginWithKakaoTalk();
  // print("🐤 kakako login ${code.accessToken}");

  User user = await UserApi.instance.me();
  // print("🐤 user : ${user.id}");
  storeUserData("userId", "${user.id}");
  storeUserData("loginType", "kakao");
  return "${user.id}";
}

kakaoAccountLogin() async {
  UserApi.instance.loginWithKakaoAccount();
  // print("🐤 kakako login ${code.accessToken}");

  User user = await UserApi.instance.me();
  // print("🐤 user : ${user.id}");
  storeUserData("userId", "${user.id}");
  storeUserData("loginType", "kakao");
  return "${user.id}";
}
