import 'package:flutter/material.dart';
import 'package:undomain/models/reel/reel_model.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/textstyles/text_styles.dart';
import 'package:undomain/widgets/comment_model/comment_model.dart';

class BottomSheetWidget extends StatefulWidget {
  final ReelModel reel;
  final String userid;
  const BottomSheetWidget({
    super.key,
    required this.reel,
    required this.userid,
  });

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Text("Comments", style: textTitalSmall)),
            widget.reel.comments.isEmpty
                ? Column(
                  children: [
                    SizedBox(height: 50),
                    Icon(Icons.cloud, size: 48, color: utilPrimaryGrey),
                    Text(
                      "No comments yet...",
                      style: textTitalSmall.copyWith(color: utilPrimaryGrey),
                    ),
                  ],
                )
                : ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return CommentItem();
                  },
                ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: 60),
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5),
          child: //your comment
              Row(
            children: [
              CircleAvatar(radius: 16, backgroundColor: utilPrimaryRed),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    fillColor: utilPrimaryGrey.withOpacity(0.5),
                    contentPadding: EdgeInsets.all(4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "add your comment...",
                    hintStyle: textBody.copyWith(
                      color: utilPrimaryGrey.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              //comment on
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: utilPrimaryRed,
                  ),
                  child: Center(
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.send_rounded,
                        size: 28,
                        color: utilPrimaryWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
