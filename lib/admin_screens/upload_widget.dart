import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app/colors.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:health_app/controller/video_uploader.dart';
import 'package:health_app/widgets/catigories_drop_menu.dart';
import 'package:health_app/widgets/pick_image_widget.dart';

class UploadVideoWidget extends StatelessWidget {
  final UploadVideoController controller = Get.put(UploadVideoController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  UploadVideoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            // Thumbnail picker
            SizedBox(
              height: 10,
            ),
            ArticleImagePicker(
              initialImageUrl: controller.articleImage.value,
              isVideoUpload: true,
              onImagePicked: (image) {
                controller.imageFile = image;
              },
            ),
            // Title & description form
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
                      hintStyle:
                          const TextStyle(fontSize: 22, color: Colors.blueGrey),
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
                      hintStyle:
                          const TextStyle(fontSize: 22, color: Colors.blueGrey),
                    ),
                  ),
                ],
              ),
            ),

            /// القائمة المنسدلة
            CategoryDropdown(
              selectedCategory: controller.doctorSpecialization,
              onChanged: (value) {
                controller.doctorSpecialization = value ?? "";
              },
            ),
            // Video picker
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
                      'إختيار الفيديو',
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
                      style:
                          const TextStyle(fontSize: 20, color: Colors.blueGrey),
                    ),
                  ),
                ),
              ],
            ),

            // Upload button
            Obx(
              () => SafeArea(
                child: MaterialButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          final title = titleController.text.trim();
                          final description = descriptionController.text.trim();

                          // Validation check
                          if (title.isEmpty ||
                              description.isEmpty ||
                              controller.doctorSpecialization.isEmpty) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              title: 'تحقق من الحقول',
                              desc:
                                  'يرجى التأكد من ملء جميع الحقول المطلوبة قبل الإضافة.',
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

                          await controller.uploadVideo(title, description);
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
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'إضافة الفيديو',
                              style:
                                  TextStyle(fontSize: 22, color: Colors.white),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}
