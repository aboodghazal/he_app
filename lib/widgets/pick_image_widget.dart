import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ArticleImagePicker extends StatefulWidget {
  final void Function(File image) onImagePicked;
  final String? initialImageUrl;
  final bool isVideoUpload; // ✅ New parameter for existing image

  const ArticleImagePicker(
      {super.key,
      required this.onImagePicked,
      this.initialImageUrl,
      this.isVideoUpload = false});

  @override
  State<ArticleImagePicker> createState() => _ArticleImagePickerState();
}

class _ArticleImagePickerState extends State<ArticleImagePicker> {
  File? _imageFile;
  late String? _networkImageUrl;

  @override
  void initState() {
    super.initState();
    _networkImageUrl = widget.initialImageUrl;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _networkImageUrl = null; // ✅ Remove old network image
      });
      widget.onImagePicked(_imageFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFEDF3F2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.teal.withOpacity(0.5)),
        ),
        child: _buildImageContent(),
      ),
    );
  }

  Widget _buildImageContent() {
    if (_imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          _imageFile!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    if (_networkImageUrl != null && _networkImageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          _networkImageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo_outlined, color: Color(0xFF80AFAD), size: 40),
        SizedBox(height: 8),
        Text(
          widget.isVideoUpload
              ? "اضافة صورة الفيديو المصغرة"
              : "إضافة صورة للمقال",
          style: TextStyle(color: Color(0xFF80AFAD)),
        ),
      ],
    );
  }
}
