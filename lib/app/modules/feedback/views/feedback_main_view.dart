import 'package:flutter/material.dart';
import 'package:frontend/app/modules/feedback/views/feedback_view.dart';
import 'package:frontend/app/modules/feedback/views/suggestion_view.dart';
import 'package:get/get.dart';

import '../../../utils/widgets/new_setting_tile.dart';

class FeedbackMainView extends StatelessWidget {
  const FeedbackMainView({super.key});

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
                Get.to(() => const FeedbackView());
              },
              leadingbackgroundColor: Colors.grey.shade200,
              iconData: Icons.feedback,
              title: 'Give Feedback',
            ),
            const SizedBox(
              height: 15,
            ),
            NewSettingTile(
              onPress: () {
                Get.to(() => const SuggestionView());
              },
              leadingbackgroundColor: Colors.grey.shade200,
              iconData: Icons.subject,
              title: 'Give Suggestions',
            ),
          ],
        ),
      ),
    );
  }
}
