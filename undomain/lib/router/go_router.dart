//page routes

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:undomain/pages/authentication/email_verification/email_verification.dart';
import 'package:undomain/pages/authentication/login/login_screen.dart';
import 'package:undomain/pages/authentication/register/register_screen.dart';
import 'package:undomain/pages/authentication/spalshscreen/spalsh.dart';
import 'package:undomain/pages/authentication/terms&conditions/terms_and_conditions.dart';
import 'package:undomain/pages/error/error_page.dart';
import 'package:undomain/pages/home/homepage.dart';
import 'package:undomain/router/router_names.dart';

class Routes {
  final goRouter = GoRouter(
    initialLocation: "/verify",
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
      // //registerpage
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
          return EmailVerification();
        },
      ),
      //Homepage
      GoRoute(
        path: "/home",
        name: RouterNames.homePage,
        builder: (context, state) {
          return Homepage();
        },
      ),
    ],
  );
}
