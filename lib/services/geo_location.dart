import 'package:geolocator/geolocator.dart';

class GeoLocation {
  double latitude;
  double longitude;
  String locationRetrieved;
  String errorExplanation;

  GeoLocation() {
    locationRetrieved = 'NOK';
    errorExplanation = '';
  }

  Future<void> getCurrentLocation() async {
    try {
      print('TRYING to get CurrentLocation !');
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      print('RECEIVED CurrentLocation !');

      latitude = position.latitude;
      longitude = position.longitude;
      print('latitude : $latitude  /  longitude : $longitude');

      locationRetrieved = 'OK';
    } catch (e) {
      print('CurrentLocation NOT RECEIVED : ' + e.toString());
      locationRetrieved = 'NOK';
      errorExplanation = e.toString();
    }
  }
}
