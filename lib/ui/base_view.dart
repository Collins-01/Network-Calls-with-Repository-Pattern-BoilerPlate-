import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BaseView<T extends AutoDisposeChangeNotifierProviderRef>
    extends ConsumerStatefulWidget {
  final Function(T model)? onModelReady;
  final Widget widget;
  const BaseView({Key? key, this.onModelReady, required this.widget})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BaseViewState();
}

class _BaseViewState<T extends AutoDisposeChangeNotifierProviderRef>
    extends ConsumerState<BaseView<T>> {
  T? _viewModel;
  @override
  void initState() {
    if (_viewModel != null) {
      widget.onModelReady?.call(_viewModel!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget;
  }
}
