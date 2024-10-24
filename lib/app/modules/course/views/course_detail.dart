import 'package:flutter/material.dart';
import 'package:frontend/app/modules/authentication/views/login_view.dart';
import 'package:frontend/app/modules/course/controllers/course_controller.dart';
import 'package:frontend/app/modules/purchases/model/purchasemodel.dart';
import 'package:frontend/app/modules/purchases/view/purchase_detail.dart';
import 'package:frontend/app/modules/questions/view/question_ask.dart';
import 'package:get/get.dart';
import 'recipet_dialog.dart';

class CourseDetail extends StatelessWidget {
  const CourseDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CourseController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Course Detail'),
        centerTitle: true,
        forceMaterialTransparency: true,
        surfaceTintColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                width: Get.width,
                height: Get.height / 2.5,
                child: Image.asset(
                  "assets/course.png",
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About the course',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${controller.selectedCourse.value.description}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Starting from \$${controller.selectedCourse.value.price1!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Button at the end of the screen
          Obx(
            () => Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: GestureDetector(
                  onTap: controller
                              .authenticationController.userModel.value.id !=
                          null
                      ? controller.enrolledCoursesList.any((course) =>
                              course.id == controller.selectedCourse.value.id)
                          ? () async {
                              controller.questioncontroller.courseId.value =
                                  controller.selectedCourse.value.id!;
                              if (controller.questioncontroller.checkgtpList
                                  .any((course) =>
                                      course.courseId ==
                                      controller.selectedCourse.value.id)) {
                                bool isExpired =
                                    await controller.checkCourseEndDate();
                                print('isExpired is $isExpired');
                                if (isExpired == true) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Subscription Expired'),
                                        content: Text(
                                          'Your subscription for this course has expired. Please renew to continue accessing the course content.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                              controller.purchaseController
                                                  .selectPurchase(controller
                                                      .expiredSpecificCourse
                                                      .value);
                                              Get.to(
                                                  () => const PurchaseDetail());
                                              controller.expiredSpecificCourse
                                                  .value = PurchaseModel();
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  await controller.questioncontroller
                                      .getQuestionDataset();
                                }
                              } else {
                                controller.questioncontroller.isUpdate.value =
                                    false;
                                Get.to(() => const QuestionAsk());
                              }
                            }
                          : () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return const ReceiptDialog();
                                },
                              );
                            }
                      : () {
                          Get.to(const LoginView());
                        },
                  child: Container(
                    width: Get.width,
                    height: 50,
                    decoration: BoxDecoration(
                        color: const Color(0xff233853),
                        borderRadius: BorderRadius.circular(100)),
                    child: Center(
                      child: controller.enrolledCoursesList.any((course) =>
                              course.id == controller.selectedCourse.value.id)
                          ? const Text(
                              "Start learning",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Purchase Now",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
