import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:undomain/pages/restart/restart.dart';
import 'package:undomain/router/router_names.dart';
import 'package:undomain/services/auth_services/authservices.dart';
import 'package:undomain/util/global/global_function.dart';
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
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final GlobalFunction _globalFunction = GlobalFunction();
  final Authservices _authservices = Authservices();
  @override
  void dispose() {
    _passwordcontroller.dispose();
    _usernamecontroller.dispose();
    super.dispose();
  }

  Future<void> _userLogin() async {
    setState(() {
      _isLoading = true;
    });

    final response = await _authservices.login(
      username: _usernamecontroller.text,
      password: _passwordcontroller.text,
    );
    if (response["success"]) {
      //restart app
      RestartWidget.restartApp(context);
    } else {
      _globalFunction.snackBarMassage(context, response["massage"], 3);
    }
    setState(() {
      _isLoading = false;
    });
  }

  //login validation frontend properties
  String usernameHint = "@username";
  bool isUsernameValid = true;
  String passwordHint = "@password";
  bool isPasswordValid = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AuthtextBox(
                      isValid: isUsernameValid,
                      controller: _usernamecontroller,
                      hint: usernameHint,
                      isShow: false,
                      onSubmit: (p0) {},
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.name,

                      validChecker: (value) => null,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    //password
                    AuthtextBox(
                      controller: _passwordcontroller,
                      isValid: isPasswordValid,
                      hint: passwordHint,
                      isShow: false,
                      onSubmit: (p0) {},
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.visiblePassword,
                      validChecker: (value) => null,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    TextButton(
                      onPressed: () {
                        GoRouter.of(
                          context,
                        ).goNamed(RouterNames.fogotpasswordScreen);
                      },
                      child: Text("Fogot Password ?", style: textLabelRed),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                    Column(
                      children: [
                        //if valid form state
                        GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate() &&
                                _usernamecontroller.text.isNotEmpty &&
                                _passwordcontroller.text.isNotEmpty) {
                              await _userLogin();
                            } else {
                              setState(() {
                                isPasswordValid = false;
                                passwordHint = "please enter your @password";
                                isUsernameValid = false;
                                usernameHint = "please enter your @username";
                              });
                            }
                          },
                          child: AuthpageButton(
                            text: "Login",
                            isLoading: _isLoading,
                          ),
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
