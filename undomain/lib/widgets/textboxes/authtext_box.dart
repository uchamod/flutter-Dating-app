import 'package:flutter/material.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/textstyles/text_styles.dart';

class AuthtextBox extends StatelessWidget {
  final void Function(String?) onSubmit;
  final TextEditingController controller;
  final String hint;
  final bool isShow;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final String? Function(String?)? validChecker;
  final bool isValid;
  const AuthtextBox({
    super.key,
    required this.onSubmit,
    required this.controller,
    required this.hint,
    required this.isShow,
    required this.textInputAction,
    required this.textInputType,
    this.validChecker,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onSubmit,
      validator: validChecker,
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: textInputType,
      obscureText: isShow,
      cursorColor: utilPrimaryGrey,
      
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: isValid ? textHint : textLabelRed,

        contentPadding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02,
          horizontal: 10,
        ),
        border: formFieldBorder(utilPrimaryGrey),
        focusedBorder: formFieldBorder(utilPrimaryGrey),
        errorBorder: formFieldBorder(utilPrimaryRed),
        enabledBorder: formFieldBorder(utilPrimaryGrey),
      ),
    );
  }
}

//border style
OutlineInputBorder formFieldBorder(Color borderColor) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(36),
    borderSide: BorderSide(color: borderColor, width: 2),
  );
}
