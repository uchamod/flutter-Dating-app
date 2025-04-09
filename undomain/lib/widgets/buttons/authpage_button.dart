import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/global/global_varibles.dart';
import 'package:undomain/util/textstyles/text_styles.dart';

class AuthpageButton extends StatelessWidget {
  final String text;

  final String path;
  const AuthpageButton({super.key, required this.text, required this.path});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).goNamed(path);
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.07,
        child: Center(child: Text(text, style: textTitle)),

        decoration: BoxDecoration(
          color: utilPrimaryRed,
          borderRadius: BorderRadius.circular(authButtonRadius),
        ),
      ),
    );
  }
}
