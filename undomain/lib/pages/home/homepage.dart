import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:undomain/util/global/global_varibles.dart';
import 'package:undomain/util/textstyles/text_styles.dart';

class Homepage extends StatefulWidget {
  final String userId;
  final String username;
  final String email;
  final Uint8List prfileUrl;
  const Homepage({
    super.key,
    required this.userId,
    required this.username,
    required this.email,
    required this.prfileUrl,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //Uint8List imageBytes = base64Decode()
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: authScreenPaddingH,
          vertical: authScreenPaddingV,
        ),
        child: Column(
          children: [
            Text("Welcome to Homepage"),
            Text(widget.userId, style: textBody),
            Text(widget.username, style: textBody),
            Text(widget.email, style: textBody),
            CircleAvatar(
              radius: 64,
              backgroundImage: MemoryImage(widget.prfileUrl),
            ),
          ],
        ),
      ),
    );
  }
}
