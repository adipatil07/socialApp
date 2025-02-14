import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/comment_cubit.dart';
import 'package:date_time_ago/date_time_ago.dart';
import 'package:social_app/services/firebase_service.dart';

class CommentBottomSheet extends StatefulWidget {
  final String postId;

  const CommentBottomSheet({required this.postId});

  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController commentController = TextEditingController();
  bool _isSendingComment = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CommentCubit(FirebaseService())..fetchComments(widget.postId),
      child: BlocBuilder<CommentCubit, CommentState>(
        builder: (context, state) {
          if (state is CommentLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CommentLoaded) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
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
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    Expanded(
                      child: state.comments.isEmpty
                          ? Center(
                              child: Text(
                                "There's no comment yet. Be the first to comment!",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
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
                                  trailing: Text(
                                    DateTimeAgo().toCalculate(
                                      comment.timestamp,
                                      locale: DateTimeAgoLocalesEnums.english,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    SingleChildScrollView(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: commentController,
                              decoration: InputDecoration(
                                labelText: "Add a comment",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: _isSendingComment
                                ? CircularProgressIndicator()
                                : Icon(Icons.send),
                            onPressed: _isSendingComment
                                ? null
                                : () async {
                                    final commentText =
                                        commentController.text.trim();
                                    if (commentText.isNotEmpty) {
                                      setState(() {
                                        _isSendingComment = true;
                                      });

                                      await context
                                          .read<CommentCubit>()
                                          .addComment(
                                              widget.postId, commentText);

                                      setState(() {
                                        _isSendingComment = false;
                                      });

                                      commentController.clear();
                                    }
                                  },
                          ),
                        ],
                      ),
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
      ),
    );
  }
}
