import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/admin_screens/create_article_screen.dart';
import 'package:health_app/admin_screens/upload_video.dart';
import 'package:health_app/admin_screens/upload_widget.dart';

import '../colors.dart';
import '../utils/app_colors.dart';

class CreateContainer extends StatelessWidget {
  const CreateContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.bacgroundColor2,
          appBar: AppBar(
            backgroundColor: AppColors.bacgroundColor2,
            iconTheme: const IconThemeData(
              color: primary, //change your color here
            ),
            title: Text(
              'إنشاء',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: primary, fontSize: 24),
            ),
            bottom: const TabBar(
              indicatorWeight: 3,
              labelColor: primary,
              labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              tabs: [
                Tab(
                  child: Text(
                    'إنشاء مقالة',
                  ),
                ),
                Tab(
                  child: Text('رفع فيديو'),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              const CreateArticleScreen(),
              // UploadVideoScreen(),
              UploadVideoWidget()
            ],
          ),
        ));
  }
}
