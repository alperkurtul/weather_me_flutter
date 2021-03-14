import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_me_flutter/common_widgets/spinner_circle.dart';
import 'package:weather_me_flutter/models/next_day_model.dart';
import 'package:weather_me_flutter/models/weather_model.dart';
import 'package:weather_me_flutter/screens/location_weather_info/widgets/weather_on_time_list.dart';
import 'package:weather_me_flutter/screens/location_weather_info/widgets/wind_humidity_etc.dart';
import 'package:weather_me_flutter/services/weather_service.dart';
import 'package:weather_me_flutter/utilities/style_settings.dart';
import 'package:weather_me_flutter/states/locations.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LocationWeather extends StatefulWidget {
  final int index;

  const LocationWeather({this.index});

  @override
  _LocationWeatherState createState() => _LocationWeatherState();
}

class _LocationWeatherState extends State<LocationWeather> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _keyAnimatedContainer = GlobalKey();
  final GlobalKey _keyListView = GlobalKey();
  final GlobalKey _keyListView1 = GlobalKey();
  final GlobalKey _keyListView2 = GlobalKey();
  final GlobalKey _keyListView3 = GlobalKey();
  double _animatedContainerDefaultHeight;
  double _listViewDefaultHeight;
  bool _theNextDayIsVisible;
  double _animatedContainerHeight;
  double _nextDayListOffset = 0.0;

  dynamic _getAnimatedContainerSizes() {
    return (_keyAnimatedContainer.currentContext != null)
        ? _keyAnimatedContainer.currentContext.size.height
        : null;
  }

  _getWidgetsSizes() {
    _animatedContainerDefaultHeight = _getAnimatedContainerSizes();

    _listViewDefaultHeight = 0;
    Size _contextSize;

    if (_keyListView1.currentContext != null) {
      _contextSize = _keyListView1.currentContext.size;
      _listViewDefaultHeight = _listViewDefaultHeight + _contextSize.height;
    }

    if (_keyListView2.currentContext != null) {
      _contextSize = _keyListView2.currentContext.size;
      _listViewDefaultHeight = _listViewDefaultHeight + _contextSize.height;
    }

    if (_keyListView3.currentContext != null) {
      _contextSize = _keyListView3.currentContext.size;
      _listViewDefaultHeight = _listViewDefaultHeight + _contextSize.height;
    }

    if (_keyListView.currentContext != null) {
      _contextSize = _keyListView.currentContext.size;
      if (_listViewDefaultHeight > _contextSize.height) {
        _listViewDefaultHeight = _listViewDefaultHeight -
            ((_listViewDefaultHeight - _contextSize.height) / 2);
      }
    }
  }

  _onVerticalDragStart(DragStartDetails details) {
    if (_animatedContainerDefaultHeight == null) {
      _getWidgetsSizes();
    }

    _nextDayListOffset = _scrollController.offset;
    if (_animatedContainerHeight == null) {
      _animatedContainerHeight = _animatedContainerDefaultHeight;
    }
  }

  _onVerticalDragUpdate(DragUpdateDetails details) {
    if (details.delta.dy < 0) {
      // draging up
      _animatedContainerHeight =
          _animatedContainerHeight - (-details.delta.dy * 1);
      if (_animatedContainerHeight < 0.0) _animatedContainerHeight = 0.0;
      dynamic height = _getAnimatedContainerSizes();
      //if (height == 0.0) {
      if (_animatedContainerHeight == 0.0) {
        _nextDayListOffset = _nextDayListOffset + (-details.delta.dy * 1);
        if (_nextDayListOffset > _listViewDefaultHeight) {
          _nextDayListOffset = _listViewDefaultHeight;
        }
        _scrollController.jumpTo(_nextDayListOffset);
      }
    } else if (details.delta.dy > 0) {
      // draging down
      if (!_theNextDayIsVisible) {
        _nextDayListOffset = _nextDayListOffset - (details.delta.dy * 1);
        if (_nextDayListOffset < 0.5) _nextDayListOffset = 0.0;
        _scrollController.jumpTo(_nextDayListOffset);
        if (_nextDayListOffset == 0.0) _theNextDayIsVisible = true;
      } else {
        _animatedContainerHeight =
            _animatedContainerHeight + (details.delta.dy * 1);
        if (_animatedContainerHeight > _animatedContainerDefaultHeight) {
          _animatedContainerHeight = _animatedContainerDefaultHeight;
        }
        if (_animatedContainerHeight == _animatedContainerDefaultHeight) {
          _scrollController.jumpTo(0);
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Color _borderColor = Colors.transparent;
    final WeatherService _weatherService = WeatherService();

    WeatherModel weatherInfo =
        context.read<Locations>().locations[widget.index].weatherData;
    List<NextDayModel> nextDays =
        context.read<Locations>().locations[widget.index].weatherData.nextDays;

    final double _availableWidth = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;

    final Widget weatherOnTime = Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: 8.0,
            left: 5.0,
            right: 5.0,
          ),
          child: Divider(thickness: 1.5, color: Color(0xFFCCCCCC)),
        ),
        Container(
          decoration: BoxDecoration(border: Border.all(color: _borderColor)),
          child: Center(
            child: WeatherOnTimeList(weatherInfo: weatherInfo),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 5.0,
          ),
          child: Divider(thickness: 1.5, color: Color(0xFFCCCCCC)),
        ),
      ],
    );

    List<Widget> nextDaysList = [];
    if (nextDays.length > 0) {
      dynamic item = nextDays[0];
      nextDaysList.add(VisibilityDetector(
        key: Key('theNextDay'),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction == 1.0) {
            //print('SEEN');
            setState(() {
              _theNextDayIsVisible = true;
              //_scrollController.jumpTo(0);
            });
          } else if (info.visibleFraction <= 0.1) {
            //print('NOTSEEN');
            setState(() {
              _theNextDayIsVisible = false;
            });
          }
        },
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Text(
                '${item.dtTxt}',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
                flex: 3,
                child: Text(
                  //'${item.id}',
                  _weatherService.getWeatherConditionIcon(int.parse(item.id))['icon'],
                  style: TextStyle(fontSize: 35.0),
                )),
            Expanded(
                flex: 1,
                child: Text(
                  '${item.temp}',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.end,
                )),
          ],
        ),
      ));
    }

    if (nextDays.length >= 1) {
      nextDays.sublist(1).forEach((item) {
        nextDaysList.add(Row(
          children: [
            Expanded(
              flex: 5,
              child: Text(
                '${item.dtTxt}',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
                flex: 3,
                child: Text(
                  _weatherService.getWeatherConditionIcon(int.parse(item.id))['icon'],
                  style: TextStyle(fontSize: 35.0),
                )),
            Expanded(
                flex: 1,
                child: Text(
                  '${item.temp}',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.end,
                )),
          ],
        ));
      });
    }

    return !weatherInfo.dataLoaded
        ? Container(
            width: MediaQuery.of(context).size.width -
                MediaQuery.of(context).padding.left -
                MediaQuery.of(context).padding.right,
            child: SpinnerCircle(),
          )
        : Container(
            width: MediaQuery.of(context).size.width -
                MediaQuery.of(context).padding.left -
                MediaQuery.of(context).padding.right,
            /*height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom,*/
            child: GestureDetector(
              onVerticalDragStart: (details) => _onVerticalDragStart(details),
              onVerticalDragUpdate: (details) => _onVerticalDragUpdate(details),
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: _borderColor)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: _borderColor)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _weatherService.getWeatherConditionIcon(
                                      int.parse(weatherInfo.id))['icon'],
                                  style: StyleSettings.mainIconSize(context),
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Column(
                                  children: [
                                    Container(
                                        child: Text('Today',
                                            style: TextStyle(
                                                fontSize: 25.0,
                                                fontWeight: FontWeight.bold))),
                                    Container(
                                        child: Text(
                                      '${weatherInfo.currentDateDisplay}',
                                      style:
                                          StyleSettings.mediumSizeText(context),
                                    )),
                                    Container(
                                        child: Text(
                                      '${weatherInfo.weatherDataTime.substring(11, 16)}',
                                      style:
                                          StyleSettings.mediumSizeText(context),
                                    )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          AnimatedContainer(
                            key: _keyAnimatedContainer,
                            height: _animatedContainerHeight,
                            duration: Duration(milliseconds: 0),
                            curve: Curves.linear,  // .easeInOut,  //.fastOutSlowIn,
                            child: FittedBox(
                              child: Column(
                                children: [
                                  Container(
                                    child: Text(
                                        '${weatherInfo.locationName}, ${weatherInfo.countryCode}',
                                        style: StyleSettings.mediumSizeText(
                                            context)),
                                  ),
                                  Container(
                                    child: Text(
                                        '${weatherInfo.realTemperature}°',
                                        style:
                                            StyleSettings.mainTemperatureSize(
                                                context)),
                                  ),
                                  Container(
                                    width: _availableWidth,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          child: Text(
                                              'Min ${weatherInfo.minTemperature}°',
                                              style: TextStyle(fontSize: 17.0)),
                                        ),
                                        Container(
                                          child: Text(
                                              'Feels like ${weatherInfo.feelsTemperature}°',
                                              style: TextStyle(fontSize: 17.0)),
                                        ),
                                        Container(
                                          child: Text(
                                              'Max ${weatherInfo.maxTemperature}°',
                                              style: TextStyle(fontSize: 17.0)),
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
                    weatherOnTime,
                    Expanded(
                      child: ListView(
                        key: _keyListView,
                        controller: _scrollController,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Container(
                            key: _keyListView1,
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: nextDaysList,
                            ),
                          ),
                          Padding(
                            key: _keyListView2,
                            padding: EdgeInsets.only(
                              bottom: 8.0,
                              left: 5.0,
                              right: 5.0,
                            ),
                            child: Divider(
                                thickness: 1.5, color: Color(0xFFCCCCCC)),
                          ),
                          Container(
                            key: _keyListView3,
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: WindHumidityEtc(weatherInfo: weatherInfo),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
