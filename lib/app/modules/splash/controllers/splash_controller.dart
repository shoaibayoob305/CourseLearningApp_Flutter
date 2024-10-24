import 'dart:convert';
import 'dart:developer';

import 'package:frontend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:frontend/app/modules/authentication/model/user_model.dart';
import 'package:frontend/app/modules/course/views/course_view.dart';
import 'package:frontend/app/modules/home/views/home_bottomnavigation_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../welcome/views/welcome_view.dart';

class SplashController extends GetxController {
  static SplashController get instance => Get.find();
  final authenticationController = Get.put(AuthenticationController());
  final box = GetStorage();

  @override
  void onInit() {
    String userData = box.read('userData') ?? "";
    Future.delayed(const Duration(milliseconds: 1500), () async {
      if (userData.isNotEmpty) {
        UserModel user = UserModel.fromJson(json.decode(userData));
        authenticationController.userModel.value = user;
        authenticationController.userModel.refresh();
        Get.offAll(() => const HomeBottomNavigationView());
      } else {
        Get.offAll(() => const HomeBottomNavigationView());
      }
    });
    super.onInit();
  }
}
