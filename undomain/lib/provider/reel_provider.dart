import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:undomain/models/reel/reel_model.dart';
import 'package:undomain/services/reelservice/reelservices.dart';

// Service provider
final reelServiceProvider = Provider<ReelsService>((ref) {
  return ReelsService();
});

//state class for video feed
class ReelFeedState {
  final List<ReelModel> reels;
  final bool isLoading;
  final bool hasError;
  final String? errormassage;
  final bool hasMore;
  final int currentPage;

  ReelFeedState({
    required this.reels,
    this.isLoading = false,
    this.hasError = false,
    this.errormassage,
    this.hasMore = true,
    this.currentPage = 1,
  });

  ReelFeedState copyWith({
    List<ReelModel>? reels,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    bool? hasMore,
    int? currentPage,
  }) {
    return ReelFeedState(
      reels: reels ?? this.reels,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errormassage: errorMessage,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

//video feed notifier
class ReelFeedNotifier extends StateNotifier<ReelFeedState> {
  final ReelsService _reelsService;
  static const int _limit = 10;
  ReelFeedNotifier(this._reelsService)
    : super(ReelFeedState(reels: [], isLoading: true));
  //fetch videos
  Future<void> fetchVideos({bool refresh = false}) async {
    if (refresh) {
      state = ReelFeedState(reels: [], isLoading: true, currentPage: 1);
    } else if (!state.hasMore) {
      return;
    } else {
      state = state.copyWith(isLoading: true, hasError: false);
    }
    try {
      final newReels = await _reelsService.fetchAllVideos(
        page: state.currentPage,
        limit: _limit,
      );

      if (!newReels[0]["success"]) {
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: newReels[0]["message"],
        );
        return;
      }

      List<ReelModel> updatedReels = [...state.reels, ...newReels[0]["reels"]];
      state = state.copyWith(
        reels: updatedReels,
        isLoading: false,
        currentPage: state.currentPage + 1,
        hasMore: newReels.length >= _limit,
      );
    } catch (err) {
      print("provider side $err");
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: err.toString(),
      );
    }
  }

  //togggle like
  Future<void> toggleLike({
    required String reelId,
    required String userId,
  }) async {
    try {
      // Make API call to toggle like
      final result = await _reelsService.likeReels(
        reelId: reelId,
        userId: userId,
      );
      if (result["success"]) {
        // Find and update the new reel
        final index = state.reels.indexWhere((reel) => reel.reelId == reelId);
        state.reels.removeAt(index);
        state.reels.add(result["data"]["reel"]);
      } else {
        print(result["message"]);
        return;
      }
    } catch (err) {
      print('Error in toggleLike: $err');
    }
  }

  //togggle like
  Future<void> toggledisLike({
    required String reelId,
    required String userId,
  }) async {
    try {
      // Make API call to toggle like
      final result = await _reelsService.dislikeReels(
        reelId: reelId,
        userId: userId,
      );
      if (result["success"]) {
        // Find and update the new reel
        final index = state.reels.indexWhere((reel) => reel.reelId == reelId);
        state.reels.removeAt(index);
        state.reels.add(result["data"]["reel"]);
      } else {
        print(result["message"]);
        return;
      }
    } catch (err) {
      print('Error in toggleLike: $err');
    }
  }
}

// Provider for video feed
final reelFeedProvider = StateNotifierProvider<ReelFeedNotifier, ReelFeedState>(
  (ref) {
    final reelService = ref.watch(reelServiceProvider);
    return ReelFeedNotifier(reelService);
  },
);

//current video index provider
final currentReelIndexProvider = StateProvider<int>((ref) => 0);
