//page routes

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:undomain/pages/authentication/email_verification/email_verification.dart';
import 'package:undomain/pages/authentication/fogotpassword/fogot_password.dart';
import 'package:undomain/pages/authentication/login/login_screen.dart';
import 'package:undomain/pages/authentication/register/register_screen.dart';
import 'package:undomain/pages/authentication/spalshscreen/spalsh.dart';
import 'package:undomain/pages/authentication/terms&conditions/terms_and_conditions.dart';
import 'package:undomain/pages/error/error_page.dart';
import 'package:undomain/pages/home/homepage.dart';
import 'package:undomain/router/router_names.dart';

class Routes {
  final goRouter = GoRouter(
    initialLocation: "/",
    errorPageBuilder: (context, state) {
      return const MaterialPage(child: ErrorPage());
    },
    routes: [
      //splash screen
      GoRoute(
        path: "/",
        name: RouterNames.splashScreen,
        builder: (context, state) {
          return SpalshScreen();
        },
      ),
      //loginpage
      GoRoute(
        path: "/login",
        name: RouterNames.loginPage,
        builder: (context, state) {
          return LoginScreen();
        },
      ),
      //loginpage
      GoRoute(
        path: "/terms",
        name: RouterNames.termsAndConditions,
        builder: (context, state) {
          return const TermsAndConditions();
        },
      ),
      //registerpage
      GoRoute(
        path: "/register",
        name: RouterNames.registerPage,
        builder: (context, state) {
          return RegisterScreen();
        },
      ),
      //verificationpage
      GoRoute(
        path: "/verify",
        name: RouterNames.verificationPage,
        builder: (context, state) {
          final String userId = (state.extra as Map<String, dynamic>)["userId"];
          final bool isFromRegister =
              (state.extra as Map<String, dynamic>)["isFromRegister"];
          final String email = (state.extra as Map<String, dynamic>)["email"];
          return EmailVerification(
            userid: userId,
            isForRegister: isFromRegister,
            email: email,
          );
        },
      ),
      //Homepage
      GoRoute(
        path: "/home",
        name: RouterNames.homePage,
        builder: (context, state) {
          String userId = (state.extra as Map<String, dynamic>)["userId"];
          String username = (state.extra as Map<String, dynamic>)["username"];
          String email = (state.extra as Map<String, dynamic>)["email"];
          Uint8List profileUrl =
              (state.extra as Map<String, dynamic>)["profileUrl"];
          return Homepage(
            email: email,
            prfileUrl: profileUrl,
            userId: userId,
            username: username,
          );
        },
      ),
      //Homepage
      GoRoute(
        path: "/fogotpassword",
        name: RouterNames.fogotpasswordScreen,
        builder: (context, state) {
          return FogotPassword();
        },
      ),
      GoRoute(
        path: "/wrapper",
        name: RouterNames.wrapperScreen,
        builder: (context, state) {
          return WrapperScreen();
        },
      ),
    ],
  );
}
