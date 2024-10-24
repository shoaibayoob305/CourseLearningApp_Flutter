import 'package:flutter/material.dart';
import 'package:frontend/app/modules/feedback/controllers/feedback_controller.dart';
import 'package:get/get.dart';

class FeedbackView extends StatelessWidget {
  const FeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FeedbackController());
    return Scaffold(
      backgroundColor: const Color(0xffEBEFFF),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Feedback',
                  style: TextStyle(
                    color: Color(0xff000E08),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Image(image: AssetImage('assets/close.png')))
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'What can we improve to make your experience better?',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color(0xff000E08),
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            MessageInput(
              reportController: controller.feedbackController,
              onTap: () =>
                  controller.isLoading.value ? null : controller.postFeedback(),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class MessageInput extends StatelessWidget {
  MessageInput({
    super.key,
    this.reportController,
    this.onTap,
  });

  TextEditingController? reportController;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: const Color(0xffF3F6F6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: reportController,
              decoration: const InputDecoration(
                hintText: 'Write your message',
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null, // Allows the TextField to grow vertically
              minLines: 1, // Set minimum lines to 1
              scrollPhysics:
                  BouncingScrollPhysics(), // Enables smooth scrolling
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
