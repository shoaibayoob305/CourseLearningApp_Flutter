import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  SettingTile({
    super.key,
    this.image,
    this.title,
    this.onTap,
    this.subTitle,
  });

  String? image;
  String? title;
  String? subTitle;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Image(image: AssetImage(image ?? 'assets/setting1.png')),
      title: Text(
        title ?? 'Account',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xff000E08),
        ),
      ),
      subtitle: subTitle!.isEmpty
          ? null
          : Text(
              subTitle ?? 'Privacy, security, change number',
              style: const TextStyle(
                color: Color(0xff797C7B),
              ),
            ),
    );
  }
}
