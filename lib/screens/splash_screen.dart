import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../admin_screens/admin_container_screen.dart';
import '../utils/app_colors.dart';
import 'container_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _checkLoginAndNavigate();
  }

  Future<void> _checkLoginAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2)); // splash delay

    if (FirebaseAuth.instance.currentUser == null) {
      // Not logged in
      _goTo(const Login());
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      final data = doc.data();
      print("${data != null && data['accountType'] == 1}");
      if (data != null && data['accountType'] == 1) {
        // Doctor
        _goTo(const AdminContainerScreen());
      } else {
        // Normal user
        _goTo(const ContainerScreen());
      }
    } catch (e) {
      debugPrint("Error fetching user type: $e");
      _goTo(const Login()); // fallback
    }
  }

  void _goTo(Widget page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Center(
        child: Image(
          image: AssetImage('images/appLogo.png'),
        ),
      ),
    );
  }
}
