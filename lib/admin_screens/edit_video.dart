import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:health_app/colors.dart';
import 'package:health_app/controller/video_uploader.dart';
import 'package:health_app/utils/app_route.dart';
import 'package:health_app/widgets/catigories_drop_menu.dart';
import 'package:health_app/models/article_model.dart';
import 'package:health_app/widgets/pick_image_widget.dart';

class EditVideoWidget extends StatelessWidget {
  final UploadVideoController controller = Get.put(UploadVideoController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ArticleModel article = Get.arguments;

  EditVideoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Prefill from article model
    controller.articleImage.value = article.imageURL ?? '';
    controller.videoURL.value = article.videoURL ?? '';
    controller.videoName.value =
        article.videoURL != null ? article.videoURL!.split('/').last : '';
    controller.doctorSpecialization = article.category;

    final titleController = TextEditingController(text: article.title);
    final descriptionController =
        TextEditingController(text: article.description);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: [
              const SizedBox(height: 10),

              /// Thumbnail picker
              ArticleImagePicker(
                initialImageUrl: controller.articleImage.value,
                isVideoUpload: true,
                onImagePicked: (image) {
                  controller.imageFile = image;
                },
              ),

              /// Title & description
              Form(
                key: formKey,
                child: Column(
                  spacing: 10,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        filled: true,
                        fillColor: primary.shade50,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: primary.shade300, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: primary.shade300, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: 'عنوان الفيديو',
                        hintStyle: const TextStyle(
                            fontSize: 22, color: Colors.blueGrey),
                      ),
                    ),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 10,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        filled: true,
                        fillColor: primary.shade50,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: primary.shade300, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: primary.shade300, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: 'الوصف',
                        hintStyle: const TextStyle(
                            fontSize: 22, color: Colors.blueGrey),
                      ),
                    ),
                  ],
                ),
              ),

              /// Category dropdown
              CategoryDropdown(
                selectedCategory: controller.doctorSpecialization,
                onChanged: (value) {
                  controller.doctorSpecialization = value ?? "";
                },
              ),

              /// Video picker
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: MaterialButton(
                      onPressed: controller.selectVideo,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 17.5),
                      color: primary.shade400,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: const Text(
                        'تحديث الفيديو',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 3,
                    child: Obx(
                      () => Text(
                        controller.videoName.value,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 20, color: Colors.blueGrey),
                      ),
                    ),
                  ),
                ],
              ),

              /// Update button
              SafeArea(
                child: Obx(
                  () => MaterialButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                            final title = titleController.text.trim();
                            final description =
                                descriptionController.text.trim();

                            if (title.isEmpty || description.isEmpty) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                title: 'تحقق من الحقول',
                                desc:
                                    'يرجى التأكد من ملء جميع الحقول المطلوبة قبل التحديث.',
                                btnOkOnPress: () {},
                                titleTextStyle: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                descTextStyle: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                              ).show();
                              return;
                            }

                            // Upload new video if user picked one
                            String? newVideoURL;
                            if (controller.selectedVideo != null) {
                              newVideoURL =
                                  await controller.uploadVideoToFirebase();
                            }

                            await controller.updateVideo(
                              docId: article.id,
                              title: title,
                              description: description,
                              category: controller.doctorSpecialization,
                            );
                          },
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 17.5),
                    color: primary.shade400,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'تحديث الفيديو',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.white),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
