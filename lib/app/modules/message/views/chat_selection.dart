import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/messages_controller.dart';
import 'friend_screen.dart';

class ChatSelectionDialog {
  static void showChatSelectionDialog(BuildContext context) {
    final controller = Get.put(MessagesController());

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled:
          true, // Adjusts the height of the modal to fit content
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  controller.isGroup.value = true;
                  controller.isOneToOne.value = false;
                  controller.friendsId.clear();
                  Navigator.pop(context); // Close the modal bottom sheet
                  await controller.getAvailableFriendsForChat(false, 'all');
                  FriendSelectionDialog.showFriendSelectionDialog();
                },
                child: Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xff233853),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      "New Group Chat",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  controller.isGroup.value = false;
                  controller.isOneToOne.value = true;
                  controller.friendsId.clear();
                  Navigator.pop(context); // Close the modal bottom sheet
                  await controller.getAvailableFriendsForChat(false, 'single');
                  FriendSelectionDialog.showFriendSelectionDialog();
                },
                child: Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xff233853),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      "One-to-One Chat",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
  }
}
