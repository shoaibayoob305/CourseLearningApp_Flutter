import 'dart:convert';
import 'dart:developer';

import 'package:frontend/app/modules/course/controllers/course_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../utils/requests/api_endpoints.dart';
import '../../../utils/widgets/defaultsnackbar.dart';
import '../../course/model/course_model.dart';

class EnrolledcourseController extends GetxController {
  // RxList<CourseModel> enrolledCoursesList = <CourseModel>[].obs;
  // RxList<CourseModel> availableCoursesList = <CourseModel>[].obs;
  RxBool isLoading = false.obs;
  final box = GetStorage();
  CourseController courseController = Get.put(CourseController());

  @override
  void onInit() {
    super.onInit();
  }
}
