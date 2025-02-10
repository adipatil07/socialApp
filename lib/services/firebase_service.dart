// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// import 'package:social_app/models/user_model.dart';
// import 'package:social_app/models/post_model.dart';
// import 'package:social_app/models/comment_model.dart';

// class FirebaseService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<User?> registerUser(UserModel userModel) async {
//     try {
//       // UserCredential userCredential =
//       //     await _auth.createUserWithEmailAndPassword(
//       //   email: userModel.email,
//       //   password: userModel.password,
//       // );
//       // await _firestore
//       //     .collection('users')
//       //     .doc(userCredential.user!.uid)
//       //     .set(userModel.toMap());
//       // return userCredential.user;
//       return null; // Temporary return
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   Future<User?> loginUser(String email, String password) async {
//     try {
//       // UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//       //   email: email,
//       //   password: password,
//       // );
//       // return userCredential.user;
//       return null; // Temporary return
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   Future<void> addPost(PostModel postModel) async {
//     try {
//       // await _firestore
//       //     .collection('posts')
//       //     .doc(postModel.postId)
//       //     .set(postModel.toMap());
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> likePost(String postId) async {
//     try {
//       // DocumentReference postRef = _firestore.collection('posts').doc(postId);
//       // await _firestore.runTransaction((transaction) async {
//       //   DocumentSnapshot postSnapshot = await transaction.get(postRef);
//       //   if (!postSnapshot.exists) {
//       //     throw Exception("Post does not exist!");
//       //   }
//       //   int newLikeCount = postSnapshot['likeCount'] + 1;
//       //   transaction.update(postRef, {'likeCount': newLikeCount});
//       // });
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> addComment(String postId, CommentModel commentModel) async {
//     try {
//       // DocumentReference postRef = _firestore.collection('posts').doc(postId);
//       // await postRef.update({
//       //   'comments': FieldValue.arrayUnion([commentModel.toMap()])
//       // });
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<List<CommentModel>> getComments(String postId) async {
//     try {
//       // DocumentSnapshot postSnapshot =
//       //     await _firestore.collection('posts').doc(postId).get();
//       // List<dynamic> commentsData = postSnapshot['comments'];
//       // return commentsData.map((data) => CommentModel.fromMap(data)).toList();
//       return []; // Temporary return
//     } catch (e) {
//       print(e);
//       return [];
//     }
//   }
// }
