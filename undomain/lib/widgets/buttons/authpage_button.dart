import 'package:flutter/material.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/global/global_varibles.dart';
import 'package:undomain/util/textstyles/text_styles.dart';

class AuthpageButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  const AuthpageButton({
    super.key,
    required this.text,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.07,
      child: Center(
        child:
            isLoading
                ? CircularProgressIndicator(color: utilPrimaryWhite)
                : Text(text, style: textTitle),
      ),

      decoration: BoxDecoration(
        color: utilPrimaryRed,
        borderRadius: BorderRadius.circular(authButtonRadius),
      ),
    );
  }
}
