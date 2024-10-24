import 'package:flutter/material.dart';
import 'package:frontend/app/modules/questions/controller/questionController.dart';
import 'package:get/get.dart';
import '../../../utils/widgets/stepper_widget.dart';

class QuestionAsk2 extends StatelessWidget {
  const QuestionAsk2({super.key});

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
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StepperWidget(pageNumber: 2.obs),
              const SizedBox(
                height: 20.0,
              ),
              const Center(
                child: Text(
                  'How detailed would you like your explanations to be?',
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
                  optionValue: 'Brief',
                  onPress: () => controller.selectQuestion2('brief'),
                  isSelected:
                      controller.question2.value == 'brief' ? true : false,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(
                () => ContainerTile(
                  optionAlpha: 'B.',
                  optionValue: 'Moderate',
                  onPress: () => controller.selectQuestion2('moderate'),
                  isSelected:
                      controller.question2.value == 'moderate' ? true : false,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(
                () => ContainerTile(
                  optionAlpha: 'C.',
                  optionValue: 'In-depth',
                  onPress: () => controller.selectQuestion2('in-depth'),
                  isSelected:
                      controller.question2.value == 'in-depth' ? true : false,
                ),
              ),
              // const Spacer(),
              // StepperWidget(pageNumber: 1.obs),
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
