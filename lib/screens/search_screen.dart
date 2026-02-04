import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:health_app/colors.dart';
import 'package:health_app/widgets/search_user.dart';
import '../widgets/spiner.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return SearchScreenState();
  }
}

class SearchScreenState extends State<SearchScreen> {
  List usersList = [];
  bool isLoading = false;
  List foundedUsers = [];
  List avatars = [];
  var collectionReference = FirebaseFirestore.instance.collection('users');

  getData() async {
    // setState(() {
    //   isLoading = true;
    // });
    var response = await collectionReference.get();
    for (var user in response.docs) {
      setState(() {
        usersList.add(user.data());
      });
    }
    // setState(() {
    //   isLoading = false;
    // });
  }

  @override
  void initState() {
    getData();
    foundedUsers = usersList;
    super.initState();
  }

  onSearch(String search) {
    setState(() {
      foundedUsers = usersList
          .where((user) => user['fullname']
              .toString()
              .toLowerCase()
              .contains(search.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   isLoading = true;
    // });

    // Timer(const Duration(seconds: 2), ()  async {
    // });

    return Scaffold(
        body: Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [primary, background2])),
      child: Stack(children: [
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
            margin: const EdgeInsets.fromLTRB(15, 130, 15, 100),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
                color: background2,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  // BoxShadow(color: Color(0xFFB8D4D3), blurStyle: BlurStyle.outer,blurRadius: 100, offset: Offset(0.0, 0.75))
                ]),
            height: 900,
            child: Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      autocorrect: false,
                      onChanged: (val) {
                        onSearch(val);
                      },
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          filled: true,
                          prefixIcon: const Icon(Icons.search,
                              color: Color(0xFF495057), size: 30),
                          fillColor: const Color(0xFFDBE8E8),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none),
                          hintText: 'البحث عن شخص معين ..',
                          hintStyle: const TextStyle(
                            fontSize: 22,
                            color: Color(0xFF495057),
                          )),
                      style: const TextStyle(
                          fontSize: 22, color: Color(0xFF495057)),
                      cursorColor: const Color(0xFF495057),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 500,
                      child: isLoading
                          ? const Spinner()
                          : foundedUsers.isEmpty
                              ? const Center(
                                  child: Text(
                                    'لا يوجد أي نتائج مطابقة',
                                    style: TextStyle(
                                        fontSize: 22, color: Color(0xFF495057)),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: foundedUsers.length,
                                  itemBuilder: (context, index) {
                                    return SearchUser(
                                        name: foundedUsers[index]['fullname']??"",
                                        email:  foundedUsers[index]['email']??"",
                                        imageURL: foundedUsers[index]['avatar']??"",
                                        phone: foundedUsers[index]['phone']??"",
                                        dateOfBirth: foundedUsers[index]['dateOfBirth']??"");
                                  },
                                  padding: const EdgeInsets.all(0),
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ]),
    ));
  }
}
