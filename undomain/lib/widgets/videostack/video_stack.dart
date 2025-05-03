import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:undomain/models/reel/reel_model.dart';
import 'package:undomain/provider/reel_provider.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoStack extends ConsumerStatefulWidget {
  final ReelModel reel;
  final int index;
  const VideoStack({super.key, required this.reel, required this.index});

  @override
  ConsumerState<VideoStack> createState() => _VideoStackState();
}

class _VideoStackState extends ConsumerState<VideoStack> with WidgetsBindingObserver{
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isInitialized = false;
  late bool _isLiked;
  Future<void> _initializeVideoPlayer() async {
    try {
      // Initialize the controller first with the URL
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.reel.url),
      );
      // Then initialize the video
      await _controller.initialize();
      // Set looping after initialization
      _controller.setLooping(true);

      // Update state to reflect initialization
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }

      // Check if this video should be playing based on current index
      final currentIndex = ref.read(currentReelIndexProvider);
      if (currentIndex == widget.index) {
        _controller.play();
        setState(() {
          _isPlaying = true;
        });
      } else if (_isPlaying) {
        _controller.pause();
        setState(() {
          _isPlaying = false;
        });
      }
    } catch (err) {
      print('Error initializing video player: $err');
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _initializeVideoPlayer();
    _isLiked = widget.reel.likes.contains(widget.reel.userId);
    super.initState();
  }

  void _ontouchScreen() {
    if (!_isInitialized) return;
    setState(() {
      _isPlaying = !_isPlaying;
      _isPlaying ? _controller.play() : _controller.pause();
    });
  }

  @override
  void didUpdateWidget(VideoStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update _isLiked when the reel data changes
    if (oldWidget.reel.likes != widget.reel.likes) {
      setState(() {
        _isLiked = widget.reel.likes.contains(widget.reel.userId);
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app going to background/foreground
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // App is in background or inactive, pause the video
      if (_isInitialized && _isPlaying) {
        _controller.pause();
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  Future<void> _haddleLikeToggle() async {
    setState(() {
      _isLiked = !_isLiked;
    });
    ref
        .read(reelFeedProvider.notifier)
        .toggleLike(reelId: widget.reel.reelId, userId: widget.reel.userId);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_controller.value.isInitialized) {
      _controller.pause();
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentReelIndexProvider);
    // Check if this video should be playing

    if (currentIndex == widget.index && !_isPlaying) {
      _controller.play();
      _isPlaying = true;
    } else if (currentIndex != widget.index && _isPlaying) {
      _controller.pause();
      _isPlaying = false;
    }

    return VisibilityDetector(
      key: Key('video-${widget.reel.reelId}'),
      onVisibilityChanged: (visibilityInfo) {
        if (!_isInitialized || !mounted) return;
        //detect video visibility
        if (visibilityInfo.visibleFraction < 0.5 && _isPlaying) {
          _controller.pause();
          setState(() {
            _isPlaying = false;
          });

          ///show when 80% video visible
        } else if (visibilityInfo.visibleFraction > 0.8 &&
            !_isPlaying &&
            currentIndex == widget.index) {
          _controller.play();
          setState(() {
            _isPlaying = true;
          });
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          //show video player
          GestureDetector(
            onTap: _ontouchScreen,
            child:
                _isInitialized
                    ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                    : Center(
                      child: CircularProgressIndicator(color: utilPrimaryRed),
                    ),
          ),

          Positioned(
            right: 15,
            bottom: 100,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _haddleLikeToggle,
                  child: Icon(
                    Icons.thumb_up,
                    color: _isLiked ? utilPrimaryRed : utilPrimaryWhite,
                    size: 28,
                  ),
                ),
                SizedBox(height: 20),
                Icon(Icons.thumb_down, color: utilPrimaryWhite, size: 28),
                SizedBox(height: 20),
                Icon(Icons.comment_outlined, color: utilPrimaryWhite, size: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
