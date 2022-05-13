import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:network_calls_with_repository_pattern/ui/views/posts/viewmodels/posts_viewmodel.dart';
import 'package:network_calls_with_repository_pattern/ui/widgtes/error_view.dart';
import 'package:network_calls_with_repository_pattern/ui/widgtes/loader.dart';

final _postViewModel =
    ChangeNotifierProvider.autoDispose((ref) => PostsViewModel(ref));

class PostsView extends ConsumerStatefulWidget {
  const PostsView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostsViewState();
}

class _PostsViewState extends ConsumerState<PostsView> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      log("${timeStamp.inSeconds}");
      ref.read(_postViewModel).onModelReady();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var model = ref.watch(_postViewModel);
    return Scaffold(
      body: model.state.when(
        idle: () {
          if (model.post.isEmpty) {
            return const Center(
              child: Text("No Posts"),
            );
          } else {
            return ListView.builder(
              itemCount: model.post.length,
              itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.post[index].title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(model.post[index].body),
                    ],
                  )),
            );
          }
        },
        error: (e) => ErrorView(retry: () => model.onModelReady(), failure: e),
        busy: () => const Loader(),
      ),
    );
  }
}
/// *
/// Empty List
/// Error
/// Loading
/// Not Loading[Done]
/// 


