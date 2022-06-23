import 'package:network_calls_with_repository_pattern/core/states/base_view_model.dart';
import 'package:flutter/foundation.dart';

abstract class AppReactiveViewModel extends BaseViewModel {
  late List<ReactiveServiceMixin> _reactiveServices;

  List<ReactiveServiceMixin> get reactiveServices;

  AppReactiveViewModel() {
    _reactToServices(reactiveServices);
  }

  void _reactToServices(List<ReactiveServiceMixin> reactiveServices) {
    _reactiveServices = reactiveServices;
    for (var reactiveService in _reactiveServices) {
      reactiveService.addListener(_indicateChange);
    }
  }

  @override
  void dispose() {
    for (var reactiveService in _reactiveServices) {
      reactiveService.removeListener(_indicateChange);
    }
    super.dispose();
  }

  void _indicateChange() {
    notifyListeners();
  }
}

mixin ReactiveServiceMixin {
  List<Function> _listeners = List<Function>.empty(growable: true);

  void addListener(void Function() listener) {
    _listeners.add(listener);
  }

  void listenToReactiveValues(List<dynamic> reactiveValues) {
    for (var reactiveValue in reactiveValues) {
      // if (reactiveValue is ReactiveValue) {
      //   reactiveValue.values.listen((value) => notifyListeners());
      // } else if (reactiveValue is ReactiveList) {
      //   reactiveValue.onChange.listen((event) => notifyListeners());
      // } else if (reactiveValue is ChangeNotifier) {
      //   reactiveValue.addListener(notifyListeners);
      // }
    }
  }

  /// Removes a listener from the service
  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  @protected
  @visibleForTesting
  void notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }
}
