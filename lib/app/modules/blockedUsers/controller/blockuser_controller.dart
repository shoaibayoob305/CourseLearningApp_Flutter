import 'dart:convert';
import 'dart:developer';

import 'package:frontend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:frontend/app/modules/friends/controller/friends_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../utils/requests/api_endpoints.dart';
import '../../../utils/widgets/defaultsnackbar.dart';
import '../model/blockeduser_model.dart';

class BlockedUserController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isUnblocking = false.obs;
  final box = GetStorage();
  AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  RxList<BlockedUserModel> blockedUserList = <BlockedUserModel>[].obs;
  FriendsController friendsController = Get.put(FriendsController());

  @override
  void onInit() async {
    super.onInit();
    authenticationController.userModel.value.id != null
        ? await getBlockedUserList(true)
        : null;
  }

  // get all blocked user
  Future<void> getBlockedUserList(bool load) async {
    try {
      isLoading.value = load;
      String endpoint = baseUrl + blockedUserEndpoint;
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
      log('blocked user response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        blockedUserList.clear();
        var decodedResponse = json.decode(response.body);
        for (var i = 0; i < decodedResponse.length; i++) {
          blockedUserList.add(BlockedUserModel.fromJson(decodedResponse[i]));
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

  // get all blocked user
  Future<void> unBlockUser(int id) async {
    print('id of unblock user $id');
    try {
      isUnblocking.value = true;
      String endpoint = '$baseUrl$blockedUserEndpoint$id/';
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
      log('blocked user response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 204) {
        getBlockedUserList(false);
        friendsController.getFriendsList();
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isUnblocking.value = false;
    }
  }
}
