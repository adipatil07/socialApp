import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/comment_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> registerUser(UserModel userModel) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': userModel.name,
          'username': userModel.username,
          'phone': userModel.phone,
          'email': userModel.email,
          'guardianPhone': userModel.guardianPhone,
          'guardianEmail': userModel.guardianEmail,
          'uid': user.uid,
        });
      }

      return user;
    } catch (e) {
      print("Firebase Registration Error: $e");
      return null;
    }
  }

  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error during user login: $e");
      print("Stack trace: ${e.toString()}");
      return null;
    }
  }

  Future<void> addPost(PostModel postModel) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postModel.postId)
          .set(postModel.toMap());
    } catch (e) {
      print("Error adding post: $e");
      print("Stack trace: ${e}");
    }
  }

  Future<void> likePost(String postId) async {
    try {
      DocumentReference postRef = _firestore.collection('posts').doc(postId);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot postSnapshot = await transaction.get(postRef);
        if (!postSnapshot.exists) {
          throw Exception("Post does not exist!");
        }
        int newLikeCount = postSnapshot['likeCount'] + 1;
        transaction.update(postRef, {'likeCount': newLikeCount});
      });
    } catch (e) {
      print("Error liking post: $e");
      print("Stack trace: ${e}");
    }
  }

  Future<void> addComment(String postId, CommentModel commentModel) async {
    try {
      DocumentReference postRef = _firestore.collection('posts').doc(postId);
      await postRef.update({
        'comments': FieldValue.arrayUnion([commentModel.toMap()])
      });
    } catch (e) {
      print("Error adding comment: $e");
      print("Stack trace: ${e}");
    }
  }

  Future<List<CommentModel>> getComments(String postId) async {
    try {
      DocumentSnapshot postSnapshot =
          await _firestore.collection('posts').doc(postId).get();
      List<dynamic> commentsData = postSnapshot['comments'];
      return commentsData.map((data) => CommentModel.fromMap(data)).toList();
    } catch (e) {
      print("Error getting comments: $e");
      print("Stack trace: ${e}");
      return [];
    }
  }

  Future<bool> isUsernameTaken(String username) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking username: $e");
      return false;
    }
  }
}
