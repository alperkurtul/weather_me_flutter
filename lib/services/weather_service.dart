import 'package:weather_me_flutter/models/application_api_mode.dart';
import 'package:weather_me_flutter/models/location_model.dart';
import 'package:weather_me_flutter/services/geo_location.dart';
import 'package:weather_me_flutter/services/networking.dart';
import 'package:weather_me_flutter/utilities/app_configuration.dart';

class WeatherService {
  dynamic weatherData;
  dynamic forecastData;

  Future<void> getLocationWeatherDataByLocationId({int locationId}) async {
    if (locationId > 0) {
      String url = AppConfiguration.apiForWeatherDataByLocationIdApi();
      NetworkHelper networkHelper;
      if (AppConfiguration.apiMode == ApplicationApiMode.OpenWeatherApi) {
        url = url.replaceAll(
            '{apiKey}', '${AppConfiguration.myRegisteredApiKey}');
      }
      networkHelper = NetworkHelper('$url${locationId.toString()}');
      weatherData = await networkHelper.getData();

      if (AppConfiguration.apiMode == ApplicationApiMode.OpenWeatherApi) {
        url = AppConfiguration.apiForForecastWeatherByLocationIdApi();
        url = url.replaceAll(
            '{apiKey}', '${AppConfiguration.myRegisteredApiKey}');
        networkHelper = NetworkHelper('$url${locationId.toString()}');
        forecastData = await networkHelper.getData();
      }
    } else
      return 'ERROR';
  }

  Future<LocationModel> getCurrentLocationByCoord(
      {double lon, double lat}) async {
    GeoLocation geoLocation = GeoLocation();

    if (lon != null && lat != null) {
      print('PRESetted CurrentLocation !');
      geoLocation.latitude = lat;
      geoLocation.longitude = lon;
      print('latitude : ' + geoLocation.latitude.toString());
      print('longitude : ' + geoLocation.longitude.toString());
    } else {
      await geoLocation.getCurrentLocation();
    }

    LocationModel _locationModel = LocationModel();
    if (geoLocation.longitude != null && geoLocation.latitude != null) {
      NetworkHelper networkHelper;

      String url = AppConfiguration.apiForCurrentWeatherByCoordApi;
      url =
          url.replaceAll('{apiKey}', '${AppConfiguration.myRegisteredApiKey}');
      url = url.replaceAll('{lat}', '${geoLocation.latitude}');
      url = url.replaceAll('{lon}', '${geoLocation.longitude}');
      networkHelper = NetworkHelper(url);

      var weatherData = await networkHelper.getData();
      try {
        _locationModel.locationId = weatherData['id'].toString();
      } catch (err) {
        print(err.toString());
        _locationModel.locationId = '0';
      }

      return _locationModel;
    } else {
      _locationModel.locationId = '0';
      return _locationModel;
    }
  }

  Future<dynamic> getLocationList({String location}) async {
    int validLength;
    if (AppConfiguration.apiMode == ApplicationApiMode.WeatherMeApi) {
      validLength = 1;
    } else if (AppConfiguration.apiMode == ApplicationApiMode.OpenWeatherApi) {
      validLength = 3;
    }

    if (location.length >= validLength) {
      NetworkHelper networkHelper;
      String url = AppConfiguration.apiForLocationListApi();
      if (AppConfiguration.apiMode == ApplicationApiMode.OpenWeatherApi) {
        url = url.replaceAll(
            '{apiKey}', '${AppConfiguration.commonLocationListApiKey}');
      }
      networkHelper = NetworkHelper('$url$location');

      return await networkHelper.getData();
    } else
      return 'ERROR';
  }

  String getWeatherConditionIcon(int condition) {
    // https://www.piliapp.com/emoji/list/weather/

    if (condition < 210) {
      return '⛈'; // Thunder cloud and rain
    } else if (condition < 300) {
      return '🌩'; // Cloud with lightning
    } else if (condition < 500) {
      return '🌦'; // White sun behind cloud with rain
    } else if (condition < 600) {
      return '🌧'; // Cloud with rain
    } else if (condition < 700) {
      return '🌨'; // Cloud with snow
    } else if (condition < 800) {
      return '☁'; // Cloud   '🌫'; // Fog
    } else if (condition == 800) {
      return '☀'; // Black sun with rays
    } else if (condition == 801) {
      return '🌤'; // White sun with small cloud
    } else if (condition <= 803) {
      return '🌥'; // White sun behind cloud
    } else if (condition == 804) {
      return '☁'; // Cloud
    } else {
      return '🤷‍';
    }

    // '🌅'
    // '🌄'
  }
}
