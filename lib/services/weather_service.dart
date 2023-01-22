import 'package:weather_me_flutter/models/application_api_mode.dart';
import 'package:weather_me_flutter/models/location_model.dart';
import 'package:weather_me_flutter/services/geo_location.dart';
import 'package:weather_me_flutter/services/networking.dart';
import 'package:weather_me_flutter/utilities/app_configuration.dart';

class WeatherService {
  dynamic weatherData;
  dynamic forecastData;

  Future<dynamic> getLocationWeatherDataByLocationId({int locationId}) async {
    if (locationId > 0) {
      String url = AppConfiguration.apiForWeatherDataByLocationIdApi();
      NetworkHelper networkHelper;
      if (AppConfiguration.apiMode == ApplicationApiMode.OpenWeatherApi) {
        url = url.replaceAll(
            '{apiKey}', '${AppConfiguration.myRegisteredApiKey}');
      }
      Uri uri = Uri.parse('$url${locationId.toString()}');
      networkHelper = NetworkHelper(uri);
      weatherData = await networkHelper.getData();
      if (weatherData == 'NOK') {
        weatherData = null;
      }
      if (AppConfiguration.apiMode == ApplicationApiMode.WeatherMeApi) {
        forecastData = weatherData;
      }

      if (AppConfiguration.apiMode == ApplicationApiMode.OpenWeatherApi) {
        url = AppConfiguration.apiForForecastWeatherByLocationIdApi();
        url = url.replaceAll(
            '{apiKey}', '${AppConfiguration.myRegisteredApiKey}');
        uri = Uri.parse('$url${locationId.toString()}');
        networkHelper = NetworkHelper(uri);
        forecastData = await networkHelper.getData();
        if (forecastData == 'NOK') {
          forecastData = null;
        }
      }
    } else {
      weatherData = null;
      forecastData = null;
      return 'ERROR';
    }
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
      Uri uri = Uri.parse(url);
      networkHelper = NetworkHelper(uri);

      var weatherData = await networkHelper.getData();
      try {
        _locationModel.locationId = weatherData['id'].toString();
      } catch (err) {
        print('$this (getCurrentLocationByCoord) : $err');
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
      Uri uri = Uri.parse('$url$location');
      networkHelper = NetworkHelper(uri);

      dynamic data = await networkHelper.getData();
      return data;
    } else {
      return 'ERROR';
    }
  }

  Map<dynamic, dynamic> getWeatherConditionIcon(int inCondition) {
    // https://www.piliapp.com/emoji/list/weather/
    String icon;
    int outCondition;

    if (inCondition < 210) {
      icon = '⛈'; // Thunder cloud and rain
      outCondition = 209;
    } else if (inCondition < 300) {
      icon = '🌩'; // Cloud with lightning
      outCondition = 299;
    } else if (inCondition < 500) {
      icon = '🌦'; // White sun behind cloud with rain
      outCondition = 499;
    } else if (inCondition < 600) {
      icon = '🌧'; // Cloud with rain
      outCondition = 599;
    } else if (inCondition < 700) {
      icon = '🌨'; // Cloud with snow
      outCondition = 699;
    } else if (inCondition < 800) {
      icon = '☁'; // Cloud   '🌫'; // Fog
      outCondition = 804; // 799;
    } else if (inCondition == 800) {
      icon = '☀'; // Black sun with rays
      outCondition = 800;
    } else if (inCondition == 801) {
      icon = '🌤'; // White sun with small cloud
      outCondition = 801;
    } else if (inCondition <= 803) {
      icon = '🌥'; // White sun behind cloud
      outCondition = 803;
    } else if (inCondition == 804) {
      icon = '☁'; // Cloud
      outCondition = 804;
    } else {
      icon = '🤷‍';
      outCondition = inCondition;
    }

    Map outMap = {'icon': icon, 'outCondition': outCondition};

    return outMap;

    // '🌅'
    // '🌄'
  }
}
