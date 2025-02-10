class PostModel {
  final String postId;
  final DateTime timestamp;
  final String userName;
  final int likeCount;
  final List<String> comments;
  final String caption;
  final String imageUrl;

  PostModel({
    required this.postId,
    required this.timestamp,
    required this.userName,
    required this.likeCount,
    required this.comments,
    required this.caption,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'timestamp': timestamp.toIso8601String(),
      'userName': userName,
      'likeCount': likeCount,
      'comments': comments,
      'caption': caption,
      'imageUrl': imageUrl,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'],
      timestamp: DateTime.parse(map['timestamp']),
      userName: map['userName'],
      likeCount: map['likeCount'],
      comments: List<String>.from(map['comments']),
      caption: map['caption'],
      imageUrl: map['imageUrl'],
    );
  }
}
