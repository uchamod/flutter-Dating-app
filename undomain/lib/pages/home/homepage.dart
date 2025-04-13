import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:undomain/util/global/global_varibles.dart';
import 'package:undomain/util/textstyles/text_styles.dart';

class Homepage extends StatefulWidget {
  final String? userId;
  final String? username;
  final String? email;
  final Uint8List? prfileUrl;
  const Homepage({
    super.key,

    this.userId,
    this.username,
    this.email,
    this.prfileUrl,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late String id;
  late String name;
  late String email;

  @override
  void initState() {
    id = widget.userId ?? "";
    name = widget.username ?? "";
    email = widget.email ?? "";

    super.initState();
  }

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
            Text(id, style: textBody),
            Text(name, style: textBody),
            Text(email, style: textBody),
            CircleAvatar(
              radius: 64,
              backgroundImage:
                  widget.prfileUrl != null
                      ? MemoryImage(widget.prfileUrl!)
                      : AssetImage("assets/pic.jpg"),
            ),
          ],
        ),
      ),
    );
  }
}
