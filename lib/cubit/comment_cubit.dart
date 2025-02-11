import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/services/firebase_service.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final FirebaseService _firebaseService;

  CommentCubit(this._firebaseService) : super(CommentInitial());

  Future<void> fetchComments(String postId) async {
    try {
      emit(CommentLoading());
      final comments = await _firebaseService.getComments(postId);
      emit(CommentLoaded(comments));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> addComment(String postId, String commentText) async {
    try {
      final String commentId = DateTime.now().millisecondsSinceEpoch.toString();
      final DateTime timestamp = DateTime.now();
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently logged in');
      }
      final String userName =
          await _firebaseService.getUsername(currentUser.uid);
      final CommentModel newComment = CommentModel(
        commentId: commentId,
        commentText: commentText,
        commentorUserName: userName,
        timestamp: timestamp,
      );
      await _firebaseService.addComment(postId, newComment);
      fetchComments(postId);
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }
}
