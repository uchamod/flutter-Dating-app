import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:undomain/services/userservices/userservices.dart';

//provider for fetched currently loged in users
final currentUserProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return await Userservices().getCurrentUser();
});

//provider for fetched  all other  users
final allUserProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return await Userservices().getAllUser();
});
// final clearUserProvider = FutureProvider<void>((ref) async {
//   return await currentUserProvider.
// });
