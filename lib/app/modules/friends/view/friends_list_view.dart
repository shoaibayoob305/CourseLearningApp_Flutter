import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controller/friends_controller.dart';

class FriendsListView extends StatelessWidget {
  const FriendsListView({super.key});

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
          padding: const EdgeInsets.only(top: 25.0),
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
                              child: ListView.builder(
                                itemCount: controller.friendsList.length,
                                itemBuilder: (context, index) {
                                  final friend = controller.friendsList[index];
                                  if (friend.acceptedAt == null ||
                                      friend.acceptedAt!.isEmpty) {
                                    return SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.isFriend = true.obs;
                                        controller.isPending = false.obs;
                                        controller.isRequestSent = false.obs;
                                        controller.selectUser(friend.id!, true);
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
                                                color: Colors.grey.shade300)
                                          ],
                                        ),
                                        child: ListTile(
                                          title:
                                              Text(friend.otherUserName ?? ''),
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.red,
                                            child: friend.otherUserImage != null
                                                ? CachedNetworkImage(
                                                    imageUrl:
                                                        friend.otherUserImage!,
                                                    progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                        CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  )
                                                : Icon(Icons.person),
                                          ),
                                          trailing: friend.acceptedAt == null
                                              ? Container(
                                                  width: 35,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: const Icon(
                                                    Icons
                                                        .person_add_alt_1_rounded,
                                                    size: 20,
                                                  ),
                                                )
                                              : null,
                                        ),
                                      ),
                                    ),
                                  );
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
