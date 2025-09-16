import 'package:flutter/material.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/global/global_varibles.dart';
import 'package:undomain/util/textstyles/text_styles.dart';

class GlobalFunction {
  void snackBarMassage(BuildContext context, String text, int duration) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: utilPrimaryRed,
        closeIconColor: utilPrimaryWhite,
        elevation: 1,
        showCloseIcon: true,
        duration: Duration(seconds: duration),
        padding: EdgeInsets.symmetric(horizontal: authScreenPaddingH),
        content: Text(text, style: textSnackbar),
      ),
    );
  }
}
