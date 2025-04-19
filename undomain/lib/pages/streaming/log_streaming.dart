import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:undomain/router/router_names.dart';
import 'package:undomain/util/global/global_varibles.dart';
import 'package:undomain/util/textstyles/text_styles.dart';
import 'package:undomain/widgets/buttons/icon_button.dart';
import 'package:undomain/widgets/expansionTitle/expansion_title.dart';
import 'package:undomain/widgets/textboxes/authtext_box.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LogStreaming extends StatefulWidget {
  const LogStreaming({super.key});

  @override
  State<LogStreaming> createState() => _LogStreamingState();
}

class _LogStreamingState extends State<LogStreaming> {
  final TextEditingController _controller = TextEditingController();

  String? selectedOption = "Comments";

  final List<String> options = [
    "Comments",
    "Distribution setting",
    "Streaming filters",
    "History",
  ];

  void _gotoLivePage(
    BuildContext context, {
    required bool isHost,
    required String liveId,
  }) {
    GoRouter.of(context).goNamed(
      RouterNames.zegoLiveScreen,
      extra: {"isHost": isHost, "liveId": liveId},
    );
  }

  final String localUserID = math.Random().nextInt(10000).toString();
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: mainPagePaddingH,
            vertical: mainPagePaddingV + deviceHeight * 0.08,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Enter your liveID to start new streaming or you can join existing one adding shared liveID.",
                  style: textHint.copyWith(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "Live_ID:", style: textLabelRed),
                    TextSpan(text: localUserID, style: textLabel),
                  ],
                ),
              ),
              SizedBox(height: deviceHeight * 0.035),
              AuthtextBox(
                onSubmit: (p0) {},
                controller: _controller,
                hint: "Enter Live ID",
                isShow: false,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.number,
                isValid: true,
              ),
              SizedBox(height: deviceHeight * 0.02),
              //go live button
              GestureDetector(
                onTap: () {
                  // Prevent multiple instances when minimized
                  if (ZegoUIKitPrebuiltLiveStreamingController()
                      .minimize
                      .isMinimizing) {
                    return;
                  }

                  _gotoLivePage(
                    context,
                    isHost:
                        _controller.text.trim() == localUserID ? true : false,
                    liveId: _controller.text.trim(),
                  );
                },
                child: IconTextButton(),
              ),
              //free space
              SizedBox(height: deviceHeight * 0.15),
              //addtionl setting drop down
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "additinal setting",
                  style: textLabelRed,
                  textAlign: TextAlign.left,
                ),
              ),
              ExpansionTitleWidget(title: "Comments"),
              ExpansionTitleWidget(title: "Distribution setting"),
              ExpansionTitleWidget(title: "Streaming filters"),
              ExpansionTitleWidget(title: "History"),
            ],
          ),
        ),
      ),
    );
  }
}
