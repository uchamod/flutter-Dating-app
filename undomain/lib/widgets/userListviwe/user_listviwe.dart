import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:undomain/models/user/user_model.dart';
import 'package:undomain/provider/user_provider.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/global/global_function.dart';
import 'package:undomain/util/textstyles/text_styles.dart';

class UserListviwe extends ConsumerWidget {
  final List<UserModel> searchUsers;
  UserListviwe({super.key, required this.searchUsers});
  //avalible worker  list wive
  final GlobalFunction _globalFunction = GlobalFunction();
  bool _hasShownError = false;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUserData = ref.watch(allUserProvider);
    return allUserData.when(
      error:
          (error, stackTrace) =>
              Center(child: Text('Error: ${error.toString()}')),
      loading:
          () => Center(child: CircularProgressIndicator(color: utilPrimaryRed)),
      data: (allusers) {
        if (!allusers["success"] && !_hasShownError) {
          _hasShownError = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            print(allusers["massage"]);
            _globalFunction.snackBarMassage(context, allusers["massage"], 3);
          });
        }
        if (searchUsers.isNotEmpty) {
          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: searchUsers.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),

            itemBuilder: (context, index) {
              UserModel user = searchUsers[index];
              Uint8List userImage = base64Decode(user.profileUrl);
              //user card
              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                //user pic
                child: ListTile(
                  contentPadding: EdgeInsets.all(8),
                  leading: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.memory(userImage),
                  ),
                  //username
                  title: Text(user.username, style: textBody),
                  //user contact
                  subtitle: Text(user.email, style: textLabel),
                  onTap: () {
                    //navigate to user profile
                  },
                ),
              );
            },
          );
        } else {
          List<UserModel> users = allusers["users"];
          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: users.length,
            scrollDirection: Axis.vertical,

            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),

            itemBuilder: (context, index) {
              UserModel user = users[index];
              Uint8List userImage = base64Decode(user.profileUrl);
              //user card
              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                //user pic
                child: ListTile(
                  contentPadding: EdgeInsets.all(8),
                  leading: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.memory(userImage),
                  ),
                  //username
                  title: Text(user.username, style: textBody),
                  //user contact
                  subtitle: Text(user.email, style: textLabel),
                  onTap: () {
                    //navigate to user profile
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
