import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_me_flutter/common_widgets/spinner_circle.dart';
import 'package:weather_me_flutter/models/next_day_model.dart';
import 'package:weather_me_flutter/models/weather_model.dart';
import 'package:weather_me_flutter/screens/locations_and_weather_screen/widgets/weather_time_item_list_widget.dart';
import 'package:weather_me_flutter/screens/locations_and_weather_screen/widgets/weather_wind_humidity_etc_widget.dart';
import 'package:weather_me_flutter/services/weather_service.dart';
import 'package:weather_me_flutter/utilities/misc_constants.dart';
import 'package:weather_me_flutter/utilities/style_settings.dart';
import 'package:weather_me_flutter/states/locations.dart';
import 'package:visibility_detector/visibility_detector.dart';

class WeatherForLocationsWidget extends StatefulWidget {
  final int? index;

  const WeatherForLocationsWidget({super.key, this.index});

  @override
  _WeatherForLocationsWidgetState createState() =>
      _WeatherForLocationsWidgetState();
}

class _WeatherForLocationsWidgetState extends State<WeatherForLocationsWidget> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _keyAnimatedContainer = GlobalKey();
  final GlobalKey _keyListView = GlobalKey();
  final GlobalKey _keyListView1 = GlobalKey();
  final GlobalKey _keyListView2 = GlobalKey();
  final GlobalKey _keyListView3 = GlobalKey();
  double? _animatedContainerDefaultHeight;
  double? _listViewDefaultHeight;
  bool? _theNextDayIsVisible;
  double? _animatedContainerHeight;
  double? _nextDayListOffset = 0.0;

  dynamic _getAnimatedContainerSizes() {
    return (_keyAnimatedContainer.currentContext != null)
        ? _keyAnimatedContainer.currentContext!.size!.height
        : null;
  }

  _getWidgetsSizes() {
    _animatedContainerDefaultHeight = _getAnimatedContainerSizes();

    _listViewDefaultHeight = 0;
    Size contextSize;

    if (_keyListView1.currentContext != null) {
      contextSize = _keyListView1.currentContext!.size!;
      _listViewDefaultHeight = _listViewDefaultHeight! + contextSize.height;
    }

    if (_keyListView2.currentContext != null) {
      contextSize = _keyListView2.currentContext!.size!;
      _listViewDefaultHeight = _listViewDefaultHeight! + contextSize.height;
    }

    if (_keyListView3.currentContext != null) {
      contextSize = _keyListView3.currentContext!.size!;
      _listViewDefaultHeight = _listViewDefaultHeight! + contextSize.height;
    }

    if (_keyListView.currentContext != null) {
      contextSize = _keyListView.currentContext!.size!;
      if (_listViewDefaultHeight! > contextSize.height) {
        _listViewDefaultHeight = _listViewDefaultHeight! -
            ((_listViewDefaultHeight! - contextSize.height) / 2);
      }
    }
  }

  _onVerticalDragStart(DragStartDetails details) {
    if (_animatedContainerDefaultHeight == null) {
      _getWidgetsSizes();
    }

    _nextDayListOffset = _scrollController.offset;
    _animatedContainerHeight ??= _animatedContainerDefaultHeight;
  }

  _onVerticalDragUpdate(DragUpdateDetails details) {
    if (details.delta.dy < 0) {
      // dragging up
      _animatedContainerHeight =
          _animatedContainerHeight! - (-details.delta.dy * 1);
      if (_animatedContainerHeight! < 0.0) _animatedContainerHeight = 0.0;
      //dynamic height = _getAnimatedContainerSizes();
      //if (height == 0.0) {
      if (_animatedContainerHeight == 0.0) {
        _nextDayListOffset = _nextDayListOffset! + (-details.delta.dy * 1);
        if (_nextDayListOffset! > _listViewDefaultHeight!) {
          _nextDayListOffset = _listViewDefaultHeight;
        }
        _scrollController.jumpTo(_nextDayListOffset!);
      }
    } else if (details.delta.dy > 0) {
      // dragging down
      if (!_theNextDayIsVisible!) {
        _nextDayListOffset = _nextDayListOffset! - (details.delta.dy * 1);
        if (_nextDayListOffset! < 0.5) _nextDayListOffset = 0.0;
        _scrollController.jumpTo(_nextDayListOffset!);
        if (_nextDayListOffset == 0.0) _theNextDayIsVisible = true;
      } else {
        _animatedContainerHeight =
            _animatedContainerHeight! + (details.delta.dy * 1);
        if (_animatedContainerHeight! > _animatedContainerDefaultHeight!) {
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
    final Color borderColor = Colors.transparent;

    // TODO
    WeatherModel? weatherInfo =
        context.read<Locations>().locations[widget.index!].weatherData;
    weatherInfo ??= WeatherModel(dataLoaded: true);

    List<NextDayModel>? nextDays = weatherInfo.nextDays;

    String realTemperature =
        (weatherInfo.realTemperature == kWeatherDataDefaultValue)
            ? ''
            : '${weatherInfo.realTemperature}°';

    String commaSign =
        (weatherInfo.locationName == kWeatherDataDefaultValue) ? '' : ',';

    String locationName = (weatherInfo.locationName == kWeatherDataDefaultValue)
        ? ''
        : weatherInfo.locationName;

    String countryCode = (weatherInfo.countryCode == kWeatherDataDefaultValue)
        ? ''
        : weatherInfo.countryCode;

    final double availableWidth = MediaQuery.of(context).size.width -
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
          decoration: BoxDecoration(border: Border.all(color: borderColor)),
          child: Center(
            child: WeatherTimeItemListWidget(weatherInfo: weatherInfo),
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
    if (nextDays!.isNotEmpty) {
      for (var item in nextDays) {
        nextDaysList.add(Row(
          children: [
            Expanded(
              flex: 5,
              child: Text(
                item.dtTxt == kWeatherDataDefaultValue ? '' : '${item.dtTxt}',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
                flex: 3,
                child: (item.id == kWeatherDataDefaultValue)
                    ? SpinnerCircle(spinnerSize: 20)
                    : Text(
                        WeatherService.getWeatherConditionIcon(
                            int.parse(item.id!))['icon'],
                        style: TextStyle(fontSize: 35.0),
                      )),
            Expanded(
                flex: 1,
                child: Text(
                  item.temp == kWeatherDataDefaultValue ? '' : '${item.temp}',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.end,
                )),
          ],
        ));
      }
    }

    if (nextDaysList.isNotEmpty) {
      Widget firstWidget = nextDaysList[0];
      nextDaysList[0] = VisibilityDetector(
          key: Key('theNextDay'),
          onVisibilityChanged: (VisibilityInfo info) {
            if (info.visibleFraction == 1.0) {
              setState(() {
                _theNextDayIsVisible = true;
              });
            } else if (info.visibleFraction <= 0.1) {
              setState(() {
                _theNextDayIsVisible = false;
              });
            }
          },
          child: firstWidget);
    }

    return !weatherInfo.dataLoaded
        ? SizedBox(
            width: MediaQuery.of(context).size.width -
                MediaQuery.of(context).padding.left -
                MediaQuery.of(context).padding.right,
            child: SpinnerCircle(),
          )
        : SizedBox(
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
                    BoxDecoration(border: Border.all(color: borderColor)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: borderColor)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              weatherInfo.id == kWeatherDataDefaultValue
                                  ? SpinnerCircle(
                                      spinnerSize: 20,
                                    )
                                  : Text(
                                      WeatherService.getWeatherConditionIcon(
                                          int.parse(weatherInfo.id))['icon'],
                                      style:
                                          StyleSettings.mainIconSize(context),
                                    ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Column(
                                children: [
                                  Text(
                                      weatherInfo.id == kWeatherDataDefaultValue
                                          ? ''
                                          : 'Today',
                                      style: TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    weatherInfo.currentDateDisplay,
                                    style:
                                        StyleSettings.mediumSizeText(context),
                                  ),
                                  Text(
                                    weatherInfo.weatherDataTime ==
                                            kWeatherDataDefaultValue
                                        ? ''
                                        : weatherInfo.weatherDataTime
                                            .substring(11, 16),
                                    style:
                                        StyleSettings.mediumSizeText(context),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          AnimatedContainer(
                            key: _keyAnimatedContainer,
                            height: _animatedContainerHeight,
                            duration: Duration(milliseconds: 0),
                            curve: Curves.linear,
                            child: FittedBox(
                              child: Column(
                                children: [
                                  Text('$locationName$commaSign $countryCode',
                                      style: StyleSettings.mediumSizeText(
                                          context)),
                                  Text(realTemperature,
                                      style: StyleSettings.mainTemperatureSize(
                                          context)),
                                  SizedBox(
                                    width: availableWidth,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                            'Min ${weatherInfo.minTemperature}°',
                                            style: TextStyle(fontSize: 17.0)),
                                        Text(
                                            'Feels like ${weatherInfo.feelsTemperature}°',
                                            style: TextStyle(fontSize: 17.0)),
                                        Text(
                                            'Max ${weatherInfo.maxTemperature}°',
                                            style: TextStyle(fontSize: 17.0)),
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
                            child: WeatherWindHumidityEtcWidget(
                                weatherInfo: weatherInfo),
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
