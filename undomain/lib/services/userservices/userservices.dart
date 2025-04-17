import "dart:convert";

import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

class Userservices {
  final baseUrl = "http://192.168.12.148:5000/api/user";
  //get jwt token
  Future<String?> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString("token");
  }

  //get userid
  Future<String?> getUserId() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString("user");
  }

  //get current device user details
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final token = await getToken();
      if (token == null) {
        print("token not valid");
        return {"success": false, "massage": "Authenticated token not found"};
      }
      final response = await http.get(
        Uri.parse("$baseUrl/getcurrentuser"),

        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      final user = jsonDecode(response.body);
      print(user);
      if (response.statusCode == 401) {
        print("user getting error $user");
        return user;
      }

      return user;
    } catch (err) {
      print("client side error $err");
      return {"success": false, "massage": "Unexpected error"};
    }
  }

  //get all user details(avalible working)
  Future<List<Map<String, dynamic>>?> getAllUser() async {
    try {
      final token = await getToken();
      if (token == null) {
        return [
          {"success": false, "massage": "Authenticated token not found"},
        ];
      }
      final response = await http.get(
        Uri.parse("$baseUrl/getalluser"),

        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );

      final allUsers = jsonDecode(response.body);
      if (response.statusCode == 500) {
        return [allUsers];
      }

      return allUsers["users"];
    } catch (err) {
      print("client side error $err");
      return [
        {"success": false, "massage": "Unexpected error"},
      ];
    }
  }

  //get user by usernname
  Future<List<Map<String, dynamic>>?> getUserByUserName(String username) async {
    try {
      final token = await getToken();
      if (token == null) {
        return [
          {"success": false, "massage": "Authenticated token not found"},
        ];
      }
      final response = await http.get(
        Uri.parse("$baseUrl/getuserbyusername/$username"),

        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final user = jsonDecode(response.body);
      if (response.statusCode == 404 || response.statusCode == 500) {
        return [user];
      }
      if (user["users"].length > 1) {
        return user["users"];
      }
      return user["users"].toList();
    } catch (err) {
      print("client side error $err");
      return [
        {"success": false, "massage": "Unexpected error"},
      ];
    }
  }
}
