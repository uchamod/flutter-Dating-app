import 'dart:math' as math;

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:undomain/router/router_names.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/global/global_varibles.dart';
import 'package:undomain/util/textstyles/text_styles.dart';

class StreamingScreen extends StatefulWidget {
  const StreamingScreen({super.key});

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {
  // Add refresh method to reload user data
  Future<void> _handleRefresh() async {
    setState(() {});

    // Wait for a moment to simulate network request
    await Future.delayed(const Duration(milliseconds: 1500));
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: utilPrimaryRed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(horizontal: mainPagePaddingH, vertical: 8),
    );
    return Scaffold(
      body: CustomMaterialIndicator(
        onRefresh: _handleRefresh,
        backgroundColor: utilPrimaryWhite,
        indicatorBuilder: (context, controller) {
          return Padding(
            padding: EdgeInsets.all(6),
            child: CircularProgressIndicator(
              color: utilPrimaryRed,
              value:
                  controller.state.isLoading
                      ? null
                      : math.min(controller.value, 1.0),
            ),
          );
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mainPagePaddingH,
              vertical:
                  mainPagePaddingV + MediaQuery.of(context).size.height * 0.05,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //title
                Center(child: SvgPicture.asset("assets/livetext.svg")),
                //illustrator
                SvgPicture.asset("assets/guitar.svg"),
                //nav to config page
                ElevatedButton(
                  style: buttonStyle,
                  onPressed: () {
                    GoRouter.of(
                      context,
                    ).goNamed(RouterNames.StremingConfigScreen);
                  },
                  child: Text(
                    "start streaming",
                    style: textTitalSmall.copyWith(color: utilPrimaryWhite),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
