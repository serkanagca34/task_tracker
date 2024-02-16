import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<String> getCurrentCity() async {
  // Request Permission
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  // Fetch Current Location
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  // Convert Location
  List<Placemark> placeMarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

  // Extract City
  String? city = placeMarks[0].locality;

  print('City : ${city}');

  return city ?? '';
}
