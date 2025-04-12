import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:undomain/router/router_names.dart';
import 'package:undomain/services/auth_services/authservices.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/global/global_function.dart';
import 'package:undomain/util/global/global_varibles.dart';
import 'package:undomain/util/textstyles/text_styles.dart';
import 'package:undomain/widgets/buttons/authpage_button.dart';

class EmailVerification extends StatefulWidget {
  final String userid;
  final bool isForRegister;
  final String? email;
  const EmailVerification({
    super.key,
    required this.userid,
    required this.isForRegister,
    this.email,
  });

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  late Timer _timer;
  int _start = 60;
  bool _isLoading = false;
  TextEditingController _pincontroller = TextEditingController();
  final GlobalFunction _globalFunction = GlobalFunction();
  final Authservices _authservices = Authservices();
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

  //request when complete the pinput
  void _onSubmit(String pin) async {
    setState(() {
      _isLoading = true;
    });
    if (pin.isEmpty || widget.userid.isEmpty) {
      _globalFunction.snackBarMassage(context, "Empty User Data", 3);
      return;
      // GoRouter.of(context).goNamed(RouterNames.homePage);
    }

    //for user registration
    if (widget.isForRegister) {
      final response = await _authservices.verifyNewUser(
        userId: widget.userid,
        verifyCode: pin,
      );
      if (response["success"]) {
        String base64String = response["user"]["profileUrl"];
        Uint8List imagesBytes = base64Decode(base64String);
        GoRouter.of(context).goNamed(
          RouterNames.homePage,
          extra: {
            "userId": response["user"]["id"],
            "username": response["user"]["username"],
            "email": response["user"]["email"],
            "profileUrl": imagesBytes,
          },
        );
      } else {
        _globalFunction.snackBarMassage(context, response["massage"], 3);
      }
      //for password reset
    } else {
      final response = await _authservices.verifyResetPassword(
        email: widget.email!,
        otp: pin,
        password: widget.userid,
      );
      if (response["success"]) {
        GoRouter.of(context).goNamed(RouterNames.loginPage);
      } else {
        _globalFunction.snackBarMassage(context, response["massage"], 3);
      }

      setState(() {
        _isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double pinputSize = MediaQuery.of(context).size.width;
    final defaultPinTheme = PinTheme(
      width: (pinputSize - 0.08) / 5,
      height: (pinputSize - 0.08) / 5,
      textStyle: TextStyle(fontSize: 20, color: utilPrimaryBlack),
      decoration: BoxDecoration(
        //  border: Border.all(color: utilPrimaryGrey),
        borderRadius: BorderRadius.circular(10),
        color: utilPrimaryWhite,
        boxShadow: [
          BoxShadow(
            offset: Offset(1, 2),
            blurRadius: 2,
            color: utilPrimaryGrey.withOpacity(0.5),
          ),
        ],
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  controller: _pincontroller,
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
                    : TextButton(
                      onPressed: () {},
                      child: Text("Resend", style: textLabelRed),
                    ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Column(
              children: [
                //verify button:to home page
                GestureDetector(
                  onTap: () => _onSubmit(_pincontroller.text),
                  child: AuthpageButton(text: "Verify", isLoading: _isLoading),
                ),
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
