import 'package:flutter/material.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:video_player/video_player.dart';

class VideoStack extends StatefulWidget {
  final String url;
  const VideoStack({super.key, required this.url});

  @override
  State<VideoStack> createState() => _VideoStackState();
}

class _VideoStackState extends State<VideoStack> {
  late VideoPlayerController _controller;
  bool isPlaying = true;

  Future<void> _initializeVideoPlayer() async {
    _controller = VideoPlayerController.asset(widget.url);
    await _controller.initialize();
    _controller.play();
    _controller.setLooping(true);
    setState(() {});
  }

  @override
  void initState() {
    _initializeVideoPlayer();
    super.initState();
  }

  void _ontouchScreen() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying ? _controller.play() : _controller.pause();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio:4/3,

      child: GestureDetector(
        onTap: _ontouchScreen,
        child: Stack(
          children: [
            _controller.value.isInitialized
                ? VideoPlayer(_controller)
                : Center(
                  child: CircularProgressIndicator(color: utilPrimaryRed),
                ),
            Positioned(
              right: 15,
              bottom: 100,
              child: Column(
                children: [
                  Icon(Icons.thumb_up, color: utilPrimaryWhite, size: 28),
                  SizedBox(height: 20),
                  Icon(Icons.thumb_down, color: utilPrimaryWhite, size: 28),
                  SizedBox(height: 20),
                  Icon(
                    Icons.comment_outlined,
                    color: utilPrimaryWhite,
                    size: 28,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
