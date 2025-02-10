class CommentModel {
  final String commentId;
  final String commentText;
  final String commentorUserName;

  CommentModel({
    required this.commentId,
    required this.commentText,
    required this.commentorUserName,
  });

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'commentText': commentText,
      'commentorUserName': commentorUserName,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentId: map['commentId'],
      commentText: map['commentText'],
      commentorUserName: map['commentorUserName'],
    );
  }
}
