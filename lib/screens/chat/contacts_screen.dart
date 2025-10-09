import 'package:flutter/material.dart';

import '../../widgets/chat/contacts_body.dart';
import '../../widgets/chat/contacts_header.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return ContactsScreenState();
  }
}

class ContactsScreenState extends State<ContactsScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12706D),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: const [
            ContactsHeader(),
            ContactsBody(),
          ],
        ),
      ),
    );
  }
}