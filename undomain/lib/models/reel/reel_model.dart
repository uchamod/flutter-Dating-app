class ReelModel {
  final String reelId;
  final String title;
  final List tags;
  final String url;
  final List likes;
  final List disLikes;
  final List<Map<String, String>> comments;

  final String userId;

  final String? weblink;
  final DateTime joinedDate;
  final DateTime updatedDate;
  ReelModel({
    required this.reelId,
    required this.title,
    required this.tags,
    required this.url,
    required this.userId,
    required this.likes,
    required this.disLikes,
    required this.comments,

    required this.weblink,
    required this.joinedDate,
    required this.updatedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "reelId": reelId,
      "title": title,
      "tags": tags,
      "url": url,
      "comments": comments,
      "userId": userId,
      "like": likes,
      "dislike": disLikes,

      "weblink": weblink,
      "joinedDate": joinedDate,
      "updatedDate": updatedDate,
    };
  }

  //convert from json object
  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      reelId: json["reelId"],
      title: json["title"],
      tags: json["tags"] ?? [],
      url: json["url"],
      comments: List<Map<String, String>>.from(json["comments"]) ?? [],
      userId: json["userId"],
      likes: json["likes"] ?? [],
      disLikes: json["disLike"] ?? [],

      weblink: json["weblink"] ?? "",
      joinedDate: DateTime.parse(json["createdAt"]),
      updatedDate: DateTime.parse(json["updatedAt"]),
    );
  }
}
