import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:undomain/router/router_names.dart';
import 'package:undomain/util/textstyles/text_styles.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({super.key});

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      GoRouter.of(context).goNamed(RouterNames.termsAndConditions);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Date NET.", style: textDisplay),
            SizedBox(height: 20),

            SizedBox(height: 10),
            CircularProgressIndicator(
              color: Colors.blue,
            ), // optional loading spinner
          ],
        ),
      ),
    );
  }
}
