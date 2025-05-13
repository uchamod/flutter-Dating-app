import "dart:convert";
import "dart:io";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";
import "package:undomain/provider/user_provider.dart";

class Authservices {
  final baseUrl = "http://192.168.97.148:5000/api/auth";
  //register new user
  Future<Map<String, dynamic>> register(
    File profileUrl, {
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/register");
      //get response
      final request = http.MultipartRequest('POST', uri);
      //attach text fields
      request.fields['username'] = username;
      request.fields['email'] = email;
      request.fields['password'] = password;
      //attach file
      request.files.add(
        await http.MultipartFile.fromPath("profileUrl", profileUrl.path),
      );
      //send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      //get body
      final user = jsonDecode(response.body);
      if (response.statusCode == 400 || response.statusCode == 500) {
        return user;
      }

      //store tooken in shared preferences
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      //set jwt token
      preferences.setString("token", user["newToken"]);
      //set user id
      preferences.setString("user", user["user"]["id"]);
      print(user["newToken"]);
      return user;
    } catch (err) {
      print("client side error $err");
      return {"succss": false, "massage": "Unexpected error"};
    }
  }

  //verify new user
  Future<Map<String, dynamic>> verifyNewUser({
    required String userId,
    required String verifyCode,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/verify"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"userId": userId, "verifyCode": verifyCode}),
      );
      final user = jsonDecode(response.body);
      if (response.statusCode == 400 ||
          response.statusCode == 408 ||
          response.statusCode == 500) {
        return user;
      }
      return user;
    } catch (err) {
      print("client side error $err");
      return {"success": false, "massage": "Unexpected error"};
    }
  }

  //login existing user
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"username": username, "password": password}),
      );

      final user = jsonDecode(response.body);
      if (response.statusCode == 400 || response.statusCode == 500) {
        return user;
      }
      //store tooken in shared preferences
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      //save jwt
      await preferences.setString("token", user["newToken"]);
      //save user id
      await preferences.setString("user", user["user"]["id"]);
      print(user["newToken"]);
      return user;
    } catch (err) {
      print("client side error $err");
      return {"success": false, "massage": "Unexpected error"};
    }
  }

  //send reset password request with email and new password
  Future<Map<String, dynamic>> sendPasswordResetRequest({
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/user-verification"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email}),
      );

      final user = jsonDecode(response.body);
      if (response.statusCode == 404 || response.statusCode == 500) {
        return user;
      }

      return user;
    } catch (err) {
      print("client side error $err");
      return {"success": false, "massage": "Unexpected error"};
    }
  }

  //verify resset password
  Future<Map<String, dynamic>> verifyResetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/reset-password"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "otp": otp, "password": password}),
      );

      final user = jsonDecode(response.body);
      if (response.statusCode == 404 ||
          response.statusCode == 500 ||
          response.statusCode == 400 ||
          response.statusCode == 408) {
        return user;
      }
      return user;
    } catch (err) {
      return {"success": false, "massage": "Unexpected error"};
    }
  }

  //log out
  Future<void> logout(WidgetRef ref) async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.remove("token");
    ref.invalidate(currentUserProvider);
    ref.invalidate(allUserProvider);
  }
}
