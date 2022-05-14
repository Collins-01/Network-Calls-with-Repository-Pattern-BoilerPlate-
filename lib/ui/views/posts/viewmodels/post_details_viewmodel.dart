import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_calls_with_repository_pattern/core/models/comments_model.dart';
import 'package:network_calls_with_repository_pattern/core/network_manager/failure.dart';
import 'package:network_calls_with_repository_pattern/core/states/base_view_model.dart';
import 'package:network_calls_with_repository_pattern/core/states/view_model_state.dart';
import '../../../../core/services/posts_service.dart';

class PostDetailsViewModel extends BaseViewModel {
  ChangeNotifierProviderRef ref;
  PostDetailsViewModel(this.ref);
  List<Comment> _comments = [];
  List<Comment> get comments => _comments;

  onModelReady(int id) {
    _getComments(id);
  }

  _getComments(int id) async {
    try {
      log(BaseViewModel().state.toString());
      changeState(const ViewModelState.busy());
      _comments = await ref.read(postService).getComments(id);
      notifyListeners();
      changeState(const ViewModelState.idle());
    } on Failure catch (e) {
      changeState(ViewModelState.error(e));
    }
  }
}
