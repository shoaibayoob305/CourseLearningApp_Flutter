import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/app/utils/widgets/defaultsnackbar.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controller/questionController.dart';

class ApiquestionView extends StatelessWidget {
  const ApiquestionView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Questioncontroller());
    controller.isCorrectAnswer.value = true;
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
        actions: [
          TextButton(
            onPressed: () {
              controller.nextQuestion();
            },
            child: const Text('Skip'),
          ),
        ],
      ),
      body: Obx(
        () => controller.question.value.results!.isEmpty
            ? const Center(
                child: Text('No Question yet'),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Obx(
                        () => Center(
                          child: Text(
                            controller.question.value.results!.first.question!
                                    .questionText ??
                                '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      controller.question.value.results!.first.question!
                                      .image ==
                                  null ||
                              controller.question.value.results!.first.question!
                                  .image!.isEmpty
                          ? const SizedBox.shrink()
                          : Image.network(controller
                              .question.value.results!.first.question!.image!),
                      const SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () => ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          shrinkWrap: true,
                          itemCount: controller.question.value.results!.first
                              .question!.options!.length,
                          itemBuilder: (context, index) {
                            final answer = controller.question.value.results!
                                .first.question!.options![index];
                            final singleValueAnswer = controller.question.value
                                .results!.first.question!.selectionType;
                            final optionAlpha =
                                '${String.fromCharCode(65 + index)}.';
                            ;
                            return Obx(
                              () => ContainerTile(
                                optionAlpha: optionAlpha,
                                optionValue: answer,
                                onPress: () => controller.selectAnswer(
                                  answer,
                                  singleValueAnswer == 'single' ? true : false,
                                ),
                                isSelected: controller.answers.contains(answer)
                                    ? true
                                    : false,
                                isMultiple: singleValueAnswer == 'single'
                                    ? false
                                    : true,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: GestureDetector(
                            onTap: controller.isLoading.value
                                ? null
                                : controller.isExplanationLoaded.value
                                    ? () {}
                                    : controller.isCorrectAnswer.value == false
                                        ? () async {
                                            await controller.nextQuestion();
                                            controller.answers.clear();
                                            controller.isCorrectAnswer.value =
                                                true;
                                          }
                                        : () async {
                                            final correctAnswers = controller
                                                .question
                                                .value
                                                .results!
                                                .first
                                                .question!
                                                .correctAnswer!;
                                            final yourAnswers =
                                                controller.answers;

                                            bool areListsEqual = correctAnswers
                                                        .length ==
                                                    yourAnswers.length &&
                                                correctAnswers.every((item) =>
                                                    yourAnswers.contains(item));
                                            log('list ${correctAnswers.every((item) => yourAnswers.contains(item))}');
                                            log('list ${correctAnswers.length} && ${yourAnswers.length}');
                                            if (controller.answers.isEmpty) {
                                              DefaultSnackbar.show('Error',
                                                  'Kindly select answer');
                                            }
                                            if (areListsEqual) {
                                              log('same');
                                              controller.isCorrectAnswer.value =
                                                  true;
                                              await controller.checkAnswers();
                                              controller.answers.clear();
                                            } else {
                                              controller.isCorrectAnswer.value =
                                                  false;
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    backgroundColor:
                                                        Colors.white,
                                                    insetPadding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 10.0,
                                                    ),
                                                    title: const Text(
                                                        "Your answer is incorrect"),
                                                    content: const Text(
                                                        "Do you want an explanation?"),
                                                    actions: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Expanded(
                                                            child: TextButton(
                                                              onPressed: () {
                                                                // Action for No button
                                                                Get.back();
                                                              },
                                                              style: TextButton
                                                                  .styleFrom(
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                                backgroundColor:
                                                                    Colors
                                                                        .red, // White text
                                                              ),
                                                              child: const Text(
                                                                  "No"),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: TextButton(
                                                              onPressed:
                                                                  () async {
                                                                // Action for Yes button
                                                                Get.back();
                                                                await controller
                                                                    .checkExplanation();
                                                                showDialog(
                                                                  context: Get
                                                                      .context!,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      insetPadding:
                                                                          EdgeInsets
                                                                              .symmetric(
                                                                        horizontal:
                                                                            10.0,
                                                                        vertical:
                                                                            10.0,
                                                                      ),
                                                                      scrollable:
                                                                          true,
                                                                      content:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              GestureDetector(
                                                                                  onTap: () {
                                                                                    Get.back();
                                                                                  },
                                                                                  child: Icon(Icons.close)),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10.0,
                                                                          ),
                                                                          Text(controller.fixUnicodeIssues(controller
                                                                              .wrongQuestionExplanation
                                                                              .value)),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              style: TextButton
                                                                  .styleFrom(
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                                backgroundColor:
                                                                    Colors
                                                                        .green, // White text
                                                              ),
                                                              child: const Text(
                                                                  "Yes"),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              controller.checkAnswers();
                                            }
                                          },
                            child: Container(
                              width: Get.width,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: const Color(0xff233853),
                                  borderRadius: BorderRadius.circular(100)),
                              child: Center(
                                child: controller.isLoading.value
                                    ? LoadingAnimationWidget.beat(
                                        color: Colors.white, size: 20)
                                    : controller.isCorrectAnswer.value == false
                                        ? const Text(
                                            "Continue",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text(
                                            "Submit",
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
                      const SizedBox(
                        height: 20.0,
                      ),
                      if (controller.isCorrectAnswer.value == false)
                        Obx(
                          () => TextButton(
                            onPressed: controller.isExplanationLoaded.value
                                ? () {}
                                : () async {
                                    await controller.checkExplanation();
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          insetPadding: EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                            vertical: 10.0,
                                          ),
                                          scrollable: true,
                                          content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        Get.back();
                                                      },
                                                      child: Icon(Icons.close)),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Text(controller.fixUnicodeIssues(
                                                  controller
                                                      .wrongQuestionExplanation
                                                      .value)),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                            child: controller.isExplanationLoaded.value
                                ? LoadingAnimationWidget.beat(
                                    color: const Color(0xff233853), size: 20)
                                : const Text(
                                    'Get Explanation',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff233853),
                                    ),
                                  ),
                          ),
                        )
                    ],
                  ),
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
    this.isMultiple = false,
  });

  final String? optionAlpha;
  final String? optionValue;
  final bool? isSelected;
  final bool isMultiple;
  final void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: null,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: isSelected == true
                ? Color(0xff233853)
                : const Color(0xffBEBAB3),
            width: isSelected == true ? 3.0 : 1.0,
          ),
        ),
        child: ListTile(
          contentPadding: isMultiple ? EdgeInsets.zero : null,
          title: Row(
            children: [
              if (isMultiple)
                Checkbox(
                  value: isSelected ?? false,
                  onChanged: (bool? value) {
                    if (onPress != null) {
                      onPress!();
                    }
                  },
                ),
              Text(
                optionAlpha ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 15.0),
              Flexible(
                child: Text(
                  optionValue ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
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


// class ContainerTile extends StatelessWidget {
//   ContainerTile({
//     super.key,
//     this.optionAlpha,
//     this.optionValue,
//     this.isSelected,
//     this.onPress,
//   });

//   final String? optionAlpha;
//   final String? optionValue;
//   bool? isSelected;
//   void Function()? onPress;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPress,
//       child: Container(
//         decoration: BoxDecoration(
//           color: isSelected == true ? Colors.orange.shade100 : null,
//           borderRadius: BorderRadius.circular(10.0),
//           border: Border.all(
//             color: isSelected == true ? Colors.orange : const Color(0xffBEBAB3),
//             width: isSelected == true ? 2.0 : 1.0,
//           ),
//         ),
//         child: ListTile(
//           title: Row(
//             children: [
//               Text(
//                 optionAlpha ?? '',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//               const SizedBox(
//                 width: 15.0,
//               ),
//               Flexible(
//                 child: Text(
//                   optionValue ?? '',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
