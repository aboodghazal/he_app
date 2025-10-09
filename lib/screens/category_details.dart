import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_app/colors.dart';
import 'package:health_app/models/article_model.dart';
import 'package:health_app/screens/article.dart';
import 'package:health_app/widgets/chat/chat_body.dart';

class CategoryDetails extends StatefulWidget {
  const CategoryDetails({super.key});

  @override
  State<StatefulWidget> createState() {
    return CategoryDetailsState();
  }
}

class CategoryDetailsState extends State<CategoryDetails> {
  List<ArticleModel> articlesList = [];
  List userSubscriptions = [];
  List doctorsList = [];
  bool isSubscribed = false;
  late String title;
  late String id;

  String formatTimestamp(String date) {
    DateTime today = DateTime.parse(date);
    String dateStr = "${today.day}-${today.month}-${today.year}";
    return dateStr;
  }

  getDoctors() async {
    var doctors = await FirebaseFirestore.instance.collection('doctors').get();
    for (var doctor in doctors.docs) {
      if (doctor.data()['specialization'] == title) {
        doctorsList.add(doctor);
      }
    }
  }

  getUserSubscriptions() async {
    var response =
        await FirebaseFirestore.instance.collection('usersSubscriptions').get();
    for (var subscription in response.docs) {
      if (subscription.id == user!.uid) {
        setState(() {
          Map<String, dynamic> data = subscription.data();
          for (String value in data.values) {
            if (value == title) {
              isSubscribed = true;
            } else {
              isSubscribed = false;
            }
          }
        });
      }
    }
  }

  subscribeToCategory() {
    var collection = fireStore.collection('usersSubscriptions');
    collection
        .doc("${user!.uid}$id") // <-- Document ID
        .set({id: title});

    AwesomeDialog(
      context: context,
      title: 'لقد قمت بالإشتراك في $title بنجاح',
      dialogType: DialogType.success,
      titleTextStyle: const TextStyle(
          color: primary, fontWeight: FontWeight.w600, fontSize: 20),
      animType: AnimType.bottomSlide,
      // desc: 'البريد الإلكتروني غير موجود !! قم بتسجيل حساب جديد',
    ).show();
  }

  unSubscribeToCategory() {
    var collection = fireStore.collection('usersSubscriptions');
    collection
        .doc(user!.uid) // <-- Document ID
        .update({id: ''});
  }

  @override
  void initState() {
    getUserSubscriptions();
    getDoctors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgument =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final categoryId = routeArgument['id'];
    final categoryTitle = routeArgument['title'];
    final categoryImage = routeArgument['imageURL'];
    final categoryDescription = routeArgument['description'];
    articlesList = routeArgument['articlesList'];
    title = categoryTitle;
    id = categoryId;

    return Scaffold(
        backgroundColor: const Color(0xFFE9EFEF),
        appBar: AppBar(
          backgroundColor: const Color(0xFF12706D),
          title: Text(categoryTitle!),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                if (!isSubscribed) {
                  isSubscribed = true;
                  subscribeToCategory();
                } else {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.rightSlide,
                    title: 'الغاء الإشتراك',
                    titleTextStyle: const TextStyle(fontSize: 22),
                    desc: 'هل تريد الغاء الإشتراك في $title ؟',
                    btnCancelOnPress: () {
                      setState(() {
                        isSubscribed = false;
                      });
                      unSubscribeToCategory();
                    },
                    btnOkText: 'تراجع',
                    btnCancelText: 'الغاء الإشتراك',
                    btnOkOnPress: () {},
                  ).show();
                }
              });
            },
            backgroundColor: primary.withOpacity(0.85),
            child: Icon(Icons.star,
                size: 30, color: !isSubscribed ? Colors.white : Colors.yellow),
          ),
        ),
        body: ListView(children: [
          SizedBox(
            height: 235,
            child:
                Image(fit: BoxFit.cover, image: NetworkImage(categoryImage!)),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: const Text('الوصف :',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF197278),
                      )),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 15),
                  child: Text(
                    categoryDescription!,
                    style: const TextStyle(fontSize: 17.5),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: const Text('الأطباء :',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF197278),
                      )),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      SizedBox(
                        width: 65,
                        height: 65,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSx2i00rE6Bg5pjZ9B8xpfX20QSOVTYiyrnXw&usqp=CAU'),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 65,
                        height: 65,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6yFUrelcAeaVL0FIUjR-qN37bLk3v8xgsNQ&usqp=CAU'),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 65,
                        height: 65,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR2VsVSb13b1Cb9gLs8xe-AN4u2g0PcSYg0Iw&usqp=CAU'),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 65,
                        height: 65,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyjYvd14BOOsNBgQEB1j8KF5euSgBgcVAJ-g&usqp=CAU'),
                        ),
                      ),
                    ],
                  ),
                  // child: ListView.builder(
                  //   itemCount: doctorsList.length,
                  //   physics: const BouncingScrollPhysics(),
                  //   scrollDirection: Axis.horizontal, itemBuilder: (BuildContext context, int index) {
                  //     return InkWell(
                  //       onTap: () {
                  //         Navigator.pushNamed(context, AppRoute.userProfile,
                  //         arguments: {
                  //           'name' : doctorsList[index].data()['fullname'].toString(),
                  //           'phone' : doctorsList[index].data()['phone'].toString(),
                  //           'dateOfBirth' : doctorsList[index].data()['dateOfBirth'].toString(),
                  //           'imageURL' : doctorsList[index].data()['avatar'].toString(),
                  //           'userID' : doctorsList[index].id.toString(),
                  //         });
                  //       },
                  //       child: SizedBox(
                  //         width: 65,
                  //         height: 65,
                  //         child: CircleAvatar(
                  //           backgroundImage: NetworkImage(doctorsList[index]['avatar']),
                  //         ),
                  //       ),
                  //     );
                  // },
                  // ),
                ),
                const SizedBox(
                  width: double.infinity,
                  child: Text('المقالات :',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF197278),
                      )),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: articlesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Article(
                      article: articlesList[index],
                    );
                  },
                ),
              ],
            ),
          )
        ]));
  }
}
