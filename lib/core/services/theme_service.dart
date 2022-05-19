import 'dart:convert';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:network_calls_with_repository_pattern/core/keys.dart';

class ThemeService extends StateNotifier<bool> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ThemeService() : super(false) {
    _getTheme();
  }

  Future<void> toggleTheme() async {
    state = !state;

    log("New Theme Value...... $state");
    _saveTheme();
  }

  _getTheme() async {
    var response = await _storage.read(key: Keys.theme);
    if (response == null || response.isEmpty) {
      return;
    }
    var value = jsonDecode(response) as bool;
    log("Getting Theme.......: $value");
    state = value;
  }

  _saveTheme() async {
    log("Saving Theme........ $state");
    await _storage.write(key: Keys.theme, value: jsonEncode(state));
  }
}

final themeService =
    StateNotifierProvider<ThemeService, bool>(((ref) => ThemeService()));
