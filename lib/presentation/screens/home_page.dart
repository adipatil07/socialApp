import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_app/presentation/screens/add_post_page.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> posts = [
    {
      'imageUrl': 'https://media.giphy.com/media/EqVipgL5iu0ivcddvA/giphy.gif',
      'title': 'Exciting Animation',
      'description': 'Enjoy this amazing GIF with lots of fun!'
    },
    {
      'imageUrl': 'https://pngimg.com/uploads/birds/birds_PNG9.png',
      'title': 'Beautiful Bird',
      'description': 'Look at this lovely bird flying in the sky.'
    },
    {
      'imageUrl':
          'http://www.pngmart.com/files/6/Barn-Owl-Transparent-Images-PNG.png',
      'title': 'Majestic Owl',
      'description': 'The wise old owl, a true symbol of knowledge.'
    },
    {
      'imageUrl': 'https://media.giphy.com/media/6U6sno5AkUsOQ/giphy.gif',
      'title': 'Funny Animation',
      'description': 'Laugh out loud with this hilarious animation!'
    },
  ];

  final Map<int, List<String>> comments = {
    0: ['Amazing GIF!', 'Looks great!', 'Wow, nice one!'],
    1: ['Beautiful bird!', 'So cute!', 'Is it real?'],
    2: ['Lovely owl!', 'I love owls.', 'Amazing photography!'],
    3: ['Haha, so funny!', 'Made my day!', 'Nice animation!'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Social App"),
        leading: Icon(Icons.app_shortcut),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4),
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: posts.length,
            pageSnapping: true,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCard(
                imageUrl: post['imageUrl']!,
                title: post['title']!,
                description: post['description']!,
                onCommentTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16.0),
                      ),
                    ),
                    builder: (context) {
                      return CommentBottomSheet(
                        postIndex: index,
                        comments: comments[index] ?? [],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Post Screen
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPostPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final VoidCallback onCommentTap;

  const PostCard({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.onCommentTap,
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
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[700],
                ),
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
                onTap: () {
                  // Handle like button press
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                      size: 28.0,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      "Like",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                    Text(
                      "Comment",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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

class CommentBottomSheet extends StatelessWidget {
  final int postIndex;
  final List<String> comments;

  const CommentBottomSheet({
    required this.postIndex,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
            Text(
              "Comments",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child:
                          Text(comments[index][0]), // First letter of comment
                    ),
                    title: Text(comments[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
