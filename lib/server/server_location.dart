// import 'dart:convert';
// import 'dart:io';

// import 'package:flowing/constants/keys.dart';
// import 'package:flowing/functions/popup.dart';
// import 'package:flowing/server/server_auth.dart';
// import 'package:flowing/home_page.dart';
// import 'package:flowing/storage/storage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

// Future<void> postServerLocation(
//     BuildContext context,
//     String address,
//     String detailAddress,
//     String buildingName,
//     String lng,
//     String lat,
//     String hCode) async {
//   String userToken = await storage.read(key: "access_token");

//   final Map<String, dynamic> activityData = {
//     'road_address': "$address",
//     'detail_address': "$detailAddress", // optional parameter
//     'building_name': "$buildingName", // optional parameter
//     'longitude': lng,
//     'latitude': lat,
//     'district_code': "$hCode"
//   };

//   var url = Uri.parse('http://$serverUrl/v1/locations');
//   var response = await http.post(url,
//       headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"},
//       body: activityData);

//   print('📍 location response : ${response.statusCode}');
//   if (response.statusCode == 201) {
//     storeUserData("user_location", "$address");
//     storeUserData("user_location_detail", "$detailAddress");
//     storeUserData("lng", lng);
//     storeUserData("lat", lat);
//     storeUserData("hCode", hCode);
//     storeUserData("building_name", buildingName);
//     Get.to(() => HomePage(screenNum: 0));
//   } else {
//     Map res = jsonDecode(response.body);
//     String errorM = res["message"];
//     errorPopUp(context, '위치 정보 전송 오류', '$errorM');
//   }
// }

// Future getServerCoord(BuildContext context, String address,
//     String detailAddress, String buildingName) async {
//   var url = Uri.parse("https://dapi.kakao.com/v2/local/search/address.json");
//   final Map<String, dynamic> activityData = {
//     "query": "$address",
//     "analyze_type": "exact",
//   };

//   await http
//       .post(url,
//           headers: {HttpHeaders.authorizationHeader: "KakaoAK $kakaoREST"},
//           body: activityData)
//       .then((response) {
//     Map adrMap = jsonDecode(response.body);
//     String lng = adrMap["documents"][0]["x"];
//     String lat = adrMap["documents"][0]["y"];
//     String hCode = adrMap["documents"][0]["address"]["h_code"];
//     print('📍 location response : $lng, $lat, $hCode');
//     postServerLocation(
//         context, address, detailAddress, buildingName, lng, lat, hCode);
//   });
// }
