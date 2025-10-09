import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app/colors.dart';
import 'package:health_app/controller/upload_article_controller.dart';
import 'package:health_app/utils/app_colors.dart';
import 'package:health_app/widgets/catigories_drop_menu.dart';
import 'package:health_app/widgets/pick_image_widget.dart';
import 'package:health_app/models/article_model.dart';

class EditArticleScreen extends StatelessWidget {
  final ArticleModel article = Get.arguments; // 👈 Retrieve the passed article

  EditArticleScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ArticleController controller = Get.put(ArticleController());

    // Initialize fields with the existing article data
    controller.titleController.text = article.title;
    controller.descController.text = article.description;
    controller.selectedCategory = article.category;
    controller.imageUrl = article.imageURL;

    return Scaffold(
      appBar: AppBar(
            backgroundColor: AppColors.bacgroundColor2,
            iconTheme: const IconThemeData(
              color: primary, //change your color here
            ),
            title: Text(
              'تعديل',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: primary, fontSize: 24),
            ),
           
          ),
      
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 5,
              children: [
                ArticleImagePicker(
                  initialImageUrl: controller.imageUrl,
                  onImagePicked: (image) {
                    controller.imageFile = image;
                  },
                ),
                const SizedBox(height: 16),

                /// القائمة المنسدلة
                CategoryDropdown(
                  selectedCategory: controller.selectedCategory,
                  onChanged: (value) {
                    controller.selectedCategory = value;
                  },
                ),

                const SizedBox(height: 16),
                TextField(
                  controller: controller.titleController,
                  decoration: InputDecoration(
                    hintText: "عنوان المقال",
                    filled: true,
                    fillColor: const Color(0xFFEDF3F2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller.descController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: "الوصف",
                    filled: true,
                    fillColor: const Color(0xFFEDF3F2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 20),

                SafeArea(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A7A75),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.updateArticle(article.id),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "تعديل المقال",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
