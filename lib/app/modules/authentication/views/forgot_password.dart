import 'package:flutter/material.dart';
import 'package:frontend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../utils/widgets/new_text_field.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthenticationController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(246, 249, 251, 1),
      body: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 20.0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: const Color(0xffEBF2F0),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new),
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Image.asset(
                    'assets/logowithtext.png',
                    width: 149,
                    height: 186,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: const Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(47, 46, 54, 1),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: const Text(
                    "Enter email to recover password",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(47, 46, 54, 1),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Obx(
                        () => NewTextField(
                          onChange: (p0) {
                            if (p0.isNotEmpty) {
                              controller.forgotEmailValidator.value =
                                  controller.forgotEmailController.text.isEmail;
                            }
                          },
                          errorMessage: controller.forgotEmailValidator.value
                              ? null
                              : 'Invalid Email address',
                          iconData: Icons.mail,
                          controller: controller.forgotEmailController,
                          obsecureText: false,
                          showPassword: false,
                          hint: '............@gmail.com',
                          isIconColor: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    bottom: 20,
                  ),
                  child: Column(
                    children: [
                      Obx(
                        () => GestureDetector(
                          onTap: controller.isLoading.value
                              ? null
                              : controller.forgotPasswordApi,
                          child: Container(
                            width: Get.width,
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(34, 55, 82, 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: controller.isLoading.value
                                  ? LoadingAnimationWidget.waveDots(
                                      color: Colors.white, size: 40)
                                  : const Text(
                                      "Recover Password",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
