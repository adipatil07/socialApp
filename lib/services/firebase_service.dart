import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/comment_model.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String? _currentUserId;
  String? _currentUsername;

  String? get currentUserId => _currentUserId;
  String? get currentUsername => _currentUsername;

  Future<void> _storeUserId(String uid) async {
    // Store the user ID in a secure storage or another method
    // For demonstration, we'll use a simple in-memory storage
    _currentUserId = uid;
    print("Stored user ID: $_currentUserId");
  }

  Future<void> loadUserId() async {
    // Load the user ID from the secure storage or another method
    // For demonstration, we'll assume the user ID is already set
    // _currentUserId = ...;
  }
  Future<void> loadUsername() async {
    // Load the user ID from the secure storage or another method
    // For demonstration, we'll assume the user ID is already set
    // _currentUserId = ...;
  }

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
        await _storeUserId(user.uid);
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
      _currentUserId = userCredential.user?.uid;
      _currentUsername = userCredential.user?.displayName;
      if (_currentUserId != null) {
        await _storeUserId(_currentUserId!);
      }
      print("Logged in user ID: $_currentUserId");
      return userCredential.user;
    } catch (e) {
      print("Firebase Login Error: $e");
      return null;
    }
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
    // Clear the user ID from the secure storage or another method
    _currentUserId = null;
    print("User logged out");
  }

  Future<void> likePost(String postId) async {
    final docRef = _firestore.collection('posts').doc(postId);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw Exception("Post does not exist!");
      }
      final newLikeCount = (snapshot.data()?['likeCount'] ?? 0) + 1;
      transaction.update(docRef, {'likeCount': newLikeCount});
    });
  }

  Future<int> getLikeCount(String postId) async {
    final doc = await _firestore.collection('posts').doc(postId).get();
    return doc.data()?['likeCount'] ?? 0;
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

  Future<UserModel?> getUserProfile(String uid) async {
    try {
      print("Fetching profile for user ID: $uid");
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        print("User profile found: ${userDoc.data()}");
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      } else {
        print("User not found");
        return null;
      }
    } catch (e) {
      print("Error getting user profile: $e");
      return null;
    }
  }

  Future<void> savePostToDatabase(PostModel post) async {
    await _firestore.collection('posts').doc(post.postId).set(post.toMap());
  }

  Future<List<PostModel>> getPosts() async {
    final QuerySnapshot snapshot = await _firestore.collection('posts').get();
    return snapshot.docs
        .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<String> getUsername(String uid) async {
    try {
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc['username'] as String;
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch username: $e');
    }
  }

  Future<List<PostModel>> fetchUserPosts(String username) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('posts')
          .where('userName', isEqualTo: username)
          .get();

      return snapshot.docs.map((doc) {
        return PostModel.fromDocumentSnapshot(doc);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching user posts: $e');
    }
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('depressionDetection/$fileName');

      print("Starting upload...");
      UploadTask uploadTask = storageRef.putFile(imageFile);

      uploadTask.snapshotEvents.listen((event) {
        print("Progress: ${event.bytesTransferred}/${event.totalBytes}");
      });

      TaskSnapshot snapshot = await uploadTask;
      print("Upload complete!");

      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Download URL: $downloadUrl");

      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return Future.error(e);
    }
  }
}
