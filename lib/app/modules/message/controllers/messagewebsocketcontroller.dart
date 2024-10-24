import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/app/modules/friends/controller/friends_controller.dart';
import 'package:frontend/app/modules/friends/model/friends_model.dart';
import 'package:frontend/app/modules/message/controllers/messages_controller.dart';
import 'package:frontend/app/modules/message/model/conversation_model.dart';
import 'package:frontend/app/modules/message/model/newmessage_model.dart'
    as conversationModel;
import 'package:frontend/app/modules/message/model/participantsModel.dart';
import 'package:frontend/app/utils/widgets/defaultsnackbar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessageWebSocketController extends GetxController {
  late WebSocketChannel channel;
  MessagesController messagesController = Get.put(MessagesController());
  FriendsController friendsController = Get.put(FriendsController());
  TextEditingController messageTextEditingController = TextEditingController();
  RxString token = ''.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    token.value = box.read('token') ?? '';
    _connectWebSocket();
  }

  // WebSocket connection method
  void _connectWebSocket() {
    channel = WebSocketChannel.connect(
      Uri.parse(
          'ws://3.91.116.119:8000/ws/chat/${messagesController.selectedConversationId.value.id}/?token=${Uri.encodeComponent(token.value)}'),
    );

    // Listen to messages from the WebSocket server
    channel.stream.listen((message) {
      log('WebSocket connected');
      log('data of WebSocket connected $message');
      final data = jsonDecode(message);
      final senderUserId = data['user_id'];
      final content = data['message'];
      log('friend value is $senderUserId');

      var participant = messagesController.participantsList.firstWhere(
        (participants) => participants.id == senderUserId,
        orElse: () => ParticipantsModel(), // Return null if no friend is found
      );
      log('friend value is ${participant.id}');

      if (participant.id != null) {
        messagesController.conversationMessages.value.results!.add(
          conversationModel.Result(
              content: content,
              createdAt: DateTime.now(),
              sender: senderUserId,
              senderImage: participant.image,
              senderName: participant.name),
        );
        messagesController.conversationMessages.refresh();
        // Scroll down smoothly to the last message
        Future.delayed(const Duration(milliseconds: 100), () {
          if (messagesController.scrollController.hasClients) {
            messagesController.scrollController.animateTo(
              messagesController.scrollController.position.maxScrollExtent,
              duration: const Duration(
                  milliseconds: 300), // Smooth scrolling duration
              curve: Curves.easeOut, // Scrolling curve
            );
          }
        });
      } else {
        print('Friend with id $senderUserId not found');
        messagesController.conversationMessages.value.results!.add(
          conversationModel.Result(
              content: content,
              createdAt: DateTime.now(),
              sender: senderUserId,
              senderImage: '',
              senderName: 'Unknown'),
        );
        messagesController.conversationMessages.refresh();
        // Scroll down smoothly to the last message
        Future.delayed(const Duration(milliseconds: 100), () {
          if (messagesController.scrollController.hasClients) {
            messagesController.scrollController.animateTo(
              messagesController.scrollController.position.maxScrollExtent,
              duration: const Duration(
                  milliseconds: 300), // Smooth scrolling duration
              curve: Curves.easeOut, // Scrolling curve
            );
          }
        });
      }
    }, onDone: () async {
      // Connection closed
      log('WebSocket closed');
      await messagesController.getMessages(false);
    }, onError: (error) {
      Get.back(); // Connection failed
      log('WebSocket error: $error');
    });
  }

  // Method to send message to WebSocket server
  void sendMessage() {
    if (messageTextEditingController.text.isNotEmpty) {
      channel.sink.add(
        jsonEncode({
          'message': messageTextEditingController.text,
          'conversation_id': messagesController.selectedConversationId.value.id,
          'created_at': DateTime.now().toIso8601String(),
        }),
      );
      messageTextEditingController.clear(); // Clear the message input
    } else {
      DefaultSnackbar.show('Error', 'Kindly enter text');
    }
  }

  @override
  void onClose() {
    // Close the WebSocket connection when the controller is destroyed
    channel.sink.close();
    super.onClose();
  }
}
