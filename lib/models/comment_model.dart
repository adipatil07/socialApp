class CommentModel {
  final String commentId;
  final String commentText;
  final String commentorUserName;
  final DateTime timestamp; // Add timestamp field

  CommentModel({
    required this.commentId,
    required this.commentText,
    required this.commentorUserName,
    required this.timestamp, // Initialize timestamp
  });

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'commentText': commentText,
      'commentorUserName': commentorUserName,
      'timestamp': timestamp.toIso8601String(), // Convert timestamp to string
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentId: map['commentId'],
      commentText: map['commentText'],
      commentorUserName: map['commentorUserName'],
      timestamp:
          DateTime.parse(map['timestamp']), // Parse timestamp from string
    );
  }
}
