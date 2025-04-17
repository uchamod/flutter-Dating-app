import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:undomain/pages/home/home_screen.dart';
import 'package:undomain/pages/profile/profile_scren.dart';
import 'package:undomain/pages/reels/reel_screen.dart';
import 'package:undomain/pages/streaming/streaming_screen.dart';
import 'package:undomain/pages/update/update_screen.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/textstyles/text_styles.dart';

class Homepage extends StatefulWidget {
  // final String userId;
  // final String? username;
  // final String? email;
  // final Uint8List? prfileUrl;
  const Homepage({
    super.key,
    // required this.userId,

    // this.userId,
    // this.username,
    // this.email,
    // this.prfileUrl,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late PersistentTabController _tabController;
  //renderd screens
  List<Widget> _buildScreen() {
    return [
      HomeScreen(),
      ReelScreen(),
      StreamingScreen(),
      UpdateScreen(),
      ProfileScren(),
    ];
  }

  //nav bar items
  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home_outlined),
        title: "Home",
        activeColorPrimary: utilPrimaryRed,
        inactiveColorPrimary: utilPrimaryGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.camera),
        title: "Reels",
        activeColorPrimary: utilPrimaryRed,
        inactiveColorPrimary: utilPrimaryGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.live_tv),
        title: "Live",
        activeColorPrimary: utilPrimaryRed,
        inactiveColorPrimary: utilPrimaryGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.update),
        title: "Upgrade",
        activeColorPrimary: utilPrimaryRed,
        inactiveColorPrimary: utilPrimaryGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person_2_outlined),
        title: "Profile",
        textStyle: textLabel,

        activeColorPrimary: utilPrimaryRed,
        inactiveColorPrimary: utilPrimaryGrey,
      ),
    ];
  }

  @override
  void initState() {
    _tabController = PersistentTabController(initialIndex: 0);
    super.initState();
  }

  //Uint8List imageBytes = base64Decode()
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: _buildScreen(),
      controller: _tabController,
      items: _navBarItems(),
      confineToSafeArea: true,
      // backgroundColor: Color.fromARGB(247, 254, 254, 254),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(24),
        colorBehindNavBar: utilPrimaryWhite,
        boxShadow: [
          BoxShadow(
            color: utilPrimaryGrey.withOpacity(0.5),
            offset: Offset(0, 0.5),
            spreadRadius: 0,
            blurRadius: 1,
          ),
        ],
      ),
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      animationSettings: NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
        ),
      ),
      // navBarStyle: NavBarStyle.style10,
    );
  }
}
