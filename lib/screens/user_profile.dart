import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_app/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_app/utils/app_route.dart';

var user = FirebaseAuth.instance.currentUser;

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});
  @override
  State<StatefulWidget> createState() {
    return UserProfileState();
  }
}

class UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgument =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final name = routeArgument['name'];
    final phone = routeArgument['phone'];
    final dateOfBirth = routeArgument['dateOfBirth'];
    final imageURL = routeArgument['imageURL'];
    final userID = routeArgument['userID'];

    print('UserID ========> $userID');

    return Scaffold(
      body: Stack(children: [
        Container(
          padding: const EdgeInsets.all(30),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [primary, Colors.white],
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.only(top: 6),
                          margin: const EdgeInsets.only(left: 5),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 130),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
                color: background2,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  // BoxShadow(color: Color(0xFFB8D4D3), blurStyle: BlurStyle.outer,blurRadius: 100, offset: Offset(0.0, 0.75))
                ]),
            height: 700.h,
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
                        backgroundImage: NetworkImage(imageURL!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== Name Row =====
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1ECEC),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Icon(Icons.person_2_outlined,
                                color: const Color(0xFF599B99), size: 30),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                Text(
                                  'الإسم :',
                                  style: TextStyle(
                                    color: const Color(0xFF599B99),
                                    fontSize: 22.sp,
                                  ),
                                ),
                                Text(
                                  name ?? '',
                                  style: TextStyle(
                                    color: const Color(0xFF495057),
                                    fontSize: 22.sp,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      const Divider(color: Color(0xFFB8D4D3), thickness: 0.7),
                      SizedBox(height: 10.h),

                      // ===== Phone Row =====
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1ECEC),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Icon(Icons.phone_android_outlined,
                                color: Color(0xFF599B99), size: 30),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                const Text(
                                  'رقم الهاتف :',
                                  style: TextStyle(
                                    color: Color(0xFF599B99),
                                    fontSize: 22,
                                  ),
                                ),
                                Text(
                                  phone ?? '',
                                  style: const TextStyle(
                                    color: Color(0xFF495057),
                                    fontSize: 22,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(color: Color(0xFFB8D4D3), thickness: 0.7),
                      const SizedBox(height: 10),

                      // ===== Date of Birth Row =====
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1ECEC),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Icon(Icons.date_range_outlined,
                                color: Color(0xFF599B99), size: 30),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                const Text(
                                  'تاريخ الميلاد :',
                                  style: TextStyle(
                                    color: Color(0xFF599B99),
                                    fontSize: 22,
                                  ),
                                ),
                                Text(
                                  dateOfBirth ?? '',
                                  style: const TextStyle(
                                    color: Color(0xFF495057),
                                    fontSize: 22,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // ===== Button Row =====
                      Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, AppRoute.chatScreen,
                                    arguments: {
                                      'name': name,
                                      'avatar': imageURL,
                                      'userID': userID.toString(),
                                    });
                              },
                              color: const Color(0xFFE1ECEC),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('images/sendMessage.svg',
                                      color: const Color(0xFF599B99)),
                                  const SizedBox(width: 10),
                                  const Flexible(
                                    child: Text(
                                      'أرسل رسالة',
                                      style: TextStyle(
                                        color: Color(0xFF599B99),
                                        fontSize: 22,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
