import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend/app/modules/course/controllers/course_controller.dart';
import 'package:frontend/app/modules/course/model/course_model.dart';
import 'package:frontend/app/modules/home/views/home_bottomnavigation_view.dart';
import 'package:frontend/app/modules/payments/model/payment_model.dart';
import 'package:frontend/app/modules/purchases/controller/purchase_controller.dart';
import 'package:frontend/app/utils/widgets/defaultsnackbar.dart';
import 'package:get/get.dart';

class ReceiptDialog extends StatelessWidget {
  const ReceiptDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CourseController());
    final purchaseController = Get.put(PurchaseController());
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        height: Get.height * 0.4,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bill Summary',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              _buildReceiptItem(
                  'Course Name', '${controller.selectedCourse.value.name}'),
              Obx(
                () => _buildReceiptItem(
                    'Course Price', '\$ ${controller.coursePrice.toString()}'),
              ),
              Obx(() => _buildReceiptItemWithDropdown()),
              const SizedBox(height: 20),
              const Text(
                'Select Payment Method',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              // Wrapping the ListView.builder inside a SizedBox with a fixed height
              Obx(
                () => Column(
                  children: controller.paymentController.paymentList
                      .map(
                        (element) => _buildRadioOption(element),
                      )
                      .toList(),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextButton(
                  onPressed: () {
                    controller.squareupController.pay();
                  },
                  child: const Text(
                    'Add New Card',
                    style: TextStyle(
                      color: Color(0xff233853),
                    ),
                  )),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            // Handle the receipt confirmation action
            // if (controller.endDate.isEmpty) {
            //   DefaultSnackbar.show('Error', 'Select End Date');
            // }
            if (controller.selectedPaymentMethod.value.cardId == null ||
                controller.selectedPaymentMethod.value.cardId!.isEmpty) {
              DefaultSnackbar.show('Error', 'Select Card');
            } else {
              Navigator.of(context).pop();
              var result = await purchaseController.buyCourse(
                controller.selectedCourse.value.id!,
                controller.selectedPaymentMethod.value.id!,
                controller.monthDuration.value,
              );
              if (result == true) {
                controller.selectedCourse.value = CourseModel();
                controller.selectedPaymentMethod.value = PaymentMethods();
                controller.monthDuration.value = 0;
                controller.coursePrice.value = 0.0;
                controller.dropdownValue.value = '1 month';
                await controller.getUserEnrolledCourses(true);
                controller.homeController.selectedIndex.value = 1;
                Get.offAll(() => const HomeBottomNavigationView());
              } else {
                return;
              }
            }
          },
          child: const Text(
            'Confirm',
            style: TextStyle(
              color: Color(0xff233853),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptItem(String itemName, String itemPrice) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(itemName)),
          SizedBox(
            width: 20.0,
          ),
          Flexible(
            child: Text(
              itemPrice,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptItemWithDropdown() {
    final controller = Get.put(CourseController());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select End date'),
          DropdownButton<String>(
            dropdownColor: Colors.white,
            underline: Container(),
            value: controller.dropdownValue.value.isEmpty
                ? null
                : controller.dropdownValue.value,
            hint: const Text('Choose time period'),
            onChanged: (String? newValue) {
              print('value is $newValue');
              if (newValue == '1 month') {
                controller.coursePrice.value =
                    controller.selectedCourse.value.price1!;
                controller.monthDuration.value = 1;
              }
              if (newValue == '3 months') {
                controller.coursePrice.value =
                    controller.selectedCourse.value.price3!;
                controller.monthDuration.value = 3;
              }
              if (newValue == '12 months') {
                controller.coursePrice.value =
                    controller.selectedCourse.value.price12!;
                controller.monthDuration.value = 12;
              }
            },
            items: controller.dropdownItems.map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(PaymentMethods value) {
    final controller = Get.put(CourseController());
    return RadioListTile<PaymentMethods>(
      title: Text('**** **** **** ${value.cardLastFourDigits!}'),
      value: value,
      groupValue: controller.selectedPaymentMethod.value,
      onChanged: (PaymentMethods? newValue) {
        log('payment data is ${value.cardLastFourDigits}');
        log('payment data is ${value.cardId}');
        controller.selectedPaymentMethod.value = newValue!;
      },
    );
  }
}
