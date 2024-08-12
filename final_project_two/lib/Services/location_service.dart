import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;

class LocationService {
  Future<String?> getLocation() async {
    try {
      Location location = Location();
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          throw Exception('Location service is disabled.');
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          throw Exception('Location permission denied.');
        }
      }

      _locationData = await location.getLocation();
      return await getCityFromLocation(_locationData.latitude, _locationData.longitude);
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  Future<String> getCityFromLocation(double? latitude, double? longitude) async {
    if (latitude == null || longitude == null) {
      throw Exception('Invalid coordinates');
    }

    try {
      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        return placemarks.first.locality ?? 'Unknown City';
      } else {
        return 'Unknown City';
      }
    } catch (e) {
      print('Error getting city from location: $e');
      return 'Unknown City';
    }
  }
}
