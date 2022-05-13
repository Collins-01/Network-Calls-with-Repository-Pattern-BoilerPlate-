import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_calls_with_repository_pattern/core/models/posts_model.dart';
import 'package:network_calls_with_repository_pattern/core/network_manager/endpoints.dart';
import 'package:network_calls_with_repository_pattern/core/network_manager/failure.dart';
import 'package:network_calls_with_repository_pattern/core/network_manager/network_client.dart';
import 'package:network_calls_with_repository_pattern/core/repositories/posts_repository.dart';

class PostsService extends PostsRepository {
  final NetworkClient client;
  PostsService(this.client);
  @override
  Future<List<Post>> getPosts() async {
    try {
      var response = await client.get(EndPoints.getPosts) as List;
      List<Post> posts = response.map((e) => Post.fromJson(e)).toList();
      return posts;
    } on Failure {
      rethrow;
    }
  }
}

final postService =
    Provider<PostsRepository>((ref) => PostsService(NetworkClient()));
