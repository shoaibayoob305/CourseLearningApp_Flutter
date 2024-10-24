import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/app/modules/course/controllers/course_controller.dart';
import 'package:frontend/app/modules/course/model/course_model.dart';
import 'package:frontend/app/modules/notification/view/notification_view.dart';
import 'package:frontend/app/utils/widgets/new_text_field.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:badges/badges.dart' as badges;

class CourseView extends StatelessWidget {
  const CourseView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CourseController());
    return Scaffold(
      backgroundColor: Color.fromRGBO(246, 249, 251, 1),
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Colors.white,
          color: const Color(0xff233853),
          onRefresh: () async {
            await controller.getCourses();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 25,
                bottom: 15,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Obx(
                      () => controller.authenticationController.userModel.value
                                  .id !=
                              null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(11),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 14,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Hello ${controller.authenticationController.userModel.value.firstName} ${controller.authenticationController.userModel.value.lastName}",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                            ),
                                          ),
                                          Text(
                                            "Today is a good day",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  Color.fromRGBO(47, 46, 54, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      Get.to(() => const NotificationPage()),
                                  child: badges.Badge(
                                    showBadge: controller.notificationController
                                                .unreadNotificationsCount >
                                            0
                                        ? true
                                        : false,
                                    badgeStyle: const badges.BadgeStyle(
                                      badgeColor: Colors.red,
                                      elevation: 0,
                                      padding: EdgeInsets.all(5),
                                    ),
                                    badgeContent: Text(
                                      '${controller.notificationController.unreadNotificationsCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: const Icon(Icons.notifications),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                  controller.authenticationController.userModel.value.id != null
                      ? const SizedBox(
                          height: 20,
                        )
                      : const SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: 56,
                      child: NewTextField(
                        obsecureText: false,
                        showPassword: false,
                        iconData: Icons.search_sharp,
                        isIconColor: true,
                        isIconSize: true,
                        iconSize: 24,
                        hint: 'Search Courses',
                        onChange: (val) {
                          if (val.isEmpty) {
                            controller.searchStart.value = false;
                            controller.searchedList
                                .clear(); // Clear the search results directly
                          } else {
                            controller.searchStart.value = true;
                            // Filter the allCoursesList based on the search query
                            controller.searchedList.value = controller
                                .allCoursesList
                                .where((element) => element.name!
                                    .toLowerCase()
                                    .contains(val.toLowerCase()))
                                .toList();
                          }
                          controller.searchedList
                              .refresh(); // Forces UI update for searchedList
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: double.infinity,
                    height: 151,
                    child: CarouselSlider.builder(
                        options: CarouselOptions(
                          autoPlay: false,
                          enableInfiniteScroll:
                              false, // Optional, set to true or false depending on your needs
                          viewportFraction:
                              0.8, // Controls how much of the screen each item should take (e.g., 80%)
                          enlargeCenterPage: true,
                        ),
                        itemCount: 15,
                        itemBuilder: (BuildContext context, int itemIndex,
                            int pageViewIndex) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16.0,
                                      top: 10,
                                      bottom: 17,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'You are enrolled in Android class',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 27,
                                            vertical: 6.5,
                                          ),
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(11),
                                          ),
                                          child: Text(
                                            'Resume',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        height: 115,
                                        child: Image.asset(
                                          'assets/carousolimage.png',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Courses',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'See all',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color.fromRGBO(34, 55, 82, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Obx(
                    () => controller.searchStart.value
                        ? MasonryView(
                            listOfItem: controller.searchedList,
                            numberOfColumn: 2,
                            itemBuilder: (item) {
                              return courseTile(item);
                            },
                          )
                        : MasonryView(
                            listOfItem: controller.allCoursesList,
                            numberOfColumn: 2,
                            itemBuilder: (item) {
                              return courseTile(item);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget for individual course item
  Widget courseTile(CourseModel item) {
    return Container(
      padding: EdgeInsets.only(
        top: 29,
        left: 9,
        right: 9,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.red,
      ),
      width: 170,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          item.image == null
              ? Image.asset('assets/course.png')
              : Image.network(item.image),
          SizedBox(height: 26),
          Text(
            item.name ?? '',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Starting from \$${item.price1!.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
