// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_calls_with_repository_pattern/core/services/theme_service.dart';
import 'package:network_calls_with_repository_pattern/ui/views/posts/post_view.dart';
import 'package:network_calls_with_repository_pattern/ui/widgtes/loder_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(themeService);
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: state ? Brightness.dark : Brightness.light,
        ),
        home: const PostsView());
  }
}
