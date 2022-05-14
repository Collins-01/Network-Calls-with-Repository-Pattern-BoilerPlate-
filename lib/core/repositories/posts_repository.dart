import 'package:network_calls_with_repository_pattern/core/models/comments_model.dart';
import 'package:network_calls_with_repository_pattern/core/models/posts_model.dart';

abstract class PostsRepository {
  Future<List<Post>> getPosts();
  Future<List<Comment>> getComments(int postId);
}
