import 'package:flutter/material.dart';
import 'package:frontend/app/modules/course/views/course_view.dart';
import 'package:frontend/app/modules/home/controllers/home_controller.dart';
import 'package:frontend/app/modules/notification/view/notification_view.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../utils/widgets/custom_curve.dart';
import '../../../utils/widgets/main_header.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: CustomCurvedEdges(),
              child: Stack(
                children: [
                  Container(
                    width: Get.width,
                    height: Get.height * 0.23,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff030619),
                          Color(0xff111d51),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 50, left: 30, right: 30),
                    child: Column(
                      children: [
                        MainHeader(
                          leadingTap: () {
                            Get.to(() => const CourseView());
                          },
                          showAvatar: true,
                          icon: 'assets/search.png',
                          title: 'Last Courses',
                          avatarTap: () {
                            Get.to(() => const NotificationPage());
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
              child: Column(
                children: [
                  Opacity(
                    opacity: 0.6,
                    child: Container(
                      width: 40,
                      height: 3,
                      decoration: ShapeDecoration(
                        color: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => controller.isLoading.value == true
                        ? Center(
                            child: LoadingAnimationWidget.waveDots(
                                color: Colors.blueGrey.shade700, size: 40),
                          )
                        : controller.enrolledCoursesList.isEmpty
                            ? const Center(
                                child: Text(
                                  'No enrolled courses yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    controller.enrolledCoursesList.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 10,
                                ),
                                itemBuilder: (context, index) {
                                  final enrolledCourse =
                                      controller.enrolledCoursesList[index];
                                  return ListTile(
                                    onTap: () {
                                      // Get.to(() => const MessageView());
                                    },
                                    leading: const Image(
                                        image: AssetImage('assets/home.png')),
                                    title: Text(
                                      enrolledCourse.name ?? '',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(
                                      enrolledCourse.description ?? '',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
