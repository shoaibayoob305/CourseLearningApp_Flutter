import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextFileld extends StatelessWidget {
  CustomTextFileld({
    super.key,
    this.controller,
    required this.obsecureText,
    required this.showPassword,
    this.onTap,
    this.hint,
    this.onChange,
    this.errorMessage,
    this.readOnly = false,
  });

  TextEditingController? controller = TextEditingController();
  bool obsecureText;
  bool showPassword;
  String? hint;
  void Function()? onTap;
  void Function(String)? onChange;
  String? errorMessage;
  bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly!,
      onChanged: onChange,
      controller: controller,
      obscureText: obsecureText ? true : false,
      decoration: InputDecoration(
        errorText: errorMessage,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black),
        suffixIcon: showPassword
            ? obsecureText
                ? GestureDetector(
                    onTap: onTap, child: const Icon(CupertinoIcons.eye_slash))
                : GestureDetector(
                    onTap: onTap, child: const Icon(CupertinoIcons.eye_fill))
            : null,
      ),
    );
  }
}
