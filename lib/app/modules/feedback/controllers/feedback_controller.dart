import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:frontend/app/modules/course/model/course_model.dart';
import 'package:frontend/app/modules/home/controllers/home_controller.dart';
import 'package:frontend/app/modules/home/views/home_bottomnavigation_view.dart';
import 'package:frontend/app/modules/payments/model/payment_model.dart';
import 'package:frontend/app/modules/setting/views/setting_view.dart';
import 'package:frontend/app/modules/subscriptions/model/subscription_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../utils/requests/api_endpoints.dart';
import '../../../utils/widgets/defaultsnackbar.dart';

class FeedbackController extends GetxController {
  RxBool isLoading = false.obs;
  final box = GetStorage();
  AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  HomeController homeController = Get.put(HomeController());
  TextEditingController feedbackController = TextEditingController();
  TextEditingController suggestionController = TextEditingController();

  // for post feedback
  Future<void> postFeedback() async {
    try {
      isLoading.value = true;
      var bodyData = {
        "subject": "Feedback",
        "message": feedbackController.text,
      };
      String endpoint = baseUrl + feedbackEndpoint;
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var response = await http.post(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode(bodyData),
      );
      log('body === $bodyData');
      log('messages response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        feedbackController.clear();
        isLoading.value = false;
        DefaultSnackbar.show('Success', 'Feedback Submitted Successfully.');
        homeController.selectedIndex.value = 2;
        Get.off(() => const HomeBottomNavigationView());
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  //for post suggestion
  Future<void> postSuggestion() async {
    try {
      isLoading.value = true;
      var bodyData = {
        "subject": "Suggestion",
        "message": suggestionController.text,
      };
      String endpoint = baseUrl + feedbackEndpoint;
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var response = await http.post(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode(bodyData),
      );
      log('body === $bodyData');
      log('messages response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        suggestionController.clear();
        isLoading.value = false;
        DefaultSnackbar.show('Success', 'Suggestion Submitted Successfully.');
        homeController.selectedIndex.value = 2;
        Get.off(() => const HomeBottomNavigationView());
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
