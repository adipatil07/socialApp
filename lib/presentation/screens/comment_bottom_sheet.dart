import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/comment_cubit.dart';
import 'package:social_app/models/comment_model.dart';

class CommentBottomSheet extends StatelessWidget {
  final String? postId;

  const CommentBottomSheet({
    super.key,
    this.postId,
  });

  @override
  Widget build(BuildContext context) {
    // Fetch comments when the bottom sheet is opened
    context.read<CommentCubit>().fetchComments(postId ?? '');

    return BlocBuilder<CommentCubit, CommentState>(
      builder: (context, state) {
        if (state is CommentLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is CommentLoaded) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
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
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.comments.length,
                      itemBuilder: (context, index) {
                        final comment = state.comments[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(comment.commentorUserName[0]),
                          ),
                          title: Text(comment.commentorUserName),
                          subtitle: Text(comment.commentText),
                        );
                      },
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Add a comment",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      final comment = CommentModel(
                        commentId: DateTime.now().toString(),
                        commentText: value,
                        commentorUserName:
                            "User", // Replace with actual user name
                      );
                      // context.read<CommentCubit>().addComment(postId, comment);
                    },
                  ),
                ],
              ),
            ),
          );
        } else if (state is CommentError) {
          return Center(child: Text(state.message));
        } else {
          return Container();
        }
      },
    );
  }
}
