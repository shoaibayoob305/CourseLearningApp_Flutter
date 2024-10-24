import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/app/modules/payments/controller/payment_controller.dart';
import 'package:frontend/app/modules/sqaureup_payment/payment.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:u_credit_card/u_credit_card.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentController());
    final squareUpController = Get.put(SquareupController());
    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: const Color(0xff233853),
      onRefresh: () async {
        await controller.getPayments();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          surfaceTintColor: Colors.transparent,
          title: const Text('Payments'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add Card',
          onPressed: () {
            squareUpController.pay();
          },
          child: const Icon(Icons.add),
        ),
        body: Obx(
          () => controller.isLoading.value == true
              ? Center(
                  child: LoadingAnimationWidget.beat(
                      color: Colors.blueGrey.shade700, size: 40),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 15, bottom: 30),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Obx(
                              () => Text(
                                '${controller.paymentList.length} Cards Available',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Obx(
                          () => SizedBox(
                            height: Get.height / 4,
                            child: PageView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.paymentList.length,
                              onPageChanged: (value) {
                                controller.selectedCardId.value =
                                    controller.paymentList[value].id!;
                              },
                              itemBuilder: (context, index) {
                                final card = controller.paymentList[index];
                                controller.selectedCardId.value =
                                    controller.paymentList.first.id!;
                                log('selected card id is ${controller.selectedCardId.value}');
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: CreditCardUi(
                                    bottomRightColor: const Color(0xff030619),
                                    topLeftColor: const Color(0xff111d51),
                                    showValidFrom: false,
                                    cardProviderLogo: const Image(
                                      image: AssetImage('assets/logowhite.png'),
                                    ),
                                    cardHolderFullName:
                                        '${controller.authenticationController.userModel.value.firstName} ${controller.authenticationController.userModel.value.lastName}',
                                    cardNumber:
                                        '**** **** **** ${card.cardLastFourDigits}',
                                    validThru:
                                        '${card.cardExpiryMonth}/${card.cardExpiryYear!.substring(2)}',
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Obx(
                          () => GestureDetector(
                            onTap: () async {
                              log('card id is ${controller.selectedCardId}');
                              if (controller.isCardDeleteLoading.value) {
                              } else {
                                await controller.deleteCard();
                              }
                            },
                            child: Container(
                              width: Get.width,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Center(
                                child: controller.isCardDeleteLoading.value
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        "Remove Card",
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
                        const SizedBox(
                          height: 40,
                        ),
                        const Icon(Icons.swipe_left),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text('Swipe Left to see more Cards'),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
