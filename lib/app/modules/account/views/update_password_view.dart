import 'package:flutter/material.dart';
import 'package:frontend/app/modules/account/controllers/account_controller.dart';
import 'package:frontend/app/utils/widgets/new_text_field.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UpdatePasswordView extends StatelessWidget {
  const UpdatePasswordView({super.key});

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 15, top: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Current Password',
                          style: TextStyle(
                            color: Color(0xff3D4A7A),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Obx(
                      () => NewTextField(
                        iconData: Icons.lock,
                        controller: controller.currentPasswordController,
                        obsecureText: controller.updateCurrentPasswordEye.value,
                        showPassword: true,
                        hint: '*******',
                        onTap: () {
                          controller.updateCurrentPasswordEye.value =
                              !controller.updateCurrentPasswordEye.value;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Row(
                      children: [
                        Text(
                          'New Password',
                          style: TextStyle(
                            color: Color(0xff233853),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Obx(
                      () => NewTextField(
                        iconData: Icons.lock,
                        controller: controller.newPasswordController,
                        obsecureText: controller.updateNewPasswordEye.value,
                        showPassword: true,
                        hint: '*******',
                        onTap: () {
                          controller.updateNewPasswordEye.value =
                              !controller.updateNewPasswordEye.value;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Row(
                      children: [
                        Text(
                          'Confirm New Password',
                          style: TextStyle(
                            color: Color(0xff233853),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Obx(
                      () => NewTextField(
                        iconData: Icons.lock,
                        controller: controller.newConfirmPasswordController,
                        obsecureText:
                            controller.updateNewConfirmPasswordEye.value,
                        showPassword: true,
                        hint: '*******',
                        onTap: () {
                          controller.updateNewConfirmPasswordEye.value =
                              !controller.updateNewConfirmPasswordEye.value;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: GestureDetector(
                          onTap: controller.isLoading.value
                              ? () {}
                              : () {
                                  controller.isEmail.value = true;
                                  controller.sendEmailCode();
                                },
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
                                      "Change Password",
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
            ],
          ),
        ),
      ),
    );
  }
}

class AvatarWithPicker extends StatelessWidget {
  const AvatarWithPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AccountController());
    return Stack(
      alignment: Alignment.center,
      children: [
        const CircleAvatar(
          radius: 80,
          backgroundImage: AssetImage('assets/home.png'),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              // Show bottom sheet dialog to pick image from camera
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.photo_camera),
                        title: const Text('Take Photo'),
                        onTap: () {
                          // Close the bottom sheet and navigate to camera
                          Get.back();
                          // Add your logic to navigate to the camera screen
                          controller.pickImageFromCamera();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text('Choose from Gallery'),
                        onTap: () {
                          // Close the bottom sheet and navigate to gallery
                          Get.back();
                          // Add your logic to open the gallery picker
                          controller.pickImageFromGallery();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
