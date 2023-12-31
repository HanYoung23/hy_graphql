import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> checkNotificationPermission() async {
  bool permitted = true;
  var status;
  await Permission.notification.request().then((value) => status = value);
  if (status != PermissionStatus.granted) permitted = false;

  return permitted;
}

Future<bool> checkLocationPermission() async {
  bool isPermission;

  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    return false;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  permission = await Geolocator.requestPermission();

  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    isPermission = false;
  } else {
    isPermission = true;
  }
  return isPermission;
}

Future checkGalleryPermission() async {
  bool permitted = true;
  var status;
  await Permission.storage.request().then((value) => status = value);
  if (status != PermissionStatus.granted) permitted = false;
  return permitted;
}
