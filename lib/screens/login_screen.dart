import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app/colors.dart';
import 'package:health_app/screens/container_screen.dart';
import 'package:health_app/screens/forget_password.dart';
import 'package:health_app/utils/app_colors.dart';
import 'package:health_app/widgets/auth/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_app/widgets/spiner.dart';
import '../admin_screens/admin_container_screen.dart';
import '../controller/auth/login_controller.dart';
import '../utils/app_route.dart';
import '../widgets/auth/custom_auth_button.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  List usersList = [];
  bool isLoading = false;
  var email, password;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  getUsers() async {
    var response = await FirebaseFirestore.instance.collection('users').get();
    for (var user in response.docs) {
      setState(() {
        usersList.add(user);
      });
    }
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => isLoading
      ? const Spinner()
      : Scaffold(
          backgroundColor: AppColors.bacgroundColor2,
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: primary, //change your color here
            ),
            backgroundColor: AppColors.bacgroundColor2,
            elevation: 0.0,
            title: Text(
              'تسجيل الدخول',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: primary, fontSize: 24),
            ),
            centerTitle: true,
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            child: ListView(children: [
              const Image(
                image: AssetImage('images/appLogo.png'),
                width: 280,
                height: 280,
              ),
              const SizedBox(height: 40),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      labelText: 'البريد الإلكتروني',
                      hintText: ' أدخل بريدك الإلكتروني',
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email_outlined,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'أدخل بريدك الإلكتروني';
                        }

                        if (val.length > 40) {
                          return 'البريد الإلكتروني طويلة للغاية';
                        } else if (val.length < 5) {
                          return 'البريد الإلكتروني قصيرة للغاية';
                        }
                        bool emailValid = RegExp(
                                r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                            .hasMatch(val);
                        if (!emailValid) {
                          return 'البريد الإلكتروني غير صالح';
                        }
                      },
                      onSaved: (val) {
                        email = val;
                      },
                      text: null,
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      labelText: 'كلمة المرور',
                      hintText: ' أدخل كلمة المرور',
                      keyboardType: TextInputType.visiblePassword,
                      icon: Icons.lock_outlined,
                      obscureText: true,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'أدخل كلمة المرور';
                        }

                        if (val.length > 30) {
                          return 'كلمة المرور طويلة للغاية';
                        } else if (val.length < 5) {
                          return 'كلمة المرور قصيرة للغاية';
                        }
                      },
                      onSaved: (val) {
                        password = val;
                      },
                      text: null,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                  margin: const EdgeInsets.only(right: 7),
                  child: InkWell(
                    onTap: () {
                      // Get.toNamed(AppRoute.forgetPassword);
                    },
                    child: Text(
                      'هل نسيت كلمة المرور ؟',
                      style: TextStyle(fontSize: 18, color: primary),
                      textAlign: TextAlign.right,
                    ),
                  )),
             
              const SizedBox(height: 40),
              CustomAuthButton(
                'تسجيل الدخول',
                () {
                  login(context);
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Text(
                      'ليس لديك حساب ؟',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoute.signup);
                    },
                    child: const Text(
                      'إنشاء حساب جديد',
                      style: TextStyle(fontSize: 18, color: primary),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              )
            ]),
          ));

  login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        setState(() {
          isLoading = true;
        });
        await Future.delayed(const Duration(seconds: 2));
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        setState(() {
          isLoading = false;
        });
        if (userCredential.user?.emailVerified == false) {
          AwesomeDialog(
            context: context,
            title: 'لم يتم التحقق من البريد الإلكتروني',
            dialogType: DialogType.error,
            titleTextStyle: const TextStyle(
                color: primary, fontWeight: FontWeight.w600, fontSize: 20),
            animType: AnimType.bottomSlide,
            desc: 'قم بتأكيد بريدك الإلكتروني لتتمكن من تسجيل الدخول',
            descTextStyle: TextStyle(fontSize: 20),
          ).show();
          userCredential.user?.sendEmailVerification();
          setState(() {
            isLoading = false;
          });
        } else {
          AwesomeDialog(
            context: context,
            title: 'نجحت عملية تسجيل الدخول',
            dialogType: DialogType.success,
            titleTextStyle: const TextStyle(
                color: primary, fontWeight: FontWeight.w600, fontSize: 20),
            animType: AnimType.bottomSlide,
            // desc: 'البريد الإلكتروني غير موجود !! قم بتسجيل حساب جديد',
          ).show();

          Timer(const Duration(seconds: 2), () {
            for (var appUser in usersList) {
              if (userCredential.user!.uid == appUser.id) {
                print(
                    '!!!!!!!!!!!@@@@@@@@@@@@@@@@@@@@@@${appUser.data()['accountType']}');
                print('!!!!!!!!!!!@@@@@@@@@@@@@@@@@@@@@@${appUser.id}');
                if (appUser.data()['accountType'] == 1) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    return const AdminContainerScreen();
                  }), (route) => false);
                } else {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    return const ContainerScreen();
                  }), (route) => false);
                }
              }
            }
          });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          AwesomeDialog(
                  context: context,
                  title: 'المستخدم غير موجود',
                  dialogType: DialogType.warning,
                  titleTextStyle: const TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                  animType: AnimType.bottomSlide,
                  desc: 'البريد الإلكتروني غير موجود !! قم بتسجيل حساب جديد',
                  descTextStyle: TextStyle(fontSize: 22),
                  dialogBackgroundColor: AppColors.bacgroundColor2,
                  dialogBorderRadius: BorderRadius.circular(15),
                  padding: EdgeInsets.all(20))
              .show();
          setState(() {
            isLoading = false;
          });
        } else if (e.code == 'wrong-password') {
          AwesomeDialog(
                  context: context,
                  title: 'كلمة المرور خاطئة',
                  dialogType: DialogType.error,
                  titleTextStyle: const TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 22),
                  animType: AnimType.bottomSlide,
                  desc:
                      'كلمة المرور التي قمت بإدخالها خاطئة !! رجاءا تأكد من كتابة كلمة المرور بشكل صحيح',
                  descTextStyle: TextStyle(fontSize: 20),
                  dialogBackgroundColor: AppColors.bacgroundColor2,
                  dialogBorderRadius: BorderRadius.circular(15),
                  padding: EdgeInsets.all(20))
              .show();
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }
}
