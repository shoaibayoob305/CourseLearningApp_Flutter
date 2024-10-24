import 'package:flutter/material.dart';
import 'package:frontend/app/modules/mycourses/view/available_courses.dart';
import 'package:frontend/app/modules/mycourses/view/enrolled_courses.dart';

class MycoursesTab extends StatelessWidget {
  const MycoursesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('My Courses'),
          centerTitle: true,
          forceMaterialTransparency: true,
          surfaceTintColor: Colors.white,
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Color(0xff233853),
            tabs: [
              Tab(text: "Enrolled"),
              Tab(text: "Available"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            EnrolledCourses(),
            AvailableCourses(),
          ],
        ),
      ),
    );
  }
}
