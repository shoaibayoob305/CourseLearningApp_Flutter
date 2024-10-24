import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../utils/widgets/defaultsnackbar.dart';
import '../../friends/controller/friends_controller.dart';
import '../controllers/messages_controller.dart';
import '../views/group_name.dart';

class FriendSelectionDialog {
  static void showFriendSelectionDialog() {
    final controller = Get.put(FriendsController());
    final messageController = Get.put(MessagesController());

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
          ),
          width: double.infinity,
          height: Get.height / 2,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                // title: const Text("Select Friends"),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  messageController.remainingFriends.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(Icons.close),
                          ),
                        )
                      : TextButton(
                          onPressed: () {
                            if (messageController.remainingFriends.isEmpty) {
                            } else if (messageController.friendsId.isEmpty) {
                              DefaultSnackbar.show(
                                  'Error', 'Select one friend');
                            } else if (messageController.isGroup.value) {
                              Get.back(); // Close the dialog
                              EnterGroupNameDialog.showGroupNameDialog();
                              // Get.to(() => const EnterGroupNameScreen());
                            } else {
                              Get.back(); // Close the dialog
                              messageController.makeConversation();
                            }
                          },
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              color: Color(0xff233853),
                            ),
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 10),
              Obx(
                () => controller.isLoading.value
                    ? Center(
                        child: LoadingAnimationWidget.beat(
                          color: Colors.blueGrey.shade700,
                          size: 40,
                        ),
                      )
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: messageController.remainingFriends.isEmpty
                              ? messageController.isOneToOne.value
                                  ? const Center(
                                      child: Text(
                                        'You already have 1-to-1 Chats with all your friends',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  : const Center(
                                      child: Text(
                                        'You already have Group Chats with all your friends',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      messageController.remainingFriends.length,
                                  itemBuilder: (context, index) {
                                    final friend = messageController
                                        .remainingFriends[index];

                                    return Obx(
                                      () => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            messageController.selectFriend(
                                                friend,
                                                !messageController
                                                    .isGroup.value);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: messageController
                                                      .isGroup.value
                                                  ? null
                                                  : messageController.friendsId
                                                          .contains(friend)
                                                      ? Border.all(
                                                          color: Colors.blue)
                                                      : null,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 4.0,
                                                  spreadRadius: 1.0,
                                                  color: Colors.grey.shade300,
                                                )
                                              ],
                                            ),
                                            child: ListTile(
                                              leading: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  messageController
                                                          .isGroup.value
                                                      ? Checkbox(
                                                          value:
                                                              messageController
                                                                  .friendsId
                                                                  .contains(
                                                                      friend),
                                                          onChanged:
                                                              (bool? value) {
                                                            // Checkbox state handler
                                                          },
                                                        )
                                                      : SizedBox.shrink(),
                                                  CircleAvatar(
                                                    backgroundColor: Colors.red,
                                                    child: friend.image != null
                                                        ? CachedNetworkImage(
                                                            imageUrl:
                                                                friend.image!,
                                                            progressIndicatorBuilder: (context,
                                                                    url,
                                                                    downloadProgress) =>
                                                                CircularProgressIndicator(
                                                                    value: downloadProgress
                                                                        .progress),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(Icons
                                                                    .error),
                                                          )
                                                        : const Icon(
                                                            Icons.person),
                                                  ),
                                                ],
                                              ),
                                              title: Text(friend.name ?? ''),
                                              // trailing: friend.acceptedAt == null
                                              //     ? Container(
                                              //         width: 35,
                                              //         height: 35,
                                              //         decoration: BoxDecoration(
                                              //           color:
                                              //               Colors.grey.shade300,
                                              //           borderRadius:
                                              //               BorderRadius.circular(
                                              //                   20.0),
                                              //         ),
                                              //         child: const Icon(
                                              //           Icons
                                              //               .person_add_alt_1_rounded,
                                              //           size: 20,
                                              //         ),
                                              //       )
                                              //     : null,
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
      ),
      barrierDismissible: true,
    );
  }
}


// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:frontend/app/modules/message/controllers/messages_controller.dart';
// import 'package:frontend/app/modules/message/views/group_name.dart';
// import 'package:frontend/app/utils/widgets/defaultsnackbar.dart';
// import 'package:get/get.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';

// import '../../friends/controller/friends_controller.dart';

// class FriendScreen extends StatelessWidget {
//   const FriendScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(FriendsController());
//     final messageController = Get.put(MessagesController());

//     return Scaffold(
//       appBar: AppBar(
//         forceMaterialTransparency: true,
//         actions: [
//           TextButton(
//             onPressed: () {
//               if (messageController.friendsId.isEmpty) {
//                 DefaultSnackbar.show('Error', 'Select one friend');
//               } else if (messageController.isGroup.value) {
//                 Get.to(() => const EnterGroupNameScreen());
//               } else {
//                 messageController.makeConversation();
//               }
//             },
//             child: Text('Next'),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.only(top: 25.0),
//         child: Column(
//           mainAxisAlignment: controller.isLoading.value
//               ? MainAxisAlignment.center
//               : MainAxisAlignment.start,
//           children: [
//             Obx(
//               () => controller.isLoading.value == true
//                   ? Center(
//                       child: LoadingAnimationWidget.beat(
//                           color: Colors.blueGrey.shade700, size: 40),
//                     )
//                   : controller.friendsList.isEmpty
//                       ? const Center(
//                           child: Text(
//                             'No Friends yet',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         )
//                       : Expanded(
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 10.0),
//                             child: ListView.builder(
//                               itemCount: controller.friendsList.length,
//                               itemBuilder: (context, index) {
//                                 final friend = controller.friendsList[index];
//                                 if (friend.acceptedAt == null ||
//                                     friend.acceptedAt!.isEmpty) {
//                                   return SizedBox.shrink();
//                                 }
//                                 return Obx(
//                                   () => Padding(
//                                     padding: const EdgeInsets.only(bottom: 10),
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         messageController.selectFriend(friend,
//                                             !messageController.isGroup.value);
//                                       },
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(8.0),
//                                           boxShadow: [
//                                             BoxShadow(
//                                                 blurRadius: 4.0,
//                                                 spreadRadius: 1.0,
//                                                 color: Colors.grey.shade300)
//                                           ],
//                                         ),
//                                         child: ListTile(
//                                           leading: Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Checkbox(
//                                                 value: messageController
//                                                     .friendsId
//                                                     .contains(friend),
//                                                 onChanged: (bool? value) {
//                                                   // Handle the checkbox state change
//                                                   // messageController.selectFriend(
//                                                   //     friend.id!,
//                                                   //     !messageController
//                                                   //         .isGroup.value);
//                                                 },
//                                               ),
//                                               CircleAvatar(
//                                                 backgroundColor: Colors.red,
//                                                 child: friend.otherUserImage !=
//                                                         null
//                                                     ? CachedNetworkImage(
//                                                         imageUrl: friend
//                                                             .otherUserImage!,
//                                                         progressIndicatorBuilder: (context,
//                                                                 url,
//                                                                 downloadProgress) =>
//                                                             CircularProgressIndicator(
//                                                                 value: downloadProgress
//                                                                     .progress),
//                                                         errorWidget: (context,
//                                                                 url, error) =>
//                                                             Icon(Icons.error),
//                                                       )
//                                                     : Icon(Icons.person),
//                                               ),
//                                             ],
//                                           ),
//                                           title:
//                                               Text(friend.otherUserName ?? ''),
//                                           trailing: friend.acceptedAt == null
//                                               ? Container(
//                                                   width: 35,
//                                                   height: 35,
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.grey.shade300,
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             20.0),
//                                                   ),
//                                                   child: const Icon(
//                                                     Icons
//                                                         .person_add_alt_1_rounded,
//                                                     size: 20,
//                                                   ),
//                                                 )
//                                               : null,
//                                         ),

//                                         // child: ListTile(
//                                         //   title: Text(friend.otherUserName ?? ''),
//                                         //   leading: CircleAvatar(
//                                         //     backgroundColor: Colors.red,
//                                         //     child: friend.otherUserImage != null
//                                         //         ? CachedNetworkImage(
//                                         //             imageUrl:
//                                         //                 friend.otherUserImage!,
//                                         //             progressIndicatorBuilder: (context,
//                                         //                     url,
//                                         //                     downloadProgress) =>
//                                         //                 CircularProgressIndicator(
//                                         //                     value:
//                                         //                         downloadProgress
//                                         //                             .progress),
//                                         //             errorWidget:
//                                         //                 (context, url, error) =>
//                                         //                     Icon(Icons.error),
//                                         //           )
//                                         //         : Icon(Icons.person),
//                                         //   ),
//                                         //   trailing: friend.acceptedAt == null
//                                         //       ? Container(
//                                         //           width: 35,
//                                         //           height: 35,
//                                         //           decoration: BoxDecoration(
//                                         //             color: Colors.grey.shade300,
//                                         //             borderRadius:
//                                         //                 BorderRadius.circular(
//                                         //                     20.0),
//                                         //           ),
//                                         //           child: const Icon(
//                                         //             Icons
//                                         //                 .person_add_alt_1_rounded,
//                                         //             size: 20,
//                                         //           ),
//                                         //         )
//                                         //       : null,
//                                         // ),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
