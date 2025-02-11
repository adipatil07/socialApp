import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final DateTime timestamp;
  final String userName;
  final int likeCount;
  final List<dynamic> comments;
  final String caption;
  final String image;

  PostModel({
    required this.postId,
    required this.timestamp,
    required this.userName,
    required this.likeCount,
    required this.comments,
    required this.caption,
    required this.image,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      userName: map['userName'],
      likeCount: map['likeCount'],
      comments: List<dynamic>.from(map['comments']),
      caption: map['caption'],
      image: map['image'],
    );
  }

  factory PostModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel.fromMap(data);
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'timestamp': timestamp,
      'userName': userName,
      'likeCount': likeCount,
      'comments': comments,
      'caption': caption,
      'image': image,
    };
  }
}
