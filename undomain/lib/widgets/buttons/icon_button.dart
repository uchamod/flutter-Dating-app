import 'package:flutter/material.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/textstyles/text_styles.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: utilPrimaryRed,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //icon
          Icon(Icons.live_tv, color: utilPrimaryWhite, size: 24),
          //text
          Text("Make Fun", style: textTitle),
        ],
      ),
    );
  }
}
