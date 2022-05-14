import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:network_calls_with_repository_pattern/core/keys.dart';
import 'package:network_calls_with_repository_pattern/core/repositories/theme_repository.dart';

class ThemeService extends ChangeNotifier implements ThemeRepositiory {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  ThemeService() {
    _getTheme();
  }
  @override
  bool get isDark => _isDark;
  bool _isDark = true;

  @override
  Future<void> toggleTheme() async {
    _isDark = !_isDark;
    notifyListeners();
    log("New Theme Value...... $_isDark");
    _saveTheme();
  }

  _getTheme() async {
    var response = await _storage.read(key: Keys.theme);
    if (response == null || response.isEmpty) {
      return;
    }
    var value = jsonDecode(response) as bool;
    log("Getting Theme.......: $value");
    _isDark = value;
    notifyListeners();
  }

  _saveTheme() async {
    log("Saving Theme........ $_isDark");
    await _storage.write(key: Keys.theme, value: jsonEncode(_isDark));
  }
}

final themeService = Provider<ThemeRepositiory>(
  (ref) => ThemeService(),
);
