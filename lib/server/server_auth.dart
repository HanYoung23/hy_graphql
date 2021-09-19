import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:letsgotrip/constants/keys.dart';
import 'package:letsgotrip/functions/device_info.dart';
import 'package:letsgotrip/storage/storage.dart';

Future<void> serverSignUp(BuildContext context, String type, String id,
    String token, String gender, String email, String birthYear) async {
  await getDeviceInfo().then((info) async {
    var url = Uri.parse('http://$serverUrl/v1/auths/signup');
    await http.post(url, body: {
      'platform_type': '$type',
      'platform_key': '$id',
      'message_token': '$token',
      'os_name': '${info["osName"]}',
      'os_version': '${info["osVersion"]}',
      'app_version': '${info["appVersion"]}',
      'model': '${info["model"]}',
      'uuid': '${info["uuid"]}',
      'email': email,
      // 'gender': "",
      // 'birth_year': "aaaa"
    }).then((response) {
      print('🙆‍♂️ sign up : ${jsonDecode(response.body)}');
      if (response.statusCode == 201) {
        serverSignIn(
            context,
            type,
            id,
            token,
            info["osName"],
            info["osVersion"],
            info["appVersion"],
            info["model"],
            info["uuid"],
            email);
      } else {
        Map res = jsonDecode(response.body);
        String errorM = res["message"];
        // errorPopUp(context, "로그인 실패", '$errorM');
      }
    });
  });
}

Future<void> serverSignIn(
    BuildContext context,
    String type,
    String id,
    String token,
    String osName,
    String osVersion,
    String appVersion,
    String model,
    String uuid,
    String email) async {
  print("$type, $id, $token, $osName, $osVersion, $appVersion, $model, $uuid");

  var url = Uri.parse('http://$serverUrl/v1/auths/signin');
  await http.post(url, body: {
    'platform_type': '$type',
    'platform_key': '$id',
    'message_token': '$token',
    'os_name': "$osName",
    'os_version': "$osVersion",
    'app_version': "$appVersion",
    'model': "$model",
    'uuid': "$uuid",
    'email': email,
    // 'gender': "",
    // 'birth_year': "aaaa"
  }).then((response) {
    print('🙆‍♂️ sign in : ${jsonDecode(response.body)}');
    var res = jsonDecode(response.body);
    var token = res["data"]["access_token"];
    if (response.statusCode == 201 && token != null) {
      // storeUserData("login_type", type); // type 저장
      // storeUserData("access_token", token);
      // storeUserData("user_id", "${res["data"]["user"]["id"]}"); // token 저장
      // storeUserData("user_nickname", "${res["data"]["user"]["nickname"]}");
      // storeUserData("user_uuid", "$uuid");
      // Get.to(() => InitLocationScreen());
    } else {
      Map res = jsonDecode(response.body);
      String errorM = res["message"];
      // errorPopUp(context, "로그인 실패", '$errorM');
    }
  });

  // firebaseAnalytics("$type로그인"); // for firabse analytics
}

Future<void> serverSignOut(
  String type,
) async {
  var userUuid = await storage.read(key: "user_uuid");

  var url = Uri.parse('http://$serverUrl/v1/auths/signout');
  await http.post(url, body: {
    'uuid': "$userUuid",
  }).then((response) {
    print('🙅‍♂️ sign out : ${jsonDecode(response.body)}');
    var res = jsonDecode(response.body);
    var token = res["data"]["access_token"];
    if (response.statusCode == 201 && token != null) {
      // Get.to(() => InitLocationScreen());
    }
  });
}
