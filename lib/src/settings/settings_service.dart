import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async {
    return ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    print(prefs.containsKey("curr_theme"));
    String? currTheme = prefs.getString("curr_theme");
    if (currTheme?.isNotEmpty ?? false) {
      return currTheme == ThemeMode.dark.name
          ? ThemeMode.dark
          : ThemeMode.light;
    } else {
      return ThemeMode.light;
    }
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("curr_theme", theme.name);
  }
}
