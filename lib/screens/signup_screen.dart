import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_app/colors.dart';
import 'package:health_app/controller/auth/signup_controller.dart';
import 'package:health_app/utils/app_colors.dart';
import 'package:health_app/widgets/auth/custom_text_field.dart';
import 'package:health_app/widgets/custom_drop_down_list.dart';
import 'package:health_app/widgets/rigestration_form.dart';

import '../widgets/auth/custom_auth_button.dart';
import '../widgets/regestration_form2.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.bacgroundColor2,
          appBar: AppBar(
            backgroundColor: AppColors.bacgroundColor2,
            iconTheme: const IconThemeData(
              color: primary, //change your color here
            ),
            title: Text(
              'إنشاء حساب',
              style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: primary, fontSize: 24),
            ),
            bottom: const TabBar(
              indicatorWeight: 3,
              labelColor: primary,
              labelStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600
              ),
              tabs: [
                Tab(
                  child: Text(
                    'مريض',
                  ),
                ),
                 Tab(
                  child: Text(
                    'طبيب'
                  ),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              RegistrationForm(),
              RegistrationForm2(),
            ],
          ),
        ));
  }
}

