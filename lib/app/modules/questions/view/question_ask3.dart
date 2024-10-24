import 'package:flutter/material.dart';
import 'package:frontend/app/modules/questions/controller/questionController.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../utils/widgets/stepper_widget.dart';

class QuestionAsk3 extends StatelessWidget {
  const QuestionAsk3({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Questioncontroller());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StepperWidget(pageNumber: 3.obs),
              const SizedBox(
                height: 20.0,
              ),
              const Center(
                child: Text(
                  'How would you like the explanations to be structured?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Image.asset('assets/questionpage.png'),
              const SizedBox(
                height: 20,
              ),
              Obx(
                () => ContainerTile(
                  optionAlpha: 'A.',
                  optionValue: 'With examples',
                  onPress: () => controller.selectQuestion3('examples'),
                  isSelected:
                      controller.question3.value == 'examples' ? true : false,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(
                () => ContainerTile(
                  optionAlpha: 'B.',
                  optionValue: 'With analogies',
                  onPress: () => controller.selectQuestion3('analogies'),
                  isSelected:
                      controller.question3.value == 'analogies' ? true : false,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(
                () => ContainerTile(
                  optionAlpha: 'C.',
                  optionValue: 'With definitions',
                  onPress: () => controller.selectQuestion3('definitions'),
                  isSelected: controller.question3.value == 'definitions'
                      ? true
                      : false,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: GestureDetector(
                    onTap: controller.isLoading.value
                        ? null
                        : () {
                            if (controller.isUpdate.value) {
                              controller.onlyUpdateConfiguration();
                            } else {
                              controller.updateConfiguration();
                            }
                          },
                    child: Container(
                      width: Get.width,
                      height: 50,
                      decoration: BoxDecoration(
                          color: controller.isQuestion3Available.value
                              ? const Color(0xff233853)
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(100)),
                      child: Center(
                        child: controller.isLoading.value
                            ? LoadingAnimationWidget.beat(
                                color: Colors.white, size: 20)
                            : controller.isUpdate.value
                                ? const Text(
                                    "Update",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "Start Course",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerTile extends StatelessWidget {
  ContainerTile({
    super.key,
    this.optionAlpha,
    this.optionValue,
    this.isSelected,
    this.onPress,
  });

  final String? optionAlpha;
  final String? optionValue;
  bool? isSelected;
  void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected == true ? Colors.orange.shade100 : null,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: isSelected == true ? Colors.orange : const Color(0xffBEBAB3),
            width: isSelected == true ? 2.0 : 1.0,
          ),
        ),
        child: ListTile(
          title: Row(
            children: [
              Text(
                optionAlpha ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
              Text(
                optionValue ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
