import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../models/article_model.dart';
import '../../models/user.dart';

class AdminHomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var userPicture = ''.obs;
  var name = ''.obs;
  var articlesList = <ArticleModel>[].obs;
  static Rx<UserModel?> doctor = Rx<UserModel?>(null);

 

  // @override
  // void onReady() {
  //   // يتم تنفيذها كل مرة الشاشة تفتح
  //   getUserData();
  //   super.onReady();
  // }

  Future<void> getUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    var userData = await _firestore.collection('users').doc(user.uid).get();

    if (userData.data() != null) {
      doctor.value = UserModel.fromJson(userData.data()!, user.uid);
      userPicture.value = userData.data()!['avatar'];
      name.value = userData.data()!['fullname'];
    }

    var userArticles = await _firestore.collection('articles').get();
    articlesList.clear();
    for (var article in userArticles.docs) {
      if (article.id.contains(user.uid)) {
        articlesList
            .add(ArticleModel.fromFirestore(article.data(), article.id));
      }
    }
  }

  String formatTimestamp(String date) {
    DateTime today = DateTime.parse(date);
    return "${today.day}-${today.month}-${today.year}";
  }
}
