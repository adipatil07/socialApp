import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/comment_model.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseStorage _storage = FirebaseStorage.instance;

  String? _currentUserId;
  String? _currentUsername;

  String? get currentUserId => _currentUserId;
  String? get currentUsername => _currentUsername;

  final gmailSmtp =
      gmail(dotenv.env["GMAIL_NAME"]!, dotenv.env["GMAIL_PASSWORD"]!);

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

  Future<String?> getGuardianEmail(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc['guardianEmail'] as String?;
      } else {
        print("User document not found!");
        return null;
      }
    } catch (e) {
      print("Error fetching guardian email: $e");
      return null;
    }
  }

  Future<void> storeDetectedEmotion(String userId, String emotion) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('emotions')
          .add({
        'emotion': emotion,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Emotion stored successfully!");
      String? guardianMail = await getGuardianEmail(userId);
      checkAndSendEmail(userId, guardianMail!);
    } catch (e) {
      print("Error storing emotion: $e");
    }
  }

  sendMail(String guardianMail, emotion, userName) async {
    print(guardianMail);
    print(emotion);
    print(userName);
    final msg = Message()
      ..from = Address(dotenv.env["GMAIL_NAME"]!)
      ..recipients.add(guardianMail)
      ..subject = """Concern Regarding $userName’s Emotional Well-being"""
      ..text = """Respected Sir / Ma'am,

I hope this email finds you well. We are reaching out to share an important update regarding $userName’s recent activity on our platform, 

Our system, which monitors emotional patterns in user posts to ensure their well-being, has detected that $userName has recently expressed consistent emotions of $emotion in their last three posts. While we respect user privacy, we believe it’s important to keep loved ones informed when such patterns emerge.

🔹 Detected Sentiment: $emotion

We encourage open conversations and checking in with $userName to ensure their well-being. If needed, you might consider offering support, discussing their feelings, or seeking professional guidance.

If you have any concerns or need further assistance, please feel free to reach out to us. Your support means the world to them.

Best regards,
Imagefy Team

""";

    try {
      final sendReport = await send(msg, gmailSmtp);
      print('${sendReport}');
    } on MailerException catch (e) {
      for (var p in e.problems) {
        print("${p.code}, ${p.msg}");
      }
    }
  }

  Future<void> checkAndSendEmail(String userId, String guardianEmail) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('emotions')
          .orderBy('timestamp', descending: true)
          .limit(3)
          .get();

      if (snapshot.docs.length < 3) {
        print("Not enough emotions recorded yet.");
        return;
      }

      List<String> emotions =
          snapshot.docs.map((doc) => doc['emotion'] as String).toList();

      if (emotions.toSet().length == 1 &&
          emotions.toSet().contains("Sadness")) {
        String emotion = emotions.first;
        print("User has consistent emotion: $emotion. Sending email...");
        String username = await getUsername(userId);
        await sendMail(guardianEmail, emotion, username);
      } else {
        print("Emotions are not the same, no email sent.");
      }
    } catch (e) {
      print("Error fetching emotions: $e");
    }
  }
}
