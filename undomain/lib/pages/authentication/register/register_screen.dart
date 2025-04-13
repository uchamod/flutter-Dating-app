import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:undomain/router/router_names.dart';
import 'package:undomain/services/auth_services/authservices.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/global/global_function.dart';
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
  final _formKey = GlobalKey<FormState>();
  final Authservices _authservices = Authservices();
  final GlobalFunction _globalFunction = GlobalFunction();
  File? _file;
  bool _isLoading = false;
  @override
  void dispose() {
    _passwordcontroller.dispose();
    _usernamecontroller.dispose();
    _confirmpasswordcontroller.dispose();
    _emailcontroller.dispose();
    super.dispose();
  }

  //regexp for password
  final RegExp passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{6,}$',
  );

  //reg exp for username
  final RegExp usernameRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  ///regexp for email
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  //login validation frontend properties
  String usernameHint = "@username";
  bool isUsernameValid = true;
  String passwordHint = "@password";
  bool isPasswordValid = true;
  String emailHint = "@email";
  bool isEmailValid = true;
  String confirmPasswordHint = "@confirm password";
  bool isConfirmPasswordValid = true;

  //set profile image
  Future<void> _setProfileImage(ImageSource source) async {
    ImagePicker _imgPicker = ImagePicker();
    final image = await _imgPicker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _file = File(image.path);
      });
    }
  }

  //save valid user data and get verifcation code
  Future<void> userRegister() async {
    setState(() {
      _isLoading = true;
    });

    final response = await _authservices.register(
      _file!,
      username: _usernamecontroller.text,
      email: _emailcontroller.text,
      password: _passwordcontroller.text,
    );
    if (response["succss"]) {
      GoRouter.of(context).goNamed(
        RouterNames.verificationPage,
        extra: {
          "userId": response["user"]["id"],
          "isFromRegister": true,
          "email": "",
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
      // resizeToAvoidBottomInset: false,
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
              Text("Date NET.", style: textDisplay),
              //auth details
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Stack(
                      children: [
                        //profile picture
                        _file != null
                            ? CircleAvatar(
                              backgroundImage: FileImage(_file!),
                              backgroundColor: utilPrimaryWhite.withOpacity(
                                0.8,
                              ),
                              radius: 64,
                            )
                            : CircleAvatar(
                              backgroundColor: utilPrimaryWhite.withOpacity(
                                0.8,
                              ),
                              radius: 64,
                            ),
                        Positioned(
                          bottom: 0,
                          right: -6,
                          child: IconButton(
                            onPressed: () {
                              _setProfileImage(ImageSource.gallery);
                            },
                            icon: Icon(
                              CupertinoIcons.camera_circle,
                              color: utilPrimaryWhite,
                              size: 40,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    //username
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
                    //email
                    AuthtextBox(
                      isValid: isEmailValid,
                      controller: _emailcontroller,
                      hint: emailHint,
                      isShow: false,
                      onSubmit: (p0) {},
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.emailAddress,
                      validChecker: (value) => null,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    //password
                    AuthtextBox(
                      isValid: isPasswordValid,
                      controller: _passwordcontroller,
                      hint: passwordHint,
                      isShow: false,
                      onSubmit: (p0) {},
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.visiblePassword,
                      validChecker: (value) => null,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    //password
                    AuthtextBox(
                      isValid: isConfirmPasswordValid,
                      controller: _confirmpasswordcontroller,
                      hint: confirmPasswordHint,
                      isShow: false,
                      onSubmit: (p0) {},
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.visiblePassword,
                      validChecker: (value) => null,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                    //to verification page
                    GestureDetector(
                      onTap: () async {
                        if (_usernamecontroller.text.isEmpty ||
                            _emailcontroller.text.isEmpty ||
                            _passwordcontroller.text.isEmpty ||
                            _confirmpasswordcontroller.text.isEmpty) {
                          setState(() {
                            isUsernameValid = false;
                            isEmailValid = false;
                            isPasswordValid = false;
                            isConfirmPasswordValid = false;
                            usernameHint = "please enter your @username";
                            emailHint = "please enter your @email";
                            passwordHint = "please enter your @password";
                            confirmPasswordHint =
                                "please enter your @confirm password";
                          });
                        } else if (usernameRegExp.hasMatch(
                          _usernamecontroller.text,
                        )) {
                          setState(() {
                            usernameHint = "@username cannot cantain symbols";
                            _usernamecontroller.clear();
                          });
                        } else if (!emailRegex.hasMatch(
                          _emailcontroller.text,
                        )) {
                          setState(() {
                            emailHint = "Invalid @email format";
                            _emailcontroller.clear();
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
                            confirmPasswordHint =
                                "password mismatching please check your password";
                            _confirmpasswordcontroller.clear();
                          });
                        } else {
                          //execute register function
                          await userRegister();
                        }
                      },
                      child: AuthpageButton(
                        text: "Register",
                        isLoading: _isLoading,
                      ),
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
      ),
    );
  }
}
