import 'dart:convert';
import 'dart:developer';

import 'package:frontend/app/modules/course/model/course_model.dart';
import 'package:frontend/app/modules/subscriptions/model/subscription_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../utils/requests/api_endpoints.dart';
import '../../../utils/widgets/defaultsnackbar.dart';

class SubscriptionsController extends GetxController {
  RxBool isLoading = false.obs;
  final box = GetStorage();
  RxList<SubscriptionsModel> subscriptionList = <SubscriptionsModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await getSubscriptions();
  }

  // get all subscriptions
  Future<void> getSubscriptions() async {
    try {
      isLoading.value = true;
      String endpoint = baseUrl + subscriptionEndpoint;
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
      log('subscription response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        log('response === $decodedResponse');
        // var courses =
        //     decodedResponse.map((json) => CourseModel.fromJson(json)).toList();
        for (var i = 0; i < decodedResponse.length; i++) {
          subscriptionList.add(SubscriptionsModel.fromJson(decodedResponse[i]));
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
}
