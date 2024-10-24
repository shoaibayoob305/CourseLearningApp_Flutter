import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackTile extends StatelessWidget {
  const FeedbackTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * 0.08,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        children: [
          Container(
            width: Get.width * 0.14,
            height: Get.height * 0.08,
            decoration: const BoxDecoration(
              color: Color(0xffD3E0FF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
            child: Checkbox(
              activeColor: const Color(0xff848D9D),
              shape: const CircleBorder(),
              value: true,
              onChanged: (value) {},
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          const Text(
            'Better UX/UI',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xff3D4A7A),
            ),
          ),
        ],
      ),
    );
  }
}
