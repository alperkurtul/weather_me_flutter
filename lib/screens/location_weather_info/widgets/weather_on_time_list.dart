import 'package:flutter/material.dart';
import 'package:weather_me_flutter/models/weather_model.dart';
import 'package:weather_me_flutter/screens/location_weather_info/widgets/weather_on_time.dart';
import 'package:weather_me_flutter/services/weather_service.dart';

class WeatherOnTimeList extends StatelessWidget {
  final WeatherModel weatherInfo;

  final WeatherService weatherService = WeatherService();

  WeatherOnTimeList({this.weatherInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final item = weatherInfo.nearFutures[index];
            return WeatherOnTime(
              time: item.dtTxt,
              degree: int.parse(item.temp),
              icon: weatherService.getWeatherConditionIcon(
                int.parse(item.id),
              ),
            );
          },
          itemCount: this.weatherInfo.nearFutures.length,
        ),
      ),
    );
  }
}
