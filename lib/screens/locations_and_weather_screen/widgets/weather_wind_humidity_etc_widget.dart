import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_me_flutter/models/weather_model.dart';
import 'dart:math' as math;

import 'package:weather_me_flutter/utilities/misc_constants.dart';

class WeatherWindHumidityEtcWidget extends StatelessWidget {
  final WeatherModel? weatherInfo;

  const WeatherWindHumidityEtcWidget({super.key, this.weatherInfo});

  @override
  Widget build(BuildContext context) {
    int windDeg = weatherInfo!.windDirectionDegree == kWeatherDataDefaultValue
        ? 0
        : int.parse(weatherInfo!.windDirectionDegree);
    int angle = 180;
    angle = angle + windDeg;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sunrise', style: TextStyle(fontSize: 16.0)),
                  Text(
                    weatherInfo!.sunRise == kWeatherDataDefaultValue
                        ? ''
                        : weatherInfo!.sunRise,
                    style:
                        TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sunset', style: TextStyle(fontSize: 16.0)),
                  Text(
                    weatherInfo!.sunSet == kWeatherDataDefaultValue
                        ? ''
                        : weatherInfo!.sunSet,
                    style:
                        TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(
          thickness: 1.5,
          color: Color(0xFFCCCCCC),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Visibility', style: TextStyle(fontSize: 16.0)),
                  Text(
                    weatherInfo!.visibility == kWeatherDataDefaultValue
                        ? ''
                        : '${weatherInfo!.visibility} km',
                    style:
                        TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Wind', style: TextStyle(fontSize: 16.0)),
                  Row(
                    children: [
                      weatherInfo!.windSpeed == kWeatherDataDefaultValue
                          ? SizedBox()
                          : Transform.rotate(
                              angle: angle * math.pi / 180,
                              child: Icon(
                                  Platform.isIOS
                                      ? CupertinoIcons.location_north_fill
                                      : Icons.navigation,
                                  size: 19.0),
                            ),
                      Text(
                        weatherInfo!.windSpeed == kWeatherDataDefaultValue
                            ? ''
                            : '${weatherInfo!.windSpeed} kmph',
                        style: TextStyle(
                            fontSize: 19.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(
          thickness: 1.5,
          color: Color(0xFFCCCCCC),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pressure', style: TextStyle(fontSize: 16.0)),
                  Text(
                    weatherInfo!.pressure == kWeatherDataDefaultValue
                        ? ''
                        : '${weatherInfo!.pressure} hPa',
                    style:
                        TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Humidity', style: TextStyle(fontSize: 16.0)),
                  Text(
                    weatherInfo!.humidity == kWeatherDataDefaultValue
                        ? ''
                        : '${weatherInfo!.humidity} %',
                    style:
                        TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(
          thickness: 1.5,
          color: Color(0xFFCCCCCC),
        ),
      ],
    );
  }
}
