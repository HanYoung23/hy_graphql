// import 'dart:convert';

// import 'package:flowing/constants/keys.dart';
// import 'package:http/http.dart' as http;

// Future getServerBanner(Function setAdList) async {
//   var url = Uri.parse('http://$serverUrl/v1/events/banner');
//   await http.get(url).then((response) {
//     String responseString = response.body.toString();
//     var res = jsonDecode(responseString);
//     print("🍞 banner response : ${response.statusCode}");
//     // print("🍞 banner response : ${response.body}");
//     List banner = [];
//     if (response.statusCode == 200) {
//       for (int i = 0; i < res["data"].length; i++) {
//         banner.add("${res["data"][i]["image"]["url"]}");
//       }
//       setAdList(banner);
//     }
//   });
// }
