import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../utils/widgets/defaultsnackbar.dart';
import '../../friends/controller/friends_controller.dart';
import '../controllers/messages_controller.dart';

class AddParticipantsScreen extends StatelessWidget {
  const AddParticipantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FriendsController());
    final messageController = Get.put(MessagesController());

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        actions: [
          TextButton(
            onPressed: () async {
              if (messageController.friendsId.isEmpty) {
                DefaultSnackbar.show('Error', 'Select one friend');
              } else {
                await messageController.addParticipants(
                    messageController.selectedConversationId.value.id!);
                messageController.friendsId.clear();
                await messageController.getSpecificParticipants(false);
                Get.back();
              }
            },
            child: Text('Add Participants'),
          ),
        ],
      ),
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
                            'No Friends available for Group',
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
                              itemCount:
                                  messageController.remainingFriends.length,
                              itemBuilder: (context, index) {
                                final friend =
                                    messageController.remainingFriends[index];

                                return Obx(
                                  () => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        messageController.selectFriend(
                                            friend, false);
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
                                          leading: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Checkbox(
                                                value: messageController
                                                    .friendsId
                                                    .contains(friend),
                                                onChanged: (bool? value) {},
                                              ),
                                              CircleAvatar(
                                                backgroundColor: Colors.red,
                                                child: friend.image != null
                                                    ? CachedNetworkImage(
                                                        imageUrl: friend.image!,
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
                                            ],
                                          ),
                                          title: Text(friend.name ?? ''),
                                        ),
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
    );
  }
}
