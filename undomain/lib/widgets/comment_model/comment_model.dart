import 'package:flutter/material.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/textstyles/text_styles.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width - 75;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //user avatar
          GestureDetector(
            onTap: () {},
            child: CircleAvatar(backgroundColor: utilPrimaryRed, radius: 20),
          ),
          const SizedBox(width: 5),
          //comment box
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: screenWidth),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: utilPrimaryWhite,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //username
                  Text(
                    textAlign: TextAlign.start,
                    "test user",
                    style: textBody,
                  ),

                  //comment
                  Text("test comment", style: textLabel),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
