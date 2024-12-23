import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_me_flutter/states/locations.dart';
import 'package:weather_me_flutter/screens/locations_and_weather_screen/widgets/location_item_widget.dart';

class LocationItemListWidget extends StatefulWidget {
  const LocationItemListWidget({super.key});

  @override
  _LocationItemListWidgetState createState() => _LocationItemListWidgetState();
}

class _LocationItemListWidgetState extends State<LocationItemListWidget> {
  late ScrollController _scrollController;
  final GlobalKey<AnimatedListState> listKey = GlobalKey();
  final double _width = 135;

  @override
  void initState() {
    super.initState();

    context
        .read<Locations>()
        .setLocateToItemInTheLocationListView(locateToItemInTheListView);

    context
        .read<Locations>()
        .setAddLocationToAnimatedList(addLocationToAnimatedList);

    context
        .read<Locations>()
        .setDeleteLocationFromAnimatedList(deleteLocationFromAnimatedList);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void locateToItemInTheListView(int index) {
    _scrollController.animateTo(_width * index,
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
    //scrollController.jumpTo(_width * index);
  }

  Widget buildAnimatedListItem(item, [selectedLocationIndex, int? index]) {
    return LocationItemWidget(
      locationName: item.locationName,
      locationIndex: index,
      selected: (selectedLocationIndex == index) ? true : false,
    );
  }

  void addLocationToAnimatedList() {
    listKey.currentState!.insertItem(
        context.read<Locations>().locations.length - 1,
        duration: Duration(milliseconds: 1500));
  }

  void deleteLocationFromAnimatedList(var removedItem, int index) {
    listKey.currentState!.removeItem(
      index,
      (context, animation) {
        return FadeTransition(
          opacity:
              CurvedAnimation(parent: animation, curve: Interval(0.5, 1.0)),
          child: SizeTransition(
            sizeFactor:
                CurvedAnimation(parent: animation, curve: Interval(0.0, 1.0)),
            axisAlignment: 0.0,
            child: buildAnimatedListItem(removedItem),
          ),
        );
      },
      duration: Duration(milliseconds: 600),
    );
  }

  @override
  Widget build(BuildContext context) {
    int len = context.read<Locations>().locations.length;
    int selectedIndex = context.read<Locations>().selectedLocationIndex;
    _scrollController =
        ScrollController(initialScrollOffset: _width * selectedIndex);

    return AnimatedList(
      key: listKey,
      physics: NeverScrollableScrollPhysics(),
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      initialItemCount: len,
      itemBuilder: (context, index, animation) {
        return FadeTransition(
          opacity: animation,
          child: buildAnimatedListItem(
              context.read<Locations>().locations[index], selectedIndex, index),
        );
      },
    );
  }
}
