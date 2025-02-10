import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final VoidCallback onCommentTap;
  final VoidCallback onLikeTap;
  final bool isLiked;
  final int likeCount;

  const PostCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.onCommentTap,
    required this.onLikeTap,
    required this.isLiked,
    required this.likeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Styled Image with rounded corners and border
        Container(
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: Colors.grey.shade300, width: 2.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
              width: double.infinity,
              height: 400.0, // Fixed height for consistency
            ),
          ),
        ),

        // Title and Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 4.0),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),

        // Like and Comment Buttons in a well-aligned horizontal row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: onLikeTap,
                child: Row(
                  children: [
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                      size: 28.0,
                    ),
                    SizedBox(width: 8.0),
                    Text("$likeCount",
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              SizedBox(width: 24.0), // Space between Like and Comment
              GestureDetector(
                onTap: onCommentTap,
                child: Row(
                  children: [
                    Icon(
                      Icons.comment,
                      color: Colors.blue,
                      size: 28.0,
                    ),
                    SizedBox(width: 8.0),
                    Text("Comment",
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Divider for better visual separation
        Divider(color: Colors.grey.shade300),
      ],
    );
  }
}
