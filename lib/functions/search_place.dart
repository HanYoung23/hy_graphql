import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:letsgotrip/constants/keys.dart';

Future kakaoSearch(String query) async {
  String url =
      "https://dapi.kakao.com/v2/local/search/keyword.json?query=$query";

  var response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      "Authorization": "KakaoAK $kakaoREST",
    },
  );
  // var statusCode = response.statusCode;
  String responseBody = response.body;
  Map responseMap = jsonDecode(responseBody);

  // print("🚨 statusCode: $statusCode");
  // print("🚨 responseBody: ${responseMap["documents"]}");
  return responseMap["documents"];
}
