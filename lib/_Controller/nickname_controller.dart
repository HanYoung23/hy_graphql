import 'package:get/get.dart';

class NicknameContoller extends GetxController {
  var isValidNickname = false.obs;
  var isVisible = false.obs;
  var preNickname = "".obs;

  Future updateIsValidNickname(bool isValid) async {
    isValidNickname.value = isValid;
  }

  Future updateIsVisible(bool val) async {
    isVisible.value = val;
  }

  Future updatePreNickname(String val) async {
    preNickname.value = val;
  }
}
