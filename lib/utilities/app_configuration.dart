import 'package:flutter/material.dart';
import 'package:weather_me_flutter/models/application_api_mode.dart';
import 'package:weather_me_flutter/models/application_environment.dart';

class AppConfiguration {
  // 5 minutes
  static int get weatherDataValidDuration =>
      DateTime.utc(1970, 1, 1, 0, 5, 0).millisecondsSinceEpoch; // 300000

  static final BoxDecoration appBackgroundBoxDecoration = BoxDecoration(
    image: DecorationImage(
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.2),
        BlendMode.dstATop,
      ),
      image: AssetImage('assets/background.jpg'),
    ),
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.1, 0.4, 0.7, 0.9],
      colors: [
        Color(0xFF65ACFE),
        Color(0xFF5F8AF5),
        Color(0xFF5A73EF),
        Color(0xFF565EEA),
      ],
    ),
  );

  static const ApplicationApiMode apiMode = ApplicationApiMode.OpenWeatherApi;
  static const ApplicationEnvironment applicationEnvironment =
      ApplicationEnvironment.Production;

  static const myRegisteredApiKey = 'bcd5cca022de3d1a38619a0f353c5c77';
  static const commonLocationListApiKey = '439d4b804bc8187953eb36d2a8c26a02';

// For the use of finding location id with GeoLocation
  static const apiForCurrentWeatherByCoordApi =
      'https://api.openweathermap.org/data/2.5/weather?appid={apiKey}&units=metric&lang=en&lat={lat}&lon={lon}';

  static String apiForLocationListApi() {
    String api;
    if (apiMode == ApplicationApiMode.OpenWeatherApi) {
      api =
          'https://openweathermap.org/data/2.5/find?&appid={apiKey}&units=metric&lang=en&q=';
    } else if (apiMode == ApplicationApiMode.WeatherMeApi) {
      if (applicationEnvironment == ApplicationEnvironment.Local) {
        api =
            'http://192.168.0.80:8080/weatherme/v1/getlocationlist?locationname=';
      } else if (applicationEnvironment == ApplicationEnvironment.Production) {
        api =
            'http://24.133.72.100:9090/weatherme/v1/getlocationlist?locationname=';
      }
    }
    return api;
  }

  static String apiForWeatherDataByLocationIdApi() {
    String api;
    if (apiMode == ApplicationApiMode.OpenWeatherApi) {
      api =
          'https://api.openweathermap.org/data/2.5/weather?appid={apiKey}&units=metric&lang=en&id=';
    } else if (apiMode == ApplicationApiMode.WeatherMeApi) {
      if (applicationEnvironment == ApplicationEnvironment.Local) {
        api = 'http://192.168.0.80:8080/weatherme/v1/getcurrentweather/';
      } else if (applicationEnvironment == ApplicationEnvironment.Production) {
        api = 'http://24.133.72.100:9090/weatherme/v1/getcurrentweather/';
      }
    }
    return api;
  }

  static String apiForForecastWeatherByLocationIdApi() {
    String api;
    if (apiMode == ApplicationApiMode.OpenWeatherApi) {
      api =
          'https://api.openweathermap.org/data/2.5/forecast?appid={apiKey}&units=metric&lang=en&cnt=40&id=';
    } else if (apiMode == ApplicationApiMode.WeatherMeApi) {
      if (applicationEnvironment == ApplicationEnvironment.Local) {
        api = '';
      } else if (applicationEnvironment == ApplicationEnvironment.Production) {
        api = '';
      }
    }
    return api;
  }
}
