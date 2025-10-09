import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_app/colors.dart';
import 'package:health_app/models/article_model.dart';
import 'package:health_app/screens/article.dart';
import '../utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  var user = FirebaseAuth.instance.currentUser;
  String userPicture = '';
  String name = '';
  List<ArticleModel> articlesList = [];
  List userSubscriptions = [];

  List<dynamic> alldata = [];

  getUserData() async {
    var userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    setState(() {
      userPicture = userData.data()!['avatar'];
      name = userData.data()!['fullname'];
    });
  }

  getUserSubscriptions() async {
    var response =
        await FirebaseFirestore.instance.collection('usersSubscriptions').get();
    for (var subscription in response.docs) {
      if (subscription.id.contains(user!.uid)) {
        Map<String, dynamic> data = subscription.data();
        for (String value in data.values) {
          if (value.isEmpty) {
            continue;
          }
          userSubscriptions.add(value);
        }
        print("len  ${userSubscriptions.length}");
        getArticles();
      }
    }
  }

  getArticles() async {
    var response = await FirebaseFirestore.instance
        .collection('articles')
        .where('category', whereIn: userSubscriptions)
        .get();
    articlesList = [];
    for (var article in response.docs) {
      articlesList.add(ArticleModel.fromFirestore(article.data(), article.id));
    }
    if (!mounted) {
      setState(() {
        articlesList;
      });
    }
  }

  String formatTimestamp(DateTime date) {
    String dateStr = "${date.day}-${date.month}-${date.year}";
    return dateStr;
  }

  @override
  void initState() {
    getUserSubscriptions();
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bacgroundColor2,
        body: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
          child: ListView(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFFB8D4D3), width: 8),
                            borderRadius: BorderRadius.circular(100)),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(userPicture),
                          radius: 40,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 13),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'مرحبا',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: primary, fontSize: 26),
                              textAlign: TextAlign.right,
                            ),
                            Text(
                              name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      color: Color(0xFF4D4C4C), fontSize: 24),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: articlesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Article(
                    article: articlesList[index],
                  );
                },
              ),
            ],
          ),
        ));
  }
}
