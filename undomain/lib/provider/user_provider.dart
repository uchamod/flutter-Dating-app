import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:undomain/services/userservices/userservices.dart';

// providers/user_provider.dart
final userServiceProvider = Provider<Userservices>((ref) {
  return Userservices();
});
//provider for fetched currently loged in users
final currentUserProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return await Userservices().getCurrentUser();
});

//provider for fetched  all other  users
final allUserProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return await Userservices().getAllUser();
});
// Follow/unfollow action provider
final followActionProvider =
    StateNotifierProvider<FollowNotifier, AsyncValue<void>>((ref) {
      final userService = ref.watch(userServiceProvider);
      return FollowNotifier(userService, ref);
    });

class FollowNotifier extends StateNotifier<AsyncValue<void>> {
  final Userservices _userService;
  final Ref _ref;

  FollowNotifier(this._userService, this._ref)
    : super(const AsyncValue.data(null));

  Future<void> toggleFollow(String userId, bool isFollowing) async {
    state = const AsyncValue.loading();

    try {
      final result = await _userService.followUnfollowUser(guestid: userId);

      if (result['success']) {
        // Invalidate the current user provider to refresh the data
        _ref.invalidate(currentUserProvider);
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(result['massage'], StackTrace.current);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
