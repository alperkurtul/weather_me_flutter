import 'package:flutter/material.dart';
import 'package:weather_me_flutter/models/application_api_mode.dart';
import 'package:weather_me_flutter/models/location_model.dart';
import 'package:weather_me_flutter/services/current_location_service.dart';
import 'package:weather_me_flutter/services/networking.dart';
import 'package:weather_me_flutter/utilities/app_configuration.dart';

class WeatherService {
  static dynamic weatherData;
  static dynamic forecastData;

  //static BuildContext? context;

  //WeatherService(context);

  static NetworkHelper networkHelper = NetworkHelper();

  static Future<dynamic> getLocationWeatherDataByLocationId(BuildContext? ctx,
      {required int locationId}) async {
    networkHelper.context = ctx;
    if (locationId > 0) {
      String? url = AppConfiguration.apiForWeatherDataByLocationIdApi();
      if (AppConfiguration.apiMode == ApplicationApiMode.OpenWeatherApi) {
        url = url?.replaceAll(
            '{apiKey}', '${AppConfiguration.myRegisteredApiKey}');
      }
      Uri uri = Uri.parse('$url${locationId.toString()}');
      networkHelper.uri = uri;
      weatherData = await networkHelper.getData();
      if (weatherData == 'NOK') {
        weatherData = null;
      }
      if (AppConfiguration.apiMode == ApplicationApiMode.WeatherMeApi) {
        forecastData = weatherData;
      }

      if (AppConfiguration.apiMode == ApplicationApiMode.OpenWeatherApi) {
        url = AppConfiguration.apiForForecastWeatherByLocationIdApi();
        url = url?.replaceAll(
            '{apiKey}', '${AppConfiguration.myRegisteredApiKey}');
        uri = Uri.parse('$url${locationId.toString()}');
        networkHelper.uri = uri;
        forecastData = await networkHelper.getData();
        if (forecastData == 'NOK') {
          forecastData = null;
          return 'NOK';
        }
        return 'OK';
      }
    } else {
      weatherData = null;
      forecastData = null;
      return 'ERROR';
    }
  }

  static Future<LocationModel> getCurrentLocationByCoord(BuildContext? ctx,
      {double? lon, double? lat}) async {
    networkHelper.context = ctx;
    CurrentLocationService currentLocationService = CurrentLocationService();

    if (lon != null && lat != null) {
      //print('PRESET CurrentLocation !');
      currentLocationService.latitude = lat;
      currentLocationService.longitude = lon;
      //print('latitude : ' + currentLocationService.latitude.toString());
      //print('longitude : ' + currentLocationService.longitude.toString());
    } else {
      await currentLocationService.getCurrentLocation();
    }

    LocationModel _locationModel = LocationModel();
    if (currentLocationService.longitude != null &&
        currentLocationService.latitude != null) {
      String url = AppConfiguration.apiForCurrentWeatherByCoordApi;
      url =
          url.replaceAll('{apiKey}', '${AppConfiguration.myRegisteredApiKey}');
      url = url.replaceAll('{lat}', '${currentLocationService.latitude}');
      url = url.replaceAll('{lon}', '${currentLocationService.longitude}');
      Uri uri = Uri.parse(url);
      networkHelper.uri = uri;

      try {
        var weatherData = await networkHelper.getData();
        _locationModel.locationId = weatherData['id'].toString();
      } catch (err) {
        print('WeatherService.getCurrentLocationByCoord : $err');
        _locationModel.locationId = '0';
      }

      return _locationModel;
    } else {
      _locationModel.locationId = '0';
      return _locationModel;
    }
  }

  static Future<dynamic> getLocationList(BuildContext ctx,
      {String? location}) async {
    networkHelper.context = ctx;
    int? validLength;
    if (AppConfiguration.apiMode == ApplicationApiMode.WeatherMeApi) {
      validLength = 1;
    } else if (AppConfiguration.apiMode == ApplicationApiMode.OpenWeatherApi) {
      validLength = 3;
    }

    if (location!.length >= validLength!) {
      String? url = AppConfiguration.apiForLocationListApi();
      if (AppConfiguration.apiMode == ApplicationApiMode.OpenWeatherApi) {
        url = url?.replaceAll(
            '{apiKey}', '${AppConfiguration.commonLocationListApiKey}');
      }
      Uri uri = Uri.parse('$url$location');
      networkHelper.uri = uri;

      dynamic data = await networkHelper.getData();
      if (data == 'NOK') {
        data = null;
        return 'NOK';
      }
      return data;
    } else {
      return 'ERROR';
    }
  }

  static Map<dynamic, dynamic> getWeatherConditionIcon(int inCondition) {
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
