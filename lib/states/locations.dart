import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_me_flutter/models/location_model.dart';
import 'package:weather_me_flutter/models/near_future_model.dart';
import 'package:weather_me_flutter/models/next_day_model.dart';
import 'package:weather_me_flutter/models/weather_model.dart';
import 'package:weather_me_flutter/services/weather_service.dart';
import 'package:weather_me_flutter/utilities/app_configuration.dart';
import 'dart:convert';

import 'package:weather_me_flutter/utilities/util_date_utils.dart';

class Locations with ChangeNotifier, DiagnosticableTreeMixin {
  List<LocationModel> _locations = [];
  int _selectedLocationIndex;
  bool _deviceLocationEnabled;
  bool _initialDataGatheringCompleted;
  Function _locateToItemInTheLocationListView;
  Function _locateToItemInTheWeatherListView;
  Function _addLocationToAnimatedList;
  Function _deleteLocationFromAnimatedList;

  Locations() {
    _locations.add(LocationModel(
      isGeoLocation: true,
      //longitude: '-0.2',
      //latitude: '51.5',
      locationId: '', //'2645801',
      locationName: 'GeoLocation',
    ));

    _deviceLocationEnabled = false;
    _initialDataGatheringCompleted = false;
    _selectedLocationIndex = 0;
  }

  List<LocationModel> get locations => _locations;

  bool get deviceLocationEnabled => _deviceLocationEnabled;

  bool get initialDataGatheringCompleted => _initialDataGatheringCompleted;

  int get selectedLocationIndex => _selectedLocationIndex;

  //Function get locateToItemInTheLocationListView => _locateToItemInTheLocationListView;
  //Function get locateToItemInTheWeatherListView => _locateToItemInTheWeatherListView;
  //Function get addLocationToAnimatedList => _addLocationToAnimatedList;
  //Function get deleteLocationFromAnimatedList => _deleteLocationFromAnimatedList;

  void deviceLocationIsWorking() {
    _deviceLocationEnabled = true;
    notifyListeners();
  }

  void setLocateToItemInTheLocationListView(Function func) {
    _locateToItemInTheLocationListView = func;
  }

  void setLocateToItemInTheWeatherListView(Function func) {
    _locateToItemInTheWeatherListView = func;
  }

  void setAddLocationToAnimatedList(Function func) {
    _addLocationToAnimatedList = func;
  }

  void setDeleteLocationFromAnimatedList(Function func) {
    _deleteLocationFromAnimatedList = func;
  }

  void gatherInitialData() {
    if (!_initialDataGatheringCompleted) _getFromSharedPreferences();
  }

  Future<void> changeSelectedLocation(int locationIndex,
      {bool notify = true,
      bool locateLocationList = true,
      bool locateWeatherList = false}) async {
    if (_selectedLocationIndex != locationIndex) {
      _selectedLocationIndex = locationIndex;

      if (_locateToItemInTheLocationListView != null) {
        if (locateLocationList) {
          _locateToItemInTheLocationListView(locationIndex);
          if (locateWeatherList) {
            _locateToItemInTheWeatherListView(locationIndex);
          }
        }
      }

      _setSelectedLocationToSharedPreferences();

      if (notify) {
        notifyListeners();
      }

      _gatherLocationWeatherData(locationIndex, true);
    }
  }

  Future<void> addNewLocation(LocationModel location) async {
    _locations.add(LocationModel(
        locationId: location.locationId, locationName: location.locationName));

    await changeSelectedLocation(_locations.length - 1,
        notify: false, locateLocationList: false);

    _locateToItemInTheLocationListView(_locations.length - 1);
    _locateToItemInTheWeatherListView(_locations.length - 1);
    _addLocationToAnimatedList();

    _setLocationsToSharedPreferences();

    notifyListeners();
  }

  Future<void> deleteFromLocation(int indexWillBeDeleted) async {
    var removedItem = _locations.removeAt(indexWillBeDeleted);
    _deleteLocationFromAnimatedList(removedItem, indexWillBeDeleted);

    if (_selectedLocationIndex == 0) {
    } else {
      if (indexWillBeDeleted == _selectedLocationIndex) {
        await changeSelectedLocation(0, notify: false, locateWeatherList: true);
      } else {
        if (_selectedLocationIndex < indexWillBeDeleted) {
        } else {
          await changeSelectedLocation(_selectedLocationIndex - 1,
              notify: false, locateLocationList: false);
        }
      }
    }

    _setLocationsToSharedPreferences();

    notifyListeners();
  }

  Future<void> _gatherLocationWeatherData(
      [int locationIndex, bool notify = true]) async {
    bool _dataGathered = false;
    int _startIndex, _endIndex;
    WeatherService _weatherService = WeatherService();

    if (locationIndex == null) {
      _startIndex = 0;
      _endIndex = _locations.length - 1;
    } else {
      _startIndex = locationIndex;
      _endIndex = locationIndex;
    }

    int index = 0;
    for (LocationModel location in _locations) {
      if (index >= _startIndex && index <= _endIndex) {
        if (location.isGeoLocation) {
          LocationModel locationModel =
              await _weatherService.getCurrentLocationByCoord();
          location.locationId = locationModel.locationId;
        }

        int validity = AppConfiguration.weatherDataValidDuration;
        int nowAsUtcMilliSeconds = UTILDateUtils.utcTimeInMilliseconds;
        int lastDataLoadedTimeAsUtcMilliSeconds =
            int.parse(location.weatherData.dataLoadedUtcTime);

        int difference =
            nowAsUtcMilliSeconds - lastDataLoadedTimeAsUtcMilliSeconds;
        if ((location.isGeoLocation) || (difference > validity)) {
          await _weatherService.getLocationWeatherDataByLocationId(
              locationId: int.parse(location.locationId));

          print(
              'API request : YES for ${location.locationName} / difference: $difference / lastSaved: $lastDataLoadedTimeAsUtcMilliSeconds / now: $nowAsUtcMilliSeconds / param: $validity');
          if (_weatherService.weatherData != null &&
              _weatherService.forecastData != null) {
            _dataGathered = true;
            _setWeatherInfo(_weatherService, index);
          }
        } else {
          print(
              'API request : NO for ${location.locationName} / difference: $difference / lastSaved: $lastDataLoadedTimeAsUtcMilliSeconds / now: $nowAsUtcMilliSeconds / param: $validity');
        }
      }
      index++;
    }

    if (_dataGathered) {
      _setLocationsToSharedPreferences();
      if (notify) {
        notifyListeners();
      }
    }
  }

  void _setWeatherInfo(WeatherService weatherService, int index) {
    _locations[index].weatherData.setWeatherInfo(weatherService);
  }

  Future<void> _setLocationsToSharedPreferences() async {
    List locationsMap = _locationsToMap();

    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
    if (locationsMap.length == 0) {
      _sharedPrefs.remove('locations');
    } else {
      String locationsString = json.encode(locationsMap);
      _sharedPrefs.setString('locations', locationsString);
    }
  }

  Future<void> _setSelectedLocationToSharedPreferences() async {
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
    _sharedPrefs.setInt('selectedLocationIndex', _selectedLocationIndex);
  }

  Future<void> _getFromSharedPreferences() async {
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();

    String locationsString = _sharedPrefs.getString('locations');
    List<dynamic> mapList = [];
    if (locationsString != null) {
      mapList = json.decode(locationsString);
    }

    mapList.asMap().forEach((index, itemLocation) {
      WeatherModel weather;
      List<NearFutureModel> nearFutures = [];
      List<NextDayModel> nextDays = [];

      itemLocation['weatherData']['nearFutures']
          .asMap()
          .forEach((index, itemNearFuture) {
        NearFutureModel nearFuture = NearFutureModel(
          id: itemNearFuture['id'],
          temp: itemNearFuture['temp'],
          dtTxt: itemNearFuture['dtTxt'],
        );
        nearFutures.add(nearFuture);
      });

      itemLocation['weatherData']['nextDays']
          .asMap()
          .forEach((index, itemNextDay) {
        NextDayModel nextDay = NextDayModel(
          id: itemNextDay['id'],
          main: itemNextDay['main'],
          description: itemNextDay['description'],
          icon: itemNextDay['icon'],
          temp: itemNextDay['temp'],
          tempMin: itemNextDay['tempMin'],
          tempMax: itemNextDay['tempMax'],
          dtTxt: itemNextDay['dtTxt'],
        );
        nextDays.add(nextDay);
      });

      weather = WeatherModel(
        dataLoaded: itemLocation['weatherData']['dataLoaded'],
        id: itemLocation['weatherData']['id'],
        main: itemLocation['weatherData']['main'],
        description: itemLocation['weatherData']['description'],
        icon: itemLocation['weatherData']['icon'],
        realTemperature: itemLocation['weatherData']['realTemperature'],
        feelsTemperature: itemLocation['weatherData']['feelsTemperature'],
        minTemperature: itemLocation['weatherData']['minTemperature'],
        maxTemperature: itemLocation['weatherData']['maxTemperature'],
        pressure: itemLocation['weatherData']['pressure'],
        humidity: itemLocation['weatherData']['humidity'],
        countryCode: itemLocation['weatherData']['countryCode'],
        sunRise: itemLocation['weatherData']['sunRise'],
        sunSet: itemLocation['weatherData']['sunSet'],
        timeZone: itemLocation['weatherData']['timeZone'],
        locationId: itemLocation['weatherData']['locationId'],
        locationName: itemLocation['weatherData']['locationName'],
        visibility: itemLocation['weatherData']['visibility'],
        windSpeed: itemLocation['weatherData']['windSpeed'],
        windDirectionDegree: itemLocation['weatherData']['windDirectionDegree'],
        weatherDataTime: itemLocation['weatherData']['weatherDataTime'],
        currentDateDisplay: itemLocation['weatherData']['currentDateDisplay'],
        nearFutures: nearFutures,
        nextDays: nextDays,
      );
      weather.dataLoadedUtcTime =
          itemLocation['weatherData']['dataLoadedUtcTime'];

      LocationModel loc = LocationModel(
        isGeoLocation: itemLocation['isGeoLocation'],
        locationId: itemLocation['locationId'],
        locationName: itemLocation['locationName'],
        country: itemLocation['country'],
        longitude: itemLocation['longitude'],
        latitude: itemLocation['latitude'],
        weatherData: weather,
      );

      _locations.add(loc);
    });

    int index = _sharedPrefs.getInt('selectedLocationIndex');
    if (index == null) {
      _selectedLocationIndex = 0;
    } else {
      if ((locations.length - 1) < index) {
        _selectedLocationIndex = 0;
      } else {
        _selectedLocationIndex = index;
      }
    }

    _initialDataGatheringCompleted = true;
    notifyListeners();

    await _gatherLocationWeatherData(0, false);
    if (_selectedLocationIndex != 0)
      await _gatherLocationWeatherData(_selectedLocationIndex, false);

    //_initialDataGatheringCompleted = true;
    notifyListeners();
  }

  List _locationsToMap() {
    List mapList = [];
    for (LocationModel loc in locations) {
      if (!loc.isGeoLocation) {
        dynamic map = loc.toMap();
        mapList.add(map);
      }
    }

    return mapList;
  }
}
