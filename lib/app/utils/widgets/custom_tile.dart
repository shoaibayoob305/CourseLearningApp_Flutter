import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTile extends StatelessWidget {
  CustomTile({
    super.key,
    this.leading,
    this.title,
    this.subTitle,
    this.trailing,
    required this.onTap,
  });
  String? leading;
  String? title;
  String? subTitle;
  String? trailing;
  VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 6,
            offset: Offset(3, 3),
            spreadRadius: 0,
          )
        ],
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title ?? '',
        ),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 0,
        ),
        subtitle: Text(subTitle ?? ''),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
