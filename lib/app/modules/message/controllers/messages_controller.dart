import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:frontend/app/modules/course/model/course_model.dart';
import 'package:frontend/app/modules/friends/controller/friends_controller.dart';
import 'package:frontend/app/modules/friends/model/friends_model.dart';
import 'package:frontend/app/modules/home/controllers/home_controller.dart';
import 'package:frontend/app/modules/home/views/home_bottomnavigation_view.dart';
import 'package:frontend/app/modules/message/model/conversation_model.dart';
import 'package:frontend/app/modules/message/model/newmessage_model.dart';
import 'package:frontend/app/modules/message/model/participantsModel.dart';
import 'package:frontend/app/modules/message/views/message_view.dart';
import 'package:frontend/app/modules/payments/model/payment_model.dart';
import 'package:frontend/app/modules/subscriptions/model/subscription_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../utils/requests/api_endpoints.dart';
import '../../../utils/widgets/defaultsnackbar.dart';
import '../model/messageslist_model.dart' as messagesModel;
import '../views/add_participants.dart';

class MessagesController extends GetxController {
  RxBool isLoading = false.obs;
  final box = GetStorage();
  AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  Rx<messagesModel.MessagesListModel> messagesList =
      messagesModel.MessagesListModel().obs;
  var conversationMessages = NewMessageModel().obs;
  // Initialize ScrollController
  final ScrollController scrollController = ScrollController();
  RxBool isLoadingMore = false.obs;
  RxBool isRenameLoading = false.obs;
  Rx<messagesModel.Result> selectedConversationId = messagesModel.Result().obs;
  TextEditingController messageController = TextEditingController();
  RxBool isGroup = false.obs;
  RxBool isOneToOne = false.obs;
  RxList<ParticipantsModel> friendsId = <ParticipantsModel>[].obs;
  TextEditingController renameGroupController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();
  RxList<ParticipantsModel> participantsList = <ParticipantsModel>[].obs;
  HomeController homeController = Get.put(HomeController());
  RxList<ParticipantsModel> remainingFriends = <ParticipantsModel>[].obs;
  FriendsController friendsController = Get.put(FriendsController());
  GlobalKey btnKey2 = GlobalKey();
  RxString? selectedMenu;
  RxBool searchStart = false.obs;
  Rx<messagesModel.MessagesListModel> searchedMessagesList =
      messagesModel.MessagesListModel().obs;

  @override
  void onInit() async {
    super.onInit();
    authenticationController.userModel.value.id != null
        ? await getMessages(true)
        : null;
    scrollController.addListener(() {
      if (scrollController.offset <=
          scrollController.position.minScrollExtent) {
        if (!isLoadingMore.value) {
          log('load more messages');
          loadMoreMessages();
        }
      }
    });
  }

  void selectFriend(ParticipantsModel id, bool singleValue) {
    print('value is $id');
    print('value is $singleValue');
    if (singleValue) {
      if (friendsId.contains(id)) {
        friendsId.remove(id);
      } else {
        friendsId.clear();
        friendsId.add(id);
      }
    } else {
      if (friendsId.contains(id)) {
        friendsId.remove(
            id); // If the answer is already selected, remove it (toggle behavior)
      } else {
        friendsId.add(id); // Otherwise, add the answer
      }
    }
    print('Current friends list : $friendsId');
    print('Current friends list: ${friendsId.length}');
  }

  List<int> listofId() {
    List<int> returingList = <int>[];
    for (var i = 0; i < friendsId.length; i++) {
      returingList.add(friendsId[i].id!);
    }
    return returingList;
  }

  Future<void> addParticipants(int id) async {
    // Call your API or method to fetch older messages here
    try {
      isLoadingMore.value = true;
      String endpoint = '$baseUrl$conersationEndpoint/$id/participants/';
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var bodyData = {
        'participants': listofId(),
      };
      var response = await http.post(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode(bodyData),
      );
      log('endpoint === $header');
      log('endpoint === $bodyData');
      log('messages response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 201) {
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoadingMore.value = false;
    }
  }

  // to rename group
  Future<void> renameGroup() async {
    try {
      isRenameLoading.value = true;
      String endpoint =
          '$baseUrl$conersationEndpoint/${selectedConversationId.value.id}/';
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var bodyData = {
        'name': renameGroupController.text,
      };
      var response = await http.patch(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode(bodyData),
      );
      log('endpoint === $header');
      log('endpoint === $bodyData');
      log('messages response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        getMessages(false);
        var decodedResponse = jsonDecode(response.body);
        messagesModel.Result result =
            messagesModel.Result.fromJson(decodedResponse);
        selectedConversationId.value = result;
        selectedConversationId.refresh();
        isRenameLoading.value = false;
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isRenameLoading.value = false;
    }
  }

  Future<void> makeConversation() async {
    // Call your API or method to fetch older messages here
    try {
      isLoadingMore.value = true;
      String endpoint = '$baseUrl$conersationEndpoint/';
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var bodyData = isOneToOne.value
          ? {
              'name': isGroup.value
                  ? groupNameController.text
                  : friendsId.first.name,
              'is_one_to_one': isOneToOne.value,
              'participants': listofId(),
            }
          : {
              'name': isGroup.value
                  ? groupNameController.text
                  : friendsId.first.name,
              'is_one_to_one': isOneToOne.value,
            };
      var response = await http.post(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode(bodyData),
      );
      log('endpoint === $header');
      log('endpoint === $bodyData');
      log('messages created response === ${response.body}');
      log('response === ${response.statusCode}');
      var error = json.decode(response.body)['error'];
      if (response.statusCode == 201) {
        var decodedResponse = json.decode(response.body);
        isOneToOne.value ? null : await addParticipants(decodedResponse['id']);
        friendsId.clear();
        await getMessages(false);
        homeController.selectedIndex.value = 2;
        Get.until(
          (route) => Get.currentRoute == '/HomeBottomNavigationView',
        );
      } else {
        DefaultSnackbar.show(
            'Error', 'Something went wrong ${error.toString()}.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreMessages() async {
    // Call your API or method to fetch older messages here
    try {
      isLoadingMore.value = true;
      String endpoint = conversationMessages.value.next ?? '';
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var response = await http.get(
        Uri.parse(endpoint),
        headers: header,
      );
      log('endpoint === $header');
      log('messages response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        log('decoded response is $decodedResponse');
        NewMessageModel conversationModel =
            NewMessageModel.fromJson(decodedResponse);
        conversationMessages.value.next = conversationModel.next;
        for (var i = 0; i < conversationModel.results!.length; i++) {
          conversationMessages.value.results!
              .add(conversationModel.results![i]);
        }
        conversationMessages.refresh();
        conversationMessages.value.results!
            .sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
        conversationMessages.refresh();
        isLoadingMore.value = false;
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoadingMore.value = false;
    }
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('MMMM d,yyyy').format(dateTime); // Example: June 12,2024
  }

  // check its today or not
  String formatTimestamp(DateTime timestamp) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    if (timestamp.isAfter(today)) {
      return 'Today';
    } else {
      return DateFormat('MMMM d,yyyy')
          .format(timestamp); // e.g., "June 12,2024"
    }
  }

  // get all conversations
  Future<void> getMessages(bool loading) async {
    try {
      isLoading.value = loading;
      String endpoint = baseUrl + conersationEndpoint;
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var response = await http.get(
        Uri.parse(endpoint),
        headers: header,
      );
      log('endpoint === $header');
      log('messages response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        messagesModel.MessagesListModel messagesListModel =
            messagesModel.MessagesListModel.fromJson(decodedResponse);
        messagesList.value = messagesListModel;
        messagesList.refresh();
        isLoading.value = false;
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // get specific conversations
  Future<void> postMessage() async {
    try {
      String endpoint =
          '$baseUrl$conversationMessagesEndpoint${selectedConversationId.value.id}/messages/';
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var bodyData = {
        'content': messageController.text,
      };
      var response = await http.post(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode(bodyData),
      );
      log('endpoint === $header');
      log('send message response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 201) {
        messageController.clear();
        await getSpecificMessages(false);
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {}
  }

  Future<void> getAvailableFriendsForChat(bool? loading, String type) async {
    try {
      isLoading.value = loading!;
      String endpoint = '$baseUrl$availableFriends?type=$type';
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var response = await http.get(
        Uri.parse(endpoint),
        headers: header,
      );
      log('endpoint === $header');
      log('available conversation response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        print('length is ${decodedResponse.length}');
        remainingFriends.clear();
        for (var i = 0; i < decodedResponse.length; i++) {
          remainingFriends.add(ParticipantsModel.fromJson(decodedResponse[i]));
        }
        remainingFriends.refresh();
        isLoading.value = false;
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // get specific conversations
  Future<void> getAvailableFriends(bool? loading, int conversation_id) async {
    try {
      isLoading.value = loading!;
      String endpoint =
          '$baseUrl$availableFriends?type=group&conversation_id=$conversation_id';
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var response = await http.get(
        Uri.parse(endpoint),
        headers: header,
      );
      log('endpoint === $header');
      log('available conversation response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        print('length is ${decodedResponse.length}');
        remainingFriends.clear();
        for (var i = 0; i < decodedResponse.length; i++) {
          remainingFriends.add(ParticipantsModel.fromJson(decodedResponse[i]));
        }
        remainingFriends.refresh();
        Get.to(() => const AddParticipantsScreen());
        isLoading.value = false;
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void checkFriends() {
    // Clear remainingFriends to ensure it only contains the new filtered friends
    remainingFriends.clear();
    friendsId.clear();

    // First, filter friends whose acceptedAt is not null or empty
    final acceptedFriends = friendsController.friendsList.where((friend) {
      return friend.acceptedAt != null;
    }).toList();
    print('accepted friend is${acceptedFriends}');
    for (var element in acceptedFriends) {
      log('id of list ${element.id}');
    }
    // Now, filter out those friends who are not in the participantsList
    final nonParticipantFriends = acceptedFriends.where((friend) {
      return !participantsList
          .any((participant) => participant.id == friend.id);
    }).toList();

    // Add the filtered friends to remainingFriends
    // remainingFriends.addAll(nonParticipantFriends);
    Get.to(() => const AddParticipantsScreen());
  }

  // get specific conversations
  Future<void> getSpecificParticipants(bool? loading) async {
    try {
      isLoading.value = loading!;
      String endpoint =
          '$baseUrl$conversationMessagesEndpoint${selectedConversationId.value.id}/participants/';
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var response = await http.get(
        Uri.parse(endpoint),
        headers: header,
      );
      log('endpoint === $header');
      log('specific conversation response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        final participantsModel = participantsModelFromJson(response.body);
        participantsList.value = participantsModel;
        // checkFriends();
        isLoading.value = false;
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // get specific conversations
  Future<void> getSpecificMessages(bool? Loading) async {
    try {
      isLoading.value = Loading!;
      String endpoint =
          '$baseUrl$conversationMessagesEndpoint${selectedConversationId.value.id}/messages/';
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var response = await http.get(
        Uri.parse(endpoint),
        headers: header,
      );
      log('endpoint === $header');
      log('specific conversation response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        NewMessageModel conversationModel =
            NewMessageModel.fromJson(decodedResponse);
        // Sort the messages by timestamp
        conversationModel.results!
            .sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

        conversationMessages.value = conversationModel;
        conversationMessages.refresh();
        isLoading.value = false;
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // leave Conversation
  Future<void> leaveConversation() async {
    try {
      String endpoint =
          '$baseUrl$conversationMessagesEndpoint${selectedConversationId.value.id}/exit/';
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var response = await http.patch(
        Uri.parse(endpoint),
        headers: header,
      );
      log('endpoint === $header');
      log('specific mute response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        await getMessages(false);
        Get.back();
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // unmute Conversation unmuteConversation
  Future<void> unmuteConversation() async {
    try {
      String endpoint =
          '$baseUrl$conversationMessagesEndpoint${selectedConversationId.value.id}/mute/';
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var response = await http.delete(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode({}),
      );
      log('endpoint === $header');
      log('specific mute response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 204) {
        await getMessages(false);
        Get.back();
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // mute specific conversations
  Future<void> muteSpecificConversation() async {
    try {
      String endpoint =
          '$baseUrl$conversationMessagesEndpoint${selectedConversationId.value.id}/mute/';
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var response = await http.post(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode({}),
      );
      log('endpoint === $header');
      log('specific mute response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 201) {
        await getMessages(false);
        Get.back();
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
