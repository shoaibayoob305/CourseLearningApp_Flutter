import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app/modules/welcome/controllers/welcome_controller.dart';
import 'package:get/get.dart';

import '../../authentication/views/login_view.dart';
import '../../authentication/views/signup_view.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WelcomeController());
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.jpg'), fit: BoxFit.cover),
          ),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Image.asset(
                    'assets/logowhite.png',
                    width: 240,
                    height: 240,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Our chat app is the perfect way to \nprepare for certifications. Happy \nlearning!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Image(
                            width: 35,
                            height: 35,
                            image: AssetImage('assets/facebook-icon.png'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Image(
                            width: 35,
                            height: 35,
                            image: AssetImage('assets/google-icon.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Divider(
                          color: Colors.grey.shade500,
                          thickness: 0.5,
                          indent: 30,
                          endIndent: 5,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'OR',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xffFFFFFF),
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Divider(
                          color: Colors.grey.shade500,
                          thickness: 0.5,
                          indent: 5,
                          endIndent: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const SignupView()),
                    child: Container(
                      width: Get.width,
                      height: Get.height * 0.07,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey.shade600,
                            Colors.white38,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          'Sign up with mail',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffFFFFFF),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Existing account? ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xffFFFFFF),
                          ),
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.to(() => const LoginView()),
                          text: 'Log in',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffFFFFFF),
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
