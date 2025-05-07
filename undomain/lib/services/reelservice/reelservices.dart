import 'dart:convert';
import 'dart:io';

import "package:http/http.dart" as http;
import 'package:undomain/models/reel/reel_model.dart';

class ReelsService {
  final baseUrl = "http://192.168.97.148:5000/api/resources";
  //get pre-singed url`
  //upload directly to s3
  //save metadata in mongo
  Future<Map<String, dynamic>> uploadVideo({
    required String userId,
    required File videoFile,
    required String title,
  }) async {
    try {
      //get pre-singed url
      final preSingedUrlResponse = await http.post(
        Uri.parse("$baseUrl/get-pre-signed-url"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'fileType': 'video/mp4',
          'filename': 'video_${DateTime.now().millisecondsSinceEpoch}.mp4',
        }),
      );
      Map<String, dynamic> response = json.decode(preSingedUrlResponse.body);
      if (preSingedUrlResponse.statusCode != 200) {
        return response;
      }
      final uploadUrl = response["data"]["uploadUrl"];
      final videoKey = response["data"]["videokey"];
      //upload directly to s3
      final s3UploadResponse = await http.put(
        Uri.parse(uploadUrl),
        body: await videoFile.readAsBytes(),
        headers: {'Content-Type': 'video/mp4'},
      );
      if (s3UploadResponse.statusCode != 200) {
        return {"success": false, "message": "could not get presinged url"};
      }
      //save metadata in mongo
      final saveMetaData = await http.post(
        Uri.parse("$baseUrl/save-metadata"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "userId": userId,
          "videoKey": videoKey,
          "title": title,
        }),
      );
      //get metadata response
      Map<String, dynamic> savaDataResponse = json.decode(saveMetaData.body);
      if (saveMetaData.statusCode != 200) {
        return savaDataResponse;
      }
      return response;
    } catch (err) {
      print("error $err");
      return {"success": false, "message": "client side error"};
    }
  }

  //fetch all videos
  Future<List<Map<String, dynamic>>> fetchAllVideos({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/fetch-videos?page=$page&limit=$limit"),
        headers: {'Content-Type': 'application/json'},
      );
      final decodeResponseBody = json.decode(response.body);
      if (response.statusCode != 200) {
        print(decodeResponseBody);
        return [decodeResponseBody];
      }

      List<dynamic> reelList = decodeResponseBody["data"]["videos"];

      List<ReelModel> reelModelList =
          reelList.map((video) => ReelModel.fromJson(video)).toList();

      return [
        {"success": true, "reels": reelModelList},
      ];
    } catch (err) {
      print("client side error $err");
      return [
        {"success": false, "message": "client side error"},
      ];
    }
  }

  //like reels
  Future<Map<String, dynamic>> likeReels({
    required String userId,
    required String reelId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/like-videos"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"userId": userId, "reelId": reelId}),
      );
      final decodeResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        return decodeResponse;
      }

      return decodeResponse;
    } catch (err) {
      print("client side error $err");
      return {"success": false, "message": "client side error"};
    }
  }

  //dislike
  Future<Map<String, dynamic>> dislikeReels({
    required String userId,
    required String reelId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/dislike-videos"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"userId": userId, "reelId": reelId}),
      );
      final decodeResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        return decodeResponse;
      }

      return decodeResponse;
    } catch (err) {
      print("client side error $err");
      return {"success": false, "message": "client side error"};
    }
  }
}
