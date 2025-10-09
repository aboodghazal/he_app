import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/models/category.dart';
import '../app_data.dart';
import '../widgets/category_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/spiner.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<StatefulWidget> createState() {
    return CategoriesState();
  }
}

class CategoriesState extends State<Categories> {
  bool isLoading = false;
  List categoriesList = [];
  var collectionReference = FirebaseFirestore.instance.collection('categories');

  getData() async {
    setState(() {
      isLoading = true;
    });
    var response = await collectionReference.get();
      response.docs.forEach((category) {
        setState(() {
          categoriesList.add(category);
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => isLoading? const Spinner() :
     Scaffold(
      backgroundColor: const Color(0xFFE9EFEF),
      body: GridView.builder(
        itemCount: categoriesList.length,
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 7/8,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
          itemBuilder: (BuildContext context, int index) {
          return CategoryItem(id: categoriesList[index].id.toString(), imageURL: categoriesList[index]['imageURL'], title: categoriesList[index]['name'], description: categoriesList[index]['description']);
          },
      )
    );
  }



