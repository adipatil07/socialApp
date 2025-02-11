import 'package:date_time_ago/date_time_ago.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String caption;
  final DateTime postTime;
  final VoidCallback onCommentTap;
  final VoidCallback onLikeTap;
  final bool isLiked;
  final int likeCount;
  final String username; // New property

  const PostCard({
    super.key,
    required this.caption,
    required this.postTime,
    required this.onCommentTap,
    required this.onLikeTap,
    required this.isLiked,
    required this.likeCount,
    required this.username, // New property
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Image.asset("assets/images/logo.webp"),
            SizedBox(height: 8.0),
            Text(username),
            SizedBox(height: 8.0),
            Text(
              caption,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.0),
            Text(DateTimeAgo().toCalculate(
              postTime,
              locale: DateTimeAgoLocalesEnums.english,
            )),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: onLikeTap,
                    ),
                    Text('$likeCount', style: TextStyle(color: Colors.red)),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.comment, color: Colors.blue),
                  onPressed: onCommentTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
