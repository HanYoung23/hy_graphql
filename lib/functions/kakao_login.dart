import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:letsgotrip/storage/storage.dart';

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
  var code = await UserApi.instance.loginWithKakaoTalk();
  print("🐤 kakako login ${code.accessToken}");
  storeUserData("accessToken", "${code.accessToken}");
  return "${code.accessToken}";
}

kakaoAccountLogin() async {
  var code = await UserApi.instance.loginWithKakaoAccount();
  print("🐤 kakako login ${code.accessToken}");
  storeUserData("accessToken", "${code.accessToken}");
  return "${code.accessToken}";
}
