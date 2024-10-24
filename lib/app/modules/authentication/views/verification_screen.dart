import 'package:flutter/material.dart';
import 'package:frontend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pinput/pinput.dart';

class VerificationScreen extends StatelessWidget {
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthenticationController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(246, 249, 251, 1),
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Text(
                  'Enter code to complete registration',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                Pinput(
                  defaultPinTheme: defaultPinTheme,
                  controller: controller.pinController,
                  length: 6,
                ),
              ],
            ),
            Obx(
              () => GestureDetector(
                onTap: controller.isLoading.value
                    ? () {}
                    : () => controller.checkPinCodeApi(),
                child: Container(
                  width: Get.width,
                  height: 50,
                  decoration: BoxDecoration(
                      color: const Color(0xff233853),
                      borderRadius: BorderRadius.circular(100)),
                  child: Center(
                    child: controller.isLoading.value
                        ? LoadingAnimationWidget.waveDots(
                            color: Colors.white, size: 40)
                        : const Text(
                            "Verify",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
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
