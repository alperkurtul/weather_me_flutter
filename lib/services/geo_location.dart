import 'package:location/location.dart';

class GeoLocation {
  double? latitude;
  double? longitude;
  String? locationRetrieved;
  String? errorExplanation;

  GeoLocation() {
    locationRetrieved = 'NOK';
    errorExplanation = '';
  }

  Future<void> getCurrentLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    //LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    //_locationData = await location.getLocation();

    try {
      //print('TRYING to get CurrentLocation !');

      final position = await location.getLocation();
      //print('RECEIVED CurrentLocation !');

      latitude = position.latitude;
      longitude = position.longitude;
      //print('latitude : $latitude  /  longitude : $longitude');

      locationRetrieved = 'OK';
    } catch (e) {
      print('CurrentLocation NOT RECEIVED : ' + e.toString());
      locationRetrieved = 'NOK';
      errorExplanation = e.toString();
    }
  }

}
