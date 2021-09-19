// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:letsgotrip/constants/keys.dart';
// import 'package:letsgotrip/functions/device_info.dart';

// final storage = new FlutterSecureStorage();

// Future<void> serverSignUp(BuildContext context, String type, String id,
//     String token, String gender, String email, String birthYear) async {
//   await getDeviceInfo().then((info) async {
    
//     var url = Uri.parse('http://$serverUrl/photo_list_map');
//     await http.post(url, body: {

//     }).then((value){
//       print(value);
//     });
    
//   });
// }