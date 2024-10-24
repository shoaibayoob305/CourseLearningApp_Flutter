import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:frontend/app/modules/course/model/course_model.dart';
import 'package:frontend/app/modules/friends/model/notfriend_model.dart';
import 'package:frontend/app/modules/friends/model/specificfriend_model.dart';
import 'package:frontend/app/modules/friends/view/friends_list_view.dart';
import 'package:frontend/app/modules/home/controllers/home_controller.dart';
import 'package:frontend/app/modules/home/views/home_bottomnavigation_view.dart';
import 'package:frontend/app/modules/payments/model/payment_model.dart';
import 'package:frontend/app/modules/subscriptions/model/subscription_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../utils/requests/api_endpoints.dart';
import '../../../utils/widgets/defaultsnackbar.dart';
import '../model/friends_model.dart';
import '../view/friends_detail.dart';

class FriendsController extends GetxController {
  RxBool isLoading = false.obs;
  final box = GetStorage();
  AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  HomeController homeController = Get.put(HomeController());
  RxList<FriendsModel> friendsList = <FriendsModel>[].obs;
  var specificFriend = FriendsModel().obs;
  Rx<SpecificUser> notFriend = SpecificUser().obs;
  Rx<SpecificFriendUser> friend = SpecificFriendUser().obs;
  RxBool isFriend = false.obs;
  RxBool isPending = false.obs;
  RxBool isRequestSent = false.obs;
  TextEditingController reportController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    authenticationController.userModel.value.id != null
        ? await getFriendsList()
        : null;
  }

  // get friend data
  Future<void> removeFriend(int Id) async {
    try {
      isLoading.value = true;
      String endpoint = '$baseUrl$friendsListEndpoint/${Id.toString()}/';
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var response = await http.delete(
        Uri.parse(endpoint),
        headers: header,
      );
      log('endpoint === $header');
      log('friends response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 204) {
        await getFriendsList();
        Get.back();
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

  // get friend data
  Future<void> acceptRequest(int Id) async {
    try {
      String endpoint = '$baseUrl$friendsListEndpoint/${Id.toString()}/';
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var response = await http.patch(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode({}),
      );
      log('endpoint === $header');
      log('friends response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 204) {
        await getFriendsList();
        Get.back();
        isLoading.value = false;
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {}
  }

  // function to select specific User
  selectUser(int friendId, bool friend) async {
    await getFriendsData(friendId);
    // if (friend) {
    //   await getFriendsData(friendId);
    // } else {
    //   await getNotFriendsData(friendId);
    // }
  }

  // get not friend specific user data
  Future<void> getNotFriendsData(int Id) async {
    try {
      String endpoint = '$baseUrl$notFriendData${Id.toString()}';
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
      log('not friends response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        SpecificUser specificUser = SpecificUser.fromJson(decodedResponse);
        notFriend.value = specificUser;
        notFriend.refresh();
        Get.to(() => const SpecificFriendView());
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {}
  }

  // get friend data
  Future<void> getFriendsData(int Id) async {
    try {
      String endpoint = '$baseUrl$friendsListEndpoint/${Id.toString()}';
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
      log('friends response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        SpecificFriendUser specificFriendUser =
            SpecificFriendUser.fromJson(decodedResponse);
        friend.value = specificFriendUser;
        friend.refresh();
        Get.to(() => const SpecificFriendView());
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {}
  }

  // get all friends
  Future<void> getFriendsList() async {
    try {
      isLoading.value = true;
      String endpoint = baseUrl + friendsListEndpoint;
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
      log('friends response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        friendsList.clear();
        var decodedResponse = json.decode(response.body);
        for (var i = 0; i < decodedResponse.length; i++) {
          friendsList.add(FriendsModel.fromJson(decodedResponse[i]));
        }
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

  // block specific user
  Future<void> blockSpecificUser() async {
    try {
      isLoading.value = true;
      var bodyData = {
        "blocked": friend.value.otherUserId,
      };
      String endpoint = baseUrl + blockedUserEndpoint;
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var response = await http.post(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode(bodyData),
      );
      log('body === $bodyData');
      log('messages response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 201) {
        reportController.clear();
        isLoading.value = false;
        DefaultSnackbar.show('Success', 'Blocked User Successfully.');
        await getFriendsList();
        Get.until(
          (route) => Get.currentRoute == '/SpecificFriendView',
        );
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // report other user
  Future<void> reportOtherUser() async {
    try {
      isLoading.value = true;
      var bodyData = {
        "reported": friend.value.id,
        "reason": reportController.text,
      };
      String endpoint = baseUrl + reportEndpoint;
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var response = await http.post(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode(bodyData),
      );
      log('body === $bodyData');
      log('messages response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 201) {
        reportController.clear();
        isLoading.value = false;
        DefaultSnackbar.show('Success', 'Report Submitted Successfully.');
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
