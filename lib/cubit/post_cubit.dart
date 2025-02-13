import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/services/firebase_service.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final FirebaseService _firebaseService;

  PostCubit(this._firebaseService) : super(PostInitial());

  Future<PostState> fetchPosts() async {
    try {
      final posts = await _firebaseService.getPosts();
      final postState = PostLoaded(posts);
      emit(postState);
      return postState;
    } catch (e) {
      final errorState = PostError(e.toString());
      emit(errorState);
      return errorState;
    }
  }

  Future<void> addPost({
    required String caption,
  }) async {
    try {
      emit(PostLoading());

      if (caption.isEmpty) {
        throw Exception('Caption cannot be empty');
      }

      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently logged in');
      }

      // Fetch the username from the current user
      final String userName =
          await _firebaseService.getUsername(currentUser.uid);
      final String postId = DateTime.now().millisecondsSinceEpoch.toString();
      final DateTime timestamp = DateTime.now();

      // Create new post
      final PostModel newPost = PostModel(
        postId: postId,
        timestamp: timestamp,
        userName: userName, // Ensure username is set correctly
        likeCount: 0,
        comments: [],
        caption: caption,
        image: '',
      );

      // Save post to database
      await _firebaseService.savePostToDatabase(newPost);

      fetchPosts(); // Refresh posts after adding a new one
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> likePost(String postId) async {
    try {
      await _firebaseService.likePost(postId);
      fetchPosts();
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<PostState> fetchUserPosts(String username) async {
    try {
      final posts = await _firebaseService.fetchUserPosts(username);
      final postState = PostLoaded(posts);
      emit(postState);
      return postState;
    } catch (e) {
      final errorState = PostError(e.toString());
      emit(errorState);
      return errorState;
    }
  }
}
