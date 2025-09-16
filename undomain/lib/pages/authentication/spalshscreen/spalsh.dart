import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:undomain/pages/authentication/login/login_screen.dart';
import 'package:undomain/pages/authentication/terms&conditions/terms_and_conditions.dart';
import 'package:undomain/pages/home/main_screen.dart';
import 'package:undomain/router/router_names.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/textstyles/text_styles.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({super.key});

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      GoRouter.of(context).goNamed(RouterNames.wrapperScreen);
    });
  }

  dynamic get splash => null;
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Text("Date NET.", style: textDisplay),
      nextScreen: WrapperScreen(),
      // animationDuration: Duration(seconds: 3000),
      backgroundColor: utilPrimaryWhite,
      centered: true,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,

      duration: 3000,
    );
  }
}

//chack auth states
class WrapperScreen extends StatefulWidget {
  const WrapperScreen({super.key});

  @override
  State<WrapperScreen> createState() => _WrapperScreenState();
}

class _WrapperScreenState extends State<WrapperScreen> {
  bool isLoged = false;
  bool isInitUser = false;
  String? userId;
  @override
  void initState() {
    _checkLoginState();
    super.initState();
  }

  void _checkLoginState() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String? token = _pref.getString("token");
    userId = _pref.getString("user");
    setState(() {
      isLoged = token != null;
      isInitUser = userId == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isInitUser
        ? TermsAndConditions()
        : isLoged
        ? Homepage(isFromLogin: false,index: 0,)
        : LoginScreen();
  }
}
