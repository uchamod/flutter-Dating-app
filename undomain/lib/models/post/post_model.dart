class PostModel {
  final String postId;
  final String title;
  final String discription;
  final List tags;
  final String userId;
  final List<String> images;
  final List<String>? favourite;
  final List<String>? dislike;
  final DateTime publishedDate;
  final String? weblink;

  PostModel({
    required this.postId,
    required this.title,
    required this.discription,
    required this.tags,
    required this.userId,
    required this.images,
    required this.favourite,
    required this.dislike,
    required this.publishedDate,
    required this.weblink,
  });

  //convert to json object
  Map<String, dynamic> toJson() {
    return {
      "postId": postId,
      "title": title,
      "tags": tags,
      "discription": discription,
      "userId": userId,
      "Images": images,
      "dislike": dislike,
      "favourite": favourite,
      "publishedDate": publishedDate,
      "weblink": weblink,
    };
  }

  //convert from json object
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json["postId"],
      title: json["title"],
      tags: json["tags"],
      discription: json["discription"],
      userId: json["userId"],
      images: json["Images"],
      favourite: json["favourite"],
      dislike: json["dislike"],
      publishedDate: json["publishedDate"],
      weblink: json["weblink"],
    );
  }
}
