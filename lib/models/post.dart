class Like {
  final int likes;
  final List<String> usernames;

  Like({required this.likes, required this.usernames});

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
        likes: json['likes'],
        usernames:
            (json['usernames'] as List).map((e) => e as String).toList());
  }
}

class Comment {
  final String userName;
  final String imageUrl;
  final String comment;

  Comment(
      {required this.userName, required this.imageUrl, required this.comment});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        userName: json['userName'],
        comment: json['comment'],
        imageUrl: json['imageUrl']);
  }
  Map<String, dynamic> toJson() {
    return {
      'imageUrl': this.imageUrl,
      'comment': this.comment,
      'userName': this.userName
    };
  }
}

class Post {
  final String postId;
  final String userId;
  final String title;
  final String detail;
  final String imageUrl;
  final String imageId;
  final Like like;
  final List<Comment> comments;

  Post(
      {required this.postId,
      required this.userId,
      required this.title,
      required this.detail,
      required this.imageUrl,
      required this.like,
      required this.comments,
      required this.imageId});
}
