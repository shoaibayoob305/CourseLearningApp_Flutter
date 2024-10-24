import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewTextField extends StatelessWidget {
  NewTextField({
    super.key,
    this.controller,
    required this.obsecureText,
    required this.showPassword,
    this.onTap,
    this.hint,
    this.onChange,
    this.errorMessage,
    this.readOnly = false,
    this.iconData,
    this.hintColor = const Color.fromRGBO(151, 151, 151, 1),
    this.isPrefixIcon = true,
    this.iconColor = const Color.fromRGBO(181, 130, 38, 1),
    this.isIconColor = false,
    this.isIconSize = false,
    this.iconSize,
  });

  TextEditingController? controller = TextEditingController();
  bool obsecureText;
  bool showPassword;
  String? hint;
  void Function()? onTap;
  void Function(String)? onChange;
  String? errorMessage;
  bool? readOnly;
  IconData? iconData;
  Color? hintColor;
  Color? iconColor;
  bool? isPrefixIcon;
  bool? isIconColor;
  bool? isIconSize;
  double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 1,
            color: Color.fromRGBO(233, 233, 233, 1),
          )),
      child: TextFormField(
        readOnly: readOnly!,
        onChanged: onChange,
        controller: controller,
        obscureText: obsecureText ? true : false,
        cursorColor: Color(0xff73CE95),
        decoration: InputDecoration(
          errorText: errorMessage,
          prefixIcon: isPrefixIcon!
              ? Icon(
                  iconData,
                  color: isIconColor == true
                      ? iconColor
                      : Color.fromRGBO(47, 46, 54, 1),
                  size: isIconSize == true ? iconSize : null,
                )
              : null,
          filled: true,
          isDense: true,
          fillColor: Color.fromRGBO(255, 255, 255, 1),
          hintText: hint,
          hintStyle: TextStyle(
            color: hintColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(233, 233, 233, 1),
              width: 1.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(233, 233, 233, 1),
              width: 1.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          suffixIcon: showPassword
              ? obsecureText
                  ? GestureDetector(
                      onTap: onTap, child: const Icon(CupertinoIcons.eye_slash))
                  : GestureDetector(
                      onTap: onTap, child: const Icon(CupertinoIcons.eye_fill))
              : null,
        ),
      ),
    );
  }
}
