import 'package:network_calls_with_repository_pattern/core/models/posts_model.dart';

abstract class PostsRepository {
  Future<List<Post>> getPosts();
}
