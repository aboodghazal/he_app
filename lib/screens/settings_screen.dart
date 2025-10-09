import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_app/widgets/chat/chat_body.dart';
import 'package:image_picker/image_picker.dart';
import '../colors.dart';
import '../utils/app_route.dart';
import '../widgets/profile_button.dart';
import '../widgets/spiner.dart';

import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return SettingsScreenState();
  }
}

class SettingsScreenState extends State<SettingsScreen> {
  // File? userPicture;
  final imagePicker = ImagePicker();
  bool isLoading = false;
  late String userPicture = '';

  getUserPicture() async {
    var userImage = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    setState(() {
      userPicture = userImage.data()!['avatar'];
    });
  }

  void goToPage(BuildContext ctx, route) {
    Navigator.of(ctx).pushNamed(
      route,
      // arguments: {
      //   'id' : id,
      //   'title' : title,
      //   'imageURL' : imageURL,
      //   'description' : description
      // }
    );
  }

  @override
  void initState() {
    getUserPicture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => isLoading
      ? const Spinner()
      : Scaffold(
          body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                SizedBox(
                  height: 165,
                  width: 165,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFFB8D4D3), width: 15),
                        boxShadow: const [
                          BoxShadow(color: Color(0xffcccbcb), blurRadius: 20)
                        ],
                        borderRadius: BorderRadius.circular(100)),
                    child: CircleAvatar(
                      backgroundColor: primary.shade50,
                      backgroundImage: NetworkImage(userPicture),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                ProfileButton(
                  icon: Icons.person_2_outlined,
                  title: 'ملفي الشخصي',
                  onPressed: () {
                    goToPage(context, AppRoute.profile);
                  },
                  color: const Color(0xFFEDF3F2),
                  titleColor: const Color(0xFF80AFAD),
                ),
                ProfileButton(
                  icon: Icons.notifications_on_outlined,
                  title: 'الإشعارات',
                  onPressed: () {
                  },
                  color: const Color(0xFFEDF3F2),
                  titleColor: const Color(0xFF80AFAD),
                ),
                ProfileButton(
                  icon: Icons.info_outline,
                  title: 'حول التطبيق',
                  onPressed: () {},
                  color: const Color(0xFFEDF3F2),
                  titleColor: const Color(0xFF80AFAD),
                ),
                ProfileButton(
                  icon: Icons.privacy_tip_outlined,
                  title: 'سياسة الخصوصية',
                  onPressed: () {},
                  color: const Color(0xFFEDF3F2),
                  titleColor: Color(0xFF80AFAD),
                ),
                ProfileButton(
                  icon: Icons.exit_to_app_rounded,
                  title: 'تسجيل الخروج',
                  onPressed: () async {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
                      title: 'تسجيل الخروج',
                      titleTextStyle: TextStyle(
                          fontSize: 22
                      ),
                      desc: 'هل تريد تسجيل الخروج ؟',
                      btnCancelOnPress: () {
                        setState(() {
                          isLoading = true;
                        });
                        Future.delayed(const Duration(seconds: 2), () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) {
                                return const Login();
                              }), (route) => false);
                          setState(() {
                            isLoading = false;
                          });
                        });
                      },
                      btnOkText: 'البقاء',
                      btnCancelText: 'تسجيل الخروج',
                      btnOkOnPress: () {
                      },
                    ).show();
                  },
                  color: const Color(0xFFF6EFF0),
                  titleColor: const Color(0xFFEE9A9A),
                ),
              ],
            ),
          ),
        ));
}
