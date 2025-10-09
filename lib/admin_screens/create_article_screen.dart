import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app/controller/upload_article_controller.dart';
import 'package:health_app/widgets/catigories_drop_menu.dart';
import 'package:health_app/widgets/pick_image_widget.dart';

class CreateArticleScreen extends StatelessWidget {
  const CreateArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ArticleController controller = Get.put(ArticleController());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ArticleImagePicker(
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
                        : () => controller.uploadArticle(),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("إضافة المقال",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
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
