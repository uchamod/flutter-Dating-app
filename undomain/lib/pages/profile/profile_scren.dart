import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:undomain/models/user/user_model.dart';
import 'package:undomain/provider/user_provider.dart';
import 'package:undomain/router/router_names.dart';
import 'package:undomain/services/auth_services/authservices.dart';
import 'package:undomain/services/userservices/userservices.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/global/global_function.dart';
import 'package:undomain/util/global/global_varibles.dart';
import 'package:undomain/util/textstyles/text_styles.dart';

class ProfileScren extends ConsumerStatefulWidget {
  final UserModel user;
  const ProfileScren({super.key, required this.user});

  @override
  ConsumerState<ProfileScren> createState() => _ProfileScrenState();
}

class _ProfileScrenState extends ConsumerState<ProfileScren> {
  // final ReelsService _reelsService = ReelsService();

  // File? _videofile;
  // final TextEditingController _titlecontroller = TextEditingController();
  final GlobalFunction _globalFunction = GlobalFunction();
  final Userservices _userservices = Userservices();
  bool _hasShownError = false;
  bool isLoading = false;
  Uint8List? imagebytes;
  bool _isfollowing = false;
  void _logout(WidgetRef ref) {
    Authservices().logout(ref);
    GoRouter.of(context).goNamed(RouterNames.loginPage);
  }

  //follow user
  Future<void> _followUser() async {
    final result = await _userservices.followUnfollowUser(
      guestid: widget.user.id,
    );
    if (!result["success"]) {
      _globalFunction.snackBarMassage(context, result["massage"], 3);
      return;
    }
    _globalFunction.snackBarMassage(context, result["massage"], 3);
    setState(() {
      _isfollowing = !_isfollowing;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //_titlecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserData = ref.watch(currentUserProvider);
    double deviceW = MediaQuery.of(context).size.width;
    double deviceH = MediaQuery.of(context).size.height;
    return Scaffold(
      body: currentUserData.when(
        error:
            (error, stackTrace) =>
                Center(child: Text('Error: ${error.toString()}')),
        loading:
            () =>
                Center(child: CircularProgressIndicator(color: utilPrimaryRed)),
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
          UserModel current = currentuser["user"];
          String base64String = widget.user.profileUrl;
          imagebytes = base64Decode(base64String);
          _isfollowing = widget.user.followers!.contains(current.id) ?? false;
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mainPagePaddingH,
              vertical: mainPagePaddingV,
            ),
            child: Column(
              children: [
                //logout
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _logout(ref);
                      },
                      child: Text("Logout", style: textBody),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
                //profile image
                imagebytes == null
                    ? Center(
                      child: CircleAvatar(
                        backgroundColor: utilPrimaryGrey,
                        radius: 24,
                      ),
                    )
                    : Center(
                      child: CircleAvatar(
                        backgroundColor: utilPrimaryGrey,
                        radius: 60,
                        backgroundImage: MemoryImage(imagebytes!),
                      ),
                    ),
                SizedBox(height: 8),
                //name
                Center(
                  child: Text(
                    "@${widget.user.username}",
                    style: textTitalSmall,
                  ),
                ),
                SizedBox(height: 16),
                //follow and followings
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //following
                    Column(
                      children: [
                        Text(
                          widget.user.following!.length.toString() ?? "0",
                          style: textBody,
                        ),
                        Text("Following", style: textBody),
                      ],
                    ),
                    //followers
                    Column(
                      children: [
                        Text(
                          widget.user.followers!.length.toString() ?? "0",
                          style: textBody,
                        ),
                        Text("Followers", style: textBody),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                //option list
                widget.user.id == current.id
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //edit profile
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: mainPagePaddingH,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: utilPrimaryRed,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Edit profile",
                            style: textTitalSmall.copyWith(
                              color: utilPrimaryWhite,
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        //register as worker
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: mainPagePaddingH,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: utilPrimaryRed,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Worker?",
                            style: textTitalSmall.copyWith(
                              color: utilPrimaryWhite,
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        //add new followings
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: utilPrimaryRed,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.add_reaction_outlined,
                            size: 28,
                            color: utilPrimaryWhite,
                          ),
                        ),
                      ],
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //follow user
                        GestureDetector(
                          onTap: () async {
                            await _followUser();
                          },
                          child:
                              _isfollowing
                                  ? Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: mainPagePaddingH,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: utilPrimaryGrey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "Unfollow",
                                      style: textTitalSmall.copyWith(
                                        color: utilPrimaryWhite,
                                      ),
                                    ),
                                  )
                                  : Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: mainPagePaddingH,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: utilPrimaryRed,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "Follow",
                                      style: textTitalSmall.copyWith(
                                        color: utilPrimaryWhite,
                                      ),
                                    ),
                                  ),
                        ),
                        SizedBox(width: 4),
                        //massage user
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: mainPagePaddingH,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: utilPrimaryRed,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Massage",
                            style: textTitalSmall.copyWith(
                              color: utilPrimaryWhite,
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        //add new followings
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: utilPrimaryRed,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.add_reaction_outlined,
                            size: 28,
                            color: utilPrimaryWhite,
                          ),
                        ),
                      ],
                    ),
                //if worker show the reels
              ],
            ),
          );
        },
      ),
    );
  }
}
