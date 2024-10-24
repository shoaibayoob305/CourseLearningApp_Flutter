import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app/modules/account/controllers/account_controller.dart';
import 'package:frontend/app/utils/widgets/new_text_field.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

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
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.all(0.0),
                                    leading: const Icon(Icons.photo_camera),
                                    title: const Text('Take Photo'),
                                    onTap: () {
                                      // Close the dialog and navigate to camera
                                      Get.back();
                                      // Add your logic to navigate to the camera screen
                                      controller.pickImageFromCamera();
                                    },
                                  ),
                                  ListTile(
                                    contentPadding: const EdgeInsets.all(0.0),
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Choose from Gallery'),
                                    onTap: () {
                                      // Close the dialog and open the gallery picker
                                      Get.back();
                                      // Add your logic to open the gallery picker
                                      controller.pickImageFromGallery();
                                    },
                                  ),
                                  ListTile(
                                    contentPadding: const EdgeInsets.all(0.0),
                                    leading: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    title: const Text(
                                      'Delete Photo',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                    onTap: () {
                                      // Close the dialog and open the gallery picker
                                      Get.back();
                                      // Add your logic to open the gallery picker
                                      controller.deleteImageUpdateProfile();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Obx(
                        () => controller.authenticationController.userModel
                                    .value.image ==
                                null
                            ? controller.imageLoading.value
                                ? CircularProgressIndicator(
                                    color: Color(0xff233853),
                                  )
                                : SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: Obx(() {
                                      return CircleAvatar(
                                        backgroundColor: Colors.black,
                                        child: controller
                                                    .authenticationController
                                                    .userModel
                                                    .value
                                                    .image ==
                                                null
                                            ? ClipOval(
                                                child: Container(
                                                  color: Colors.grey,
                                                  child: Center(
                                                    child: Text(
                                                      "${controller.authenticationController.userModel.value.firstName?.isNotEmpty ?? false ? controller.authenticationController.userModel.value.firstName!.substring(0, 1) : ''}${controller.authenticationController.userModel.value.lastName?.isNotEmpty ?? false ? controller.authenticationController.userModel.value.lastName!.substring(0, 1) : ''}",
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl: controller
                                                            .authenticationController
                                                            .userModel
                                                            .value
                                                            .image ??
                                                        '',
                                                    width: 120,
                                                    height: 120,
                                                    fit: BoxFit.cover,
                                                    progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                        CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                  // child: Image.network(
                                                  //   controller
                                                  //           .authenticationController
                                                  //           .userModel
                                                  //           .value
                                                  //           .image ??
                                                  //       '',
                                                  //   width: 120,
                                                  //   height: 120,
                                                  //   fit: BoxFit.cover,
                                                  // ),
                                                ),
                                              ),
                                      );
                                    }),
                                  )
                            : controller.imageLoading.value
                                ? CircularProgressIndicator(
                                    color: Color(0xff233853),
                                  )
                                : Container(
                                    width: 120.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        // Optional: Set a background color for the circle
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 4,
                                        )
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: Colors.black
                                        //         .withOpacity(0.3),
                                        //     spreadRadius: 2,
                                        //     blurRadius: 5,
                                        //     offset: const Offset(
                                        //         0, 3),
                                        //   ),
                                        // ],
                                        ),
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: controller
                                                .authenticationController
                                                .userModel
                                                .value
                                                .image ??
                                            '',
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.fill,
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Text(
                          'Full Name',
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
                    NewTextField(
                      iconData: Icons.person,
                      controller: controller.editFullNameController,
                      obsecureText: false,
                      showPassword: false,
                      hint: '',
                    ),
                    const SizedBox(height: 30),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: GestureDetector(
                          onTap: controller.isLoading.value
                              ? () {}
                              : () => controller.updateProfileApi(),
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
                                      "Update Profile",
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
