import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app/modules/message/views/friend_screen.dart';
import 'package:frontend/app/modules/message/views/message_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controllers/messages_controller.dart';

class MainMessageView extends StatelessWidget {
  const MainMessageView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MessagesController());

    String formatTimestamp(DateTime? timestamp) {
      // DateTime dateTime = DateTime.parse(timestamp!);
      String formattedTime =
          DateFormat('h:mm a').format(timestamp!); // 12-hour format with AM/PM
      return formattedTime;
    }

    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: const Color(0xff233853),
      onRefresh: () async {
        await controller.getMessages(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text('Chats'),
          centerTitle: true,
          actions: [
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: const EdgeInsets.all(5.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    customButton: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 3.0,
                          top: 3.0,
                          bottom: 3.0,
                          right: 3.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: const Color(0xff233853),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: Get.width * 0.30,
                      offset: const Offset(-90, -04),
                    ),
                    value: null,
                    items: const [
                      DropdownMenuItem<String>(
                        value: '1-to-1 Chat',
                        child: Text(
                          '1-to-1 Chat',
                          style: TextStyle(
                            color: Color(0xff233853),
                          ),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Group Chat',
                        child: Text(
                          'Group Chat',
                          style: TextStyle(
                            color: Color(0xff233853),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (String? newValue) async {
                      if (newValue == 'Group Chat') {
                        controller.isGroup.value = true;
                        controller.isOneToOne.value = false;
                        controller.friendsId
                            .clear(); // Close the modal bottom sheet
                        await controller.getAvailableFriendsForChat(
                            false, 'all');
                        FriendSelectionDialog.showFriendSelectionDialog();
                      } else if (newValue == '1-to-1 Chat') {
                        controller.isGroup.value = false;
                        controller.isOneToOne.value = true;
                        controller.friendsId
                            .clear(); // Close the modal bottom sheet
                        await controller.getAvailableFriendsForChat(
                            false, 'single');
                        FriendSelectionDialog.showFriendSelectionDialog();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Obx(
          () => controller.isLoading.value == true
              ? Center(
                  child: LoadingAnimationWidget.beat(
                      color: Colors.blueGrey.shade700, size: 40),
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 10.0,
                    ),
                    child: Column(
                      children: [
                        if (controller.messagesList.value.results!.isEmpty)
                          const Center(
                            child: Text(
                              'No Messages yet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        else
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                border:
                                    Border.all(color: const Color(0xffBEBAB3))),
                            child: TextField(
                              onChanged: (val) {
                                if (val.isEmpty) {
                                  controller.searchStart.value = false;
                                  controller.searchedMessagesList.value
                                      .results = []; // Clear the search results
                                } else {
                                  controller.searchStart.value = true;
                                  // Filter the chat list based on the search query
                                  controller
                                          .searchedMessagesList.value.results =
                                      controller.messagesList.value.results!
                                          .where((element) => element.name!
                                              .toLowerCase()
                                              .contains(val.toLowerCase()))
                                          .toList();
                                  controller.searchedMessagesList.refresh();
                                }
                                log('length of search is ${controller.searchedMessagesList.value.results!.length}');
                              },
                              cursorColor: const Color(0xff73CE95),
                              decoration: const InputDecoration(
                                filled: true,
                                isDense: true,
                                suffixIcon: Icon(
                                  Icons.search,
                                  size: 28,
                                ),
                                fillColor: Colors.white,
                                hintText: "Search chats",
                                hintStyle: TextStyle(
                                    color: Color(0xff78746D),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0)),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Obx(
                          () => controller.searchStart.value
                              ? ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: controller.searchedMessagesList
                                      .value.results!.length,
                                  separatorBuilder: (context, index) =>
                                      const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                  ),
                                  itemBuilder: (context, index) {
                                    final message = controller
                                        .searchedMessagesList
                                        .value
                                        .results![index];
                                    final lastMessageTime =
                                        message.lastMessage?.createdAt == null
                                            ? ""
                                            : formatTimestamp(
                                                message.lastMessage!.createdAt);
                                    return GestureDetector(
                                      onTap: () async {
                                        controller.selectedConversationId
                                            .value = message;
                                        Get.to(() => const MessageView());
                                        await controller
                                            .getSpecificMessages(true);
                                        await controller
                                            .getSpecificParticipants(false);
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
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  message.isOneToOne == true
                                                      ? message.name!
                                                      : message.name!,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                    color: Color(0xff303030),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                lastMessageTime,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          subtitle: message
                                                      .lastMessage?.content ==
                                                  null
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Flexible(
                                                      child: Text(
                                                        "Write a message to start this conversation",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12,
                                                          color:
                                                              Color(0xff686A8A),
                                                        ),
                                                      ),
                                                    ),
                                                    message.isMuted == true
                                                        ? const Icon(
                                                            Icons
                                                                .speaker_notes_off,
                                                            size: 16,
                                                          )
                                                        : Container()
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        message.lastMessage!
                                                                .content ??
                                                            '',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12,
                                                          color:
                                                              Color(0xff686A8A),
                                                        ),
                                                      ),
                                                    ),
                                                    message.isMuted == true
                                                        ? const Icon(
                                                            Icons
                                                                .speaker_notes_off,
                                                            size: 16,
                                                          )
                                                        : Container()
                                                  ],
                                                ),
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                Colors.grey.shade400,
                                            child: message.isCourseGroup ==
                                                        false &&
                                                    message.isOneToOne == false
                                                ? const Icon(
                                                    Icons.group,
                                                    color: Colors.white,
                                                  )
                                                : message.isOneToOne == true
                                                    ? const Icon(
                                                        Icons.person,
                                                        color: Colors.white,
                                                      )
                                                    : message.isCourseGroup ==
                                                            true
                                                        ? ClipOval(
                                                            child: Image.asset(
                                                              'assets/course.png',
                                                              fit: BoxFit.cover,
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                            ),
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: controller
                                      .messagesList.value.results!.length,
                                  separatorBuilder: (context, index) =>
                                      const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                  ),
                                  itemBuilder: (context, index) {
                                    final message = controller
                                        .messagesList.value.results![index];
                                    log('message id is ${message.id}');
                                    final lastMessageTime =
                                        message.lastMessage?.createdAt == null
                                            ? ""
                                            : formatTimestamp(
                                                message.lastMessage!.createdAt);
                                    return GestureDetector(
                                      onTap: () async {
                                        controller.selectedConversationId
                                            .value = message;
                                        Get.to(() => const MessageView());
                                        await controller
                                            .getSpecificMessages(true);
                                        await controller
                                            .getSpecificParticipants(false);
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
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  message.isOneToOne == true
                                                      ? message.name!
                                                      : message.name!,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                    color: Color(0xff303030),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                lastMessageTime,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          subtitle: message
                                                      .lastMessage?.content ==
                                                  null
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Flexible(
                                                      child: Text(
                                                        "Write a message to start this conversation",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12,
                                                          color:
                                                              Color(0xff686A8A),
                                                        ),
                                                      ),
                                                    ),
                                                    message.isMuted == true
                                                        ? const Icon(
                                                            Icons
                                                                .speaker_notes_off,
                                                            size: 16,
                                                          )
                                                        : Container()
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        message.lastMessage!
                                                                .content ??
                                                            '',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12,
                                                          color:
                                                              Color(0xff686A8A),
                                                        ),
                                                      ),
                                                    ),
                                                    message.isMuted == true
                                                        ? const Icon(
                                                            Icons
                                                                .speaker_notes_off,
                                                            size: 16,
                                                          )
                                                        : Container()
                                                  ],
                                                ),
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                Colors.grey.shade400,
                                            child: message.isCourseGroup ==
                                                        false &&
                                                    message.isOneToOne == false
                                                ? const Icon(
                                                    Icons.group,
                                                    color: Colors.white,
                                                  )
                                                : message.isOneToOne == true
                                                    ? const Icon(
                                                        Icons.person,
                                                        color: Colors.white,
                                                      )
                                                    : message.isCourseGroup ==
                                                            true
                                                        ? ClipOval(
                                                            child: Image.asset(
                                                              'assets/course.png',
                                                              fit: BoxFit.cover,
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                            ),
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
