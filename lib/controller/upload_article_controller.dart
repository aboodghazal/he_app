import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app/controller/admin_home_controller.dart';
import 'package:health_app/utils/app_route.dart';

class ArticleController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  String? selectedCategory;
  File? imageFile;
  String? imageUrl; // Added field for existing image URL

  var isLoading = false.obs;

  /// رفع مقال جديد
  Future<void> uploadArticle() async {
    if (titleController.text.isEmpty ||
        descController.text.isEmpty ||
        selectedCategory == null) {
      Get.snackbar("خطأ", "الرجاء إدخال جميع البيانات");
      return;
    }

    try {
      isLoading.value = true;

      String? uploadedImageUrl;
      if (imageFile != null) {
        uploadedImageUrl = await _uploadImage(imageFile!);
      }

      final now = DateTime.now().toIso8601String();

      if (AdminHomeController.doctor.value != null) {
        await FirebaseFirestore.instance
            .collection("articles")
            .doc("${AdminHomeController.doctor.value?.id}$now")
            .set({
          "title": titleController.text.trim(),
          "description": descController.text.trim(),
          "writer": AdminHomeController.doctor.value?.fullname ?? "",
          "category": selectedCategory,
          "imageURL": uploadedImageUrl,
          "date": now,
        });

        Get.offNamed(AppRoute.adminHomePage);
        Get.snackbar("تم", "تمت إضافة المقال بنجاح");
        clearForm();
      } else {
        Get.snackbar("خطأ", "فشل رفع المقال");
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل رفع المقال: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// تحديث مقال موجود
  Future<void> updateArticle(String articleId) async {
    if (titleController.text.isEmpty ||
        descController.text.isEmpty ||
        selectedCategory == null) {
      Get.snackbar("خطأ", "الرجاء إدخال جميع البيانات");
      return;
    }

    try {
      isLoading.value = true;

      String? newImageUrl = imageUrl; // keep the old one by default

      // إذا تم اختيار صورة جديدة
      if (imageFile != null) {
        newImageUrl = await _uploadImage(imageFile!);
      }

      await FirebaseFirestore.instance
          .collection("articles")
          .doc(articleId)
          .update({
        "title": titleController.text.trim(),
        "description": descController.text.trim(),
        "category": selectedCategory,
        "imageURL": newImageUrl,
      });

      Get.offNamed(AppRoute.adminHomePage);
// العودة بعد التعديل
      Get.snackbar("تم", "تم تعديل المقال بنجاح");
    } catch (e) {
      Get.snackbar("خطأ", "فشل تعديل المقال: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// رفع صورة إلى Firebase Storage
  Future<String> _uploadImage(File file) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child("articlesImages/${DateTime.now().millisecondsSinceEpoch}.jpg");
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  /// تنظيف البيانات بعد الإضافة
  void clearForm() {
    titleController.clear();
    descController.clear();
    selectedCategory = null;
    imageFile = null;
    imageUrl = null;
  }
  }
