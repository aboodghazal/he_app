import 'package:flutter/material.dart';

import '../../colors.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool isEnabled;
  final void Function()? onTap;
  final void Function(String?)? onSaved;
  final String? text;
  const CustomTextField({super.key, required this.labelText, required this.hintText, required this.keyboardType, required this.icon,  this.obscureText = false , required this.validator, this.isEnabled = true, this.onTap,required this.onSaved, required this.text});
  @override
  State<StatefulWidget> createState() {
    return CustomTextFieldState();
  }
}

class CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          onTap: widget.onTap,
          enabled: widget.isEnabled,
          onSaved: widget.onSaved,
          validator: widget.validator,
          obscureText: widget.obscureText,
          cursorColor: primary,
          initialValue: widget.text,
          autocorrect: false,
          keyboardType: widget.keyboardType,
          textAlign: TextAlign.right,
          autofocus: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(
                  color: primary,
                )
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(
                    color: primary,
                    width: 2
                )
            ),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(
                    color: Color(0xFFE57373),
                    width: 2
                )
            ),
            label: Container(
                margin: const EdgeInsets.symmetric(horizontal: 9),
                child: Text(widget.labelText, style: const TextStyle(
                    color: primary
                ),)),
            suffixIcon: Icon(widget.icon, color: primary ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            labelStyle: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: widget.hintText,
          ),
        )
    );
  }
}