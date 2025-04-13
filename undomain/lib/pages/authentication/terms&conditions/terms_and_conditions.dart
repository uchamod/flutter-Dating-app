import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:undomain/router/router_names.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/global/global_varibles.dart';
import 'package:undomain/util/textstyles/text_styles.dart';
import 'package:undomain/widgets/buttons/authpage_button.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  bool isChecked = false;
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: authScreenPaddingH,
          vertical: authScreenPaddingV,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // SizedBox(height: deviceHeight),
            Column(
              children: [
                //title
                Text("Date NET.", style: textDisplay),
                //termes and conditions
                Text(
                  "Forem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. Maecenas eget condimentum velit, sit amet feugiat lectus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Praesent auctor purus luctus enim egestas, ac scelerisque ante pulvinar. Donec ut rhoncus ex. Suspendisse ac rhoncus nisl, eu tempor urna. Curabitur vel bibendum lorem. Morbi convallis convallis diam sit amet lacinia. Aliquam in elementum tellus.Forem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. Maecenas eget condimentum velit, sit amet feugiat lectus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Praesent auctor purus luctus enim egestas, ac scelerisque ante pulvinar. Donec ut rhoncus ex",
                  style: textBody,
                ),
              ],
            ),

            //accept box
            Column(
              children: [
                Row(
                  children: [
                    //acceptent check box
                    Checkbox(
                      value: isChecked,
                      activeColor: utilPrimaryRed,
                      onChanged: (value) {
                        setState(() {
                          isInitialUser = true;
                          isChecked = !isChecked;
                        });
                      },
                      checkColor: utilPrimaryWhite,
                      autofocus: true,
                      focusColor: utilPrimaryRed,
                      side: BorderSide(color: utilPrimaryBlack, width: 1),
                    ),
                    Text("I agree terms & conditions", style: textLabel),
                  ],
                ),
                //route to login page
                GestureDetector(
                  onTap: () {
                    isChecked
                        ? GoRouter.of(context).goNamed(RouterNames.loginPage)
                        : ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: utilPrimaryRed,
                            closeIconColor: utilPrimaryWhite,
                            elevation: 1,
                            showCloseIcon: true,
                            padding: EdgeInsets.symmetric(
                              horizontal: authScreenPaddingH,
                            ),
                            content: Text(
                              "Please accept terms & conditions",
                              style: textSnackbar,
                            ),
                          ),
                        );
                  },
                  child: AuthpageButton(text: "Continue", isLoading: false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
