import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_me_flutter/utilities/show_alert.dart';
import 'package:flutter/material.dart';

class CurrentLocationService {
  String? latitude;
  String? longitude;
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
    Position locationData;
    bool serviceEnabled;
    LocationPermission permission;
    int tryCount;

    tryCount = 0;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    while (!serviceEnabled) {
      tryCount++;
      if (tryCount >= 100) {
        if (ctx.mounted) {
          await showAlertDialog(ctx, 'Location Services Error',
              'Location Services are disabled. \nTo use the app, first you must enable Location Services in the Settings then click OK below.');
        }
      }
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
    }

    permission = await Geolocator.requestPermission();
    while (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (ctx.mounted) {
        await showAlertDialog(ctx, 'Location Permissions Error',
            'No Location Permissions. \nTo use the app, first you must enable Location Permissions in the App Settings then click OK below.');
      }
      permission = await Geolocator.requestPermission();
    }

    locationRetrieved = 'NOK';
    errorExplanation = 'Current location not retrieved';

    // TODO
    DateTime current = DateTime.now();
    DateTime checkDate = DateTime(2023, 04,
        12); // DEPLOY TRICK for iOS:: checkDate must be set as a few days later than deploy date
    if (current.isAfter(checkDate)) {
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        //ISTANBUL
        latitude = '41.01384';
        longitude = '28.949659';
      } else {
        //await showAlertDialog(ctx, 'Debug Message', 'before getCurrentPosition');  // for Debugging
        locationData = await Geolocator.getCurrentPosition();
        //await showAlertDialog(ctx, 'Debug Message', 'after getCurrentPosition');  // for Debugging

        latitude = locationData.latitude.toString();
        longitude = locationData.longitude.toString();
      }
    } else {
      //ISTANBUL
      latitude = '41.01384';
      longitude = '28.949659';
    }

    //CUPERTINO
    //latitude = '37.32463299';
    //longitude = '-122.02403404';

    //print('latitude : $latitude  /  longitude : $longitude');

    locationRetrieved = 'OK';
    errorExplanation = 'Current location retrieved';
  }
}
