import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 249, 251, 1),
      body: SizedBox(
        width: Get.width,
        child: FadeInUp(
          duration: const Duration(milliseconds: 1500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logowithtext.png', // Replace with your image asset
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Master New Skills with CertifAi',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color.fromRGBO(47, 46, 54, 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
