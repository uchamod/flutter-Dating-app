import 'package:flutter/material.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/textstyles/text_styles.dart';

class ExpansionTitleWidget extends StatelessWidget {
  final String title;
  const ExpansionTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title, style: textBody),
      expansionAnimationStyle: AnimationStyle(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut,
      ),

      collapsedShape: Border.fromBorderSide(BorderSide.none),

      backgroundColor: utilPrimaryWhite,
      iconColor: utilPrimaryBlack,

      children: [],
    );
  }
}
