import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

Future<void> storeUserData(String key, String value) async {
  await storage.write(key: key, value: value);
  print("🌕 storeUserdata key : $key, value : $value");
}

Future<void> deleteUserData(String key) async {
  await storage.delete(key: key);
  print("🌕 deletedUserData $key");
}

Future<void> deleteAllUserData() async {
  await storage.deleteAll();
  print("🌕 deleteAllUserData");
}

Future seeValue(String key) async {
  String value = await storage.read(key: key);
  print("🌕 see $key : $value");
  return value;
}

Future<void> seeAllValues() async {
  Map<String, String> allValues = await storage.readAll();
  print("🌕 see all values : $allValues");
}

//isWalkThrough true
// isProfileSet true

// userId
// customerId 35
// loginType kakao,naver,apple

// postSaveData
// calendarSaveData
