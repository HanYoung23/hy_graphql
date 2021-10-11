import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:letsgotrip/storage/storage.dart';

kakaoLogin() async {
  final installed = await isKakaoTalkInstalled();
  if (installed) {
    print("🐤 kakako native login");
    kakaoNativeLogin();
  } else {
    print("🐤 kakako account login");
    kakaoAccountLogin();
  }
}

kakaoNativeLogin() async {
  try {
    var code = await UserApi.instance.loginWithKakaoTalk();
    print("🐤 kakako login ${code.accessToken}");
    storeUserData("accessToken", "${code.accessToken}");
  } catch (e) {
    print("🚨 kakao login error : $e");
  }
}

kakaoAccountLogin() async {
  try {
    var code = await UserApi.instance.loginWithKakaoAccount();
    print("🐤 kakako login ${code.accessToken}");
    storeUserData("accessToken", "${code.accessToken}");
  } catch (e) {
    print("🚨 kakao login error : $e");
  }
}
