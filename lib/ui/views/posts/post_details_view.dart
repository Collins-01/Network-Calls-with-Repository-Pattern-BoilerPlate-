import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:network_calls_with_repository_pattern/core/models/posts_model.dart';
import 'package:network_calls_with_repository_pattern/ui/views/posts/viewmodels/post_details_viewmodel.dart';
import 'package:network_calls_with_repository_pattern/ui/widgtes/error_view.dart';
import 'package:network_calls_with_repository_pattern/ui/widgtes/loader.dart';
import '../../../core/extensions/xcontext.dart' show Context;
import '../../../core/extensions/xstrings.dart' show XString;

final _postDetailViewModel =
    ChangeNotifierProvider((ref) => PostDetailsViewModel(ref));

class PostDetailsView extends ConsumerStatefulWidget {
  final Post post;
  const PostDetailsView({Key? key, required this.post}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostDetailsViewState();
}

class _PostDetailsViewState extends ConsumerState<PostDetailsView> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      ref.read(_postDetailViewModel).onModelReady(widget.post.id);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var model = ref.watch(_postDetailViewModel);
    return Scaffold(
      appBar: AppBar(
        title: Text("Post ${widget.post.id}"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post.title.capitalize(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.post.body.capitalize(),
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(.8)),
            ),
            const SizedBox(
              height: 50,
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            model.state.when(
                busy: () => const SizedBox(
                      height: 100,
                      child: Loader(),
                    ),
                error: (e) => ErrorView(
                    retry: () => model.onModelReady(widget.post.id),
                    failure: e),
                idle: () {
                  if (model.comments.isEmpty) {
                    return const Center(
                      child: Text("No Comments"),
                    );
                  } else {
                    return Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          model.comments.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Container(
                              width: context.deviceWidth,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Colors.grey.withOpacity(.3),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Email: ${model.comments[index].email}"),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Text("Name: ${model.comments[index].name}"),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(model.comments[index].body.capitalize()),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ));
                  }
                })
          ],
        ),
      ),
    );
  }
}
