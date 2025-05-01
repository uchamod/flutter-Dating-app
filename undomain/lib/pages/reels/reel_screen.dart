import 'package:flutter/material.dart';

class ReelScreen extends StatefulWidget {
  const ReelScreen({super.key});

  @override
  State<ReelScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelScreen> {
  final List<String> videoUrls = [
    "assets/hyimage.mp4",
    "assets/image.mp4",
    "assets/imakhhge.mp4",
  ];
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
    // PageView.builder(
    //   scrollDirection: Axis.vertical,
    //   // controller: _pageController,
    //   itemCount: videoUrls.length,
    //   physics: const BouncingScrollPhysics(),
    //   itemBuilder: (context, index) {
    //     return VideoStack(url: videoUrls[index]);
    //   },
    // );
  }
}
