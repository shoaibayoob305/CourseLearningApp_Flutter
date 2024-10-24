import 'dart:convert';
import 'dart:developer';

import 'package:frontend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:frontend/app/modules/course/model/course_model.dart';
import 'package:frontend/app/modules/payments/model/payment_model.dart';
import 'package:frontend/app/modules/purchases/controller/purchase_controller.dart';
import 'package:frontend/app/modules/subscriptions/model/subscription_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../utils/requests/api_endpoints.dart';
import '../../../utils/widgets/defaultsnackbar.dart';

class PaymentController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isCardDeleteLoading = false.obs;
  final box = GetStorage();
  AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  PurchaseController purchaseController = Get.put(PurchaseController());
  RxList<PaymentMethods> paymentList = <PaymentMethods>[].obs;
  RxInt selectedCardId = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    authenticationController.userModel.value.id != null
        ? await getPayments()
        : null;
  }

  // get all payments added
  Future<bool> addPayments(String sourceId) async {
    try {
      isLoading.value = true;
      String endpoint = baseUrl + specificPaymentEndpoint;
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var bodyData = {
        'nonce': sourceId,
      };
      var response = await http.post(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode(bodyData),
      );
      log('endpoint === $header');
      log('payment response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 201) {
        getPayments();
        isLoading.value = false;
        return true;
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
        return false;
      }
    } catch (e) {
      log('Error ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

// get all payments added
  Future<void> deleteCard() async {
    try {
      isCardDeleteLoading.value = true;
      String endpoint = '$baseUrl$paymentEndpoint/${selectedCardId.value}/';
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
      log('payment response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 204) {
        await getPayments();
        selectedCardId.value = 0;
        isCardDeleteLoading.value = false;
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isCardDeleteLoading.value = false;
    }
  }

  // get all payments added
  Future<void> getPayments() async {
    try {
      isLoading.value = true;
      String endpoint = baseUrl + paymentEndpoint;
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
      log('payment response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        paymentList.clear();
        var decodedResponse = json.decode(response.body);
        for (var i = 0; i < decodedResponse.length; i++) {
          paymentList.add(PaymentMethods.fromJson(decodedResponse[i]));
        }
        paymentList.refresh();
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
