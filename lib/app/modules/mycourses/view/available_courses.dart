import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controller/enrolledcourse_controller.dart';

class AvailableCourses extends StatelessWidget {
  const AvailableCourses({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EnrolledcourseController());
    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: const Color(0xff233853),
      onRefresh: () async {
        await controller.courseController.getCourses();
        await controller.courseController.getUserEnrolledCourses(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(
          () => controller.isLoading.value == true
              ? Center(
                  child: LoadingAnimationWidget.beat(
                      color: Colors.blueGrey.shade700, size: 40),
                )
              : controller.courseController.availableCoursesList.isEmpty
                  ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height -
                            100, // Adjust as needed
                        child: const Center(
                          child: Text(
                            'No enrolled courses yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        top: 25,
                        left: 16,
                        right: 16,
                        bottom: 15,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              // physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller
                                  .courseController.availableCoursesList.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 15,
                              ),
                              itemBuilder: (context, index) {
                                final enrolledCourse = controller
                                    .courseController
                                    .availableCoursesList[index];
                                return GestureDetector(
                                  onTap: () {
                                    controller.courseController
                                        .selectCourse(enrolledCourse);
                                  },
                                  child: Container(
                                    width: Get.width,
                                    // height: 297,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xffBEBAB3)),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: Get.width,
                                          child: Image.asset(
                                            "assets/course.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.symmetric(horizontal: 15),
                                        //   child: Text(
                                        //     "3 h 30 min ",
                                        //     style: TextStyle(
                                        //       fontSize: 12,
                                        //       fontWeight: FontWeight.w500,
                                        //       color: Color(0xff5BA092),
                                        //     ),
                                        //   ),
                                        // ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Text(
                                            "${enrolledCourse.name}",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff3C3A36),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Text(
                                            "${enrolledCourse.description}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff3C3A36),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Text(
                                            "Starting from \$${enrolledCourse.price1!.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
