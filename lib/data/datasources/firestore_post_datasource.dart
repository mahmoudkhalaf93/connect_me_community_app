import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/post_model.dart';

abstract class FirestorePostDataSource {
  Future<List<PostModel>> getPosts();
  Future<void> createPost(PostModel post);
}

class FirestorePostDataSourceImpl implements FirestorePostDataSource {
  final FirebaseFirestore firestore;

  FirestorePostDataSourceImpl({required this.firestore});

  @override
  Future<List<PostModel>> getPosts() async {
    // Seed some initial data if the collection is empty for testing purposes.
    final countQuery = await firestore.collection('posts').limit(1).get();
    if (countQuery.docs.isEmpty) {
      await _seedInitialData();
    }

    final snapshot = await firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => PostModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  Future<void> _seedInitialData() async {
    final batch = firestore.batch();
    final List<Map<String, dynamic>> dummyPosts = [
      {
        'authorName': 'Omar Khalil',
        'content': "Welcome to the ConnectMe Community! We are excited to have you here. Let's build something great together. 🚀",
        'timestamp': FieldValue.serverTimestamp(),
      },
      {
        'authorName': 'Sarah Ahmed',
        'content': "Just finished the new Flutter course. The Clean Architecture section was mind-blowing! Highly recommended. 💻📱",
        'timestamp': FieldValue.serverTimestamp(),
      },
      {
        'authorName': 'Ahmed Ali',
        'content': 'Does anyone have recommendations for state management in large apps? BLoC vs Riverpod?',
        'timestamp': FieldValue.serverTimestamp(),
      },
    ];

    for (var post in dummyPosts) {
      final docRef = firestore.collection('posts').doc();
      batch.set(docRef, post);
    }
    await batch.commit();
  }

  @override
  Future<void> createPost(PostModel post) async {
    await firestore.collection('posts').add(post.toJson());
  }
}
