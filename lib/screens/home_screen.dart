import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app/controller/home_controller.dart';
import 'package:health_app/screens/article.dart';
import '../utils/app_colors.dart';
import '../colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    Future.microtask(() => controller.loadData());

    return Scaffold(
      backgroundColor: AppColors.bacgroundColor2,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        child: Column(
          children: [
            // 🔹 Profile Section — rebuilds only once
            Obx(() {
              return Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFB8D4D3), width: 8),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: CircleAvatar(
                      backgroundImage: controller.userPicture.value.isNotEmpty
                          ? NetworkImage(controller.userPicture.value)
                          : const AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                      radius: 40,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مرحبا',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: primary, fontSize: 26),
                      ),
                      Text(
                        controller.name.value,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                              color: const Color(0xFF4D4C4C),
                              fontSize: 24,
                            ),
                      ),
                    ],
                  ),
                ],
              );
            }),

            const SizedBox(height: 20),

            // 🔹 Loading indicator only for article section
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // 🔹 Articles Section — only this part rebuilds when articlesList changes
              return Obx(() {
                if (controller.articlesList.isEmpty) {
                  return const Center(
                    child: Text(
                      "لا توجد مقالات متاحة حاليًا.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.articlesList.length,
                  itemBuilder: (context, index) {
                    final article = controller.articlesList[index];
                    return Article(article: article);
                  },
                );
              });
            }),
          ],
        ),
      ),
    );
  }
}
