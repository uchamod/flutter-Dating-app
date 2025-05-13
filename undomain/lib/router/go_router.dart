//page routes

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:undomain/models/user/user_model.dart';
import 'package:undomain/pages/authentication/email_verification/email_verification.dart';
import 'package:undomain/pages/authentication/fogotpassword/fogot_password.dart';
import 'package:undomain/pages/authentication/login/login_screen.dart';
import 'package:undomain/pages/authentication/register/register_screen.dart';
import 'package:undomain/pages/authentication/spalshscreen/spalsh.dart';
import 'package:undomain/pages/authentication/terms&conditions/terms_and_conditions.dart';
import 'package:undomain/pages/error/error_page.dart';
import 'package:undomain/pages/home/home_screen.dart';
import 'package:undomain/pages/home/main_screen.dart';
import 'package:undomain/pages/profile/profile_scren.dart';
import 'package:undomain/pages/reels/reel_screen.dart';
import 'package:undomain/pages/streaming/live_screen.dart';
import 'package:undomain/pages/streaming/log_streaming.dart';
import 'package:undomain/pages/streaming/streaming_screen.dart';
import 'package:undomain/pages/update/update_screen.dart';
import 'package:undomain/router/router_names.dart';

class Routes {
  // static final RouteObserver<ModalRoute> shellRouteObserver = RouteObserver();
  // static final GlobalKey<NavigatorState> _rootNavigatorKey =
  //     GlobalKey<NavigatorState>();
  final goRouter = GoRouter(
    // navigatorKey: _rootNavigatorKey,
    // observers: [shellRouteObserver],
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
          bool isRestarted = (state.extra as Map<String, dynamic>)["start"];

          return HomeScreen(isRestart: isRestarted);
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
      //wrapper page
      GoRoute(
        path: "/wrapper",
        name: RouterNames.wrapperScreen,
        builder: (context, state) {
          return WrapperScreen();
        },
      ),
      //main screen
      GoRoute(
        path: "/main",
        name: RouterNames.mainpage,
        builder: (context, state) {
          bool isFromLogin =
              (state.extra as Map<String, dynamic>)["isFromLogin"];
          int index = (state.extra as Map<String, dynamic>)["index"];
          String userId = (state.extra as Map<String, dynamic>)["userId"];
          return Homepage(
            isFromLogin: isFromLogin,
            index: index,
            userId: userId,
          );
        },
      ),
      //stream logpage
      GoRoute(
        path: "/stream",
        name: RouterNames.StremingConfigScreen,
        builder: (context, state) {
          return LogStreaming();
        },
      ),
      //zego live stream page
      GoRoute(
        path: "/live",
        name: RouterNames.zegoLiveScreen,
        builder: (context, state) {
          bool isHost = (state.extra as Map<String, dynamic>)["isHost"];
          String liveId = (state.extra as Map<String, dynamic>)["liveId"];
          return ZegoLiveScreen(isHost: isHost, liveId: liveId);
        },
      ),
      //llive first look page
      GoRoute(
        path: "/livestream",
        name: RouterNames.mainStremaingPage,
        builder: (context, state) {
          return StreamingScreen();
        },
      ),
      //reel page
      GoRoute(
        path: "/reel",
        name: RouterNames.reelPage,
        builder: (context, state) {
          String userId = (state.extra as Map<String, dynamic>)["userId"];
          return ReelScreen(userId: userId);
        },
      ),
      //profile page
      GoRoute(
        path: "/profile",
        name: RouterNames.profilePage,
        builder: (context, state) {
          UserModel user = (state.extra as Map<String, dynamic>)["user"];
          return ProfileScren(user: user);
        },
      ),
      //updatepage
      GoRoute(
        path: "/update",
        name: RouterNames.updatePage,
        builder: (context, state) {
          String userId = (state.extra as Map<String, dynamic>)["userId"];
          return UpdateScreen(userId: userId);
        },
      ),
    ],
  );
}
