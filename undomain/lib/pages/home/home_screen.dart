import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:undomain/services/userservices/userservices.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/global/global_function.dart';
import 'package:undomain/util/textstyles/text_styles.dart';

class HomeScreen extends StatefulWidget {
  // final String userId;
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _serchItem = "";
  final FloatingSearchBarController _floatingSearchBarController =
      FloatingSearchBarController();
  final Userservices _userservices = Userservices();
  final GlobalFunction _globalFunction = GlobalFunction();
  late Map<String, dynamic> user;
  Uint8List? imagebytes;
  String username = "";
  //get device user
  Future<void> _getDeviceUser() async {
    user = await _userservices.getCurrentUser();
    if (!user["succss"]) {
      _globalFunction.snackBarMassage(context, user["massage"], 3);
    } else {
      setState(() {
        username = user["user"]["username"];

        String base64String = user["user"]["profileUrl"];
        imagebytes = base64Decode(base64String);
      });
    }
  }

  @override
  void initState() {
    _getDeviceUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceW = MediaQuery.of(context).size.width;
    double deviceH = MediaQuery.of(context).size.height;
    double space = (deviceW - 72) / 2;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          //fit: StackFit.expand,
          children: [
            //background image
            Image.asset(
              "assets/mess.jpeg",
              fit: BoxFit.fill,
              height: deviceH * 0.4,
              width: double.infinity,
            ),
            //user name
            Positioned(
              top: deviceH * 0.03,
              left: deviceW * 0.03,
              child: Chip(
                label: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "Welcome ", style: textLabelRed),
                      TextSpan(text: username, style: textLabel),
                    ],
                  ),
                ),
                autofocus: true,
                backgroundColor: utilPrimaryWhite,
                labelPadding: EdgeInsets.all(2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),

            //uaer profile  picture
            Positioned(
              top: deviceH * 0.03,
              right: deviceW * 0.03,
              child:
                  imagebytes == null
                      ? CircleAvatar(
                        backgroundColor: utilPrimaryGrey,
                        radius: 24,
                      )
                      : CircleAvatar(
                        backgroundColor: utilPrimaryGrey,
                        radius: 24,
                        backgroundImage: MemoryImage(imagebytes!),
                      ),
            ),
            //search bar
            Positioned(
              child: Padding(
                padding: EdgeInsets.only(top: deviceH * 0.3),
                child: searchBar(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBar(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: "Who you are looking for?",
      controller: _floatingSearchBarController,
      hintStyle: GoogleFonts.poppins(
        color: utilPrimaryGrey,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
      scrollPadding: EdgeInsets.all(8),
      transitionDuration: Duration(microseconds: 600),
      transitionCurve: Curves.easeInOut,
      autocorrect: true,

      borderRadius: BorderRadius.circular(24),
      textInputAction: TextInputAction.search,
      elevation: 2,
      automaticallyImplyBackButton: false,
      iconColor: utilPrimaryBlack,
      leadingActions: [Icon(Icons.search, color: utilPrimaryGrey)],
      physics: BouncingScrollPhysics(),
      openAxisAlignment: 0,
      width: isPortrait ? 500 : 750,
      debounceDelay: Duration(microseconds: 400),
      onQueryChanged: (query) {
        setState(() {
          _serchItem = query;
        });
      },
      transition: CircularFloatingSearchBarTransition(),

      actions: [],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Material(color: utilPrimaryWhite, elevation: 1),
        );
      },
    );
  }
}
