import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app/models/comment_model.dart';
// import 'package:social_app/services/firebase_service.dart';

part 'comment_state.dart';

// class CommentCubit extends Cubit<CommentState> {
//   CommentCubit() : super(CommentInitial());

//   // final FirebaseService _firebaseService;

//   // CommentCubit(this._firebaseService) : super(CommentInitial());

//   Future<void> fetchComments(String postId) async {
//     try {
//       emit(CommentLoading());
//       // final comments = await _firebaseService.getComments(postId);
//       final comments = [
//         CommentModel(
//             commentId: "101",
//             commentText: "Nice Image",
//             commentorUserName: "Adipatil07")
//       ]; // Temporary comments
//       emit(CommentLoaded(comments));
//     } catch (e) {
//       emit(CommentError(e.toString()));
//     }
//   }

//   Future<void> addComment(String postId, CommentModel comment) async {
//     try {
//       // await _firebaseService.addComment(postId, comment);
//       fetchComments(postId);
//     } catch (e) {
//       emit(CommentError(e.toString()));
//     }
//   }
// }
class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(CommentLoading());

  void fetchComments(String postId) {
    // Simulate fetching comments
    final comments = List.generate(
      5,
      (index) => CommentModel(
        commentId: '$index',
        commentText: 'This is a dummy comment $index',
        commentorUserName: 'User $index',
      ),
    );
    emit(CommentLoaded(comments));
  }
}
