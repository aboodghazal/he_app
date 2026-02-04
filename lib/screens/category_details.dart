import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_app/colors.dart';
import 'package:health_app/models/article_model.dart';
import 'package:health_app/screens/article.dart';
import 'package:health_app/widgets/chat/chat_body.dart';

class CategoryDetails extends StatefulWidget {
  const CategoryDetails({super.key});

  @override
  State<StatefulWidget> createState() => CategoryDetailsState();
}

class CategoryDetailsState extends State<CategoryDetails> {
  List<ArticleModel> articlesList = [];
  List doctorsList = [];
  bool isSubscribed = false;
  late String title;
  late String id;
  bool _initialized = false;

  /// ✅ Format timestamp
  String formatTimestamp(String date) {
    DateTime today = DateTime.parse(date);
    return "${today.day}-${today.month}-${today.year}";
  }

  /// ✅ Get doctors that match this category
  Future<void> getDoctors() async {
    var doctors = await FirebaseFirestore.instance.collection('doctors').get();
    doctorsList = doctors.docs
        .where((d) => d.data()['specialization'] == title)
        .toList();
    if (mounted) setState(() {});
  }

  /// ✅ Efficient version — read only this user's subscription doc
  Future<void> getUserSubscriptions() async {
    final docRef = FirebaseFirestore.instance
        .collection('usersSubscriptions')
        .doc(user!.uid);

    final doc = await docRef.get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data()!;
      // Check if any of the values match this category title
      isSubscribed = data.containsValue(title);
    } else {
      isSubscribed = false;
    }

    if (mounted) setState(() {});
  }

  /// ✅ Subscribe user to this category
  Future<void> subscribeToCategory() async {
    final collection = FirebaseFirestore.instance.collection('usersSubscriptions');

    await collection
        .doc(user!.uid)
        .set({id: title}, SetOptions(merge: true));

    AwesomeDialog(
      context: context,
      title: 'لقد قمت بالإشتراك في $title بنجاح',
      dialogType: DialogType.success,
      titleTextStyle: const TextStyle(
          color: primary, fontWeight: FontWeight.w600, fontSize: 20),
      animType: AnimType.bottomSlide,
    ).show();
  }

  /// ✅ Unsubscribe user (delete specific field)
  Future<void> unSubscribeToCategory() async {
    final collection = FirebaseFirestore.instance.collection('usersSubscriptions');
    await collection.doc(user!.uid).update({id: FieldValue.delete()});
  }

  /// ✅ Initialize data after route arguments are ready
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final routeArgument =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

      id = routeArgument['id'];
      title = routeArgument['title'];
      articlesList = routeArgument['articlesList'];

      getUserSubscriptions();
      getDoctors();

      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeArgument =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final categoryImage = routeArgument['imageURL'];
    final categoryDescription = routeArgument['description'];

    return Scaffold(
      backgroundColor: const Color(0xFFE9EFEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12706D),
        title: Text(title),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
        child: FloatingActionButton(
          onPressed: () {
            if (!isSubscribed) {
              setState(() => isSubscribed = true);
              subscribeToCategory();
            } else {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.rightSlide,
                title: 'الغاء الإشتراك',
                titleTextStyle: const TextStyle(fontSize: 22),
                desc: 'هل تريد الغاء الإشتراك في $title ؟',
                btnCancelOnPress: () {
                  setState(() => isSubscribed = false);
                  unSubscribeToCategory();
                },
                btnOkText: 'تراجع',
                btnCancelText: 'الغاء الإشتراك',
                btnOkOnPress: () {},
              ).show();
            }
          },
          backgroundColor: primary.withOpacity(0.85),
          child: Icon(
            Icons.star,
            size: 30,
            color: isSubscribed ? Colors.yellow : Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 235,
            child: Image(fit: BoxFit.cover, image: NetworkImage(categoryImage!)),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'الوصف :',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF197278),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 15),
                  child: Text(
                    categoryDescription!,
                    style: const TextStyle(fontSize: 17.5),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'الأطباء :',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF197278),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  height: 100,
                  child: doctorsList.isEmpty
                      ? const Center(child: Text("لا يوجد أطباء حالياً"))
                      : ListView.builder(
                          itemCount: doctorsList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var doctor = doctorsList[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: CircleAvatar(
                                radius: 32,
                                backgroundImage: NetworkImage(
                                  doctor['avatar'] ??
                                      'https://via.placeholder.com/150',
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'المقالات :',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF197278),
                    ),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: articlesList.length,
                  itemBuilder: (context, index) {
                    return Article(article: articlesList[index]);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
