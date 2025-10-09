// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:health_app/colors.dart';
// import 'package:health_app/utils/app_colors.dart';
// import 'package:health_app/widgets/auth/custom_text_field.dart';
//
// import '../controller/auth/login_controller.dart';
// import '../widgets/auth/custom_auth_button.dart';
//
// class ForgetPassword extends StatelessWidget {
//   const ForgetPassword({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     LoginControllerImp controller = Get.put(LoginControllerImp());
//     return Scaffold(
//         backgroundColor: AppColors.bacgroundColor2,
//         appBar: AppBar(
//           backgroundColor: AppColors.bacgroundColor2,
//           elevation: 0.0,
//           title: Text(
//             'تسجيل الدخول',
//             style: Theme.of(context)
//                 .textTheme
//                 .titleLarge!
//                 .copyWith(color: primary, fontSize: 24),
//           ),
//           centerTitle: true,
//         ),
//         body: Container(
//           padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
//           child: ListView(
//               children: [
//                 const Image(
//                   image: AssetImage('images/appLogo.png'),
//                   width: 280,
//                   height: 280,
//                 ),
//                 SizedBox(height: 40),
//                 Container(
//                     child: const CustomTextField(
//                         'البريد الإلكتروني',
//                         ' أدخل بريدك الإلكتروني',
//                         TextInputType.emailAddress,
//                         Icons.email_outlined
//                     )
//                 ),
//                 SizedBox(height: 30),
//                 Container(
//                     child: const CustomTextField(
//                         'كلمة المرور',
//                         ' أدخل كلمة المرور',
//                         TextInputType.visiblePassword,
//                         Icons.lock_outlined
//                     )
//                 ),
//                 const SizedBox(height: 15,),
//                 Container(
//                     margin: EdgeInsets.only(right: 7),
//                     child: const InkWell(
//                       child: Text('هل نسيت كلمة المرور ؟',
//                         style: TextStyle(
//                             fontSize: 18,
//                             color: primary
//                         ),
//                         textAlign: TextAlign.right,
//                       ),
//                     )
//                 ),
//                 const SizedBox(height: 40),
//
//                 CustomAuthButton(
//                   'تسجيل الدخول',
//                       (){},
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         controller.goToSignUp();
//                       },
//                       child: Text('إنشاء حساب جديد',
//                         style: TextStyle(
//                             fontSize: 18,
//                             color: primary
//                         ),
//                         textAlign: TextAlign.right,
//                       ),
//                     ),
//                     Container(
//                       child: Text('ليس لديك حساب ؟',
//                         style: TextStyle(
//                             fontSize: 18
//                         ),),
//                       margin: EdgeInsets.only(left: 10),
//                     ),
//
//                   ],
//                 )
//               ]),
//         ));
//   }
// }
