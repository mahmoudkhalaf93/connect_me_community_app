import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String id;
  final String authorName;
  final String content;
  final DateTime timestamp;

  const PostEntity({
    required this.id,
    required this.authorName,
    required this.content,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, authorName, content, timestamp];
}
