import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:undomain/models/user/user_model.dart';
import 'package:undomain/pages/home/home_screen.dart';
import 'package:undomain/pages/profile/profile_scren.dart';
import 'package:undomain/pages/reels/reel_screen.dart';
import 'package:undomain/pages/streaming/streaming_screen.dart';
import 'package:undomain/pages/update/update_screen.dart';
import 'package:undomain/provider/user_provider.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/textstyles/text_styles.dart';

class Homepage extends ConsumerStatefulWidget {
  final bool isFromLogin;
  final int index;
  final String userId;
  const Homepage({
    super.key,
    required this.isFromLogin,
    required this.index,
    required this.userId,
  });

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  late PersistentTabController _tabController;
  UserModel? user;
  //renderd screens
  // List<Widget> _buildScreen() {
  //   return [
  //     HomeScreen(isRestart: widget.isFromLogin),
  //     ReelScreen(userId: widget.userId),
  //     StreamingScreen(),
  //     UpdateScreen(userId: widget.userId),
  //     ProfileScren(user: user!),
  //   ];
  // }

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
    _tabController = PersistentTabController(initialIndex: widget.index);
    // Schedule this after the current frame
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final currentUserData = ref.read(currentUserProvider);
    //   currentUserData.whenData((userData) {
    //     setState(() {
    //       user = userData["user"];
    //     });
    //   });
    // });

    //_restart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Access the provider in the build method
    final currentUserData = ref.watch(currentUserProvider);
    return currentUserData.when(
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
      loading: () => Center(child: CircularProgressIndicator()),
      data: (userData) {
        user = userData["user"];
        return PersistentTabView(
          context,
          screens: <Widget>[
            HomeScreen(isRestart: widget.isFromLogin),
            ReelScreen(userId: widget.userId),
            StreamingScreen(),
            UpdateScreen(userId: widget.userId),
            ProfileScren(user: user!),
          ],
          controller: _tabController,
          items: _navBarItems(),
          confineToSafeArea: true,

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
              screenTransitionAnimationType:
                  ScreenTransitionAnimationType.fadeIn,
            ),
          ),
          // navBarStyle: NavBarStyle.style10,
        );
      },
    );
  }
}
