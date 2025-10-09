import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:health_app/colors.dart';

class Spinner2 extends StatelessWidget {
  const Spinner2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: background2,
        body: Center(
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: background2,
              borderRadius: BorderRadius.circular(100)
            ),
            child: SpinKitWave(
              color: primary.shade400,
              size: 45.0,
            ),
          ),
        ));
  }
}
