import 'package:flutter/material.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:http/http.dart' as http;
import 'package:letsgotrip/constants/keys.dart';

Future<void> postServerMapPhotos(
    BuildContext context, LatLngBounds lntlng) async {
  var url = Uri.parse('http://$serverUrl/photo_list_map');
  await http.post(url, body: {
    "latitude1": lntlng.southwest.latitude.toString(),
    "latitude2": lntlng.northeast.latitude.toString(),
    "longitude1": lntlng.southwest.longitude.toString(),
    "longitude2": lntlng.northeast.longitude.toString(),
  }).then((value) {
    print("🚨🚨🚨 ${value.body}");
  });
}

// latitude1:지도남쪽끝위도, latitude2:지도북쪽끝위도, longitude1:지도서쪽끝경도, longitude2:지도동쪽끝경도
// print("🚨 southwest.latitude: " + lntlng.southwest.latitude.toString());
//       print("🚨 southwest.longitude: " + lntlng.southwest.longitude.toString());
//       print("🚨 northeast.latitude: " + lntlng.northeast.latitude.toString());
//       print("🚨 northeast.longitude: " + lntlng.northeast.longitude.toString());