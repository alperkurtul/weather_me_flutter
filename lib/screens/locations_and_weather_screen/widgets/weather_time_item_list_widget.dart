import 'package:flutter/material.dart';
import 'package:weather_me_flutter/models/weather_model.dart';
import 'package:weather_me_flutter/screens/locations_and_weather_screen/widgets/weather_time_item_widget.dart';
import 'package:weather_me_flutter/services/weather_service.dart';
import 'package:weather_me_flutter/utilities/misc_constants.dart';

class WeatherTimeItemListWidget extends StatelessWidget {
  final WeatherModel? weatherInfo;

  const WeatherTimeItemListWidget({super.key, this.weatherInfo});

  @override
  Widget build(BuildContext context) {
    WeatherModel weatherModel = weatherInfo!;
    if (weatherInfo == null) {
      weatherModel = WeatherModel();
    }
    //weatherModel = WeatherModel();

    return SizedBox(
      height: 120.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final item = weatherModel.nearFutureTimes![index];
            return WeatherTimeItemWidget(
              time: item.dtTxt,
              degree: item.temp,
              icon: (item.id == kWeatherDataDefaultValue)
                  ? item.id
                  : WeatherService.getWeatherConditionIcon(
                      int.parse(item.id),
                    )['icon'],
            );
          },
          itemCount: weatherModel.nearFutureTimes!.length,
        ),
      ),
    );
  }
}
