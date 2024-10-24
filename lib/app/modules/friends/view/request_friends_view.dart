import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controller/friends_controller.dart';

class RequestFriendsView extends StatelessWidget {
  const RequestFriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FriendsController());

    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: const Color(0xff233853),
      onRefresh: () async {
        await controller.getFriendsList();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            mainAxisAlignment: controller.isLoading.value
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Obx(
                () => controller.isLoading.value == true
                    ? Center(
                        child: LoadingAnimationWidget.beat(
                            color: Colors.blueGrey.shade700, size: 40),
                      )
                    : controller.friendsList.isEmpty
                        ? const Center(
                            child: Text(
                              'No Friends yet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ListView.separated(
                                itemCount: controller.friendsList.length,
                                separatorBuilder: (context, index) =>
                                    const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5.0)),
                                itemBuilder: (context, index) {
                                  final friend = controller.friendsList[index];

                                  return friend.acceptedAt == null &&
                                          friend.fromUser ==
                                              controller
                                                  .authenticationController
                                                  .userModel
                                                  .value
                                                  .id
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: GestureDetector(
                                            onTap: () {
                                              controller.isFriend = false.obs;
                                              controller.isPending = false.obs;
                                              controller.isRequestSent =
                                                  true.obs;
                                              controller.selectUser(
                                                  friend.id!, false);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 4.0,
                                                      spreadRadius: 1.0,
                                                      color:
                                                          Colors.grey.shade300)
                                                ],
                                              ),
                                              child: ListTile(
                                                title: Text(
                                                    friend.otherUserName ?? ''),
                                                leading: CircleAvatar(
                                                  backgroundColor: Colors.red,
                                                  child: friend
                                                              .otherUserImage !=
                                                          null
                                                      ? CachedNetworkImage(
                                                          imageUrl: friend
                                                              .otherUserImage!,
                                                          progressIndicatorBuilder: (context,
                                                                  url,
                                                                  downloadProgress) =>
                                                              CircularProgressIndicator(
                                                                  value: downloadProgress
                                                                      .progress),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        )
                                                      : Icon(Icons.person),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox.shrink();
                                },
                              ),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
