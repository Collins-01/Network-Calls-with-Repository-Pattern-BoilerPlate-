import 'package:flutter/material.dart';
import 'package:network_calls_with_repository_pattern/core/states/view_model_state.dart';

class BaseViewModel extends ChangeNotifier {
  ViewModelState _state = const ViewModelState.idle();
  ViewModelState get state => _state;

  ///Returns true if the state is BUSY
  bool get isBusy =>
      _state.maybeWhen<bool>(busy: () => true, orElse: () => false);

  ///Returns true if the state is Idle
  bool get isIdle => _state.maybeWhen(idle: () => true, orElse: () => false);

  ///Returns true if the state has an Error
  bool get isError =>
      _state.maybeWhen<bool>(error: (value) => true, orElse: () => false);

  /// A getter to return the Error for the Current State
  String getError() =>
      _state.maybeWhen(error: (failure) => failure.message, orElse: () => "");
  changeState(ViewModelState newState) {
    _state = newState;
    // notify listeners if viewmodel is still active
    if (!isDisposed) notifyListeners();
  }

  bool _disposed = false;

  /// Returns True,  if the current State has been disposed
  bool get isDisposed => _disposed;
  @override
  void dispose() {
    super.dispose();
    _disposed = true;
  }
}
