class ReelModel {
  final String reelId;
  final String title;
  final List tags;
  final String url;
  final List likes;
  final List disLikes;
  final List<Map<String, String>> comments;
  final bool processed;
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
    required this.processed,
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
      "dislikes": disLikes,
      "processed": processed,
      "weblink": weblink,
      "joinedDate": joinedDate,
      "updatedDate": updatedDate,
    };
  }

  //convert from json object
  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      reelId: json["reelId"],
      userId: json["userId"],
      title: json["title"],
      url: json["url"],
      joinedDate: DateTime.parse(json["joinedDate"]),
      updatedDate: DateTime.parse(json["updatedDate"]),
      weblink: json["weblink"] ?? "google",
      processed: json["processed"],
      likes: json["likes"] ?? [],
      disLikes: json["disLikes"] ?? [],
      comments: List<Map<String, String>>.from(json["comments"]) ?? [],
      tags: json["tags"] ?? [],
    );
  }
}
