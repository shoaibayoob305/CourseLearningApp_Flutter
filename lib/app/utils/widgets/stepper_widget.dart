import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StepperWidget extends StatelessWidget {
  StepperWidget({super.key, required this.pageNumber});
  RxInt pageNumber = 1.obs;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(
        width: 30,
      ),
      pageNumber == 1 ? activeStep() : previousStep(),
      pageNumber == 1 ? connecter() : connecter(isActive: true),
      pageNumber == 1
          ? inactiveStep()
          : pageNumber == 2
              ? activeStep()
              : previousStep(),
      pageNumber == 3 ? connecter(isActive: true) : connecter(),
      pageNumber == 3 ? activeStep() : inactiveStep(),
      SizedBox(
        width: 30,
      ),
    ]);
  }

  Container inactiveStep() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  Container previousStep() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Color(0xff233853),
        border: Border.all(color: Color(0xff233853), width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Icon(Icons.check, color: Colors.white, size: 20),
    );
  }

  Expanded connecter({bool isActive = false}) {
    return Expanded(
      child: Divider(
        color: isActive ? Color(0xff233853) : Colors.grey,
        height: 2,
      ),
    );
  }

  Container activeStep() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff233853), width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Icon(Icons.circle, color: Color(0xff233853), size: 20),
    );
  }
}
