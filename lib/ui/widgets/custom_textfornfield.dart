import 'package:flutter/material.dart';
import 'package:tadbiro_app/utils/app_color.dart';

class CustomTextFormField extends StatelessWidget {
  final IconData? icon;
  final String labelText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final TextInputAction? textInputAction;
  final Function()? onTap;
  final int? maxLines;
  final bool? readOnly;
  const CustomTextFormField({
    super.key,
    this.icon,
    this.textInputAction,
    required this.controller,
    required this.labelText,
    this.validator,
    this.obscureText,
    this.onTap,
    this.maxLines,
    this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        readOnly: readOnly ?? false,
        maxLines: maxLines ?? 1,
        onTap: onTap,
        textInputAction: textInputAction ?? TextInputAction.next,
        controller: controller,
        keyboardAppearance: Brightness.light,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: labelText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.orange, width: 3),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.orange, width: 3),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        obscureText: obscureText ?? false,
        validator: validator,
      ),
    );
  }
}
