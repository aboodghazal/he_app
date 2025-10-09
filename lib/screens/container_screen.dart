// import 'package:chat_composer/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:health_app/screens/categories.dart';
import 'package:health_app/screens/chat/chat_screen.dart';
import 'package:health_app/screens/chat/contacts_screen.dart';
import 'package:health_app/screens/home_screen.dart';
import 'package:health_app/screens/settings_screen.dart';

import '../colors.dart';
import '../utils/app_colors.dart';

class ContainerScreen extends StatefulWidget{
  const ContainerScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return ContainerScreenState();
  }
}

class ContainerScreenState extends State<ContainerScreen> {
  int selectedTab = 0;
  String title = 'الرئيسية';
  var firebaseMessaging = FirebaseMessaging.instance;

  List<Widget> navBarPages = [
    HomeScreen(),
    const ContactsScreen(),
    Categories(),
    const SettingsScreen()
  ];


  @override
  void initState() {
    firebaseMessaging.getToken().then((token) =>
      print(token)
    );
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
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
            color: AppColors.bacgroundColor,
            borderRadius: BorderRadius.circular(35),
            // border: Border.all(color: primary),
            boxShadow: [
              BoxShadow(color: primary.shade100, blurRadius: 5, offset: const Offset(3,3))
            ]
        ),
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 25),
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
                } else if(selectedTab == 2) {
                  title = 'التصنيفات';
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
              GButton(icon: Icons.list_alt_outlined,
                  text: 'التصنيفات'),
              GButton(icon: Icons.settings_outlined,
                  text: 'الإعدادات'),
            ],
          ),
        ),
      ),
      body: navBarPages.elementAt(selectedTab),
    );
  }
}