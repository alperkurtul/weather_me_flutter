import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

class CurrentLocationService {
  double? latitude;
  double? longitude;
  String? locationRetrieved;
  String? errorExplanation;

  CurrentLocationService() {
    locationRetrieved = 'NOK';
    errorExplanation = '';
  }

  Future<void> getCurrentLocation() async {

    //await _getCurrentLocationByLocationPackageOLD();
    //await _getCurrentLocationByLocationPackage();

    await _getCurrentLocationByGeoLocatorPackage();
  }

  Future<void> _getCurrentLocationByGeoLocatorPackage() async {
    Position _locationData;
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    locationRetrieved = 'NOK';
    errorExplanation = 'Current location not retrieved';

    // TODO
    DateTime current = DateTime.now();
    DateTime checkDate = new DateTime(2023,11,7);
    if (current.isAfter(checkDate)) {
      _locationData = await Geolocator.getCurrentPosition();

      latitude = _locationData.latitude;
      longitude = _locationData.longitude;
    } else {
      //ISTANBUL
      latitude = 41.01384;
      longitude = 28.949659;
    }

    //latitude = _locationData.latitude;
    //longitude = _locationData.longitude;

    //CUPERTINO
    //latitude = 37.32463299;
    //longitude = -122.02403404;

    //ISTANBUL
    //latitude = 41.01384;
    //longitude = 28.949659;

    //print('latitude : $latitude  /  longitude : $longitude');

    locationRetrieved = 'OK';
    errorExplanation = 'Current location retrieved';

  }

  Future<void> _getCurrentLocationByLocationPackage() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

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

    locationRetrieved = 'NOK';
    errorExplanation = 'Current location not retrieved';

    _locationData = await location.getLocation();

    latitude = _locationData.latitude;
    longitude = _locationData.longitude;
    //latitude = 37.32465919;
    //longitude = -122.02302279;
    //print('latitude : $latitude  /  longitude : $longitude');

    locationRetrieved = 'OK';
    errorExplanation = 'Current location retrieved';

  }

/*Future<void> _getCurrentLocationByLocationPackageOLD() async {
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
      //latitude = 37.32465919;
      //longitude = -122.02302279;
      print('latitude : $latitude  /  longitude : $longitude');

      locationRetrieved = 'OK';
    } catch (e) {
      print('CurrentLocation NOT RECEIVED : ' + e.toString());
      locationRetrieved = 'NOK';
      errorExplanation = e.toString();
    }
  }*/

}

