import 'package:flutter/material.dart';
import 'package:weather_me_flutter/common_widgets/spinner_circle.dart';
import 'package:weather_me_flutter/utilities/app_configuration.dart';

class SpinnerCircleWithScaffold extends StatefulWidget {
  const SpinnerCircleWithScaffold({super.key});

  @override
  _SpinnerCircleWithScaffold createState() => _SpinnerCircleWithScaffold();
}

class _SpinnerCircleWithScaffold extends State<SpinnerCircleWithScaffold> {
  @override
  Widget build(BuildContext context) {
    double availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Container(
        decoration: AppConfiguration.appBackgroundBoxDecoration,
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(height: availableHeight, child: SpinnerCircle()),
          ),
        ),
      ),
    );
  }
}
