import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:undomain/router/router_names.dart';
import 'package:undomain/services/auth_services/authservices.dart';
import 'package:undomain/util/global/global_varibles.dart';
import 'package:undomain/util/textstyles/text_styles.dart';

class ProfileScren extends ConsumerStatefulWidget {
  const ProfileScren({super.key});

  @override
  ConsumerState<ProfileScren> createState() => _ProfileScrenState();
}

class _ProfileScrenState extends ConsumerState<ProfileScren> {
  void _logout(WidgetRef ref) {
    Authservices().logout(ref);
    GoRouter.of(context).goNamed(RouterNames.loginPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: mainPagePaddingH,
              vertical: mainPagePaddingV,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    _logout(ref);
                  },
                  child: Text("Logout", style: textBody),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
