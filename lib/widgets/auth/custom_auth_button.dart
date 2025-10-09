import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/colors.dart';

class CustomAuthButton extends StatelessWidget {
  final String tital;
  final Color? color;
  final void Function()? onPressed;

  const CustomAuthButton(this.tital, this.onPressed, {super.key, this.color = primary});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: color,
      textColor: Colors.white,
      padding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25)
      ),
      child: Text(tital,
      style: const TextStyle(
        fontSize: 22
      ),),
    );
  }
}
