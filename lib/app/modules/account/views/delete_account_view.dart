import 'package:flutter/material.dart';
import 'package:frontend/app/modules/account/controllers/account_controller.dart';
import 'package:frontend/app/utils/widgets/new_text_field.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DeleteAccountView extends StatelessWidget {
  const DeleteAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AccountController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        surfaceTintColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'WARNING: Deleting your account is a permanent action and cannot be undone. All your data, including your profile, posts, and settings, will be permanently removed. Please make sure you have saved any important information before proceeding.\n\nTo confirm account deletion, please enter your password:',
              style: TextStyle(fontSize: 16.0, color: Colors.red),
            ),
            const SizedBox(height: 40.0),
            Obx(
              () => NewTextField(
                controller: controller.deleteAccountPasswordController,
                obsecureText: controller.deletePasswordEye.value,
                showPassword: true,
                hint: '*******',
                onTap: () {
                  controller.updateCurrentPasswordEye.value =
                      !controller.updateCurrentPasswordEye.value;
                },
              ),
            ),
            const SizedBox(height: 30.0),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: GestureDetector(
                  onTap: controller.isLoading.value
                      ? () {}
                      : () => controller.deletePasswordApi(),
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
                              "Delete Account",
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
            ),
          ],
        ),
      ),
    );
  }
}
