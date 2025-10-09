import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:health_app/controller/admin_home_controller.dart';
import 'package:health_app/utils/app_route.dart';
import 'package:image_picker/image_picker.dart';

class UploadVideoController extends GetxController {
  final ImagePicker imagePicker = ImagePicker();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  var articleImage = ''.obs;
  var videoName = 'لم يتم اختيار فيديو'.obs;
  var videoURL = ''.obs;
  var isLoading = false.obs;

  File? imageFile;
  PlatformFile? selectedVideo;

  var doctorName = ''.obs;
  var doctorSpecialization = '';

  @override
  void onInit() {
    super.onInit();
    if (AdminHomeController.doctor.value != null) {
      doctorName.value = AdminHomeController.doctor.value!.fullname;
    }
  }

  /// Upload image to Firebase Storage
  Future<String> _uploadImage(File file) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child("articlesImages/${DateTime.now().millisecondsSinceEpoch}.jpg");
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  /// Select a video from device
  Future<void> selectVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null && result.files.isNotEmpty) {
      selectedVideo = result.files.first;
      videoName.value = selectedVideo!.name;
    }
  }

  /// Uploads video file to Firebase and returns its URL
  Future<String?> uploadVideoToFirebase() async {
    if (selectedVideo == null) return null;
    try {
      final file = File(selectedVideo!.path!);
      final ref = FirebaseStorage.instance
          .ref()
          .child('videos/${user!.uid}_${selectedVideo!.name}');
      final uploadTask = await ref.putFile(file);
      final url = await uploadTask.ref.getDownloadURL();
      videoURL.value = url;
      return url;
    } catch (e) {
      Get.snackbar("خطأ", "فشل رفع الفيديو: $e");
      return null;
    }
  }

  /// Update existing video document in Firestore
  Future<void> updateVideo({
    required String docId,
    required String title,
    required String description,
    required String category,
  }) async {
    if (title.isEmpty || description.isEmpty) {
      Get.snackbar("تنبيه", "الرجاء إدخال عنوان ووصف للفيديو");
      return;
    }

    isLoading.value = true;
    try {
      // Upload new image if selected
      String? newImageUrl = articleImage.value;
      if (imageFile != null) {
        newImageUrl = await _uploadImage(imageFile!);
      }

      // Upload new video if selected
      String? newVideoUrl = videoURL.value;
      if (selectedVideo != null) {
        newVideoUrl = await uploadVideoToFirebase();
      }

      final Map<String, dynamic> updatedData = {
        'title': title,
        'description': description,
        'videoURL': newVideoUrl,
        'imageURL': newImageUrl,
        'category': category,
        'date': DateTime.now().toString(),
      };

      await fireStore.collection('articles').doc(docId).update(updatedData);

      Get.snackbar("تم بنجاح", "تم تحديث الفيديو بنجاح");
      Get.offNamed(AppRoute.adminHomePage);
    } catch (e) {
      Get.snackbar("خطأ", "فشل تحديث الفيديو: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Upload a brand-new video (used in add-video flow)
  Future<void> uploadVideo(String title, String description) async {
    if (title.isEmpty || description.isEmpty) {
      Get.snackbar("تنبيه", "الرجاء إدخال عنوان ووصف للفيديو");
      return;
    }

    if (imageFile == null || selectedVideo == null) {
      Get.snackbar("تنبيه", "الرجاء اختيار صورة وفيديو قبل الرفع");
      return;
    }

    isLoading.value = true;
    try {
      // Upload image
      final imageUrl = await _uploadImage(imageFile!);

      // Upload video
      final videoUrl = await uploadVideoToFirebase();
      if (videoUrl == null) return;

      final t = DateTime.now().toString();
      await fireStore.collection('articles').doc('${user!.uid}_$t').set({
        'title': title,
        'description': description,
        'videoURL': videoUrl,
        'imageURL': imageUrl,
        'category': doctorSpecialization,
        'writer': doctorName.value,
        'date': t,
        'doctorId': user!.uid,
      });

      Get.snackbar("تم بنجاح", "تم رفع الفيديو بنجاح");
      Get.offNamed(AppRoute.adminHomePage);
    } catch (e) {
      Get.snackbar("خطأ", "فشل رفع الفيديو: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
