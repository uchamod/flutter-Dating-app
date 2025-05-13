import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:undomain/provider/reel_provider.dart';
import 'package:undomain/util/colors/colors.dart';
import 'package:undomain/widgets/videostack/video_stack.dart';

class ReelScreen extends ConsumerStatefulWidget {
  final String userId;
  const ReelScreen({required this.userId, super.key});

  @override
  ConsumerState<ReelScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends ConsumerState<ReelScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  //fetch reels when load the screen
  @override
  void initState() {
    Future.microtask(() => ref.read(reelFeedProvider.notifier).fetchVideos());
    print("fetch videos");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final reelFeedState = ref.watch(reelFeedProvider);

    // Show loading indicator when initially loading
    if (reelFeedState.reels.isEmpty && reelFeedState.isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: utilPrimaryRed)),
      );
    }
    // Show error message if there's an error
    if (reelFeedState.hasError && reelFeedState.reels.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${reelFeedState.errormassage}'),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(reelFeedProvider.notifier)
                      .fetchVideos(refresh: true);
                },
                child: Center(child: const Text('Retry')),
              ),
            ],
          ),
        ),
      );
    }
    return PageView.builder(
      scrollDirection: Axis.vertical,
      controller: _pageController,
      itemCount: reelFeedState.reels.length + (reelFeedState.hasMore ? 1 : 0),
      physics: const BouncingScrollPhysics(),
      onPageChanged: (int index) {
        // Update current video index
        ref.read(currentReelIndexProvider.notifier).state = index;
        // Load more videos when approaching the end
        if (reelFeedState.hasMore &&
            index >= reelFeedState.reels.length - 3 &&
            !reelFeedState.isLoading) {
          ref.read(reelFeedProvider.notifier).fetchVideos();
        }
      },
      itemBuilder: (context, index) {
        // Show loading indicator at the end when loading more videos
        if (index >= reelFeedState.reels.length) {
          return Center(
            child: CircularProgressIndicator(color: utilPrimaryWhite),
          );
        }
        return VideoStack(reel: reelFeedState.reels[index], index: index,userId: widget.userId,);
      },
    );
  }
}
