import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_app/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_app/widgets/auth/custom_auth_button.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/custom_text_field2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/spiner.dart';
import '../widgets/spinner2.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  late File image;
  final imagePicker = ImagePicker();
  var user = FirebaseAuth.instance.currentUser;
  late String name, email, phone, dateOfBirth;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  late String userPicture = '';
  late String? firebaseName;
  late String? firebaseEmail;
  late String? firebasePhone;
  late String? firebaseDateOfBirth;
  bool isEditingEnabled = false;
  Color color = const Color(0xFF368583);
  String title = 'تعديل الملف الشخصي';
  bool isLoading = false;
  bool isImageLoading = false;
  bool x = true;

  uploadImage() async {
    var pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // var imageName = basename(pickedImage.path);
      image = File(pickedImage.path);
      // upload image to firebase Storage:
      var storageRef = FirebaseStorage.instance.ref('usersImages/${user!.uid}');
      setState(() {
        isImageLoading = true;
      });
      await storageRef.putFile(image);
      // get image url from firebase storage:
        var i =  await storageRef.getDownloadURL();

        setState(() {
          userPicture = i;
          isImageLoading = false;
        });
    }
  }

  getUserData() async {
    setState(() {
      isLoading = true;
    });
    var userRef = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      setState(() {
        userPicture = userRef.data()!['avatar'];
        firebaseName = userRef.data()!['fullname'];
        firebaseEmail = userRef.data()!['email'];
        firebasePhone = userRef.data()!['phone'];
        firebaseDateOfBirth = userRef.data()!['dateOfBirth'];
      });
      setState(() {
        isLoading = false;
      });
  }

  updateProfile() async {
    x = false;
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      x = true;
      fireStore.collection('users').doc(user!.uid).update({
        'fullname': name,
        'email': email,
        'phone': phone,
        'dateOfBirth': dateOfBirth,
        'avatar' : userPicture
      });

      var userAccountType = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      if(userAccountType.data()!['accountType'] == 1) {
        fireStore.collection('doctors').doc(user!.uid).update({
          'fullname': name,
          'email': email,
          'phone': phone,
          'dateOfBirth': dateOfBirth,
          'avatar' : userPicture
        });
        AwesomeDialog(
          context: context,
          title: 'تم تعديل الملف الشخصي بنجاح',
          dialogType: DialogType.success,
          titleTextStyle: const TextStyle(
              color: primary, fontWeight: FontWeight.w600, fontSize: 20),
          animType: AnimType.bottomSlide,
          // desc: 'البريد الإلكتروني غير موجود !! قم بتسجيل حساب جديد',
        ).show();
      } else {
        fireStore.collection('patients').doc(user!.uid).update({
          'fullname': name,
          'email': email,
          'phone': phone,
          'dateOfBirth': dateOfBirth,
          'avatar' : userPicture
        });
        AwesomeDialog(
          context: context,
          title: 'تم تعديل الملف الشخصي بنجاح',
          dialogType: DialogType.success,
          titleTextStyle: const TextStyle(
              color: primary, fontWeight: FontWeight.w600, fontSize: 20),
          animType: AnimType.bottomSlide,
          // desc: 'البريد الإلكتروني غير موجود !! قم بتسجيل حساب جديد',
        ).show();
      }
    } else {
      x = false;
      AwesomeDialog(
        context: context,
        title: 'قم بإدخال جميع الحقول بشكل صحيح !!',
        dialogType: DialogType.warning,
        titleTextStyle: const TextStyle(
            color: primary, fontWeight: FontWeight.w600, fontSize: 20),
        animType: AnimType.bottomSlide,
      ).show();
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => isLoading? const Spinner():
    Scaffold(
      backgroundColor: background2,
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
      ),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              SizedBox(
                  height: 165,
                  width: 165,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      isImageLoading ? Stack(
                        children: [
                          Container(
                            width: 165,
                            height: 165,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                    color: const Color(0xFFB8D4D3), width: 15),
                                color: background2
                            ),
                            child: const Spinner2(),
                          ),
                          Container(
                            width: 165,
                            height: 165,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                    color: const Color(0xFFB8D4D3), width: 15),
                                color: background2.withOpacity(0)
                            ),
                          )
                        ],
                      ) :

                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFFB8D4D3), width: 15),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color(0xffcccbcb), blurRadius: 20)
                            ],
                            borderRadius: BorderRadius.circular(100)),
                        child: CircleAvatar(
                          backgroundColor: primary.shade50,
                          backgroundImage: NetworkImage(userPicture),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 20,
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black45,
                                // border: Border.all(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(50)),
                            height: 45,
                            width: 45,
                            child: TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                )),
                                onPressed: () {
                                  uploadImage();
                                },
                                child: Center(
                                    child: SvgPicture.asset(
                                  'images/camera.svg',
                                  color: Colors.white,
                                  width: 25,
                                  height: 25,
                                )))),
                      ),
                    ],
                  )),
              const SizedBox(height: 40),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField2(
                      labelText: 'الإسم',
                      hintText: 'أدخل إسمك',
                      keyboardType: TextInputType.text,
                      icon: Icons.person_2_outlined,
                      validator: (val) {
                        if ((val?.length)! > 20) {
                          return 'إسم المستخدم طويل جدا';
                        }
                        if ((val?.length)! < 5) {
                          return 'إسم المستخدم قصير جدا ';
                        }
                      },
                      onSaved: (val) {
                        name = val!;
                      },
                      text: firebaseName,
                      isEnabled: isEditingEnabled,
                    ),
                    const SizedBox(height: 40),
                    CustomTextField2(
                      labelText: 'البريد الإلكتروني',
                      hintText: 'أدخل بريدك الإلكتروني',
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email_outlined,
                      validator: (val) {
                        bool emailValid =
                        RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                            .hasMatch(val!);
                        if (!emailValid) {
                          return 'البريد الإلكتروني غير صالح';
                        }
                      },
                      onSaved: (val) {
                        email = val!;
                      },
                      text: firebaseEmail,
                      isEnabled: isEditingEnabled,
                    ),
                    const SizedBox(height: 40),
                    CustomTextField2(
                      labelText: 'رقم الهاتف',
                      hintText: 'أدخل رقم هاتفك',
                      keyboardType: TextInputType.phone,
                      icon: Icons.phone_android_outlined,
                      validator: (val) {
                        if ((val?.length)! > 20) {
                          return 'رقم الهاتف لا يمكن ان يكون أكثر من ٩ أرقام !!';
                        }
                        if ((val?.length)! < 5) {
                          return 'قم بإدخال رقم هاتف صالح';
                        }
                      },
                      onSaved: (val) {
                        phone = val!;
                      },
                      text: firebasePhone,
                      isEnabled: isEditingEnabled,
                    ),
                    const SizedBox(height: 40),
                    CustomTextField2(
                      labelText: 'تاريخ الميلاد',
                      hintText: 'أدخل تاريخ ميلادك',
                      keyboardType: TextInputType.datetime,
                      icon: Icons.date_range_outlined,
                      validator: (val) {
                        if ((val?.length)! > 10 || (val?.length)! < 6) {
                          return 'قم بإدخال التاريخ بشكل صحيح';
                        }
                      },
                      onSaved: (val) {
                        dateOfBirth = val!;
                      },
                      text: firebaseDateOfBirth,
                      isEnabled: isEditingEnabled,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                child: CustomAuthButton(title, color: color, () {
                  setState(() {
                      if (isEditingEnabled == true) {
                        updateProfile();
                        if(x) {
                          isEditingEnabled = false;
                          title = 'تعديل الملف الشخصي';
                          color = const Color(0xFF368583);
                        }
                      } else {
                        isEditingEnabled = true;
                        title = 'حفظ التعديلات';
                        color = const Color(0xFF8a817c);
                      }
                    }
                    // if (isEditingEnabled == true) {
                    // } else {
                    // }
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }