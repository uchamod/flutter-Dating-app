import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:undomain/models/user/user_model.dart';
import 'package:undomain/provider/user_provider.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/textstyles/text_styles.dart';

class UserListviwe extends ConsumerWidget {
  const UserListviwe({super.key});
  //avalible worker  listt wive
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
        if (!allusers["success"]) {
          return Center(child: Text(allusers["message"]));
        }
        List<UserModel> users = allusers["users"];
        return ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: users.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          primary: true,
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
      },
    );
  }
}
