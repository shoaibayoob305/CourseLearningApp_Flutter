import 'package:flutter/material.dart';

class NewSettingTile extends StatelessWidget {
  NewSettingTile({
    super.key,
    this.onPress,
    this.leadingbackgroundColor,
    this.iconData,
    this.title,
    this.iconColor,
    this.showRightArrow = true,
  });

  void Function()? onPress;
  Color? leadingbackgroundColor;
  Color? iconColor;
  IconData? iconData;
  String? title;
  bool? showRightArrow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: ListTile(
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: leadingbackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Icon(
              iconData,
              color: iconColor,
            ),
          ),
          title: Text(
            title ?? "",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          trailing: showRightArrow!
              ? const Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Color(0xffBEBEBE),
                )
              : null,
        ),
      ),
    );
  }
}
