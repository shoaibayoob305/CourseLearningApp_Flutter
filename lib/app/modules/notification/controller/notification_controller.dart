import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:frontend/app/modules/course/model/course_model.dart';
import 'package:frontend/app/modules/payments/model/payment_model.dart';
import 'package:frontend/app/modules/subscriptions/model/subscription_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../utils/requests/api_endpoints.dart';
import '../../../utils/widgets/defaultsnackbar.dart';
import '../model/notification_model.dart';

class NotificationController extends GetxController {
  RxBool isLoading = false.obs;
  final box = GetStorage();
  AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  Rx<NotificationsModel> notificationsList = NotificationsModel().obs;
  RxList<Results> unReadNotification = <Results>[].obs;
  RxList<Results> readNotification = <Results>[].obs;
  RxInt unreadNotificationsCount = 0.obs;
  // Initialize ScrollController
  final ScrollController scrollController = ScrollController();
  RxBool isLoadingMore = false.obs;

  @override
  void onInit() async {
    super.onInit();
    authenticationController.userModel.value.id != null
        ? await getNotifications()
        : null;
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!isLoadingMore.value) {
          log('load more notification');
          loadMoreNotifications();
        }
      }
    });
  }

  Future<void> loadMoreNotifications() async {
    // Call your API or method to fetch older messages here
    try {
      isLoadingMore.value = true;
      String endpoint = notificationsList.value.next ?? '';
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
        NotificationsModel notificationsModel =
            NotificationsModel.fromJson(decodedResponse);
        notificationsList.value.next = notificationsModel.next;
        for (var i = 0; i < notificationsModel.results!.length; i++) {
          notificationsList.value.results!.add(notificationsModel.results![i]);
        }
        notificationsList.refresh();
        notificationsList.value.results!
            .sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
        notificationsList.refresh();
        countUnreadNotifications();
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

  // get all notification added
  Future<void> getNotifications() async {
    try {
      isLoading.value = true;
      String endpoint = baseUrl + notificationEndpoint;
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
      log('notification response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        notificationsList.value = NotificationsModel();
        var decodedResponse = json.decode(response.body);
        NotificationsModel notificationsModel =
            NotificationsModel.fromJson(decodedResponse);
        notificationsList.value = notificationsModel;
        // for (var i = 0; i < decodedResponse.length; i++) {
        //   notificationsList
        //       .add(NotificationsModel.fromJson(decodedResponse[i]));
        // }
        notificationsList.refresh();
        countUnreadNotifications();
        print('unread Notifications $unreadNotificationsCount');
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

  countUnreadNotifications() {
    unreadNotificationsCount.value = 0;
    unReadNotification.clear();
    readNotification.clear();
    for (var i = 0; i < notificationsList.value.results!.length; i++) {
      if (notificationsList.value.results![i].read == false) {
        unreadNotificationsCount.value += 1;
        unReadNotification.add(notificationsList.value.results![i]);
        unReadNotification.refresh();
      } else {
        readNotification.add(notificationsList.value.results![i]);
        readNotification.refresh();
      }
    }
  }

  // get all notification readed
  Future<void> readAllNotifications() async {
    try {
      isLoading.value = true;
      String endpoint = baseUrl + readNotificationEndpoint;
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
      log('payment response === ${response.body}');
      log('read all response === ${response.statusCode}');
      if (response.statusCode == 200) {
        // getNotifications();
        unreadNotificationsCount.value = 0;
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
