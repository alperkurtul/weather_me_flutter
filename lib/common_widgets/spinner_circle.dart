import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpinnerCircle extends StatelessWidget {
  final double spinnerSize;

  const SpinnerCircle({super.key, this.spinnerSize = 70});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitCircle(
        color: Colors.white,
        size: spinnerSize,
      ),
    );
  }
}
