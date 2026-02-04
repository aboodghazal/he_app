import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/article_model.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var userPicture = ''.obs;
  var name = ''.obs;
  var isLoading = true.obs;
  var articlesList = <ArticleModel>[].obs;
  var userSubscriptions = <String>[].obs;

  User? get user => _auth.currentUser;

  @override
  void onInit() {
    super.onInit();
    // loadData();
    getUserData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    await getUserSubscriptions();
    await getArticles();
    isLoading.value = false;
  }

  Future<void> getUserData() async {
    try {
      final doc = await _firestore.collection('users').doc(user!.uid).get();
      userPicture.value = doc['avatar'];
      name.value = doc['fullname'];
    } catch (e) {
      print('Error getting user data: $e');
    }
  }

  Future<void> getUserSubscriptions() async {
    try {
      userSubscriptions.clear();
      final response = await _firestore.collection('usersSubscriptions').get();

      for (var subscription in response.docs) {
        if (subscription.id.contains(user!.uid) ||
            subscription.id == user!.uid) {
          final data = subscription.data();
          for (var value in data.values) {
            if (value is String && value.isNotEmpty) {
              userSubscriptions.add(value);
            }
          }
        }
      }
      print("User subscriptions: ${userSubscriptions.length}");
    } catch (e) {
      print('Error getting subscriptions: $e');
    }
  }

  Future<void> getArticles() async {
    try {
      if (userSubscriptions.isEmpty) {
        articlesList.clear();
        return;
      }

      final response = await _firestore
          .collection('articles')
          .where('category', whereIn: userSubscriptions)
          .get();

      articlesList.value = response.docs
          .map((doc) => ArticleModel.fromFirestore(doc.data(), doc.id))
          .toList();
      print("Articles loaded: ${articlesList.length}");
    } catch (e) {
      print('Error getting articles: $e');
    }
  }

  String formatTimestamp(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }
}
