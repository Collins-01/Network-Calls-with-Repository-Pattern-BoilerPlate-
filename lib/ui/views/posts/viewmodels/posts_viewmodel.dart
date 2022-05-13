import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:network_calls_with_repository_pattern/core/models/posts_model.dart';
import 'package:network_calls_with_repository_pattern/core/network_manager/failure.dart';
import 'package:network_calls_with_repository_pattern/core/services/posts_service.dart';
import 'package:network_calls_with_repository_pattern/core/states/base_view_model.dart';
import 'package:network_calls_with_repository_pattern/core/states/view_model_state.dart';

class PostsViewModel extends BaseViewModel {
  AutoDisposeChangeNotifierProviderRef ref;
  PostsViewModel(this.ref);
  List<Post> _posts = [];
  List<Post> get post => _posts;

  onModelReady() {
    _getPosts();
  }

  _getPosts() async {
    try {
      changeState(const ViewModelState.busy());
      _posts = await ref.read(postService).getPosts();
      notifyListeners();
      changeState(const ViewModelState.idle());
    } on Failure catch (e) {
      changeState(ViewModelState.error(e));
    }
  }
}
