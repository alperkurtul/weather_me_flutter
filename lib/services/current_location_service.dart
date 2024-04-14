import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_me_flutter/utilities/show_alert.dart';
import 'package:flutter/material.dart';

class CurrentLocationService {
  double? latitude;
  double? longitude;
  String? locationRetrieved;
  String? errorExplanation;
  BuildContext ctx;

  CurrentLocationService(this.ctx) {
    locationRetrieved = 'NOK';
    errorExplanation = '';
  }

  Future<void> getCurrentLocation() async {
    await _getCurrentLocationByGeoLocatorPackage();
  }

  Future<void> _getCurrentLocationByGeoLocatorPackage() async {
    Position _locationData;
    bool _serviceEnabled;
    LocationPermission _permission;
    int _cnt;

    _cnt = 0;
    // Test if location services are enabled.
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    while (!_serviceEnabled) {
      _cnt++;
      if (_cnt >= 100) {
        await showAlertDialog(ctx, 'Location Services Error',
            'Location Services are disabled. \nTo use the app, first you must enable Location Services in the Settings then click OK below.');
      }
      _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    }

    _permission = await Geolocator.requestPermission();
    while (_permission == LocationPermission.denied ||
        _permission == LocationPermission.deniedForever) {
      await showAlertDialog(ctx, 'Location Permissions Error',
          'No Location Permissions. \nTo use the app, first you must enable Location Permissions in the App Settings then click OK below.');
      _permission = await Geolocator.requestPermission();
    }

    locationRetrieved = 'NOK';
    errorExplanation = 'Current location not retrieved';

    // TODO
    DateTime current = DateTime.now();
    DateTime checkDate = new DateTime(2023, 04,
        12); // DEPLOY TRICK for iOS:: checkDate must be set as a few days later than deploy date
    if (current.isAfter(checkDate)) {
      if (_permission == LocationPermission.denied ||
          _permission == LocationPermission.deniedForever) {
        //ISTANBUL
        latitude = 41.01384;
        longitude = 28.949659;
      } else {
        //await showAlertDialog(ctx, 'Debug Message', 'before getCurrentPosition');  // for Debugging
        _locationData = await Geolocator.getCurrentPosition();
        //await showAlertDialog(ctx, 'Debug Message', 'after getCurrentPosition');  // for Debugging

        latitude = _locationData.latitude;
        longitude = _locationData.longitude;
      }
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
}
