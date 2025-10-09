import 'dart:async';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:health_app/screens/login_screen.dart';
import '../colors.dart';
import '../utils/app_route.dart';
import 'auth/custom_auth_button.dart';
import 'auth/custom_text_field.dart';
import 'custom_drop_down_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class RegistrationForm extends StatefulWidget{
  const RegistrationForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegistrationFormState();
  }
}

class RegistrationFormState extends State<RegistrationForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var username, email, phone, password, dateOfBirth, category, categoryID;
  List avatars = [];

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String? _deviceToken;

  Future<String?> getDeviceToken() async {
    _deviceToken = await _firebaseMessaging.getToken();
    print(_deviceToken);
    return _deviceToken;
  }

  CollectionReference patients = FirebaseFirestore.instance.collection('patients');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference usersSubscriptions = FirebaseFirestore.instance.collection('usersSubscriptions');

  Future<void> getDefaultImages() async {
    var storageRef = await FirebaseStorage.instance.ref('default').listAll();
    storageRef.items.forEach((image) async {
      final url = await image.getDownloadURL();
      setState(() {
        avatars.add(url);
        print('~~~~~~~~~~~~~~~~~~~ url = $url');
      });
    });
  }

  // getCategoryID() async {
  //     var categoryRef = await FirebaseFirestore.instance.collection('categories').where('name', isEqualTo: category).get();
  //     categoryID = categoryRef.;
  //     return categoryRef.id;
  // }



  @override
  void initState() {
    super.initState();
    getDefaultImages();
    getDeviceToken();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      child: Form(
        key: formKey,
        child: ListView(children: [
          const SizedBox(height: 30),
          CustomTextField(
            labelText: 'إسم المستخدم',
            hintText: ' قم بإدخال إسمك الكامل',
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
              username = val;
            }, text: null,
          ),
          const SizedBox(height: 30),
          CustomTextField(
            labelText: 'البريد الإلكتروني',
            hintText: ' أدخل بريدك الإلكتروني',
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
              email = val;
            }, text: null,
          ),
          const SizedBox(height: 30),
          CustomTextField(
            labelText: 'رقم الهاتف',
            hintText: ' أدخل رقم هاتفك',
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
              phone = val;
            }, text: null,
          ),
          const SizedBox(height: 30),
          CustomTextField(
            labelText: 'تاريخ الميلاد',
            hintText: ' أدخل تاريخ ميلادك',
            keyboardType: TextInputType.datetime,
            icon: Icons.date_range,
            validator: (val) {
              if ((val?.length)! > 10 || (val?.length)! < 6) {
                return 'قم بإدخال التاريخ بشكل صحيح';
              }
            },
            onSaved: (val) {
              dateOfBirth = val;
            }, text: null,
          ),
          const SizedBox(height: 30),
          CustomTextField(
            labelText: 'كلمة المرور',
            hintText: ' أدخل كلمة المرور',
            keyboardType: TextInputType.visiblePassword,
            icon: Icons.lock_outlined,
            obscureText: true,
            validator: (val) {
              RegExp regex = RegExp(
                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
              if (val!.isEmpty) {
                return 'قم بإدخال كلمة المرور';
              } else {
                if (!regex.hasMatch(val)) {
                  return 'أدخل كلمة مرور صالحة';
                } else {
                  return null;
                }
              }
            },
            onSaved: (val) {
              password = val;
            }, text: null,
          ),
          const SizedBox(height: 30),
          CustomDropDownList(
            validator: ( val ) {
              if( val == null ) {
                return 'قم بإختيار المرض';
              }
            },
            hint: 'إختر المرض', label: 'المرض', onSaved: (val) {
              category = val;
          },
          ),
          const SizedBox(height: 40),
          CustomAuthButton(
            'إنشاء الحساب',
            () {
              print(email);
              print(password);

              signUp(context);
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Text(
                  'لديك حساب بالفعل ؟',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                        return  const Login();
                      }), (route) => false);                },
                child: const Text(
                  'تسجيل الدخول',
                  style: TextStyle(fontSize: 18, color: primary),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }

  void signUp(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password);
        patients.doc(userCredential.user!.uid).set({
          'fullname': username,
          'email' : email,
          'phone' : phone,
          'dateOfBirth' : dateOfBirth,
          'illness' : category,
          'avatar' : avatars[Random().nextInt(avatars.length)],
          'deviceToken' : _deviceToken
        });
        users.doc(userCredential.user!.uid).set({
          'fullname': username,
          'email' : email,
          'phone' : phone,
          'dateOfBirth' : dateOfBirth,
          'accountType' : 0,
          'avatar' : avatars[Random().nextInt(avatars.length)],
        });

        AwesomeDialog(context: context,
                  title: 'تم إنشاء الحساب بنجاح',
                  dialogType: DialogType.success,
                  titleTextStyle: const TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 20
                  ),
                  animType: AnimType.bottomSlide,
                  desc: 'قم بتأكيد بريدك الإلكتروني لتتمكن من تسجيل الدخول',
                  descTextStyle: TextStyle(
                    fontSize: 20
                  )
                ).show();
                Timer(const Duration(seconds: 7), () {
                  Navigator.of(context).pushReplacementNamed(AppRoute.login);
    });
        if(userCredential.user?.emailVerified == false)  {
          User? user = FirebaseAuth.instance.currentUser;
          if (user!= null && !user.emailVerified) {
            await user.sendEmailVerification();
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          AwesomeDialog(context: context,
              title: 'كلمة المرور ضعيفة للغاية !!',
              dialogType: DialogType.warning,
              titleTextStyle: const TextStyle(
                  color: primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 20
              ),
              animType: AnimType.bottomSlide,
              desc: 'قم بكتابة كلمة مرور قوية تحتوي على رموز وحروف كبيرة وأرقام',
              descTextStyle: TextStyle(
                  fontSize: 20
              )
          ).show();
        } else if (e.code == 'email-already-in-use') {
          AwesomeDialog(context: context,
              title: 'البريد الإلكتروني مسجل بالفعل !!',
              dialogType: DialogType.warning,
              titleTextStyle: const TextStyle(
                  color: primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 20
              ),
              animType: AnimType.bottomSlide,
              desc: 'البريد الإلكتروني الذي قمت بإدخاله مسجل لدينا بالفعل، قم بتسجيل الدخول',
              descTextStyle: TextStyle(
                  fontSize: 20
              )
          ).show();
        }
      } catch (e) {
        print(e);
      }
    } else {
      print('not validate ============================');
      for (var element in avatars) {
        print('=========================     $element');
      }
    }
  }
}
