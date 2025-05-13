// // First, let's set up the necessary dependencies in pubspec.yaml

// // Add these to your pubspec.yaml:
// /*
// dependencies:
//   flutter:
//     sdk: flutter
//   video_player: ^2.7.2
//   flutter_riverpod: ^2.4.9
//   http: ^1.1.0
//   dio: ^5.3.3
//   cached_network_image: ^3.3.0
//   visibility_detector: ^0.4.0+2
//   flutter_cache_manager: ^3.3.1
//   path_provider: ^2.1.1
//   connectivity_plus: ^5.0.1
// */

// // --- Models ---

// // lib/models/video_model.dart
// import 'package:flutter/foundation.dart';

// class VideoModel {
//   final String id;
//   final String userId;
//   final String videoUrl;
//   final String thumbnailUrl;
//   final String description;
//   final int likesCount;
//   final int commentsCount;
//   final int sharesCount;
//   final bool isLiked;
//   final DateTime createdAt;
//   final String videoKey; // S3 object key

//   VideoModel({
//     required this.id,
//     required this.userId,
//     required this.videoUrl,
//     required this.thumbnailUrl,
//     required this.description,
//     required this.likesCount,
//     required this.commentsCount,
//     required this.sharesCount,
//     this.isLiked = false,
//     required this.createdAt,
//     required this.videoKey,
//   });

//   factory VideoModel.fromJson(Map<String, dynamic> json) {
//     return VideoModel(
//       id: json['_id'] ?? '',
//       userId: json['userId'] ?? '',
//       videoUrl: json['videoUrl'] ?? '',
//       thumbnailUrl: json['thumbnailUrl'] ?? '',
//       description: json['description'] ?? '',
//       likesCount: json['likesCount'] ?? 0,
//       commentsCount: json['commentsCount'] ?? 0,
//       sharesCount: json['sharesCount'] ?? 0,
//       isLiked: json['isLiked'] ?? false,
//       videoKey: json['videoKey'] ?? '',
//       createdAt: json['createdAt'] != null 
//           ? DateTime.parse(json['createdAt']) 
//           : DateTime.now(),
//     );
//   }
// }

// // --- API Service ---

// // lib/services/video_service.dart
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../models/video_model.dart';

// class VideoService {
//   // Replace with your EC2 instance URL
//   final String baseUrl = 'https://your-ec2-instance.amazonaws.com/api';
//   final Dio _dio = Dio();

//   // Fetch videos for feed
//   Future<List<VideoModel>> fetchVideos({int page = 1, int limit = 10}) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/videos?page=$page&limit=$limit'),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body)['data'];
//         return data.map((json) => VideoModel.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load videos');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }

//   // Upload video to S3 via EC2 backend
//   Future<bool> uploadVideo({
//     required File videoFile,
//     required String description,
//     required String userId,
//   }) async {
//     try {
//       // First get a pre-signed URL for direct S3 upload
//       final getUploadUrlResponse = await http.post(
//         Uri.parse('$baseUrl/videos/get-upload-url'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'userId': userId,
//           'fileType': 'video/mp4',
//           'fileName': 'video_${DateTime.now().millisecondsSinceEpoch}.mp4',
//         }),
//       );
      
//       if (getUploadUrlResponse.statusCode != 200) {
//         throw Exception('Failed to get upload URL');
//       }
      
//       final uploadData = json.decode(getUploadUrlResponse.body);
//       final String uploadUrl = uploadData['uploadUrl'];
//       final String videoKey = uploadData['key'];
      
//       // Upload the video directly to S3 using the pre-signed URL
//       final s3UploadResponse = await http.put(
//         Uri.parse(uploadUrl),
//         body: await videoFile.readAsBytes(),
//         headers: {
//           'Content-Type': 'video/mp4',
//         },
//       );
      
//       if (s3UploadResponse.statusCode != 200) {
//         throw Exception('Failed to upload to S3');
//       }
      
//       // Now save the video metadata to your backend
//       final metadataResponse = await http.post(
//         Uri.parse('$baseUrl/videos/metadata'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'userId': userId,
//           'videoKey': videoKey,
//           'description': description,
//         }),
//       );
      
//       if (metadataResponse.statusCode == 200 || metadataResponse.statusCode == 201) {
//         return true;
//       } else {
//         throw Exception('Failed to save video metadata');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }

//   // Like/unlike video
//   Future<bool> toggleLike(String videoId) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/videos/$videoId/like'),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         return true;
//       } else {
//         throw Exception('Failed to toggle like');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
// }

// // --- Riverpod Providers ---

// // lib/providers/video_providers.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/video_model.dart';
// import '../services/video_service.dart';

// // Service provider
// final videoServiceProvider = Provider<VideoService>((ref) {
//   return VideoService();
// });

// // State class for video feed
// class VideoFeedState {
//   final List<VideoModel> videos;
//   final bool isLoading;
//   final bool hasError;
//   final String? errorMessage;
//   final bool hasMore;
//   final int currentPage;

//   VideoFeedState({
//     required this.videos,
//     this.isLoading = false,
//     this.hasError = false,
//     this.errorMessage,
//     this.hasMore = true,
//     this.currentPage = 1,
//   });

//   VideoFeedState copyWith({
//     List<VideoModel>? videos,
//     bool? isLoading,
//     bool? hasError,
//     String? errorMessage,
//     bool? hasMore,
//     int? currentPage,
//   }) {
//     return VideoFeedState(
//       videos: videos ?? this.videos,
//       isLoading: isLoading ?? this.isLoading,
//       hasError: hasError ?? this.hasError,
//       errorMessage: errorMessage,
//       hasMore: hasMore ?? this.hasMore,
//       currentPage: currentPage ?? this.currentPage,
//     );
//   }
// }

// // Video feed notifier
// class VideoFeedNotifier extends StateNotifier<VideoFeedState> {
//   final VideoService _videoService;
//   static const int _limit = 10;
  
//   VideoFeedNotifier(this._videoService) 
//       : super(VideoFeedState(videos: [], isLoading: true));

//   Future<void> fetchVideos({bool refresh = false}) async {
//     if (refresh) {
//       state = VideoFeedState(videos: [], isLoading: true, currentPage: 1);
//     } else if (state.isLoading || !state.hasMore) {
//       return;
//     } else {
//       state = state.copyWith(isLoading: true, hasError: false);
//     }

//     try {
//       final newVideos = await _videoService.fetchVideos(
//         page: state.currentPage,
//         limit: _limit,
//       );

//       if (newVideos.isEmpty) {
//         state = state.copyWith(
//           hasMore: false,
//           isLoading: false,
//         );
//         return;
//       }

//       final updatedVideos = [...state.videos, ...newVideos];
      
//       state = state.copyWith(
//         videos: updatedVideos,
//         isLoading: false,
//         currentPage: state.currentPage + 1,
//         hasMore: newVideos.length >= _limit,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         hasError: true,
//         errorMessage: e.toString(),
//       );
//     }
//   }

//   Future<void> toggleLike(String videoId) async {
//     try {
//       await _videoService.toggleLike(videoId);
      
//       state = state.copyWith(
//         videos: state.videos.map((video) {
//           if (video.id == videoId) {
//             return VideoModel(
//               id: video.id,
//               userId: video.userId,
//               videoUrl: video.videoUrl,
//               thumbnailUrl: video.thumbnailUrl,
//               description: video.description,
//               likesCount: video.isLiked ? video.likesCount - 1 : video.likesCount + 1,
//               commentsCount: video.commentsCount,
//               sharesCount: video.sharesCount,
//               isLiked: !video.isLiked,
//               createdAt: video.createdAt,
//             );
//           }
//           return video;
//         }).toList(),
//       );
//     } catch (e) {
//       // Handle error
//     }
//   }
// }

// // Provider for video feed
// final videoFeedProvider = StateNotifierProvider<VideoFeedNotifier, VideoFeedState>((ref) {
//   final videoService = ref.watch(videoServiceProvider);
//   return VideoFeedNotifier(videoService);
// });

// // Current video index provider
// final currentVideoIndexProvider = StateProvider<int>((ref) => 0);

// // --- Video Feed Screen ---

// // lib/screens/video_feed_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/video_providers.dart';
// import '../widgets/video_player_item.dart';

// class VideoFeedScreen extends ConsumerStatefulWidget {
//   const VideoFeedScreen({Key? key}) : super(key: key);

//   @override
//   ConsumerState<VideoFeedScreen> createState() => _VideoFeedScreenState();
// }

// class _VideoFeedScreenState extends ConsumerState<VideoFeedScreen> {
//   final PageController _pageController = PageController();

//   @override
//   void initState() {
//     super.initState();
//     // Fetch videos when screen loads
//     Future.microtask(() => ref.read(videoFeedProvider.notifier).fetchVideos());
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final videoFeedState = ref.watch(videoFeedProvider);
    
//     // Show loading indicator when initially loading
//     if (videoFeedState.videos.isEmpty && videoFeedState.isLoading) {
//       return const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     // Show error message if there's an error
//     if (videoFeedState.hasError && videoFeedState.videos.isEmpty) {
//       return Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Error: ${videoFeedState.errorMessage}'),
//               ElevatedButton(
//                 onPressed: () {
//                   ref.read(videoFeedProvider.notifier).fetchVideos(refresh: true);
//                 },
//                 child: const Text('Retry'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       body: PageView.builder(
//         scrollDirection: Axis.vertical,
//         controller: _pageController,
//         itemCount: videoFeedState.videos.length + (videoFeedState.hasMore ? 1 : 0),
//         onPageChanged: (int index) {
//           // Update current video index
//           ref.read(currentVideoIndexProvider.notifier).state = index;
          
//           // Load more videos when approaching the end
//           if (videoFeedState.hasMore && 
//               index >= videoFeedState.videos.length - 3 && 
//               !videoFeedState.isLoading) {
//             ref.read(videoFeedProvider.notifier).fetchVideos();
//           }
//         },
//         itemBuilder: (context, index) {
//           // Show loading indicator at the end when loading more videos
//           if (index >= videoFeedState.videos.length) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           // Return video player item
//           return VideoPlayerItem(
//             video: videoFeedState.videos[index],
//             index: index,
//           );
//         },
//       ),
//     );
//   }
// }

// // --- Video Player Item Widget ---

// // lib/widgets/video_player_item.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:video_player/video_player.dart';
// import 'package:visibility_detector/visibility_detector.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import '../models/video_model.dart';
// import '../providers/video_providers.dart';

// class VideoPlayerItem extends ConsumerStatefulWidget {
//   final VideoModel video;
//   final int index;

//   const VideoPlayerItem({
//     Key? key,
//     required this.video,
//     required this.index,
//   }) : super(key: key);

//   @override
//   ConsumerState<VideoPlayerItem> createState() => _VideoPlayerItemState();
// }

// class _VideoPlayerItemState extends ConsumerState<VideoPlayerItem> {
//   late VideoPlayerController _videoPlayerController;
//   bool _isPlaying = false;
//   bool _isInitialized = false;
//   bool _isDisposed = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeVideoPlayer();
//   }

//   void _initializeVideoPlayer() async {
//     _videoPlayerController = VideoPlayerController.network(widget.video.videoUrl);
    
//     await _videoPlayerController.initialize();
    
//     if (_isDisposed) return;
    
//     setState(() {
//       _isInitialized = true;
//     });
    
//     // Set video to loop
//     _videoPlayerController.setLooping(true);
    
//     // Auto-play if this is the current video
//     _checkIfShouldPlay();
//   }

//   void _checkIfShouldPlay() {
//     final currentIndex = ref.read(currentVideoIndexProvider);
//     if (currentIndex == widget.index && _isInitialized && !_isDisposed) {
//       _videoPlayerController.play();
//       setState(() {
//         _isPlaying = true;
//       });
//     } else if (_isPlaying && _isInitialized && !_isDisposed) {
//       _videoPlayerController.pause();
//       setState(() {
//         _isPlaying = false;
//       });
//     }
//   }

//   void _togglePlayPause() {
//     if (_isInitialized && !_isDisposed) {
//       if (_isPlaying) {
//         _videoPlayerController.pause();
//       } else {
//         _videoPlayerController.play();
//       }
//       setState(() {
//         _isPlaying = !_isPlaying;
//       });
//     }
//   }

//   @override
//   void didUpdateWidget(VideoPlayerItem oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     _checkIfShouldPlay();
//   }

//   @override
//   void dispose() {
//     _isDisposed = true;
//     _videoPlayerController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentIndex = ref.watch(currentVideoIndexProvider);
    
//     // Check if this video should be playing
//     if (currentIndex == widget.index && !_isPlaying && _isInitialized) {
//       _videoPlayerController.play();
//       _isPlaying = true;
//     } else if (currentIndex != widget.index && _isPlaying && _isInitialized) {
//       _videoPlayerController.pause();
//       _isPlaying = false;
//     }

//     return VisibilityDetector(
//       key: Key('video-${widget.video.id}'),
//       onVisibilityChanged: (visibilityInfo) {
//         if (visibilityInfo.visibleFraction < 0.5 && _isPlaying && _isInitialized && !_isDisposed) {
//           _videoPlayerController.pause();
//           setState(() {
//             _isPlaying = false;
//           });
//         } else if (visibilityInfo.visibleFraction > 0.8 && 
//                   !_isPlaying && 
//                   _isInitialized && 
//                   !_isDisposed && 
//                   currentIndex == widget.index) {
//           _videoPlayerController.play();
//           setState(() {
//             _isPlaying = true;
//           });
//         }
//       },
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Video Player
//           GestureDetector(
//             onTap: _togglePlayPause,
//             child: _isInitialized
//                 ? AspectRatio(
//                     aspectRatio: _videoPlayerController.value.aspectRatio,
//                     child: VideoPlayer(_videoPlayerController),
//                   )
//                 : Center(
//                     child: CircularProgressIndicator(),
//                   ),
//           ),
          
//           // Video Info Overlay (at the bottom)
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                   colors: [
//                     Colors.black.withOpacity(0.7),
//                     Colors.transparent,
//                   ],
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.video.description,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 8),
//                 ],
//               ),
//             ),
//           ),
          
//           // Action Buttons (right side)
//           Positioned(
//             right: 16,
//             bottom: 80,
//             child: Column(
//               children: [
//                 // Like Button
//                 IconButton(
//                   onPressed: () {
//                     ref.read(videoFeedProvider.notifier).toggleLike(widget.video.id);
//                   },
//                   icon: Icon(
//                     widget.video.isLiked ? Icons.favorite : Icons.favorite_border,
//                     color: widget.video.isLiked ? Colors.red : Colors.white,
//                     size: 30,
//                   ),
//                 ),
//                 Text(
//                   _formatCount(widget.video.likesCount),
//                   style: const TextStyle(color: Colors.white),
//                 ),
//                 const SizedBox(height: 16),
                
//                 // Comment Button
//                 IconButton(
//                   onPressed: () {
//                     // Show comments modal
//                     _showCommentsModal(context);
//                   },
//                   icon: const Icon(
//                     Icons.comment,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
//                 Text(
//                   _formatCount(widget.video.commentsCount),
//                   style: const TextStyle(color: Colors.white),
//                 ),
//                 const SizedBox(height: 16),
                
//                 // Share Button
//                 IconButton(
//                   onPressed: () {
//                     // Implement share functionality
//                   },
//                   icon: const Icon(
//                     Icons.share,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
//                 Text(
//                   _formatCount(widget.video.sharesCount),
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
          
//           // Play/Pause Indicator (shows briefly when tapped)
//           if (!_isInitialized)
//             const Center(
//               child: CircularProgressIndicator(
//                 color: Colors.white,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
  
//   void _showCommentsModal(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.black.withOpacity(0.9),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.6,
//           minChildSize: 0.3,
//           maxChildSize: 0.9,
//           expand: false,
//           builder: (context, scrollController) {
//             return Column(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   width: 40,
//                   height: 5,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(2.5),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Text(
//                     'Comments (${widget.video.commentsCount})',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     controller: scrollController,
//                     itemCount: 10, // Replace with actual comments
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         leading: const CircleAvatar(
//                           backgroundColor: Colors.grey,
//                           child: Icon(Icons.person),
//                         ),
//                         title: Text(
//                           'User ${index + 1}',
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                         subtitle: Text(
//                           'This is a sample comment ${index + 1}',
//                           style: TextStyle(color: Colors.grey[400]),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
  
//   String _formatCount(int count) {
//     if (count < 1000) return count.toString();
//     if (count < 1000000) return '${(count / 1000).toStringAsFixed(1)}K';
//     return '${(count / 1000000).toStringAsFixed(1)}M';
//   }
// }

// // --- Node.js Backend for AWS EC2 (For Reference) ---



// // lib/main.dart
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'screens/video_feed_screen.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   // Set preferred orientations to portrait only
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
  
//   // Set system UI overlay style
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//     ),
//   );
  
//   runApp(const ProviderScope(child: MyApp()));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Video Reels App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: Colors.black,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const VideoFeedScreen(),
//     );
//   }
// }