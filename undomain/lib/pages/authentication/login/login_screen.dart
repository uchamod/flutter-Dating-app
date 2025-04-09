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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: authScreenPaddingH,
            vertical: authScreenPaddingV,
          ),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              //title
              Column(children: [Text("Date NET.", style: textDisplay)]),
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              //auth details
              Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AuthtextBox(
                      controller: _usernamecontroller,
                      hint: "@username",
                      isShow: false,
                      onSubmit: (p0) {},
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.name,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    //password
                    AuthtextBox(
                      controller: _passwordcontroller,
                      hint: "@password",
                      isShow: false,
                      onSubmit: (p0) {},
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.visiblePassword,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                    Column(
                      children: [
                        AuthpageButton(
                          text: "Login",
                          path: RouterNames.homePage,
                        ),
                        //to register page
                        TextButton(
                          onPressed: () {
                            GoRouter.of(
                              context,
                            ).goNamed(RouterNames.registerPage);
                          },
                          child: Text("Create one", style: textLabelRed),
                        ),
                      ],
                    ),

                    //to home page
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
