import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app/colors.dart';
import 'package:health_app/models/article_model.dart';
import '../utils/app_route.dart';

class AdminArticleView extends StatelessWidget {
  final ArticleModel article;
  final Function delete;

  const AdminArticleView({super.key, required this.article,required this.delete});

 
  @override
  Widget build(BuildContext context) {
    print(article.imageURL);
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFFEBF1F0),
      ),
      padding: const EdgeInsets.only(left: 10),
      height: 115,
      child: Row(
        children: [
          // 🖼️ Article Image
          Expanded(
            flex: 3,
            child: Container(
              height: 115,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                child: Image.network(
                  article.imageURL ?? "",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 40, color: primary),
                ),
              ),
            ),
          ),

          // 📝 Title + Description
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    article.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // 🗑️ Edit + Delete Buttons
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Delete
                GestureDetector(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
                      title: 'حذف المقالة',
                      titleTextStyle: const TextStyle(fontSize: 22),
                      desc: 'هل تريد حذف المقالة؟',
                      btnCancelOnPress: () async {
                        delete();
                      },
                      btnOkText: 'إلغاء',
                      btnCancelText: 'حذف',
                      btnOkOnPress: () {},
                    ).show();
                  },
                  child: const Icon(
                    Icons.delete,
                    size: 28,
                    color: Colors.red,
                  ),
                ),

                // Edit
                GestureDetector(
                  onTap: () {
                    if (article.isVideo) {
                      Get.toNamed(
                        AppRoute.editvideo,
                        arguments: article, // 👈 Pass full article model
                      );
                    } else {
                      Get.toNamed(
                        AppRoute.editArticle,
                        arguments: article, // 👈 Pass full article model
                      );
                    }
                  },
                  child: const Icon(
                    Icons.edit,
                    size: 28,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
