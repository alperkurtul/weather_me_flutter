import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_me_flutter/models/weather_model.dart';
import 'dart:math' as math;

class WindHumidityEtc extends StatelessWidget {
  final WeatherModel weatherInfo;

  WindHumidityEtc({this.weatherInfo});

  @override
  Widget build(BuildContext context) {
    int windDeg = int.parse(weatherInfo.windDirectionDegree);
    int angle = 180;
    angle = angle + windDeg;

    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Text('Sunrise',
                              style: TextStyle(fontSize: 16.0))),
                      Container(
                        child: Text(
                          '${weatherInfo.sunRise}',
                          style: TextStyle(
                              fontSize: 19.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child:
                              Text('Sunset', style: TextStyle(fontSize: 16.0))),
                      Container(
                        child: Text(
                          '${weatherInfo.sunSet}',
                          style: TextStyle(
                              fontSize: 19.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1.5,
          color: Color(0xFFCCCCCC),
        ),
        Container(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Text('Visibility',
                              style: TextStyle(fontSize: 16.0))),
                      Container(
                        child: Text(
                          '${weatherInfo.visibility} km',
                          style: TextStyle(
                              fontSize: 19.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child:
                              Text('Wind', style: TextStyle(fontSize: 16.0))),
                      Container(
                        child: Row(
                          children: [
                            Transform.rotate(
                              angle: angle * math.pi / 180,
                              child: Icon(
                                  Platform.isIOS
                                      ? CupertinoIcons.location_north_fill
                                      : Icons.navigation,
                                  size: 19.0),
                            ),
                            Text(
                              '${weatherInfo.windSpeed} kmph',
                              style: TextStyle(
                                  fontSize: 19.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1.5,
          color: Color(0xFFCCCCCC),
        ),
        Container(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Text('Pressure',
                              style: TextStyle(fontSize: 16.0))),
                      Container(
                        child: Text(
                          '${weatherInfo.pressure} hPa',
                          style: TextStyle(
                              fontSize: 19.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Text('Humidity',
                              style: TextStyle(fontSize: 16.0))),
                      Container(
                        child: Text(
                          '${weatherInfo.humidity} %',
                          style: TextStyle(
                              fontSize: 19.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1.5,
          color: Color(0xFFCCCCCC),
        ),
      ],
    );
  }
}
