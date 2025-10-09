import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:health_app/colors.dart';
import 'package:health_app/screens/chat/contacts_screen.dart';
import 'package:health_app/screens/settings_screen.dart';
import '../utils/app_colors.dart';
import 'admin_home_screen.dart';

class AdminContainerScreen extends StatefulWidget {
  const AdminContainerScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return AdminContainerScreenState();
  }
}

class AdminContainerScreenState extends State<AdminContainerScreen> {
  int selectedTab = 0;
  String title = 'الرئيسية';
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  List<Widget> navBarPages = [
    const AdminHomeScreen(),
    const ContactsScreen(),
    const SettingsScreen()
  ];

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bacgroundColor2,
      appBar: AppBar(
        title: Text(title),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          
          padding: const EdgeInsets.all(0),
          
          decoration: BoxDecoration(
              color: AppColors.bacgroundColor,
              borderRadius: BorderRadius.circular(35),
              // border: Border.all(color: primary),
              boxShadow: [
                BoxShadow(color: primary.shade100, blurRadius: 5, offset: const Offset(3,3))
              ]
          ),
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 20),
          // color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: GNav(
              backgroundColor: AppColors.bacgroundColor,
              color: primary,
              activeColor: Colors.white,
              tabBackgroundColor: primary.shade400,
              gap: 10,
              onTabChange: (index) {
                setState(() {
                  selectedTab = index;
                  if (selectedTab == 0) {
                    title = 'الرئيسية';
                  } else if (selectedTab == 1) {
                    title = 'الرسائل';
                  } else {
                    title = 'الإعدادات';
                  }
                });
              },
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              tabs: const [
                GButton(icon: Icons.home_outlined,
                  text: 'الرئيسية',),
                GButton(icon: Icons.chat_outlined,
                    text: 'الرسائل'),
                GButton(icon: Icons.settings_outlined,
                    text: 'الإعدادات'),
              ],
            ),
          ),
        ),
      ),
      body: navBarPages.elementAt(selectedTab),
    );
  }
}