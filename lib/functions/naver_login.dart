import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:letsgotrip/storage/storage.dart';

naverLogin() async {
  NaverLoginResult res = await FlutterNaverLogin.logIn();
  print("🐸 naver login result : ${res.account.id}");
  storeUserData("userId", "${res.account.id}");
  storeUserData("loginType", "naver");
  return "${res.account.id}";
}

naverLogout() async {
  NaverLoginResult res = await FlutterNaverLogin.logOut();
  print("🐸 naver logout result : $res");
  return res;
}

naverUser() async {
  NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;
  print("🐸 naver token result : $res");
}