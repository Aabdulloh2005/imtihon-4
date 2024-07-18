import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import 'package:geocoding/geocoding.dart';

class LocationService {
  static LocationPermission? permission;

  static Future<bool> checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission != LocationPermission.deniedForever;
  }

  static Future<Position?> determinePosition() async {
    if (permission != LocationPermission.deniedForever ||
        permission != LocationPermission.denied) {
      return await Geolocator.getCurrentPosition();
    }
    return null;
  }

  static Future<String> determinePositionName(GeoPoint location) async {
    if (permission != LocationPermission.deniedForever ||
        permission != LocationPermission.denied) {
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(location.latitude, location.longitude);
      Placemark place = placeMarks[0];
      return "${place.street} ${place.name}";
    }
    return '';
  }
}
