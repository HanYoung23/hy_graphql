import 'package:geolocator/geolocator.dart';

Future<Position> getUserLocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);
  return position;
}
