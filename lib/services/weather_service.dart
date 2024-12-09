import 'package:flutter/material.dart';
import 'package:weather_me_flutter/models/application_api_mode.dart';
import 'package:weather_me_flutter/models/location_model.dart';
import 'package:weather_me_flutter/services/current_location_service.dart';
import 'package:weather_me_flutter/services/networking.dart';
import 'package:weather_me_flutter/utilities/app_configuration.dart';

class WeatherService {
  dynamic weatherData;
  dynamic forecastData;

  Future<dynamic> getLocationWeatherDataByLocationId(BuildContext? ctx,
      {required int locationId}) async {
    if (locationId > 0) {
      String? url = AppConfiguration.apiForWeatherDataByLocationId();
      if (AppConfiguration.apiMode == ApplicationApiMode.OpenWeatherApi) {
        url = url?.replaceAll(
            '{apiKey}', '${AppConfiguration.myRegisteredApiKey}');
      }
      Uri uri = Uri.parse('$url${locationId.toString()}');
      weatherData = await NetworkHelper.getData(ctx!, uri);
      if (weatherData == 'NOK') {
        weatherData = null;
      }
      if (AppConfiguration.apiMode == ApplicationApiMode.WeatherMeApi) {
        forecastData = weatherData;
      }

      if (AppConfiguration.apiMode == ApplicationApiMode.OpenWeatherApi) {
        url = AppConfiguration.apiForForecastWeatherByLocationId();
        url = url?.replaceAll(
            '{apiKey}', '${AppConfiguration.myRegisteredApiKey}');
        uri = Uri.parse('$url${locationId.toString()}');
        if (ctx.mounted) {
          forecastData = await NetworkHelper.getData(ctx, uri);
        }
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

  static Future<LocationModel> getCurrentLocationByCoordination(
      BuildContext? ctx,
      {String? lon,
      String? lat}) async {
    CurrentLocationService currentLocationService =
        CurrentLocationService(ctx!);

    if ((lon != null && lat != null) || (lon != '' && lat != '')) {
      //print('PRESET CurrentLocation !');
      currentLocationService.latitude = lat;
      currentLocationService.longitude = lon;
      //print('latitude : ' + currentLocationService.latitude.toString());
      //print('longitude : ' + currentLocationService.longitude.toString());
    } else {
      await currentLocationService.getCurrentLocation();
    }

    LocationModel locationModel = LocationModel();
    if (currentLocationService.longitude != null &&
        currentLocationService.latitude != null) {
      locationModel.latitude = currentLocationService.latitude!;
      locationModel.longitude = currentLocationService.longitude!;

      String url = AppConfiguration.apiForCurrentLocationByCoordination;
      url =
          url.replaceAll('{apiKey}', '${AppConfiguration.myRegisteredApiKey}');
      url = url.replaceAll('{lat}', '${currentLocationService.latitude}');
      url = url.replaceAll('{lon}', '${currentLocationService.longitude}');
      Uri uri = Uri.parse(url);

      dynamic weatherData;
      try {
        if (ctx.mounted) {
          weatherData = await NetworkHelper.getData(ctx, uri);
        }
        locationModel.locationId = weatherData['id'].toString();
      } catch (err) {
        if (weatherData == 'NOK') {
          print(
              'WeatherService.getCurrentLocationByCoordination : (weatherData = $weatherData) ');
        } else {
          print('WeatherService.getCurrentLocationByCoordination : $err');
        }
        locationModel.locationId = '0';
      }

      return locationModel;
    } else {
      locationModel.locationId = '0';
      return locationModel;
    }
  }

  Future<dynamic> getLocationList(BuildContext ctx, {String? location}) async {
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

      dynamic data = await NetworkHelper.getData(ctx, uri);
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
      //icon = '🤷‍';
      icon = '';
      outCondition = inCondition;
    }

    Map outMap = {'icon': icon, 'outCondition': outCondition};

    return outMap;

    // '🌅'
    // '🌄'
  }
}
