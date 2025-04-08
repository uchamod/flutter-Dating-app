import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:undomain/router/router_names.dart';
import 'package:undomain/util/global/global_varibles.dart';
import 'package:undomain/util/textstyles/text_styles.dart';
import 'package:undomain/widgets/buttons/authpage_button.dart';
import 'package:undomain/widgets/textboxes/authtext_box.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmpasswordcontroller =
      TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  @override
  void dispose() {
    _passwordcontroller.dispose();
    _usernamecontroller.dispose();
    _confirmpasswordcontroller.dispose();
    _emailcontroller.dispose();
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
                  //email
                  AuthtextBox(
                    controller: _passwordcontroller,
                    hint: "@email",
                    isShow: false,
                    onSubmit: (p0) {},
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.emailAddress,
                  ),
                  //password
                  AuthtextBox(
                    controller: _confirmpasswordcontroller,
                    hint: "@password",
                    isShow: false,
                    onSubmit: (p0) {},
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.visiblePassword,
                  ),
                  //password
                  AuthtextBox(
                    controller: _emailcontroller,
                    hint: "@password",
                    isShow: false,
                    onSubmit: (p0) {},
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.visiblePassword,
                  ),
                  //to verification page
                  AuthpageButton(
                    text: "Register",
                    path: RouterNames.verificationPage,
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
            ),
          ],
        ),
      ),
    );
  }
}
