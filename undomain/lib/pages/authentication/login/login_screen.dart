import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:undomain/router/router_names.dart';
import 'package:undomain/util/global/global_varibles.dart';
import 'package:undomain/util/textstyles/text_styles.dart';
import 'package:undomain/widgets/buttons/authpage_button.dart';
import 'package:undomain/widgets/textboxes/authtext_box.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  @override
  void dispose() {
    _passwordcontroller.dispose();
    _usernamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: authScreenPaddingH,
          vertical: authScreenPaddingV,
        ),
        child: Column(
          children: [
            //title
            Text("Date NET.", style: textDisplay),
            //auth details
            Form(
              child: Column(
                children: [
                  //username
                  AuthtextBox(
                    controller: _usernamecontroller,
                    hint: "@username",
                    isShow: false,
                    onSubmit: (p0) {},
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.name,
                  ),
                  //password
                  AuthtextBox(
                    controller: _passwordcontroller,
                    hint: "@password",
                    isShow: false,
                    onSubmit: (p0) {},
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.visiblePassword,
                  ),
                  //to home page
                  AuthpageButton(text: "Login", path: RouterNames.homePage),
                  //to register page
                  TextButton(
                    onPressed: () {
                      GoRouter.of(context).goNamed(RouterNames.registerPage);
                    },
                    child: Text("Create one", style: textLabelRed),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
