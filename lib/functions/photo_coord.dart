import 'dart:io';
import 'package:exif/exif.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future pullPhotoCoordnate(File photo) async {
  final exifData = await readExifFromFile(photo);

  if (exifData["GPS GPSLatitude"] != null) {
    String latitude = "${exifData["GPS GPSLatitude"]}";
    String longitude = "${exifData["GPS GPSLongitude"]}";

    String lat = latitude.substring(1, latitude.length - 1);
    String lng = longitude.substring(1, longitude.length - 1);
    List latDataList = lat.split(",");
    List lngDataList = lng.split(",");
    String latValue = (double.parse(latDataList[0]) +
            double.parse(latDataList[1]) / 60 +
            double.parse(latDataList[2]) / 3600)
        .toStringAsFixed(7);
    String lngValue = (double.parse(lngDataList[0]) +
            double.parse(lngDataList[1]) / 60 +
            double.parse(lngDataList[2]) / 3600)
        .toStringAsFixed(7);

    // print("🚨 GPSLongitude data : ${latValue}, ${lngValue}");
    return LatLng(double.parse(latValue), double.parse(lngValue));
  } else {
    return null;
  }
}

// 37.5269304, 126.9035138

// 37, 31, 37
// 126, 54, 13


// double latValue = double.parse(latDataList[0]) +
//           double.parse(latDataList[1]) / 60 +
//           double.parse(latDataList[2]) / 3600;
//       // .toStringAsFixed(7);
//   double lngValue = double.parse(lngDataList[0]) +
//           double.parse(lngDataList[1]) / 60 +
//           double.parse(lngDataList[2]) / 3600;
//       // .toStringAsFixed(7);