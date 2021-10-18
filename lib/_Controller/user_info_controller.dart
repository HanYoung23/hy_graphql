import 'package:get/get.dart';
import 'package:letsgotrip/storage/storage.dart';

class UserInfoContoller extends GetxController {
  int customerId;

  Future setCustomerId() async {
    String id = await storage.read(key: "customerId");
    customerId = int.parse(id);
    update();
  }
}
