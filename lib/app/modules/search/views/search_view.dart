import 'package:flutter/material.dart';
import 'package:frontend/app/modules/course/controllers/course_controller.dart';
import 'package:get/get.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CourseController());
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                color: const Color(0xffF3F6F6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) {
                        if (val.isEmpty) {
                          controller.searchStart.value = false;
                          controller.searchedList.value =
                              []; // Clear the search results
                        } else {
                          controller.searchStart.value = true;
                          // Filter the courseList based on the search query
                          controller.searchedList.value = controller
                              .allCoursesList
                              .where((element) => element.name!
                                  .toLowerCase()
                                  .contains(val.toLowerCase()))
                              .toList();
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Search Course',
                        hintStyle: const TextStyle(
                          color: Color(0xff797C7B),
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                        border: InputBorder.none,
                        prefixIcon: Image.asset('assets/search1.png'),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Get.back();
                            controller.searchedList.clear();
                            controller.searchStart.value = false;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              'Courses',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xff000E08),
              ),
            ),
            Obx(
              () => Expanded(
                child: controller.searchStart.value
                    ? ListView.separated(
                        shrinkWrap: true,
                        itemCount: controller.searchedList.length,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 5,
                        ),
                        itemBuilder: (context, index) => ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.shade800,
                            radius: 25,
                            backgroundImage:
                                const AssetImage('assets/course.png'),
                          ),
                          title: Text(
                            controller.searchedList[index].name!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000E08),
                            ),
                          ),
                          subtitle: Text(
                            controller.searchedList[index].description!,
                            style: const TextStyle(
                              color: Color(0xff797C7B),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: controller.allCoursesList.length,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 5,
                        ),
                        itemBuilder: (context, index) => ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.shade800,
                            radius: 25,
                            backgroundImage:
                                const AssetImage('assets/course.png'),
                          ),
                          title: Text(
                            controller.allCoursesList[index].name!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000E08),
                            ),
                          ),
                          subtitle: Text(
                            controller.allCoursesList[index].description!,
                            style: const TextStyle(
                              color: Color(0xff797C7B),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
