import 'package:flutter/material.dart';

class StyleSettings {
  static TextStyle mainIconSize(BuildContext context) {
    int deviceHeight = findDeviceHeightAsPortrait(context);

    if (deviceHeight > 800) {
      return TextStyle(fontSize: 120.0);
    } else if (deviceHeight > 600) {
      return TextStyle(fontSize: 90.0);
    } else if (deviceHeight > 500) {
      return TextStyle(fontSize: 60.0);
    } else {
      return TextStyle(fontSize: 40.0);
    }
  }

  static TextStyle mainTemperatureSize(BuildContext context) {
    int deviceHeight = findDeviceHeightAsPortrait(context);

    if (deviceHeight > 800) {
      return TextStyle(fontSize: 100.0);
    } else if (deviceHeight > 600) {
      return TextStyle(fontSize: 80.0);
    } else if (deviceHeight > 500) {
      return TextStyle(fontSize: 50.0);
    } else {
      return TextStyle(fontSize: 40.0);
    }
  }

  static TextStyle smallSizeText(BuildContext context) {
    int deviceHeight = findDeviceHeightAsPortrait(context);

    if (deviceHeight > 800) {
      return TextStyle(fontSize: 25.0);
    } else if (deviceHeight > 600) {
      return TextStyle(fontSize: 20.0);
    } else if (deviceHeight > 500) {
      return TextStyle(fontSize: 15.0);
    } else {
      return TextStyle(fontSize: 13.0);
    }
  }

  static TextStyle mediumSizeText(BuildContext context) {
    int deviceHeight = findDeviceHeightAsPortrait(context);

    if (deviceHeight > 800) {
      return TextStyle(fontSize: 23.0);
    } else if (deviceHeight > 600) {
      return TextStyle(fontSize: 20.0);
    } else if (deviceHeight > 500) {
      return TextStyle(fontSize: 17.0);
    } else {
      return TextStyle(fontSize: 14.0);
    }
  }

  static int findDeviceHeightAsPortrait(BuildContext context) {
    double deviceHeight;
    int deviceHeightRounded;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      deviceHeight = MediaQuery.of(context).size.height;
    } else {
      deviceHeight = MediaQuery.of(context).size.width;
    }

    deviceHeightRounded = int.parse(deviceHeight.toStringAsFixed(0));

    return deviceHeightRounded;
  }
}
