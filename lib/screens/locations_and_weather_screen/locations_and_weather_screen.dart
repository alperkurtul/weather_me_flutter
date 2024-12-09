import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_me_flutter/common_widgets/spinner_circle.dart';
import 'package:weather_me_flutter/common_widgets/spinner_circle_with_scaffold.dart';
import 'package:weather_me_flutter/models/location_model.dart';
import 'package:weather_me_flutter/screens/add_location/add_location.dart';
import 'package:weather_me_flutter/screens/locations_and_weather_screen/widgets/location_item_list_widget.dart';
import 'package:weather_me_flutter/screens/locations_and_weather_screen/widgets/weather_for_locations_widget.dart';
import 'package:weather_me_flutter/services/current_location_service.dart';
import 'package:weather_me_flutter/states/locations.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:weather_me_flutter/utilities/app_configuration.dart';
import 'package:weather_me_flutter/utilities/show_alert.dart';

class LocationsAndWeatherScreen extends StatefulWidget {
  static const String routeName = 'locations-and-weather-screen';

  const LocationsAndWeatherScreen({super.key});

  @override
  _LocationsAndWeatherScreenState createState() =>
      _LocationsAndWeatherScreenState();
}

class _LocationsAndWeatherScreenState extends State<LocationsAndWeatherScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    Provider.of<Locations>(context, listen: false)
        .setLocateToItemInTheWeatherListView(locateToItemInTheListView);

    _checkForCurrentLocation(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _checkForCurrentLocation(BuildContext ctx) async {
    CurrentLocationService currentLocation = CurrentLocationService(ctx);
    await currentLocation.getCurrentLocation();
    if (currentLocation.locationRetrieved == 'OK') {
      if (ctx.mounted) {
        Provider.of<Locations>(ctx, listen: false).deviceLocationIsWorking();

        List<LocationModel> locations =
            Provider.of<Locations>(ctx, listen: false).locations;
        locations[0].longitude = currentLocation.longitude!;
        locations[0].latitude = currentLocation.latitude!;

        Provider.of<Locations>(ctx, listen: false).gatherInitialData(ctx);
      }
    } else {
      if (ctx.mounted) {
        showAlertDialog(
            ctx, 'Location Error', currentLocation.errorExplanation!);
      }
    }
  }

  void locateToItemInTheListView(int index) {
    final double width = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;
    _scrollController.animateTo(width * index,
        duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
    //_scrollController.jumpTo(_width * index);
  }

  void showCurrentLocationWeatherData() {
    Provider.of<Locations>(context, listen: false)
        .changeSelectedLocation(0, locateWeatherList: true);
  }

  @override
  Widget build(BuildContext context) {
    /*print(
        'MediaQuery.of(context).orientation : ${MediaQuery.of(context).orientation}');
    print(
        'MediaQuery.of(context).size.height : ${MediaQuery.of(context).size.height}');
    print(
        'MediaQuery.of(context).size.width : ${MediaQuery.of(context).size.width}');
    print(
        'MediaQuery.of(context).padding.top : ${MediaQuery.of(context).padding.top}');
    print(
        'MediaQuery.of(context).padding.bottom : ${MediaQuery.of(context).padding.bottom}');
    print(
        'MediaQuery.of(context).padding.left : ${MediaQuery.of(context).padding.left}');
    print(
        'MediaQuery.of(context).padding.right : ${MediaQuery.of(context).padding.right}');
    print(
        'MediaQuery.of(context).viewInsets.bottom : ${MediaQuery.of(context).viewInsets.bottom}');
    print(
        'MediaQuery.of(context).viewInsets.top : ${MediaQuery.of(context).viewInsets.top}');
    print(
        'MediaQuery.of(context).viewInsets.left : ${MediaQuery.of(context).viewInsets.left}');
    print(
        'MediaQuery.of(context).viewInsets.right : ${MediaQuery.of(context).viewInsets.right}');
    print(
        'MediaQuery.of(context).viewPadding.top : ${MediaQuery.of(context).viewPadding.top}');
    print(
        'MediaQuery.of(context).viewPadding.bottom : ${MediaQuery.of(context).viewPadding.bottom}');
    print(
        'MediaQuery.of(context).viewPadding.left : ${MediaQuery.of(context).viewPadding.left}');
    print(
        'MediaQuery.of(context).viewPadding.right : ${MediaQuery.of(context).viewPadding.right}');*/

    Color borderColor = Colors.transparent;

    double availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    double availableWidth = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;

    int selectedIndex = context.read<Locations>().selectedLocationIndex;

    _scrollController =
        ScrollController(initialScrollOffset: availableWidth * selectedIndex);

    return !context.watch<Locations>().deviceLocationEnabled
        ? SpinnerCircleWithScaffold()
        : Scaffold(
            //bottomNavigationBar: Text(''),
            body: Container(
              decoration: AppConfiguration.appBackgroundBoxDecoration,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: availableHeight,
                    child: !context
                            .watch<Locations>()
                            .initialDataGatheringCompleted
                        ? SpinnerCircle()
                        : Column(
                            children: [
                              _buildSelectableLocations(
                                  borderColor, context, selectedIndex),
                              _buildWeatherInfoForAllLocations(
                                  context, selectedIndex),
                            ],
                          ),
                  ),
                ),
              ),
            ),
            //persistentFooterButtons: [],
          );
  }

  Expanded _buildWeatherInfoForAllLocations(
      BuildContext context, int selectedIndex) {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: context.read<Locations>().locations.length,
        physics: PageScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return VisibilityDetector(
            key: Key(index.toString()),
            onVisibilityChanged: (VisibilityInfo info) {
              if (info.visibleFraction == 1) {
                int selectedLocationIndex = selectedIndex;
                if (selectedLocationIndex != index) {
                  context.read<Locations>().changeSelectedLocation(index);
                }
              }
            },
            child: Row(
              children: [
                WeatherForLocationsWidget(index: index),
                /*Container(
                                    child: SizedBox(
                                      width: 0.0,
                                    ),
                                  ),*/
              ],
            ),
          );
        },
      ),
    );
  }

  Container _buildSelectableLocations(
      Color borderColor, BuildContext context, int selectedIndex) {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(border: Border.all(color: borderColor)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15.0),
                    ),
                  ),
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => AddLocation(),
                );
              },
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Color(0xFFCCCCCC),
                    ),
                  ),
                  height: 40.0,
                  width: 40.0,
                  child: Icon(Platform.isIOS ? CupertinoIcons.add : Icons.add,
                      size: 30.0)),
            ),
            SizedBox(width: 4.0),
            Expanded(
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(style: BorderStyle.none)),
                height: 40.0,
                //width: 305.0,
                child: LocationItemListWidget(),
              ),
            ),
            SizedBox(width: 4.0),
            GestureDetector(
              onTap: showCurrentLocationWeatherData,
              child: Container(
                  decoration: BoxDecoration(
                    color: (selectedIndex == 0)
                        ? Theme.of(context).primaryColor.withOpacity(0.8)
                        : Color(0xFF65ACFE),
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Color(0xFFCCCCCC),
                    ),
                  ),
                  height: 40.0,
                  width: 40.0,
                  child: Icon(
                      Platform.isIOS
                          ? CupertinoIcons.location_fill
                          : Icons.near_me,
                      color: (selectedIndex == 0)
                          ? Color(0xBB5F8AF5)
                          : Theme.of(context).primaryColor.withOpacity(0.8),
                      size: 30.0)),
            ),
          ],
        ),
      ),
    );
  }
}
