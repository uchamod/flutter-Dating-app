import 'package:flutter/material.dart';
import 'package:undomain/router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData.light(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      title: "Date Net",
      routerConfig: Routes().goRouter,
    );
  }
}
