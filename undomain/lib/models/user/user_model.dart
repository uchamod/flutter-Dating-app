class UserModel {
  final String id;
  final String username;
  final String password;
  final String email;
  final String profileUrl;
  final bool isCreator;
  final DateTime joinedDate;
  final DateTime updatedDate;
  final String serviceDiscription;
  final String? bio;
  final List<dynamic>? followers;
  final List<dynamic>? following;
  final int? contact;
  final String? referenceUrl;
  final bool? isVerified;
  final String? verifyCode;
  final int? codeExpireTime;
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
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.isCreator,
    required this.isVerified,
    required this.verifyCode,
    required this.codeExpireTime,
  });

  //   convert to json object
  Map<String, dynamic> toJson() {
    return {
      "id": id,
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
      "isVerified": isVerified,
      "verifyCode": verifyCode,
      "codeExpireTime": codeExpireTime,
    };
  }

  //convert from json object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"],
      username: json["username"],
      serviceDiscription: json["serviceDiscription"] ?? "",
      email: json["email"],
      password: json["password"],
      joinedDate:  DateTime.parse(json["createdAt"]),
      updatedDate:  DateTime.parse(json["updatedAt"]),
      profileUrl: json["profileUrl"] ?? "",
      followers: json["followers"] ?? [],
      following: json["followings"] ?? [],

      bio: json["bio"] ?? "",
      contact: json["contact"] ?? 0,
      isCreator: json["isCreator"],
      referenceUrl: json["referenceUrl"] ?? "",
      isVerified: json["isVerified"],
      verifyCode: json["verifyCode"] ?? "",
      codeExpireTime: json["codeExpireTime"] ?? 0,
    );
  }
}
