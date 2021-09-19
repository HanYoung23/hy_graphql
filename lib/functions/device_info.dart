import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:ios_utsname_ext/extension.dart';
import 'package:package_info/package_info.dart';
import 'package:uuid/uuid.dart';

Future getDeviceInfo() async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};

  var getUuid = Uuid().v4();
  String osName; // ios or android or test
  String osVersion;
  String model;
  String appVersion;

  if (Platform.isAndroid) {
    deviceData = readAndroidDeviceInfo(await deviceInfoPlugin.androidInfo);
    osName = "android";
  } else if (Platform.isIOS) {
    deviceData = readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    osName = "ios";
  }
  String appVersionInfo = await getAppInfo();

  osVersion = "${deviceData["OS버전"]}";
  model = "${deviceData["기기"]}";
  appVersion = "$appVersionInfo";

  return {
    "osName": osName,
    "osVersion": osVersion,
    "model": model,
    "appVersion": appVersion,
    "uuid": "$getUuid"
  };
}

// Map<String, dynamic> postDeviceInfo(String osName, String osVersion,
//     String model, String appVersion, String uuid) {
//   return {
//     "osName": osName,
//     "osVersion": osVersion,
//     "model": model,
//     "appVersion": appVersion,
//     "uuid": uuid
//   };
// }

Map<String, dynamic> readAndroidDeviceInfo(AndroidDeviceInfo info) {
  // var release = info.version.release;
  var sdkInt = info.version.sdkInt;
  // var manufacturer = info.manufacturer;
  var model = info.model;
  return {
    // "OS 버전": "Android $release (SDK $sdkInt)",
    "OS버전": "SDK $sdkInt",
    // "기기": "$manufacturer $model"
    "기기": "$model"
  };
}

Map<String, dynamic> readIosDeviceInfo(IosDeviceInfo info) {
  // var systemName = info.systemName;
  var version = info.systemVersion;
  var machine = info.utsname.machine.iOSProductName;
  return {"OS버전": "ios $version", "기기": "$machine"};
}

Future getAppInfo() async {
  PackageInfo info = await PackageInfo.fromPlatform();
  return info.version;
}
