import 'dart:convert';
import 'dart:developer';

import 'package:frontend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../utils/requests/api_endpoints.dart';
import '../../../utils/widgets/defaultsnackbar.dart';
import '../../course/model/course_model.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();
  final box = GetStorage();
  RxBool isLoading = false.obs;
  RxList<CourseModel> enrolledCoursesList = <CourseModel>[].obs;
  var selectedIndex = 0.obs;
  AuthenticationController authenticationController =
      Get.put(AuthenticationController());

  @override
  void onInit() async {
    super.onInit();
  }

  // for changing bottom navigation page
  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
