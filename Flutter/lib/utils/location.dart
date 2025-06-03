import 'package:fingo/utils/utils.dart';
import 'package:geolocator/geolocator.dart';

Future<List> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return ["Location services are disabled."];
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return ["Permission denied!"];
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return ["Permission denied!"];
  }

  Position position = await Geolocator.getCurrentPosition();
  return [position.latitude, position.longitude];
}