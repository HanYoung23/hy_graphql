import 'package:get/get.dart';

class NotificationContoller extends GetxController {
  var isNotification = false.obs;

  Future updateIsNotification(bool isNoti) async {
    isNotification.value = isNoti;
  }
}
