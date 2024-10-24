import 'dart:convert';
import 'dart:developer';

import 'package:frontend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:frontend/app/modules/course/controllers/course_controller.dart';
import 'package:frontend/app/modules/course/model/course_model.dart';
import 'package:frontend/app/modules/payments/model/payment_model.dart';
import 'package:frontend/app/modules/purchases/model/purchasemodel.dart';
import 'package:frontend/app/modules/purchases/view/purchase_detail.dart';
import 'package:frontend/app/modules/questions/controller/questionController.dart';
import 'package:frontend/app/modules/questions/view/question_ask.dart';
import 'package:frontend/app/modules/subscriptions/model/subscription_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../utils/requests/api_endpoints.dart';
import '../../../utils/widgets/defaultsnackbar.dart';

class PurchaseController extends GetxController {
  RxBool isLoading = false.obs;
  final box = GetStorage();
  RxInt courseId = 0.obs;
  RxInt paymentMethod = 0.obs;
  Questioncontroller questioncontroller = Get.put(Questioncontroller());
  RxList<PurchaseModel> purchaseList = <PurchaseModel>[].obs;
  Rx<PurchaseModel> selectedPurchaseCourse = PurchaseModel().obs;
  RxInt selectedPurchaseCourseIdForLater = 0.obs;
  Rx<PaymentMethods> specificPaymentDetail = PaymentMethods().obs;
  AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  RxString monthDuration = '1 month'.obs;

  @override
  void onInit() async {
    super.onInit();
    authenticationController.userModel.value.id != null
        ? await getAllPurchases()
        : null;
  }

  selectPurchase(PurchaseModel model) async {
    selectedPurchaseCourse.value = model;
    selectedPurchaseCourse.refresh();
    selectedPurchaseCourse.value.paymentMethod == null
        ? clearSpecificPayment()
        : await getSpecificPayment(selectedPurchaseCourse.value.paymentMethod);
    Get.to(() => const PurchaseDetail());
  }

  clearSpecificPayment() {
    log('null');
    specificPaymentDetail.value = PaymentMethods();
    specificPaymentDetail.refresh();
  }

  bool isSelectedCourseExpire() {
    final DateTime currentDate = DateTime.now();
    final DateTime endDate = selectedPurchaseCourse.value.endDate!;

// Calculate the difference in days between the current date and the subscription end date
    final int daysRemaining = endDate.difference(currentDate).inDays;

// Check if the subscription has ended or is ending within the next 10 days
    final bool showButton = daysRemaining <= 10;
    return showButton;
  }

  // get all purchases
  Future<void> renewCourse(int courseId, int paymentId, int endDate) async {
    try {
      isLoading.value = true;
      String endpoint = '$baseUrl$purchaseEndpoint/${courseId.toString()}/';
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var bodyData = {
        "payment_method": paymentId,
        "duration": endDate,
      };
      log('renew body data is ${json.encode(bodyData)}');
      var response = await http.patch(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode(bodyData),
      );
      log('response === ${response.statusCode}');
      log('purchased courses response === ${response.body}');
      if (response.statusCode == 204) {
        log('purchased renewed');
        await getAllPurchases();
        await checkCourseExists();
        isLoading.value = false;
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error renew course ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  checkCourseExists() async {
    final matchingCourse = purchaseList.firstWhere(
      (item) =>
          item.id == selectedPurchaseCourseIdForLater.value, // Match by id
    );
    selectedPurchaseCourse.value = matchingCourse;
    await getSpecificPayment(selectedPurchaseCourse.value.paymentMethod);
    selectedPurchaseCourseIdForLater.value = 0;
  }

  // get all purchases
  Future<bool> buyCourse(int courseId, int paymentId, int endDate) async {
    try {
      isLoading.value = true;
      String endpoint = '$baseUrl$purchaseEndpoint/';
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var bodyData = {
        "course": courseId,
        "payment_method": paymentId,
        "duration": endDate,
      };
      log('body data is ${json.encode(bodyData)}');
      var response = await http.post(Uri.parse(endpoint),
          headers: header, body: json.encode(bodyData));
      log('endpoint === $header');
      log('subscription response === ${response.body}');
      log('response === ${response.statusCode}');
      var decodedResponse = json.decode(response.body);
      if (response.statusCode == 201) {
        log('purchased courses response === $decodedResponse');
        await getAllPurchases();
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

  // get all purchases
  Future<void> getSpecificPayment(int? paymentId) async {
    try {
      String endpoint = '$baseUrl$paymentEndpoint/$paymentId';
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
      log('purchase response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        PaymentMethods paymentMethods =
            PaymentMethods.fromJson(decodedResponse);
        specificPaymentDetail.value = paymentMethods;
        specificPaymentDetail.refresh();
      }
    } catch (e) {
      log('Error ${e.toString()}');
    }
  }

  // get all purchases
  Future<void> getAllPurchases() async {
    try {
      isLoading.value = true;
      String endpoint = '$baseUrl$purchaseEndpoint/';
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
      log('purchase response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        purchaseList.clear();
        var decodedResponse = json.decode(response.body);
        log('purchases courses response === $decodedResponse');
        for (var i = 0; i < decodedResponse.length; i++) {
          purchaseList.add(PurchaseModel.fromJson(decodedResponse[i]));
        }
        purchaseList.refresh();
        purchaseList.sort((a, b) => a.startDate!.compareTo(b.startDate!));
        purchaseList.refresh();
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
