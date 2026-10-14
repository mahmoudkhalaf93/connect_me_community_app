import '../models/post_model.dart';

abstract class LocalPostDataSource {
  Future<List<PostModel>> getCachedPosts();
}

class LocalPostDataSourceImpl implements LocalPostDataSource {
  // In a real app, this would use SharedPreferences, Hive, or SQLite.
  // For this Capstone requirement (Factory Pattern demonstration), we simulate local cache.
  final List<PostModel> _cachedPosts = [];

  @override
  Future<List<PostModel>> getCachedPosts() async {
    return _cachedPosts;
  }
}
