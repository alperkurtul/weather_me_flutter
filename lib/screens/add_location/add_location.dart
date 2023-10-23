import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_me_flutter/models/application_api_mode.dart';
import 'package:weather_me_flutter/models/location_model.dart';
import 'package:weather_me_flutter/services/weather_service.dart';
import 'package:weather_me_flutter/states/locations.dart';
import 'package:weather_me_flutter/utilities/app_configuration.dart';
import 'package:weather_me_flutter/utilities/delay_and_trigger_utility.dart';

class AddLocation extends StatefulWidget {
  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  String? searchText;
  List<dynamic> locationList = [];
  String _latestVal = '';
  DelayAndTriggerUtility _delayAndTriggerUtility = DelayAndTriggerUtility(800, 50);

  Future<void> addNewLocation(String? locationName, String? locId) async {
    await context.read<Locations>().addNewLocation(
        LocationModel(locationId: locId!, locationName: locationName!));
    Navigator.pop(context);
  }

  Future<void> _getLocationListWithDelayed(String val) async {
    _latestVal = val;
    bool isDelayPeriodEndedResult = await _delayAndTriggerUtility.isDelayPeriodEnded();
    if (isDelayPeriodEndedResult) {
      await _getLocationList(_latestVal);
    }
  }

  Future<void> _getLocationList(String val) async {
    //print('****** _getLocationList ***** : $val');
    searchText = val;

    var response;
    if (searchText == '') {
      setState(() {
        locationList = [];
      });
    } else {
      searchText = searchText!.trimRight();
      response =
          await WeatherService.getLocationList(context, location: searchText);

      if (response != 'ERROR' && response != 'NOK') {
        if (AppConfiguration.apiMode == ApplicationApiMode.WeatherMeApi) {
          if (response['searchedKeyword'] == searchText) {
            setState(() {
              locationList = response['locationRespList'];
            });
          }
        } else if (AppConfiguration.apiMode ==
            ApplicationApiMode.OpenWeatherApi) {
          if (response['list'].length > 0) {
            final responseList = response['list'];
            final locList = [];
            for (final response in responseList) {
              if (searchText!.length <= response['name'].toString().length) {
                if (response['name']
                        .toString()
                        .toLowerCase()
                        .substring(0, searchText!.length) ==
                    searchText!.toLowerCase()) {
                  locList.add(response);
                }
              }
            }

            if (locList.length > 0) {
              setState(() {
                locationList = locList;
              });
            } else {
              setState(() {
                locationList = [];
              });
            }
          } else {
            setState(() {
              locationList = [];
            });
          }
        }
      } else {
        setState(() {
          locationList = [];
        });
      }
    }
  }

  Widget buildLocationList() {
    if (locationList.length == 0) {
      return SizedBox();
    } else {
      return Container(
        padding: EdgeInsets.only(left: 40.0),
        height: 150.0,
        child: ListView.builder(
          itemCount: locationList.length,
          itemBuilder: (context, index) {
            final loc = locationList[index];
            String? locationId;
            String? locationName;
            String? country;
            if (AppConfiguration.apiMode == ApplicationApiMode.WeatherMeApi) {
              locationId = loc['locationId'].toString();
              locationName = loc['locationName'].toString();
              country = loc['country'].toString();
            } else if (AppConfiguration.apiMode ==
                ApplicationApiMode.OpenWeatherApi) {
              locationId = loc['id'].toString();
              locationName = loc['name'].toString();
              country = loc['sys']['country'].toString();
            }

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: GestureDetector(
                onTap: () {
                  addNewLocation(locationName, locationId);
                },
                child: Text(
                  '$locationName, $country',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom -
          70.0,
      padding: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              'Enter city name',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Row(
            children: [
              Container(
                height: 38.0,
                width: MediaQuery.of(context).size.width - 90,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  onChanged: (value) {
                    _getLocationListWithDelayed(value);
                  },
                  autofocus: true,
                  style: TextStyle(color: Colors.grey),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: Icon(
                            Platform.isIOS
                                ? CupertinoIcons.search
                                : Icons.search,
                            color: Colors.grey,
                            size: 20.0),
                      ),
                      hintText: 'Search...'),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5.0),
                width: 50.0,
                child: FittedBox(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.0),
          buildLocationList(),
        ],
      ),
    );
  }
}
