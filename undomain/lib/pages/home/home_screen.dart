import 'dart:convert';
import 'dart:typed_data';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:undomain/models/user/user_model.dart';
import 'package:undomain/pages/admob/banner_ad.dart';
import 'package:undomain/provider/user_provider.dart';
import 'package:undomain/services/userservices/userservices.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/global/global_function.dart';
import 'package:undomain/util/textstyles/text_styles.dart';
import 'package:undomain/widgets/loading_indicator/plain_indicator.dart';
import 'package:undomain/widgets/userListviwe/user_listviwe.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final bool isRestart;
  const HomeScreen({super.key, required this.isRestart});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final FloatingSearchBarController _floatingSearchBarController =
      FloatingSearchBarController();
  final Userservices _userservices = Userservices();
  final GlobalFunction _globalFunction = GlobalFunction();
  late Map<String, dynamic> user;
  Uint8List? imagebytes;
  String username = "";
  List<UserModel> searchedUsers = [];
  final _indicatorController = IndicatorController();
  Future<void> _searchUser(String query) async {
    if (query.isEmpty) {
      return;
    }
    Map<String, dynamic> response = await _userservices.getUserByUserName(
      query,
    );
    if (!response["success"]) {
      print(response["massage"]);
      _globalFunction.snackBarMassage(context, response["massage"], 3);
    } else {
      setState(() {
        searchedUsers = response["users"];
      });
    }
  }

  // Add refresh method to reload user data
  Future<void> _handleRefresh() async {
    // Invalidate the provider to force a refresh
    ref.invalidate(currentUserProvider);

    // Clear search results
    setState(() {
      searchedUsers = [];
    });

    // Wait for a moment to simulate network request
    await Future.delayed(const Duration(milliseconds: 1500));
  }

  bool _hasShownError = false;
  @override
  Widget build(BuildContext context) {
    final currentUserData = ref.watch(currentUserProvider);
    double deviceW = MediaQuery.of(context).size.width;
    double deviceH = MediaQuery.of(context).size.height;
    double space = (deviceW - 72) / 2;
    return SafeArea(
      child: Scaffold(
        body: currentUserData.when(
          loading:
              () => Center(
                child: CircularProgressIndicator(color: utilPrimaryRed),
              ),

          error:
              (error, stackTrace) =>
                  Center(child: Text('Error: ${error.toString()}')),
          data: (currentuser) {
            if ((!currentuser["success"] && !_hasShownError) ||
                currentuser["user"] == null) {
              _hasShownError = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _globalFunction.snackBarMassage(
                  context,
                  currentuser["massage"],
                  3,
                );
              });
            }
            if (currentuser["user"] == null) {
              Center(child: CircularProgressIndicator(color: utilPrimaryRed));
            }
            UserModel user = currentuser["user"];
            String base64String = user.profileUrl;
            imagebytes = base64Decode(base64String);
            return PlaneIndicator(
              controller: _indicatorController,
              handleRefresh: _handleRefresh,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: deviceH * 0.4,
                    child: Stack(
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
                                  TextSpan(
                                    text: "Welcome ",
                                    style: textLabelRed,
                                  ),
                                  TextSpan(
                                    text: user.username ?? username,
                                    style: textLabel,
                                  ),
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
                  // SizedBox(height: 16),
                  BannerAdWidget(),
                  //show all users(will avalible workers)
                  Expanded(child: UserListviwe(searchUsers: searchedUsers)),
                ],
              ),
            );
          },
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
      //serch
      onSubmitted: (query) async {
        searchedUsers = [];
        await _searchUser(query);
      },
      onQueryChanged: (query) {},
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
