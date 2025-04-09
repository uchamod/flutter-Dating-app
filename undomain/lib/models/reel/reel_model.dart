class ReelModel {
  final String reelId;
  final String title;
  final List tags;
  final String discription;

  final String userId;
  final List<String>? favourite;
  final List<String>? dislike;
  final DateTime publishedDate;
  final String? weblink;

  ReelModel({
    required this.reelId,
    required this.title,
    required this.tags,
    required this.discription,
    required this.userId,
    required this.favourite,
    required this.dislike,
    required this.publishedDate,
    required this.weblink,
  });

  Map<String, dynamic> toJson() {
    return {
      "reelId": reelId,
      "title": title,
      "tags": tags,
      "discription": discription,

      "userId": userId,
      "favourite": favourite,
      "dislike": dislike,
      "publishedDate": publishedDate,
      "weblink": weblink,
    };
  }

  //convert from json object
  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      reelId: json["reelId"],
      title: json["title"],
      tags: json["tags"],
      discription: json["discription"],

      userId: json["userId"],
      favourite: json["favourite"],
      dislike: json["dislike"],
      publishedDate: json["publishedDate"],
      weblink: json["weblink"],
    );
  }
}
