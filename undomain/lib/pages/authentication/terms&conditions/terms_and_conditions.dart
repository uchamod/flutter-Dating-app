import 'package:flutter/material.dart';
import 'package:undomain/router/router_names.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/global/global_varibles.dart';
import 'package:undomain/util/textstyles/text_styles.dart';
import 'package:undomain/widgets/buttons/authpage_button.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

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
            //termes and conditions
            Text(
              "Forem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. Maecenas eget condimentum velit, sit amet feugiat lectus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Praesent auctor purus luctus enim egestas, ac scelerisque ante pulvinar. Donec ut rhoncus ex. Suspendisse ac rhoncus nisl, eu tempor urna. Curabitur vel bibendum lorem. Morbi convallis convallis diam sit amet lacinia. Aliquam in elementum tellus.Forem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. Maecenas eget condimentum velit, sit amet feugiat lectus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Praesent auctor purus luctus enim egestas, ac scelerisque ante pulvinar. Donec ut rhoncus ex",
              style: textBody,
            ),

            //accept box
            Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (value) {},
                  checkColor: utilPrimaryRed,
                  autofocus: true,
                  focusColor: utilPrimaryRed,
                  side: BorderSide(color: utilPrimaryBlack, width: 1),
                ),
                Text("I agree terms & conditions", style: textLabel),
                //go to login page
                AuthpageButton(path: RouterNames.loginPage, text: "Continue"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
