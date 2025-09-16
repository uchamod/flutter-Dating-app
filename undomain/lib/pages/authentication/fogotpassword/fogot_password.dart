import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:undomain/router/router_names.dart';
import 'package:undomain/services/auth_services/authservices.dart';
import 'package:undomain/util/global/global_function.dart';
import 'package:undomain/util/global/global_varibles.dart';
import 'package:undomain/util/textstyles/text_styles.dart';
import 'package:undomain/widgets/buttons/authpage_button.dart';
import 'package:undomain/widgets/textboxes/authtext_box.dart';

class FogotPassword extends StatefulWidget {
  const FogotPassword({super.key});

  @override
  State<FogotPassword> createState() => _FogotPasswordState();
}

class _FogotPasswordState extends State<FogotPassword> {
  final TextEditingController _confirmpasswordcontroller =
      TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final Authservices _authservices = Authservices();
  final GlobalFunction _globalFunction = GlobalFunction();
  //regexp for password
  final RegExp passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{6,}$',
  );
  String confirmpasswordHint = "@confirm password";
  bool isconfirmpasswordValid = true;
  String passwordHint = "@password";
  String emailHint = "@email";
  bool isPasswordValid = true;

  Future<void> _getCodeForResetPassword() async {
    setState(() {
      _isLoading = true;
    });

    final response = await _authservices.sendPasswordResetRequest(
      email: _emailcontroller.text,
    );
    if (response["success"]) {
      GoRouter.of(context).goNamed(
        RouterNames.verificationPage,
        extra: {
          "userId": _passwordcontroller.text,
          "isFromRegister": false,
          "email": response["user"]["id"],
        },
      );
    } else {
      _globalFunction.snackBarMassage(context, response["massage"], 3);
    }
    setState(() {
      _isLoading = false;
    });
  }

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
                    //password
                    AuthtextBox(
                      isValid: isPasswordValid,
                      controller: _emailcontroller,
                      hint: emailHint,
                      isShow: false,
                      onSubmit: (p0) {},
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.emailAddress,

                      validChecker: (value) => null,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    AuthtextBox(
                      isValid: isPasswordValid,
                      controller: _passwordcontroller,
                      hint: passwordHint,
                      isShow: false,
                      onSubmit: (p0) {},
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.name,

                      validChecker: (value) => null,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    //confirm password
                    AuthtextBox(
                      controller: _confirmpasswordcontroller,
                      isValid: isconfirmpasswordValid,
                      hint: confirmpasswordHint,
                      isShow: false,
                      onSubmit: (p0) {},
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.visiblePassword,
                      validChecker: (value) => null,
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                    Column(
                      children: [
                        //if valid form state
                        GestureDetector(
                          onTap: () async {
                            if (_confirmpasswordcontroller.text.isEmpty &&
                                _passwordcontroller.text.isEmpty) {
                              setState(() {
                                isPasswordValid = false;
                                passwordHint = "please enter your @password";
                                isconfirmpasswordValid = false;
                                confirmpasswordHint =
                                    "please confirm your password";
                              });
                            } else if (!passwordRegExp.hasMatch(
                              _passwordcontroller.text,
                            )) {
                              setState(() {
                                passwordHint = "weak password";
                                _passwordcontroller.clear();
                              });
                            } else if (_passwordcontroller.text !=
                                _confirmpasswordcontroller.text) {
                              setState(() {
                                confirmpasswordHint =
                                    "password mismatching please check your password";
                                _confirmpasswordcontroller.clear();
                              });
                            } else {
                              await _getCodeForResetPassword();
                            }
                          },

                          child: AuthpageButton(
                            text: "Submit",
                            isLoading: false,
                          ),
                        ),
                        //to register page
                        TextButton(
                          onPressed: () {
                            GoRouter.of(
                              context,
                            ).goNamed(RouterNames.registerPage);
                          },
                          child: Text(
                            "Create new account",
                            style: textLabelRed,
                          ),
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
