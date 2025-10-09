import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_app/models/article_model.dart';
import 'package:health_app/utils/app_route.dart';

class CategoryItem extends StatefulWidget {
  final String id;
  final String imageURL;
  final String title;
  final String description;

  const CategoryItem(
      {super.key,
      required this.id,
      required this.imageURL,
      required this.title,
      required this.description});
  @override
  State<StatefulWidget> createState() {
    return CategoryItemState();
  }
}

class CategoryItemState extends State<CategoryItem> {
  List<ArticleModel> articlesList = [];

  getArticles() async {
    var response = await FirebaseFirestore.instance
        .collection('articles')
        .orderBy('date', descending: true)
        .get();
    for (var article in response.docs) {
      if (article.data()['category'] == widget.title) {
        articlesList
            .add(ArticleModel.fromFirestore(article.data(), article.id));
      }
    }
    setState(() {
      articlesList;
    });
  }

  void selectCategory(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(AppRoute.categoryDetails, arguments: {
      'id': widget.id,
      'title': widget.title,
      'imageURL': widget.imageURL,
      'description': widget.description,
      'articlesList': articlesList
    });
  }

  @override
  void initState() {
    getArticles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectCategory(context),
      borderRadius: BorderRadius.circular(15),
      splashColor: const Color(0xFF197278),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image(
              image: NetworkImage(widget.imageURL),
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15)),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          )
        ],
      ),
    );
  }
}
