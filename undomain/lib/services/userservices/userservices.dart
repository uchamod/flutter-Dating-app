import "dart:convert";

import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";
import "package:undomain/models/user/user_model.dart";

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
      UserModel currentUser = UserModel.fromJson(user["user"]);
      return {"success": true, "user": currentUser};
    } catch (err) {
      print("client side error $err");
      return {"success": false, "massage": "Unexpected error"};
    }
  }

  //get all user details(avalible working)
  Future<Map<String, dynamic>> getAllUser() async {
    try {
      final token = await getToken();
      if (token == null) {
        return {"success": false, "massage": "Authenticated token not found"};
      }
      final response = await http.get(
        Uri.parse("$baseUrl/getalluser"),

        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );

      Map<String, dynamic> allUsersMap = jsonDecode(response.body);

      if (response.statusCode == 500) {
        return allUsersMap;
      }
      List<dynamic> users = allUsersMap["users"];
      List<UserModel> allUsers =
          users.map((item) => UserModel.fromJson(item)).toList();
      return {"success": true, "users": allUsers};
    } catch (err) {
      print("client side error $err");
      return {"success": false, "massage": "Unexpected error"};
    }
  }

  //get user by usernname
  Future<Map<String, dynamic>> getUserByUserName(String username) async {
    try {
      final token = await getToken();
      if (token == null) {
        return {"success": false, "massage": "Authenticated token not found"};
      }
      final response = await http.get(
        Uri.parse("$baseUrl/getuserbyusername/$username"),

        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final users = jsonDecode(response.body);
      if (response.statusCode == 404 || response.statusCode == 500) {
        return users;
      }

      List<UserModel> fetchedUsers =
          users.map((user) => UserModel.fromJson(user)).toList();
      // if (users["users"].length > 1) {
      //   return users["users"];
      // }
      return {"success": false, users: fetchedUsers};
    } catch (err) {
      print("client side error $err");
      return {"success": false, "massage": "Unexpected error"};
    }
  }
}
