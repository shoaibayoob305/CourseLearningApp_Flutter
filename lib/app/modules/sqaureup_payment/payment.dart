import 'dart:developer';
import 'package:frontend/app/modules/payments/controller/payment_controller.dart';
import 'package:frontend/app/utils/widgets/defaultsnackbar.dart';
import 'package:get/get.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

class SquareupController extends GetxController {
  final paymentController = Get.put(PaymentController());
  void _onCardEntryComplete() {
    // Handle the payment result here (e.g., send the result to your server)
  }

  void _onCardEntryCancel() {
    // Handle the card entry cancelation here
  }

  void pay() {
    InAppPayments.startCardEntryFlow(
      collectPostalCode: false,
      onCardNonceRequestSuccess: (CardDetails result) async {
        try {
          // You can call your backend server to process the payment here
          log('result is ${result.nonce}');
          var apiResponse = await paymentController.addPayments(result.nonce);
          InAppPayments.completeCardEntry(
              onCardEntryComplete: _onCardEntryComplete);
          if (apiResponse == false) {
            DefaultSnackbar.show('Error', 'Something went wrong.');
          }
        } catch (ex) {
          // Handle any errors
          InAppPayments.showCardNonceProcessingError(ex.toString());
        }
      },
      onCardEntryCancel: _onCardEntryCancel,
    );
  }
}
