import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/app/modules/message/controllers/messages_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../controllers/messagewebsocketcontroller.dart';
import 'rename_group_dialog.dart';

class MessageView extends StatelessWidget {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MessagesController());
    final messageWebSocketController = Get.put(MessageWebSocketController());
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
        title: ListTile(
          // leading: Stack(
          //   children: [
          //     CircleAvatar(
          //       backgroundColor: Colors.grey.shade800,
          //       radius: 25,
          //       child: const ClipOval(
          //         child: Icon(Icons.person),
          //       ),
          //     ),
          //     const Positioned(
          //       right: 0,
          //       bottom: 0,
          //       child: CircleAvatar(
          //         backgroundColor: Color(0xff2BEF83),
          //         radius: 7,
          //       ),
          //     ),
          //   ],
          // ),
          title: Obx(
            () => Text(
              controller.selectedConversationId.value.isOneToOne == true
                  ? controller.selectedConversationId.value.name ?? ''
                  : controller.selectedConversationId.value.name ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xff000E08),
              ),
            ),
          ),
          // subtitle: const Text(
          //   'Active now',
          //   style: TextStyle(
          //     color: Color(0xff797C7B),
          //     fontSize: 12,
          //   ),
          // ),
        ),
        actions: [
          PopupMenuButton<int>(
            color: Colors.grey.shade200,
            offset: Offset(0, AppBar().preferredSize.height),
            onSelected: (value) {
              switch (value) {
                case 0:
                  print('Zero action');
                  controller.renameGroupController.text =
                      controller.selectedConversationId.value.name ?? '';
                  RenameGroupDialog.showGroupNameDialog();
                case 1:
                  // Perform action for first button
                  print("First action");
                  controller.selectedConversationId.value.isMuted == true
                      ? controller.unmuteConversation()
                      : controller.muteSpecificConversation();
                  break;
                case 2:
                  // Perform action for second button
                  print("Second action");
                  controller.getAvailableFriends(
                      false, controller.selectedConversationId.value.id!);
                  break;
                case 3:
                  // Perform action for third button
                  print("Third action");
                  controller.leaveConversation();
                  break;
              }
            },
            itemBuilder: (context) => controller
                            .selectedConversationId.value.isOneToOne ==
                        false &&
                    controller.selectedConversationId.value.isCourseGroup ==
                        false
                ? [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text("Rename"),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: controller.selectedConversationId.value.isMuted ==
                              true
                          ? Text("Unmute")
                          : Text("Mute"),
                    ),
                    const PopupMenuItem<int>(
                      value: 2,
                      child: Text("Add Participants"),
                    ),
                    const PopupMenuItem<int>(
                      value: 3,
                      child: Text("Leave Group"),
                    ),
                  ]
                : controller.selectedConversationId.value.isCourseGroup == true
                    ? [
                        PopupMenuItem<int>(
                          value: 1,
                          child:
                              controller.selectedConversationId.value.isMuted ==
                                      true
                                  ? Text("Unmute")
                                  : Text("Mute"),
                        ),
                        const PopupMenuItem<int>(
                          value: 3,
                          child: Text("Leave Group"),
                        ),
                      ]
                    : [
                        PopupMenuItem<int>(
                          value: 1,
                          child:
                              controller.selectedConversationId.value.isMuted ==
                                      true
                                  ? Text("Unmute")
                                  : Text("Mute"),
                        ),
                      ],
            icon: const Icon(Icons.more_vert), // Three dots icon
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.isLoading.value == true) {
            return Center(
              child: LoadingAnimationWidget.beat(
                  color: Colors.blueGrey.shade700, size: 40),
            );
          } else {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              controller.scrollController.animateTo(
                controller.scrollController.position.maxScrollExtent,
                duration: const Duration(
                    milliseconds: 300), // Adjust the duration as needed
                curve: Curves.easeOut, // Smooth animation curve
              );
            });
            return Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 15,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => Expanded(
                      child: ListView.builder(
                        controller: controller.scrollController,
                        itemCount: controller.isLoadingMore.value
                            ? controller.conversationMessages.value.results!
                                    .length +
                                1
                            : controller
                                .conversationMessages.value.results!.length,
                        itemBuilder: (context, index) {
                          if (index == 0 && controller.isLoadingMore.value) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, bottom: 15.0),
                              child: Center(
                                child: LoadingAnimationWidget.beat(
                                  color: Colors.blueGrey.shade700,
                                  size: 30,
                                ),
                              ),
                            );
                          }

                          final message = controller
                              .conversationMessages.value.results![index];
                          final myName = controller
                              .authenticationController.userModel.value.id;
                          final image = message.senderImage == null
                              ? ''
                              : '${message.senderImage}';
                          print('image $image');
                          final formattedDate =
                              controller.formatTimestamp(message.createdAt!);
                          print('date is $formattedDate');

                          // Format only the date part for comparison
                          final currentMessageDate = DateFormat('MMMM d,yyyy')
                              .format(message.createdAt!);
                          final todayDate =
                              DateFormat('MMMM d,yyyy').format(DateTime.now());

                          // Determine if the date should be displayed
                          String? displayDate;
                          if (index == 0) {
                            displayDate = currentMessageDate == todayDate
                                ? "Today"
                                : currentMessageDate;
                          } else {
                            final previousMessageDate =
                                DateFormat('MMMM d,yyyy').format(controller
                                    .conversationMessages
                                    .value
                                    .results![index - 1]
                                    .createdAt!);
                            if (currentMessageDate != previousMessageDate) {
                              displayDate = currentMessageDate == todayDate
                                  ? "Today"
                                  : currentMessageDate;
                            }
                          }

                          return MessageBubble(
                            userImage: image,
                            sender: message.senderName ?? '',
                            text: message.content ?? '',
                            isMe: message.sender == myName,
                            timestamp: DateFormat('MMMM dd, yyyy – hh:mm a')
                                .format(message.createdAt!),
                            formattedDate:
                                displayDate != null ? displayDate : null,
                          );
                        },
                      ),
                    ),
                  ),
                  MessageInput(
                    controller:
                        messageWebSocketController.messageTextEditingController,
                    onPress: () {
                      FocusScope.of(context).unfocus();
                      messageWebSocketController.sendMessage();
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  final String userImage;
  final String timestamp;
  final String? formattedDate;
  final bool isOneToOne;

  const MessageBubble({
    super.key,
    required this.sender,
    required this.text,
    required this.isMe,
    required this.userImage,
    required this.timestamp,
    this.formattedDate,
    this.isOneToOne = true,
  });

  String formatTimestamp(String timestamp) {
    DateFormat inputFormat = DateFormat('MMMM dd, yyyy – hh:mm a');
    DateTime dateTime = inputFormat.parse(timestamp);
    return DateFormat('h:mm a').format(dateTime);
  }

  Color getRandomColor(String senderName) {
    final random = Random(senderName.hashCode);
    return Color.fromARGB(
      255,
      random.nextInt(256), // Red
      random.nextInt(256), // Green
      random.nextInt(256), // Blue
    );
  }

  @override
  Widget build(BuildContext context) {
    final senderColor =
        getRandomColor(sender); // Get color based on sender's name

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (formattedDate != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Center(
              child: Text(
                formattedDate!,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 6.0,
            horizontal: 5.0,
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (!isMe)
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade800,
                      radius: 20,
                      child: ClipOval(
                        child: userImage.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: userImage,
                                width: 40,
                                height: 40,
                                fit: BoxFit.fill,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )
                            : Image.asset('assets/person.png'),
                      ),
                    ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: isMe
                                ? BorderRadius.circular(10.0)
                                : BorderRadius.circular(10.0),
                            color: isMe
                                ? const Color(0xff3D4A7A)
                                : Colors.blue.shade100,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 13.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Show sender's name if it's not one-to-one and not the user's message
                                if (!isOneToOne && !isMe)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      sender,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            senderColor, // Set random color for the sender's name
                                      ),
                                    ),
                                  ),
                                Text(
                                  text,
                                  style: TextStyle(
                                    color: isMe ? Colors.white : Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  formatTimestamp(timestamp),
                                  style: TextStyle(
                                    color:
                                        isMe ? Colors.white70 : Colors.black54,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (isMe)
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade800,
                      radius: 20,
                      child: ClipOval(
                        child: userImage.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: userImage,
                                width: 40,
                                height: 40,
                                fit: BoxFit.fill,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )
                            : Image.asset('assets/person.png'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MessageInput extends StatelessWidget {
  MessageInput({super.key, required this.controller, required this.onPress});

  TextEditingController controller = TextEditingController();
  void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: const Color(0xffF3F6F6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Write your message',
                hintStyle: TextStyle(
                  color: Color(0xff797C7B),
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: onPress,
          ),
        ],
      ),
    );
  }
}
