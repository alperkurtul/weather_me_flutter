import 'package:weather_me_flutter/models/weather_model.dart';

class LocationModel {
  bool isGeoLocation;
  String locationId;
  String locationName;
  String country;
  String longitude;
  String latitude;
  WeatherModel weatherData;

  LocationModel({
    this.isGeoLocation = false,
    this.locationId = '',
    this.locationName = '',
    this.country = '',
    this.longitude = '',
    this.latitude = '',
    this.weatherData,
  }) {
    if (this.weatherData == null) {
      weatherData = WeatherModel();
    }
  }

  dynamic toMap() {
    return {
      'isGeoLocation': isGeoLocation,
      'locationId': locationId,
      'locationName': locationName,
      'country': country,
      'longitude': longitude,
      'latitude': latitude,
      'weatherData': weatherData.toMap(),
    };
  }
}
