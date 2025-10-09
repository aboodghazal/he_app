import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:health_app/colors.dart';
import 'package:health_app/utils/app_route.dart';
import 'package:image_picker/image_picker.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return UploadVideoScreenState();
  }
}

class UploadVideoScreenState extends State<UploadVideoScreen> {
  var randomVideoID = Random().nextInt(1000000000);
  late File image;
  final imagePicker = ImagePicker();
  String articleImage = '';
  String doctorName = '';
  String doctorSpecialization = '';
  bool x = true;
  late String time;
  late String title, description;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  var user = FirebaseAuth.instance.currentUser;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String videoName = 'لم يتم اختيار فيديو';
  PlatformFile? video;
  UploadTask? uploadTask;
  String? videoURL;

  uploadImage() async {
    var pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // var imageName = basename(pickedImage.path);
      image = File(pickedImage.path);
      // upload image to firebase Storage:
      var t = DateTime.now();
      var storageRef = FirebaseStorage.instance
          .ref('articlesImages/${user!.uid + '%%' + t.toString()}');
      time = t.toString();
      setState(() {
        // isImageLoading = true;
      });
      await storageRef.putFile(image);
      // get image url from firebase storage:
      var i = await storageRef.getDownloadURL();

      setState(() {
        articleImage = i;
        x = false;
        // isImageLoading = false;
      });
    }
  }

  Future selectVideo() async {
    final selectedVideo = await FilePicker.platform.pickFiles();
    setState(() {
      video = selectedVideo?.files.first;
      videoName = video!.name;
    });
  }

  Future uploadVideo() async {
    final path = 'videos/${video!.name}';
    final uploadVideo = File(video!.path!);

    final storageRef = FirebaseStorage.instance.ref().child(path);
    uploadTask = storageRef.putFile(uploadVideo);
    final snapshot = await uploadTask!.whenComplete(() => {
    AwesomeDialog(
    context: context,
    title: 'تم إضافة الفيديو بنجاح',
    dialogType: DialogType.success,
    titleTextStyle: const TextStyle(
    color: primary,
    fontWeight: FontWeight.w600,
    fontSize: 20),
    animType: AnimType.bottomSlide,
    ).show(),

    Future.delayed(const Duration(seconds: 2), () {
    Navigator.pushNamed(context, AppRoute.adminHomePage);
    })
    });

    final url = await snapshot.ref.getDownloadURL();
    videoURL = url;
  }

  getUserData() async {
    // setState(() {
    //   isLoading = true;
    // });
    var userRef = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(user!.uid)
        .get();
    setState(() {
      doctorName = userRef.data()!['fullname'];
      doctorSpecialization = userRef.data()!['specialization'];
    });
    // setState(() {
    //   isLoading = false;
    // });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background2,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                child: GestureDetector(
                    child: Container(
                      width: double.infinity,
                      height: 240,
                      decoration: BoxDecoration(
                        border: Border.all(color: primary.shade300, width: 2),
                        borderRadius: BorderRadius.circular(15),
                        color: primary.shade50,
                        image: DecorationImage(
                            image: NetworkImage(articleImage),
                            fit: BoxFit.cover),
                      ),
                      child: Center(
                        child: x
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 80,
                                    color: primary.shade200,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'إضافة صورة الفيديو المصغرة',
                                    style: TextStyle(
                                        fontSize: 24, color: primary.shade300),
                                  )
                                ],
                              )
                            : const Text(''),
                      ), // button text
                    ),
                    onTap: () {
                      uploadImage();
                    }),

                // GestureDetector(
                //   onTap: () {
                //
                //   },

                // ),
                //
                // Container(
                //   height: 240,
                //   child: const Image(
                //     image: NetworkImage(''),
                //   ),
                // )
              ),
              const SizedBox(height: 20),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        autocorrect: false,
                        onSaved: (val) {
                          title = val!;
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            filled: true,
                            // prefixIcon: Icon(Icons.title, color: primary.shade300, size: 30),
                            fillColor: primary.shade50,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: primary.shade300, width: 2),
                                borderRadius: BorderRadius.circular(15)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: primary.shade300, width: 2),
                                borderRadius: BorderRadius.circular(15)),
                            hintText: 'عنوان الفيديو',
                            hintStyle: const TextStyle(
                              fontSize: 22,
                              color: Colors.blueGrey,
                            )),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        autocorrect: false,
                        onSaved: (val) {
                          description = val!;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          filled: true,
                          // prefixIcon: Icon(Icons.description_outlined, color: primary.shade300, size: 30),
                          fillColor: primary.shade50,
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primary.shade300, width: 2),
                              borderRadius: BorderRadius.circular(15)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primary.shade300, width: 2),
                              borderRadius: BorderRadius.circular(15)),
                          hintText: 'الوصف',
                          hintStyle: const TextStyle(
                            fontSize: 22,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: MaterialButton(
                      onPressed: () {
                        selectVideo();
                      },
                      elevation: 2,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 17.5),
                      color: primary.shade400,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: const Text('إختيار الفيديو', style: TextStyle(
                        color: Colors.white
                      ),),
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    flex: 3,
                    child: Text( video?.name == null ?
                      videoName = 'لم يتم إختيار فيديو' : videoName,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 20, color: Colors.blueGrey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15,),
              MaterialButton(
                onPressed: () {
                  // formKey.currentState!.save();
                  // fireStore
                  //     .collection('articles')
                  //     .doc(user!.uid + '%%' + time.toString())
                  //     .set({
                  //   'category': doctorSpecialization,
                  //   'date': time.toString(),
                  //   'description': description,
                  //   'title': title,
                  //   'imageURL': articleImage,
                  //   'writer': doctorName
                  // });

                  uploadVideo();

                },
                elevation: 2,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 17.5),
                color: primary.shade400,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'إضافة الفيديو',
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
