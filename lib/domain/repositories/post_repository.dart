import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure, List<PostEntity>>> getPosts();
  Future<Either<Failure, void>> createPost(PostEntity post);
}
