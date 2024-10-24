import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/app/modules/payments/controller/payment_controller.dart';
import 'package:frontend/app/modules/sqaureup_payment/payment.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../payments/model/payment_model.dart';
import '../controller/purchase_controller.dart';

class PurchaseDetail extends StatelessWidget {
  const PurchaseDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PurchaseController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text('Purchase Detail'),
        forceMaterialTransparency: true,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30.0,
              ),
              const Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircleAvatar(
                    child: Image(
                      image: AssetImage('assets/course.png'),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text('Course:'),
              const SizedBox(
                height: 10.0,
              ),
              Obx(() => Text(
                  '${controller.selectedPurchaseCourse.value.courseName}')),
              const SizedBox(
                height: 20.0,
              ),
              const Text('Amount:'),
              const SizedBox(
                height: 10.0,
              ),
              Obx(
                () => Text(
                    '\$${controller.selectedPurchaseCourse.value.amount!.toStringAsFixed(2)}'),
              ),
              // const SizedBox(
              //   height: 20.0,
              // ),
              // const Text('Status:'),
              // const SizedBox(
              //   height: 10.0,
              // ),
              // Text('${controller.selectedPurchaseCourse.value.status}'),
              const SizedBox(
                height: 20.0,
              ),
              controller.selectedPurchaseCourse.value.paymentMethod != null
                  ? const Text('Payment Method:')
                  : const SizedBox.shrink(),
              controller.selectedPurchaseCourse.value.paymentMethod != null
                  ? const SizedBox(
                      height: 10.0,
                    )
                  : const SizedBox.shrink(),
              controller.selectedPurchaseCourse.value.paymentMethod != null
                  ? Obx(
                      () => Text(
                          '${controller.selectedPurchaseCourse.value.paymentMethodCardBrand}'),
                    )
                  : const SizedBox.shrink(),
              controller.selectedPurchaseCourse.value.paymentMethod != null
                  ? const SizedBox(
                      height: 20.0,
                    )
                  : const SizedBox.shrink(),
              const Text('Purchased On:'),
              const SizedBox(
                height: 10.0,
              ),
              Obx(
                () => Text(
                    '${DateFormat('yyyy-MM-dd').format(controller.selectedPurchaseCourse.value.startDate!)}'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text('End of Subscription:'),
              const SizedBox(
                height: 10.0,
              ),
              Obx(
                () => Text(
                    '${DateFormat('yyyy-MM-dd').format(controller.selectedPurchaseCourse.value.endDate!)}'),
              ),
              const SizedBox(
                height: 40.0,
              ),

              Obx(
                () => controller.isSelectedCourseExpire()
                    ? GestureDetector(
                        onTap: () {
                          showRenewSubscriptionDialog(context);
                        },
                        child: Container(
                          width: Get.width,
                          height: 50,
                          decoration: BoxDecoration(
                              color: const Color(0xff233853),
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: controller.isLoading.value
                                ? LoadingAnimationWidget.waveDots(
                                    color: Colors.white, size: 40)
                                : const Text(
                                    "Renew Subscription",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(PaymentMethods value) {
    final controller = Get.put(PurchaseController());
    return RadioListTile<PaymentMethods>(
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      title: Text('**** **** **** ${value.cardLastFourDigits!}'),
      value: value,
      groupValue: controller.specificPaymentDetail.value,
      onChanged: (PaymentMethods? newValue) {
        log('payment data is ${value.cardLastFourDigits}');
        log('payment data is ${value.cardId}');
        controller.specificPaymentDetail.value = newValue!;
      },
    );
  }

  void showRenewSubscriptionDialog(BuildContext context) {
    final controller = Get.put(PurchaseController());
    final paymentController = Get.put(PaymentController());
    final squareUpController = Get.put(SquareupController());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: const Text(
            'Renew Subscription',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Payment Method',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Obx(
                () => controller.specificPaymentDetail.value == null ||
                        controller.specificPaymentDetail.value
                                .cardLastFourDigits ==
                            null
                    ? paymentController.paymentList.isEmpty
                        ? TextButton(
                            onPressed: () {
                              squareUpController.pay();
                            },
                            child: const Text(
                              'Add New Card',
                              style: TextStyle(
                                color: Color(0xff233853),
                              ),
                            ),
                          )
                        : Column(
                            children: paymentController.paymentList
                                .map(
                                  (element) => _buildRadioOption(element),
                                )
                                .toList(),
                          )
                    : _buildCustomRadio(
                        value:
                            '${controller.specificPaymentDetail.value.cardLastFourDigits}',
                        groupValue:
                            '${controller.specificPaymentDetail.value.cardLastFourDigits}',
                        label:
                            'Card ending in ${controller.specificPaymentDetail.value.cardLastFourDigits}',
                      ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Select Number of Days to Add',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Column(
                children: [
                  Obx(
                    () => _buildCustomRadio(
                      value: '1 month',
                      groupValue: controller.monthDuration.value,
                      label: '1 month',
                      onChanged: (value) {
                        controller.monthDuration.value = value!;
                      },
                    ),
                  ),
                  Obx(
                    () => _buildCustomRadio(
                      value: '3 months',
                      groupValue: controller.monthDuration.value,
                      label: '3 months',
                      onChanged: (value) {
                        controller.monthDuration.value = value!;
                      },
                    ),
                  ),
                  Obx(
                    () => _buildCustomRadio(
                      value: '12 months',
                      groupValue: controller.monthDuration.value,
                      label: '12 months',
                      onChanged: (value) {
                        controller.monthDuration.value = value!;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Obx(
              () => GestureDetector(
                onTap: () {
                  Get.back();
                  int endDate = 0;
                  if (controller.monthDuration.value == '1 month') {
                    endDate = 1;
                  } else if (controller.monthDuration.value == '3 months') {
                    endDate = 3;
                  } else if (controller.monthDuration.value == '12 months') {
                    endDate = 12;
                  }

                  controller.renewCourse(
                      controller.selectedPurchaseCourse.value.id!,
                      controller.selectedPurchaseCourse.value.paymentMethod ==
                              null
                          ? controller.specificPaymentDetail.value.id!
                          : controller
                              .selectedPurchaseCourse.value.paymentMethod!,
                      endDate);
                },
                child: Container(
                  width: Get.width,
                  height: 50,
                  decoration: BoxDecoration(
                      color: const Color(0xff233853),
                      borderRadius: BorderRadius.circular(100)),
                  child: Center(
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Renew",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

// Custom Container-based Radio Button Option
  Widget _buildCustomRadio({
    required String value,
    required String groupValue,
    required String label,
    ValueChanged<String?>? onChanged,
  }) {
    final bool isSelected =
        value == groupValue; // Determine if the option is selected
    return GestureDetector(
      onTap: () {
        if (onChanged != null)
          onChanged(value); // Trigger the onChanged callback with the value
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            // Icon to simulate a radio check
            Container(
              padding: EdgeInsets.all(1.0), // Adjust as needed for spacing
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Color(0xff233853)
                      : Colors.grey, // Border color based on selection
                  width: 2.0, // Adjust as needed for border width
                ),
              ),
              child: Center(
                child: Icon(
                  size: 8,
                  isSelected ? Icons.circle : null, // Change icon if selected
                  color: isSelected
                      ? Color(0xff233853)
                      : Colors.grey, // Icon color
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black, // Text colorbncv
                fontWeight: isSelected
                    ? FontWeight.w500
                    : FontWeight.normal, // Bold if selected
              ),
            ),
          ],
        ),
      ),
    );
  }
}
