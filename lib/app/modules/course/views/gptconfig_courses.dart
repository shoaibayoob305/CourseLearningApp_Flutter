import 'package:flutter/material.dart';
import 'package:frontend/app/modules/questions/controller/questionController.dart';
import 'package:frontend/app/modules/questions/view/question_ask.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GptconfigCourses extends StatelessWidget {
  const GptconfigCourses({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Questioncontroller());

    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: const Color(0xff233853),
      onRefresh: () async {
        await controller.checkgptConfig();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text('Course Configurations'),
          centerTitle: true,
        ),
        body: Obx(
          () => controller.isLoading.value == true
              ? Center(
                  child: LoadingAnimationWidget.beat(
                      color: Colors.blueGrey.shade700, size: 40),
                )
              : controller.checkgtpList.isEmpty
                  ? const Center(
                      child: Text(
                        'No Configured Course yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: controller.checkgtpList.length,
                        separatorBuilder: (context, index) => const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0)),
                        itemBuilder: (context, index) {
                          final course = controller.checkgtpList[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 4.0,
                                    spreadRadius: 1.0,
                                    color: Colors.grey.shade300)
                              ],
                            ),
                            child: ListTile(
                              title: Text(course.courseName ?? ''),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Vocabulary Level: ${course.vocabularyLevel!.capitalize}'),
                                  Text(
                                      'Detail Level: ${course.detailLevel!.capitalize}'),
                                  Text(
                                      'Explanation Style: ${course.explanationStyle!.capitalize}'),
                                ],
                              ),
                              trailing: TextButton(
                                  onPressed: () {
                                    controller.courseId.value =
                                        course.courseId!;
                                    controller.isUpdate.value = true;
                                    Get.to(() => const QuestionAsk());
                                  },
                                  child: const Text(
                                    'Edit',
                                    style: TextStyle(color: Colors.red),
                                  )),
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ),
    );
  }
}
