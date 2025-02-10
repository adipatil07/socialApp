import 'package:flutter/material.dart';
import 'package:social_app/core/utils/app_colors.dart';
import 'package:social_app/presentation/screens/add_post_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/post_cubit.dart';
import 'package:social_app/presentation/screens/comment_bottom_sheet.dart';
import 'package:social_app/presentation/screens/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().fetchPosts();
  }

  Map<String, bool> likedPosts = {};
  Map<String, int> likeCounts = {};

  void _likePost(String postId) {
    setState(() {
      likedPosts[postId] = !(likedPosts[postId] ?? false);
      if (likedPosts[postId]!) {
        likeCounts[postId] = (likeCounts[postId] ?? 0) + 1;
      } else {
        likeCounts[postId] = (likeCounts[postId] ?? 1) - 1;
      }
    });
    context.read<PostCubit>().likePost(postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Imagefy",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.secondaryColor,
        leading: Image.asset("assets/images/logo.webp"),
      ),
      body: SafeArea(
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PostLoaded) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4),
                child: PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: state.posts.length,
                  pageSnapping: true,
                  itemBuilder: (context, index) {
                    final post = state.posts[index];
                    return PostCard(
                      imageUrl: post.imageUrl,
                      title: post.caption,
                      description: post.caption,
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
                                // postId: post.postId,
                                );
                          },
                        );
                      },
                      onLikeTap: () => _likePost(post.postId),
                      isLiked: likedPosts[post.postId] ?? false,
                      likeCount: likeCounts[post.postId] ?? 0,
                    );
                  },
                ),
              );
            } else if (state is PostError) {
              return Center(child: Text(state.message));
            } else {
              return Container();
            }
          },
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
