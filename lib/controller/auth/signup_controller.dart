
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:health_app/utils/app_route.dart';

import '../../widgets/rigestration_form.dart';

abstract class SignUpController extends GetxController {
  signUp();
  goToLogin();
}

class SignUpControllerImp extends SignUpController {
  late TextEditingController username;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController dateOfBirth;
  late TextEditingController password;


  @override
  signUp() async {

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: "obada.marouf@gmail.com",
          password: "aaa12aaa21"
      );
      print('================================================');
      print(userCredential);
      print('================================================');
      // if(userCredential.user?.emailVerified == false)  {
      //   User? user = FirebaseAuth.instance.currentUser;
      //   if (user!= null && !user.emailVerified) {
      //     await user.sendEmailVerification();
      //   }
      // }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  goToLogin() {
    Get.toNamed(AppRoute.login);
  }
  @override
  void onInit() {
    username = TextEditingController();
    email = TextEditingController();
    phone = TextEditingController();
    dateOfBirth = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    phone.dispose();
    dateOfBirth.dispose();
    password.dispose();
    super.dispose();
  }
}