//page routes

import 'package:go_router/go_router.dart';
import 'package:undomain/pages/authentication/login/login_screen.dart';
import 'package:undomain/pages/authentication/terms&conditions/terms_and_conditions.dart';
import 'package:undomain/router/router_names.dart';

class Routes {
  final GoRouter goRouter = GoRouter(
    initialLocation: "/",
    routes: [
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
          return TermsAndConditions();
        },
      ),
      //registerpage
      GoRoute(path: "/register", name: RouterNames.registerPage),
      //verificationpage
      GoRoute(path: "/verify", name: RouterNames.verificationPage),
      //Homepage
      GoRoute(path: "/home", name: RouterNames.homePage),
    ],
  );
}
