import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/firestore_post_datasource.dart';
import '../datasources/local_post_datasource.dart';
import '../models/post_model.dart';

// Enum to define which data source to use (Factory Pattern requirement)
enum DataSourceType { remote, local }

class PostRepositoryImpl implements PostRepository {
  final FirestorePostDataSource remoteDataSource;
  final LocalPostDataSource localDataSource;

  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  /// Factory Pattern implementation for Data Source selection
  /// (Requirement #5: "Apply the Factory Pattern to the PostRepository data source selection.")
  Future<List<PostModel>> _getDataSource(DataSourceType type) {
    switch (type) {
      case DataSourceType.remote:
        return remoteDataSource.getPosts();
      case DataSourceType.local:
        return localDataSource.getCachedPosts();
      default:
        throw Exception("Unknown Data Source");
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts() async {
    try {
      // Here we could check for internet connection. We'll default to remote.
      final posts = await _getDataSource(DataSourceType.remote);
      return Right(posts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createPost(PostEntity post) async {
    try {
      final postModel = PostModel(
        id: post.id,
        authorName: post.authorName,
        content: post.content,
        timestamp: post.timestamp,
      );
      await remoteDataSource.createPost(postModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
