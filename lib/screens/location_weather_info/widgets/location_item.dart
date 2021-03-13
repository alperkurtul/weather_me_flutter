import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_me_flutter/states/locations.dart';
import 'package:weather_me_flutter/services/weather_service.dart';

class LocationItem extends StatelessWidget {
  final String locationName;
  final int locationIndex;
  final bool selected;

  final WeatherService weatherService = WeatherService();

  LocationItem({this.locationName, this.locationIndex, this.selected = false});

  void changeSelectedLocation(BuildContext context, int index) async {
    int locationId = int.parse(
        context.read<Locations>().locations[index].locationId.toString());
    await weatherService.getLocationWeatherDataByLocationId(
        locationId: locationId);
    context
        .read<Locations>()
        .changeSelectedLocation(index, locateLocationList: false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 5.0),
      child: GestureDetector(
        onLongPress: (locationIndex == null || locationIndex == 0)
            ? null
            : () {
                context.read<Locations>().deleteFromLocation(locationIndex);
              },
        child: Container(
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).primaryColor.withOpacity(0.8)
                : Color(0x605F8AF5),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
              color: Color(0xFFCCCCCC),
            ),
          ),
          width: 130.0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
            child: Center(
              child: FittedBox(
                child: (locationIndex == 0)
                    ? Icon(
                        Platform.isIOS
                            ? CupertinoIcons.location_fill
                            : Icons.near_me,
                        color: selected
                            ? Color(0xBB5F8AFF)
                            : Theme.of(context).primaryColor,
                        size: 30.0)
                    : Row(
                        children: [
                          Text(
                            '$locationName  ',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: selected
                                    ? Color(0xFF565EEA)
                                    : Theme.of(context).primaryColor),
                          ),
                          Icon(
                              Platform.isIOS
                                  ? CupertinoIcons.delete
                                  : Icons.delete,
                              size: 27.0,
                              color: selected
                                  ? Color(0xFF565EEA)
                                  : Theme.of(context).primaryColor),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
