import 'package:flutter/material.dart';

class CustomTextField2 extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final IconData icon;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final String? text;
  final bool isEnabled;

  const CustomTextField2({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.keyboardType,
    required this.icon,
    this.validator,
    this.onSaved,
    this.text,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: isEnabled,
      initialValue: text,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
