import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:health_app/colors.dart';

class Spinner extends StatelessWidget {
  const Spinner({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: background2,
        body: Center(
      child: SpinKitPouringHourGlassRefined(
        color: Color(0xFF106865),
        size: 150.0,
      ),
    ));
  }
}
