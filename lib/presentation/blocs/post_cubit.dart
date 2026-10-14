import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepository postRepository;

  PostCubit({required this.postRepository}) : super(PostInitial());

  Future<void> loadPosts() async {
    emit(PostLoading());
    final result = await postRepository.getPosts();
    result.fold(
      (failure) => emit(PostError(failure.message)),
      (posts) => emit(PostLoaded(posts)),
    );
  }

  Future<void> createPost(String authorName, String content) async {
    // Save previous state to revert back to list after creating
    final currentState = state;
    List<PostEntity> currentPosts = [];
    if (currentState is PostLoaded) {
      currentPosts = currentState.posts;
    }

    emit(PostCreating());

    final newPost = PostEntity(
      id: '', // Firestore generates this
      authorName: authorName,
      content: content,
      timestamp: DateTime.now(),
    );

    final result = await postRepository.createPost(newPost);

    result.fold(
      (failure) {
        emit(PostError(failure.message));
        if (currentPosts.isNotEmpty) {
          emit(PostLoaded(currentPosts)); // Revert
        }
      },
      (_) {
        // Success
        emit(PostCreated());
        loadPosts(); // Refresh list
      },
    );
  }
}
