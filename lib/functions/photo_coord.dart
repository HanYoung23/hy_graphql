import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:metadata/metadata.dart';

Future pullPhotoCoordnate(File photo) async {
  // final exifData = await readExifFromFile(photo);
  final fileByte = await photo.readAsBytes();
  var result = MetaData.exifData(fileByte);
  print("🚨 result : ${result.exifData}");
  // print("🚨 GPSLongitude data : $exifData");
  // print("🚨 GPSLongitude data : ${exifData["GPS GPSLatitude"]}");

  if (result.exifData["gps"]["GPSLatitude"] != null) {
    String latitude = "${result.exifData["gps"]["GPSLatitude"]}";
    String longitude = "${result.exifData["gps"]["GPSLongitude"]}";

    String lat = latitude.substring(1, latitude.length - 1);
    String lng = longitude.substring(1, longitude.length - 1);
    List latDataList = lat.split(",");
    List lngDataList = lng.split(",");

    if (latDataList[2].contains("/") || lngDataList[2].contains("/")) {
      List latCalc = latDataList[2].split("/");
      List lngCalc = lngDataList[2].split("/");
      double lastLat = int.parse(latCalc[0]) / int.parse(latCalc[1]);
      double lastLng = int.parse(lngCalc[0]) / int.parse(lngCalc[1]);
      print("🚨 lastLat : $lastLat");
      print("🚨 lastLng : $lastLng");
      latDataList[2] = "$lastLat";
      lngDataList[2] = "$lastLng";
    }

    String latValue = (double.parse(latDataList[0]) +
            double.parse(latDataList[1]) / 60 +
            double.parse(latDataList[2]) / 3600)
        .toStringAsFixed(7);
    String lngValue = (double.parse(lngDataList[0]) +
            double.parse(lngDataList[1]) / 60 +
            double.parse(lngDataList[2]) / 3600)
        .toStringAsFixed(7);

    print("🚨 GPSLongitude data : $latValue, $lngValue");
    return LatLng(double.parse(latValue), double.parse(lngValue));

    // if (exifData["GPS GPSLatitude"] != null) {
    //   String latitude = "${exifData["GPS GPSLatitude"]}";
    //   String longitude = "${exifData["GPS GPSLongitude"]}";

    //   String lat = latitude.substring(1, latitude.length - 1);
    //   String lng = longitude.substring(1, longitude.length - 1);
    //   List latDataList = lat.split(",");
    //   List lngDataList = lng.split(",");

    //   if (latDataList[2].contains("/") || lngDataList[2].contains("/")) {
    //     List latCalc = latDataList[2].split("/");
    //     List lngCalc = lngDataList[2].split("/");
    //     double lastLat = int.parse(latCalc[0]) / int.parse(latCalc[1]);
    //     double lastLng = int.parse(lngCalc[0]) / int.parse(lngCalc[1]);
    //     print("🚨 lastLat : $lastLat");
    //     print("🚨 lastLng : $lastLng");
    //     latDataList[2] = "$lastLat";
    //     lngDataList[2] = "$lastLng";
    //   }

    //   String latValue = (double.parse(latDataList[0]) +
    //           double.parse(latDataList[1]) / 60 +
    //           double.parse(latDataList[2]) / 3600)
    //       .toStringAsFixed(7);
    //   String lngValue = (double.parse(lngDataList[0]) +
    //           double.parse(lngDataList[1]) / 60 +
    //           double.parse(lngDataList[2]) / 3600)
    //       .toStringAsFixed(7);

    //   print("🚨 GPSLongitude data : ${latValue}, ${lngValue}");
    //   return LatLng(double.parse(latValue), double.parse(lngValue));
  } else {
    return null;
  }
}

// 목동 : 37.5280556, 126.8777778
// 영등포 : 37.5269304, 126.9035138

// 37.516666666666
// 113890

// 37, 31, 37
// 126, 54, 13