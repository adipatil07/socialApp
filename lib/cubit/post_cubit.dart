import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app/models/post_model.dart';
// import 'package:social_app/services/firebase_service.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  // final FirebaseService _firebaseService;

  // PostCubit(this._firebaseService) : super(PostInitial());

  Future<void> fetchPosts() async {
    try {
      emit(PostLoading());
      // final posts = await _firebaseService.getPosts();
      final posts = [
        PostModel(
            postId: "101",
            timestamp: DateTime.now(),
            userName: "adi",
            likeCount: 11,
            comments: ["comments", "comment2"],
            caption: "Hello new image",
            imageUrl:
                "https://static.vecteezy.com/system/resources/thumbnails/036/324/708/small/ai-generated-picture-of-a-tiger-walking-in-the-forest-photo.jpg")
      ]; // Temporary posts
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> addPost(PostModel post) async {
    try {
      // await _firebaseService.addPost(post);
      fetchPosts();
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> likePost(String postId) async {
    try {
      // await _firebaseService.likePost(postId);
      fetchPosts();
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
}
