import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_app/colors.dart';
import 'package:health_app/utils/app_route.dart';

import 'avatar.dart';

class ContactsHeader extends StatefulWidget {
  const ContactsHeader({super.key});

  @override
  State<StatefulWidget> createState() {
    return ContactsHeaderState();
  }

}

class ContactsHeaderState extends State<ContactsHeader> {
  TextEditingController controller = TextEditingController();
  List usersList = [];
  var collectionReference = FirebaseFirestore.instance.collection('users');
  var currentUser = FirebaseAuth.instance.currentUser;

  getData() async {
    // setState(() {
    //   isLoading = true;
    // });
    var response = await collectionReference.get();
    for (var user in response.docs) {
      setState(() {
        print(currentUser!.uid);
        print(currentUser!.email);
        if(user.id != currentUser!.uid){
          print('----------${user.id}----------');
          usersList.add(user);
        }
      }
        );
    }
    // setState(() {
    //   isLoading = false;
    // });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: primary,
      padding: const EdgeInsets.only(top: 20, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                //  Text('المحادثات', style: TextStyle(
                //   fontSize: 30,
                //   fontWeight: FontWeight.bold,
                //   color: background2,
                // ),
                //   textAlign: TextAlign.start,
                // ),
              ],
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoute.searchPage);
                  },
                  child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white12,
                      ),
                      child: const Icon(
                        Icons.search,
                        size: 37,
                        color: background2,
                      ),
                    ),
                ),

                const SizedBox(
                  width: 3,
                ),
                Expanded(
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: usersList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoute.userProfile,
                              arguments: {
                              'name' : usersList[index].data()['fullname'].toString(),
                              'phone' : usersList[index].data()['phone'].toString(),
                              'dateOfBirth' : usersList[index].data()['dateOfBirth'].toString(),
                              'imageURL' : usersList[index].data()['avatar'].toString(),
                              'userID' : usersList[index].id.toString(),
                              }
                              );
                              },
                              child: Avatar(
                                margin: const EdgeInsets.only(right: 15),
                                image: usersList[index]['avatar'],
                              ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
    );
  }
}


