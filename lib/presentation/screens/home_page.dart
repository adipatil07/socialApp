import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/core/utils/app_colors.dart';
import 'package:social_app/presentation/screens/add_post_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/post_cubit.dart';
import 'package:social_app/presentation/screens/comment_bottom_sheet.dart';
import 'package:social_app/presentation/screens/post_card.dart';
import 'package:social_app/router/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showAllPosts = true;

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.webp", height: 32),
            const SizedBox(width: 8),
            const Text(
              "Imagefy",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.secondaryColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            onPressed: () {
              context.pushNamed(AppRoutes.profile.name);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            ToggleButtons(
              isSelected: [showAllPosts, !showAllPosts],
              onPressed: (index) {
                setState(() {
                  showAllPosts = index == 0;
                });
                context.read<PostCubit>().fetchPosts();
              },
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("All"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("Uploaded"),
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<PostCubit, PostState>(
                builder: (context, state) {
                  if (state is PostLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is PostLoaded) {
                    final posts = showAllPosts
                        ? state.posts
                        : state.posts
                            .where((post) => post.userName == "adi")
                            .toList(); // Replace "adi" with the logged-in user's name
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 4),
                      child: PageView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: posts.length,
                        pageSnapping: true,
                        itemBuilder: (context, index) {
                          final post = posts[index];
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
          ],
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
