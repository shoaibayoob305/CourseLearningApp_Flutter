import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:frontend/app/modules/authentication/views/signup_view.dart';
import 'package:frontend/app/modules/home/views/home_bottomnavigation_view.dart';
import 'package:frontend/app/utils/widgets/new_text_field.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'forgot_password.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                            Get.offAll(() => const HomeBottomNavigationView());
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
                        color: Color.fromRGBO(47, 46, 54, 1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: const Text(
                      "Login to your account",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(47, 46, 54, 1),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        Obx(
                          () => NewTextField(
                            iconData: Icons.mail,
                            isIconColor: true,
                            onChange: (p0) {
                              if (p0.isNotEmpty) {
                                controller.loginEmailValidator.value =
                                    controller
                                        .loginEmailController.text.isEmail;
                              }
                            },
                            controller: controller.loginEmailController,
                            errorMessage: controller.loginEmailValidator.value
                                ? null
                                : 'Invalid Email address',
                            obsecureText: false,
                            showPassword: false,
                            hint: 'Email',
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Obx(
                          () => NewTextField(
                            iconData: Icons.lock,
                            isIconColor: true,
                            controller: controller.loginPasswordController,
                            obsecureText: controller.loginObsecureText.value,
                            showPassword: true,
                            hint: '*******',
                            onTap: () {
                              controller.loginObsecureText.value =
                                  !controller.loginObsecureText.value;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const ForgotPassword());
                              },
                              child: const Text(
                                "Forgot Password?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(47, 46, 54, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        Obx(
                          () => GestureDetector(
                            onTap: controller.isLoading.value
                                ? null
                                : controller.loginApi,
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
                                        "Login",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Don’t have an account? ',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(151, 151, 151, 1),
                            ),
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(() => const SignupView());
                                  },
                                text: 'Sign up',
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(35, 56, 83, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: const Text(
                      "Or",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(47, 46, 54, 1),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Obx(
                      () => GestureDetector(
                        onTap: controller.isLoading.value
                            ? null
                            : controller.handleSignIn,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          width: Get.width,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 1,
                              color: Color.fromRGBO(233, 233, 233, 1),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: controller.isLoading.value
                                ? LoadingAnimationWidget.waveDots(
                                    color: Colors.white, size: 40)
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: SvgPicture.asset(
                                            'assets/figmagoogle.svg'),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        "Login with Google",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff233853),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
