import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskorganizer/app/date/providers/storage_provider.dart';

/// A provider class for managing theme modes in the application.
/// This class uses GetX for state management and interacts with `StorageProvider`
/// to persist the user's theme preference.
class ThemeProvider extends GetxController {
  /// An instance of `StorageProvider` to handle theme persistence in local storage.
  final StorageProvider _storageService = StorageProvider();

  /// Reactive variable to hold the current theme mode.
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  /// Getter for the current theme mode.
  ThemeMode get themeMode => _themeMode.value;

  /// Called during the initialization phase of the controller.
  /// Loads the user's preferred theme mode from storage.
  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  /// Updates the current theme mode and persists it to local storage.
  ///
  /// - `mode`: The new theme mode to be set (e.g., `ThemeMode.light`, `ThemeMode.dark`).
  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    _storageService.writeThemeMode(mode.name); // Save the theme mode as a string.
    update(); // Notify listeners about the change.
  }

  /// Loads the saved theme mode from local storage and updates the reactive theme variable.
  /// Defaults to `ThemeMode.system` if no value is found.
  void _loadThemeFromStorage() {
    String? savedTheme = _storageService.readThemeMode();
    if (savedTheme != null) {
      _themeMode.value = _themeModeFromString(savedTheme);
    } else {
      _themeMode.value = ThemeMode.system;
    }
  }

  /// Converts a string representation of the theme mode back to a `ThemeMode` instance.
  ///
  /// - `mode`: The string representation of the theme mode (e.g., "light", "dark").
  /// Returns the corresponding `ThemeMode` or defaults to `ThemeMode.system`.
  ThemeMode _themeModeFromString(String mode) {
    if (ThemeMode.light.name == mode) {
      return ThemeMode.light;
    } else if (ThemeMode.dark.name == mode) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }
}
