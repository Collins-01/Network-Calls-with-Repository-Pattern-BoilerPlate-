import 'dart:developer';
import 'package:network_calls_with_repository_pattern/core/services/theme_service.dart';
import 'package:network_calls_with_repository_pattern/ui/base_view.dart';

import '../../../core/extensions/xstrings.dart' show XString;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:network_calls_with_repository_pattern/core/states/view_model_state.dart';
import 'package:network_calls_with_repository_pattern/ui/views/posts/post_details_view.dart';
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
      appBar: AppBar(
        title: const Text("Posts"),
        actions: [
          Consumer(builder: (_, theme, __) {
            return Switch(
                // ignore: invalid_use_of_protected_member
                value: theme.watch(themeService.notifier).state,
                onChanged: (v) {
                  theme.watch(themeService.notifier).toggleTheme();
                });
          })
        ],
      ),
      body: model.state.when(
        idle: () {
          if (model.posts.isEmpty &&
              model.state != const ViewModelState.idle()) {
            return const Center(
              child: Text("No Posts"),
            );
          } else {
            return ListView.builder(
              itemCount: model.posts.length,
              itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            PostDetailsView(post: model.posts[index]))),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.5),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16),
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.posts[index].title.capitalize(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(model.posts[index].body.capitalize()),
                        ],
                      ),
                    ),
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

// class TestBaseView extends StatelessWidget {
//   const TestBaseView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final model =
//         ChangeNotifierProvider.autoDispose((ref) => PostsViewModel(ref));
//     return BaseView<model>(
//       onModelReady: (vm) {
//         vm.onModelReady();
//       },
//       widget: const Scaffold(),
//     );
//   }
// }
