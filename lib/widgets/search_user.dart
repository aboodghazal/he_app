import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/utils/app_route.dart';

class SearchUser extends StatelessWidget {
  final String name;
  final String email;
  final String imageURL;
  final String phone;
  final String dateOfBirth;

  const SearchUser({super.key, required this.name, required this.email, required this.imageURL, required this.phone, required this.dateOfBirth});

  void goToProfileScreen(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
        AppRoute.userProfile,
        arguments: {
          'name' : name,
          'phone' : phone,
          'dateOfBirth' : dateOfBirth,
          'imageURL' : imageURL,
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: InkWell(
        onTap: () {
          goToProfileScreen(context);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
              color: const Color(0xFFDBE8E8),
        ),
          width: 370,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Flexible(
            child: Row(
              children: [
                 Flexible(
                   child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: const Color(0xFF89B8B6), width: 5)
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(imageURL),
                    ),
                ),
                 ),
                const SizedBox(width: 15),
                Column(
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(name, textAlign: TextAlign.start, style: const TextStyle(
                        fontSize: 22,
                        color: Color(0xFF495057)
                      ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      width: 200,
                      child: Text(email, textAlign: TextAlign.start, style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF495057)
                      ),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}