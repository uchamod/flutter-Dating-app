import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:undomain/models/reel/reel_model.dart';
import 'package:undomain/provider/reel_provider.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/util/textstyles/text_styles.dart';
import 'package:undomain/widgets/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoStack extends ConsumerStatefulWidget {
  final ReelModel reel;
  final int index;
  final String userId;
  const VideoStack({
    super.key,
    required this.reel,
    required this.index,
    required this.userId,
  });

  @override
  ConsumerState<VideoStack> createState() => _VideoStackState();
}

class _VideoStackState extends ConsumerState<VideoStack>
    with WidgetsBindingObserver, RouteAware {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isInitialized = false;
  late bool _isLiked;
  late bool _isdisLiked;
  RouteObserver<ModalRoute<void>>? _routeObserver;
  bool _isRouteActive = true;
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
      if (currentIndex == widget.index && _isRouteActive && mounted) {
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
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeVideoPlayer();
    _isLiked = widget.reel.likes.contains(widget.reel.userId);
    _isdisLiked = widget.reel.disLikes.contains(widget.reel.userId);
    //subcribe to route changes
    _routeObserver = RouteObserver<ModalRoute<void>>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final modelRoute = ModalRoute.of(context);
      if (modelRoute != null) {
        _routeObserver?.subscribe(this, modelRoute);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-subscribe to route observer if the route changes
    final modelRoute = ModalRoute.of(context);
    if (modelRoute != null) {
      _routeObserver?.subscribe(this, modelRoute);
    }
  }

  @override
  void didPush() {
    // Route was pushed, mark as active
    _isRouteActive = true;
    if (_isInitialized &&
        !_isPlaying &&
        ref.read(currentReelIndexProvider) == widget.index) {
      _controller.play();
      setState(() {
        _isPlaying = true;
      });
    }
    super.didPush();
  }

  @override
  void didPopNext() {
    // Route was popped and this route is now visible again
    _isRouteActive = true;
    if (_isInitialized &&
        !_isPlaying &&
        ref.read(currentReelIndexProvider) == widget.index) {
      _controller.play();
      setState(() {
        _isPlaying = true;
      });
    }
    super.didPopNext();
  }

  @override
  void didPop() {
    // Route was popped, mark as inactive
    _isRouteActive = false;
    if (_isInitialized && _isPlaying) {
      _controller.pause();
      setState(() {
        _isPlaying = false;
      });
    }
    super.didPop();
  }

  @override
  void didPushNext() {
    // Another route was pushed on top, mark as inactive
    _isRouteActive = false;
    if (_isInitialized && _isPlaying) {
      _controller.pause();
      setState(() {
        _isPlaying = false;
      });
    }
    super.didPushNext();
  }

  //pause and play video when touch the screen
  void _ontouchScreen() {
    if (!_isInitialized || !_isRouteActive) return;
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
    if (oldWidget.reel.disLikes != widget.reel.disLikes) {
      setState(() {
        _isdisLiked = widget.reel.disLikes.contains(widget.userId);
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
    } else if (state == AppLifecycleState.resumed && _isRouteActive) {
      if (_isInitialized &&
          !_isPlaying &&
          ref.read(currentReelIndexProvider) == widget.index) {
        _controller.play();
        setState(() {
          _isPlaying = true;
        });
      }
    }
  }

  //haddle like function
  Future<void> _haddleLikeToggle() async {
    if (!_isRouteActive) return;
    setState(() {
      _isLiked = !_isLiked;
    });
    ref
        .read(reelFeedProvider.notifier)
        .toggleLike(reelId: widget.reel.reelId, userId: widget.userId);
  }

  //haddle dislike function
  Future<void> _haddledisLikeToggle() async {
    if (!_isRouteActive) return;
    setState(() {
      _isdisLiked = !_isdisLiked;
    });
    ref
        .read(reelFeedProvider.notifier)
        .toggledisLike(reelId: widget.reel.reelId, userId: widget.userId);
  }

  //open bottom sheet widget
  Future<void> _openBoottomSheet() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheetWidget(reel: widget.reel, userid: widget.userId);
      },
    );
  }

  //dispose video player
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _routeObserver?.unsubscribe(this);

    if (_isInitialized) {
      if (_controller.value.isPlaying) {
        _controller.pause();
      }
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentReelIndexProvider);
    // Check if this video should be playing
    if (_isInitialized && _isRouteActive) {
      if (currentIndex == widget.index && !_isPlaying) {
        _controller.play();
        setState(() {
          _isPlaying = true;
        });
      } else if (currentIndex != widget.index && _isPlaying) {
        _controller.pause();
        setState(() {
          _isPlaying = false;
        });
      } else if (_isPlaying) {
        _controller.pause();
        setState(() {
          _isPlaying = false;
        });
      }
    }

    return VisibilityDetector(
      key: Key('video-${widget.reel.reelId}'),
      onVisibilityChanged: (visibilityInfo) {
        if (!_isInitialized || !mounted || !_isRouteActive) return;
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
                GestureDetector(
                  onTap: _haddledisLikeToggle,
                  child: Icon(
                    Icons.thumb_down,
                    color: _isdisLiked ? utilPrimaryRed : utilPrimaryWhite,
                    size: 28,
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    await _openBoottomSheet();
                  },
                  child: Icon(
                    Icons.comment_outlined,
                    color: utilPrimaryWhite,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
          //title and tags
          Positioned(
            left: 15,
            top: MediaQuery.of(context).size.height * 0.85,
            child: Column(
              children: [
                Text(
                  widget.reel.title,
                  style: textHint.copyWith(color: utilPrimaryWhite),
                ),
                if (widget.reel.tags.isNotEmpty)
                  for (String tag in widget.reel.tags)
                    Flexible(child: Text(tag, style: textLabel)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
