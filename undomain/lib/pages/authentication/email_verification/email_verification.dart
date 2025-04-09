import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:undomain/router/router_names.dart';
import 'package:undomain/util/global/global_varibles.dart';
import 'package:undomain/util/textstyles/text_styles.dart';
import 'package:undomain/widgets/buttons/authpage_button.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  late Timer _timer;
  int _start = 60;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _start = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        _timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _onSubmit(String pin) {
    // Validate or verify PIN here
    print("Entered Code: $pin");
  }

  @override
  Widget build(BuildContext context) {
    double pinputSize = MediaQuery.of(context).size.width;
    final defaultPinTheme = PinTheme(
      width: (pinputSize - 0.08) / 5,
      height: (pinputSize - 0.08) / 5,
      textStyle: TextStyle(fontSize: 20, color: Colors.black),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
    );
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: authScreenPaddingH,
          vertical: authScreenPaddingV,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            //title
            Text("Date NET.", style: textDisplay),
            Column(
              children: [
                Text("Enter verification code ", style: textTitalSmall),
                Text("check out given @email", style: textLabel),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                //pinputs
                Pinput(
                  length: 5,
                  keyboardType: TextInputType.number,
                  onCompleted: _onSubmit,
                  defaultPinTheme: defaultPinTheme,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                //time render
                _start > 0
                    ? RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: "Resend code ", style: textLabel),
                          TextSpan(text: "${_start}s", style: textLabelRed),
                        ],
                      ),
                    )
                    : Text("Resend", style: textLabel),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Column(
              children: [
                //verify button:to home page
                AuthpageButton(path: RouterNames.homePage, text: "Verify"),
                //to login page
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).goNamed(RouterNames.loginPage);
                  },
                  child: Text("Login", style: textLabelRed),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
