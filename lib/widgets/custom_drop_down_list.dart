import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_app/colors.dart';
import 'package:dropdown_search/dropdown_search.dart';

class CustomDropDownList extends StatefulWidget {
  final String? Function(Object?)? validator;
  final String hint;
  final String label;
  var selectedValue;
  final void Function(String?)? onSaved;

  CustomDropDownList(
      {super.key,
      this.validator,
      required this.hint,
      required this.label,
      required this.onSaved});

  @override
  State<StatefulWidget> createState() {
    return CustomDropDownListState();
  }
}

class CustomDropDownListState extends State<CustomDropDownList> {
  List<String> categoriesList = [];

  var collectionReference = FirebaseFirestore.instance.collection('categories');

  getData() async {
    var response = await collectionReference.get();
    for (var category in response.docs) {
      setState(() {
        categoriesList.add(category.data()['name']);
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownSearch<String>(
        onSaved: widget.onSaved,
        validator: widget.validator,
        popupProps: const PopupProps.menu(
          showSelectedItems: true,
        ),
        items: (filter, loadProps) => categoriesList,
        decoratorProps: DropDownDecoratorProps(
          // ✅ fixed class name
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: primary,
                width: 2,
              ),
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            label: Container(
              margin: const EdgeInsets.symmetric(horizontal: 9),
              child: Text(widget.label),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w500,
              color: primary,
            ),
            hintText: widget.hint,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(
                color: primary,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
