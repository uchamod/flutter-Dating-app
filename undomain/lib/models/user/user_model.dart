class UserModel {
  final String uid;
  final String username;
  final String password;
  final String email;
  final String profileUrl;
  final bool isCreator;
  final DateTime joinedDate;
  final DateTime updatedDate;
  final String serviceDiscription;
  final String? bio;
  final List<String>? followers;
  final List<String>? following;
  final int? contact;
  final String? referenceUrl;
  UserModel({
    required this.contact,
    required this.referenceUrl,
    required this.joinedDate,
    required this.updatedDate,
    required this.bio,

    required this.followers,
    required this.following,
    required this.serviceDiscription,

    required this.profileUrl,
    required this.uid,
    required this.username,
    required this.password,
    required this.email,
    required this.isCreator,
  });

  //   convert to json object
  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "username": username,
      "email": email,
      "profileUrl": profileUrl,
      "password": password,
      "joinedDate": joinedDate,
      "updatedDate": updatedDate,
      "contact": contact,
      "bio": bio,
      "serviceDiscription": serviceDiscription,
      "isCreator": isCreator,
      "referenceUrl": referenceUrl,
      "followers": followers,
      "following": following,
    };
  }

  //convert from json object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json["uid"],
      username: json["username"],
      serviceDiscription: json["serviceDiscription"] ?? "",
      email: json["email"],
      password: json["password"],
      joinedDate: json["joinedDate"],
      updatedDate: json["updatedDate"],
      profileUrl: json["image"] ?? "",
      followers: json["followers"] ?? [],
      following: json["followings"] ?? [],

      bio: json["bio"] ?? "",
      contact: json["contact"] ?? "",
      isCreator: json["isCreator"],
      referenceUrl: json["referenceUrl"] ?? "",
    );
  }
}
