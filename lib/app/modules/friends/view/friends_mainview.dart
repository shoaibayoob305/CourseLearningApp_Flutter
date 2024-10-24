import 'package:flutter/material.dart';
import 'package:frontend/app/modules/blockedUsers/view/blockuser_view.dart';
import 'package:frontend/app/modules/course/views/gptconfig_courses.dart';
import 'package:frontend/app/utils/widgets/new_setting_tile.dart';
import 'package:get/get.dart';

class FriendsMainview extends StatelessWidget {
  const FriendsMainview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        surfaceTintColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            NewSettingTile(
              onPress: () {
                Get.to(() => const BlockedUserView());
              },
              leadingbackgroundColor: Colors.grey.shade200,
              iconData: Icons.person_off_outlined,
              title: 'Blocked Users',
            ),
            SizedBox(
              height: 15,
            ),
            NewSettingTile(
              onPress: () {
                Get.to(() => const GptconfigCourses());
              },
              leadingbackgroundColor: Colors.grey.shade200,
              iconData: Icons.edit,
              title: 'Course Configurations',
            ),
          ],
        ),
      ),
    );
  }
}
