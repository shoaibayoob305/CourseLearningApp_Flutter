import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app/modules/friends/controller/friends_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SpecificFriendView extends StatelessWidget {
  const SpecificFriendView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FriendsController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('Friend Info'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () => controller.notFriend.value.image == null
                      ? CircleAvatar(
                          backgroundColor: Colors.grey.shade800,
                          radius: 40,
                          child: ClipOval(
                            child: Center(
                              child: Text(
                                "${controller.friend.value.otherUserName?.substring(0, 1)}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.grey.shade800,
                          radius: 40,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: controller.notFriend.value.image ?? '',
                              width: 120,
                              height: 120,
                              fit: BoxFit.fill,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                ),
                const SizedBox(
                    width: 16), // Space between the avatar and the text
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          controller.friend.value.otherUserName ?? '',
                          style: const TextStyle(
                            fontSize: 20, // Adjust the font size as needed
                            fontWeight: FontWeight
                                .w500, // Adjust the font weight as needed
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Obx(
                        () => Text(
                          'Member since ${DateFormat('MMMM dd, yyyy').format(DateTime.parse(controller.friend.value.otherUserMemberSince ?? ''))}',
                          style: const TextStyle(
                            fontSize: 16, // Adjust the font size as needed
                            fontWeight: FontWeight
                                .w500, // Adjust the font weight as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                controller.isFriend.value
                    ? Obx(
                        () => GestureDetector(
                          onTap: controller.isLoading.value
                              ? null
                              : () => controller
                                  .removeFriend(controller.friend.value.id!),
                          child: Container(
                            width: Get.width * 0.80,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(100)),
                            child: Center(
                              child: controller.isLoading.value
                                  ? LoadingAnimationWidget.waveDots(
                                      color: Colors.white, size: 40)
                                  : const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        "Remove Friend",
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
                      )
                    : controller.isPending.value
                        ? Row(
                            children: [
                              Obx(
                                () => GestureDetector(
                                  onTap: controller.isLoading.value
                                      ? null
                                      : () => controller.acceptRequest(
                                          controller.friend.value.id!),
                                  child: Container(
                                    width: Get.width * 0.40,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff233853),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Center(
                                      child: controller.isLoading.value
                                          ? LoadingAnimationWidget.waveDots(
                                              color: Colors.white, size: 40)
                                          : const Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                "Accept Request",
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
                              const SizedBox(
                                width: 5.0,
                              ),
                              Obx(
                                () => GestureDetector(
                                  onTap: controller.isLoading.value
                                      ? null
                                      : () => controller.removeFriend(
                                          controller.friend.value.id!),
                                  child: Container(
                                    width: Get.width * 0.40,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Center(
                                      child: controller.isLoading.value
                                          ? LoadingAnimationWidget.waveDots(
                                              color: Colors.white, size: 40)
                                          : const Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                "Reject Request",
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
                          )
                        : Obx(
                            () => GestureDetector(
                              onTap: controller.isLoading.value
                                  ? null
                                  : () => controller.removeFriend(
                                      controller.friend.value.id!),
                              child: Container(
                                width: Get.width * 0.80,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Center(
                                  child: controller.isLoading.value
                                      ? LoadingAnimationWidget.waveDots(
                                          color: Colors.white, size: 40)
                                      : const Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            "Cancel Request",
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
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: const EdgeInsets.all(5.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        customButton: const Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xff233853),
                          size: 35,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          width: Get.width * 0.26,
                          offset: const Offset(0, -04),
                        ),
                        value: null,
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'report',
                            child: Text(
                              'Report',
                              style: TextStyle(
                                color: Color(0xff233853),
                              ),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: 'block',
                            child: Text(
                              'Block',
                              style: TextStyle(
                                color: Color(0xff233853),
                              ),
                            ),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          if (newValue == 'report') {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  backgroundColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 20.0,
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Report User',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        'Tell us why you want to report this user.',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Text(
                                        'Reason',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  Colors.grey), // Border color
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Rounded corners
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: TextField(
                                            controller:
                                                controller.reportController,
                                            maxLines:
                                                8, // Set this to however many lines you want
                                            decoration: const InputDecoration(
                                              border: InputBorder
                                                  .none, // Remove the default border
                                              hintText: 'Enter Report',
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      GestureDetector(
                                        onTap: () {
                                          Get.back();
                                          controller.reportOtherUser();
                                        },
                                        child: Container(
                                          width: Get.width,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: const Color(0xff233853),
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          child: Center(
                                            child: controller.isLoading.value
                                                ? LoadingAnimationWidget
                                                    .waveDots(
                                                        color: Colors.white,
                                                        size: 40)
                                                : const Text(
                                                    "Submit Report",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else if (newValue == 'block') {
                            // Handle block action
                            controller.blockSpecificUser();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
