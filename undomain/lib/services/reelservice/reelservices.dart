import 'dart:convert';
import 'dart:io';

import "package:http/http.dart" as http;

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
}
