import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DefaultSnackbar {
  static void show(String title, String message,
      {Duration duration = const Duration(seconds: 3)}) {
    Get.snackbar(
      title,
      message,
      duration: duration,
      backgroundColor: const Color(0xff233853),
      snackPosition: SnackPosition.TOP,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: const Duration(milliseconds: 500),
      icon: const Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
      shouldIconPulse: true,
    );
  }
}
