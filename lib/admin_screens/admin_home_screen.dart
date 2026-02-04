import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app/colors.dart';
import 'package:health_app/controller/admin_home_controller.dart';
import 'package:health_app/models/article_model.dart';
// ignore: unused_import
import 'package:health_app/screens/article.dart';
import '../utils/app_colors.dart';
import '../utils/app_route.dart';
import '../widgets/article_admin_item.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});
  Future<void> deleteArticle(BuildContext context, ArticleModel article) async {
    try {
      // Delete article from Firestore
      await FirebaseFirestore.instance
          .collection('articles')
          .doc(article.id)
          .delete();

      // Delete image from Storage if exists
      if (article.imageURL != null && article.imageURL!.isNotEmpty) {
        final ref = FirebaseStorage.instance.refFromURL(article.imageURL!);
        await ref.delete();
      }

      Get.snackbar("تم الحذف", "تم حذف المقال بنجاح",
          backgroundColor: Colors.green.shade100);
    } catch (e) {
      Get.snackbar("خطأ", "فشل حذف المقال: $e",
          backgroundColor: Colors.red.shade100);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminHomeController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getUserData();
    });
    return Scaffold(
      backgroundColor: AppColors.bacgroundColor2,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoute.createContainer);
        },
        backgroundColor: primary.withOpacity(0.85),
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        child: Column(
          children: [
            SizedBox(
              height: 120,
              child: Obx(() => Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xFFB8D4D3), width: 8),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: CircleAvatar(
                              backgroundImage: controller
                                      .userPicture.value.isNotEmpty
                                  ? NetworkImage(controller.userPicture.value)
                                  : null,
                              radius: 40,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 13),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'مرحبا دكتور',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: primary, fontSize: 22),
                                  textAlign: TextAlign.right,
                                ),
                                Text(
                                  controller.name.value,
                                  style: const TextStyle(
                                      fontSize: 22, color: Color(0xFF4D4C4C)),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  )),
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.articlesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final article = controller.articlesList[index];
                      return AdminArticleView(
                        article: article,
                        delete: () {
                          deleteArticle(context, article);
                          controller.articlesList.remove(article);
                          controller.articlesList.refresh();
                        },
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
