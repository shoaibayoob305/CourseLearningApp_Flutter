import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:frontend/app/utils/widgets/new_text_field.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthenticationController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(246, 249, 251, 1),
      body: SingleChildScrollView(
        child: SafeArea(
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
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          top: 20.0,
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
                  SizedBox(
                    height: 45,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: const Text(
                      "Welcome to CertifAI",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: const Text(
                      "Create your free account",
                      textAlign: TextAlign.center,
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
                        NewTextField(
                          iconData: Icons.person,
                          controller: controller.signupFullNameController,
                          obsecureText: false,
                          showPassword: false,
                          isIconColor: true,
                          hint: 'Full Name',
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Obx(
                          () => NewTextField(
                            onChange: (p0) {
                              if (p0.isNotEmpty) {
                                controller.signupEmailValidator.value =
                                    controller
                                        .signupEmailController.text.isEmail;
                              }
                            },
                            errorMessage: controller.signupEmailValidator.value
                                ? null
                                : 'Invalid Email address',
                            iconData: Icons.mail,
                            controller: controller.signupEmailController,
                            obsecureText: false,
                            showPassword: false,
                            isIconColor: true,
                            hint: '............@gmail.com',
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Obx(
                          () => NewTextField(
                            iconData: Icons.lock,
                            controller: controller.signupPasswordController,
                            obsecureText:
                                controller.signupPasswordObsecureText.value,
                            showPassword: true,
                            isIconColor: true,
                            hint: 'Password',
                            onTap: () {
                              controller.signupPasswordObsecureText.value =
                                  !controller.signupPasswordObsecureText.value;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Obx(
                          () => NewTextField(
                            iconData: Icons.lock,
                            isIconColor: true,
                            controller:
                                controller.signupConfirmPasswordController,
                            obsecureText: controller
                                .signupConfirmPasswordObsecureText.value,
                            showPassword: true,
                            hint: 'Confirm Password',
                            onTap: () {
                              controller
                                      .signupConfirmPasswordObsecureText.value =
                                  !controller
                                      .signupConfirmPasswordObsecureText.value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
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
                                : controller.sendVerificationEmailApi,
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
                                        "Sign up",
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
                        SizedBox(
                          height: 14.0,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(147, 146, 150, 1),
                            ),
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.back();
                                  },
                                text: 'Login',
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(38, 56, 83, 1),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
