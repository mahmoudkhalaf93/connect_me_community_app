import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/post.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.authorName,
    required super.content,
    required super.timestamp,
  });

  factory PostModel.fromJson(Map<String, dynamic> json, String documentId) {
    return PostModel(
      id: documentId,
      authorName: json['authorName'] ?? 'Unknown',
      content: json['content'] ?? '',
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorName': authorName,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
