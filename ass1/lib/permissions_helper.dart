import 'package:geolocator/geolocator.dart';

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled; don't continue accessing the position.
    return Future.error('Location services are disabled.');
  }

  // Check the current permission status.
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // Request permission if it's denied.
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied; handle appropriately.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever; handle appropriately.
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.',
    );
  }

  // When we reach here, permissions are granted, and we can access the position.
  return await Geolocator.getCurrentPosition();
}
