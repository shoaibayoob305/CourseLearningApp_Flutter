import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:frontend/app/modules/course/model/course_model.dart';
import 'package:frontend/app/modules/course/model/gptmodel.dart';
import 'package:frontend/app/modules/course/views/course_detail.dart';
import 'package:frontend/app/modules/friends/controller/friends_controller.dart';
import 'package:frontend/app/modules/home/controllers/home_controller.dart';
import 'package:frontend/app/modules/notification/controller/notification_controller.dart';
import 'package:frontend/app/modules/notification/model/notification_model.dart';
import 'package:frontend/app/modules/payments/controller/payment_controller.dart';
import 'package:frontend/app/modules/purchases/controller/purchase_controller.dart';
import 'package:frontend/app/modules/purchases/model/purchasemodel.dart';
import 'package:frontend/app/modules/sqaureup_payment/payment.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../utils/requests/api_endpoints.dart';
import '../../../utils/widgets/defaultsnackbar.dart';
import '../../payments/model/payment_model.dart';
import '../../questions/controller/questionController.dart';

class CourseController extends GetxController {
  AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  NotificationController notificationController =
      Get.put(NotificationController());
  PaymentController paymentController = Get.put(PaymentController());
  SquareupController squareupController = Get.put(SquareupController());
  Questioncontroller questioncontroller = Get.put(Questioncontroller());
  HomeController homeController = Get.put(HomeController());
  PurchaseController purchaseController = Get.put(PurchaseController());
  FriendsController friendsController = Get.put(FriendsController());
  RxBool likeButton = false.obs;
  RxString seletedFilter = 'All'.obs;
  RxBool isLoading = false.obs;
  var allCoursesList = <CourseModel>[].obs;
  RxList<CourseModel> enrolledCoursesList = <CourseModel>[].obs;
  RxList<CourseModel> availableCoursesList = <CourseModel>[].obs;
  final box = GetStorage();
  RxBool searchStart = false.obs;
  RxList<CourseModel> searchedList = <CourseModel>[].obs;
  var selectedCourse = CourseModel().obs;
  RxList<String> dropdownItems = ['1 month', '3 months', '12 months'].obs;
  RxString dropdownValue = '1 month'.obs;
  RxDouble coursePrice = 0.0.obs;
  RxInt monthDuration = 1.obs;
  Rx<PaymentMethods> selectedPaymentMethod = PaymentMethods().obs;
  Rx<PurchaseModel> expiredSpecificCourse = PurchaseModel().obs;

  @override
  void onInit() async {
    super.onInit();
    await checkCacheCourses();
    authenticationController.userModel.value.id != null
        ? getUserEnrolledCourses(false)
        : null;
  }

  Future<bool> checkCourseEndDate() async {
    print('entered');
    // Assuming each course has an 'endDate' property and it's of DateTime type
    var today = DateTime.now();

    expiredSpecificCourse.value = purchaseController.purchaseList.firstWhere(
      (course) => course.course == selectedCourse.value.id,
      // Returns null if no matching course found
    );

    if (expiredSpecificCourse != null) {
      // Check if endDate is before today or equal to today
      if (expiredSpecificCourse.value.endDate!.isBefore(today) ||
          expiredSpecificCourse.value.endDate!.isAtSameMomentAs(today)) {
        // Show a dialog that the course has expired

        return true; // Indicates the course has expired
      }
    }

    return false; // Indicates the course has not expired
  }

  // user enrolled courses
  Future<void> getUserEnrolledCourses(bool loading) async {
    try {
      isLoading.value = loading;
      String endpoint = baseUrl + courseEnrolledEndpoint;
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var response = await http.get(
        Uri.parse(endpoint),
        headers: header,
      );
      log('enrolled response === ${response.statusCode}');
      if (response.statusCode == 200) {
        enrolledCoursesList.clear();
        availableCoursesList.clear();
        var decodedResponse = json.decode(response.body);
        log('response === $decodedResponse');
        for (var i = 0; i < decodedResponse.length; i++) {
          enrolledCoursesList.add(CourseModel.fromJson(decodedResponse[i]));
        }
        enrolledCoursesList.refresh();
        coursesCheck();
        isLoading.value = false;
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void coursesCheck() {
    log('enter function');
    if (enrolledCoursesList.isEmpty) {
      log('all courses length ${allCoursesList.length}');
      log('empty enrolled');
      // If no courses are enrolled, all courses are available
      availableCoursesList.value = allCoursesList;
    } else {
      log('all courses length ${allCoursesList.length}');
      log('not empty enrolled');
      // Otherwise, filter out the courses that are already enrolled
      availableCoursesList.value = allCoursesList
          .where((course) => !enrolledCoursesList
              .any((enrolledCourse) => enrolledCourse.id == course.id))
          .toList();
    }
    log('available courses length ${availableCoursesList.length}');
  }

  // function to check in cache courses we have or not
  Future<void> checkCacheCourses() async {
    final cacheCourses = box.read('coursesList') ?? '';
    log('coursesList in cache ${cacheCourses.length}');
    if (cacheCourses == '') {
      log('courses from api');
      getCourses();
    } else {
      log('courses from cache');
      for (var i = 0; i < cacheCourses.length; i++) {
        allCoursesList.add(CourseModel.fromJson(cacheCourses[i]));
      }
      allCoursesList.refresh();
    }
  }

  // get specific course
  Future<void> getSpecificCourse(String id) async {
    try {
      String endpoint = baseUrl + specificCourseEndpoint + id;
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var response = await http.get(
        Uri.parse(endpoint),
        headers: header,
      );
      log('endpoint === $header');
      // log('response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        log('response === $decodedResponse');
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    }
  }

  // get all courses
  Future<void> getCourses() async {
    try {
      isLoading.value = true;
      String endpoint = '$baseUrl$courseEndpoint';
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        // 'authorization': 'Bearer $token',
      };
      var response = await http.get(
        Uri.parse(endpoint),
        headers: header,
      );
      log('endpoint === $header');
      log('courses response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        box.write('coursesList', decodedResponse);
        log('response === $decodedResponse');
        log('stored in cache');
        allCoursesList.clear();
        for (var i = 0; i < decodedResponse.length; i++) {
          allCoursesList.add(CourseModel.fromJson(decodedResponse[i]));
        }
        allCoursesList.refresh();
        isLoading.value = false;
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void selectCourse(CourseModel course) {
    selectedCourse.value = course;
    selectedCourse.refresh();
    coursePrice.value = selectedCourse.value.price1!;
    Get.to(() => const CourseDetail());
  }

  //sort courses according to price ascending
  // void sortCoursesAscending() {
  //   allCoursesList.sort((a, b) => a.price!.compareTo(b.price!));
  // }

  //sort courses according to price descending
  // void sortCoursesDescending() {
  //   allCoursesList.sort((a, b) => b.price!.compareTo(a.price!));
  // }

  //sort courses according to price descending
  void sortCoursesNone() {
    allCoursesList.sort((a, b) => a.id!.compareTo(b.id!));
  }
}
