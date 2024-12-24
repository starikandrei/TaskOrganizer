import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskorganizer/app/date/providers/language_provider.dart';
import 'package:taskorganizer/app/date/providers/theme_provider.dart';
import 'package:taskorganizer/app/date/services/auth_service.dart';
import 'package:taskorganizer/app/date/services/task_notification_service.dart';
import 'package:taskorganizer/app/date/services/tasks_service.dart';
import 'package:taskorganizer/app/routes/app_pages.dart';

class SettingsController extends GetxController {
  /// Dependencies for theme management, authentication, and services
  final ThemeProvider _themeProvider;
  final LanguageProvider languageProvider;
  final AuthServices authServices;
  final TaskService _taskService;
  final TaskNotificationService _taskNotificationService;

  /// Reactive variable to hold the current theme mode (light, dark, or system)
  late final Rx<ThemeMode> currentMode;
  late final RxString languageCode;

  /// Constructor initializes the dependencies and sets the current theme mode
  SettingsController(
    this._themeProvider,
    this.authServices,
    this._taskService,
    this._taskNotificationService,
    this.languageProvider,
  )   : currentMode = _themeProvider.themeMode.obs,
        languageCode = languageProvider.languageCode.obs;

  /// Handles changes in theme mode
  void onThemeModeChanged(ThemeMode themeMode) {
    currentMode.value = themeMode;
    _themeProvider.setThemeMode(themeMode);
  }

  /// Handles changes in language
  void onLanguageChanged(String languageCode) {
    this.languageCode.value = languageCode;
    languageProvider.setLanguage(languageCode);
  }

  /// Logs out the user
  /// Clears user session and navigates to the authorization screen
  Future<void> logout() async {
    await authServices.logout();
    Get.offAndToNamed(Routes.AUTHORIZATION);
  }

  /// Deletes the user account and all associated data
  /// Removes tasks, notifications, and the user profile from the database
  void deleteAccount() {
    String uid = authServices.uid.value!;
    _taskNotificationService.deleteAllNotificationsByUserId(uid);
    _taskService.deleteAllTasksByUserId(uid);
    authServices.delete();
    Get.offAndToNamed(Routes.AUTHORIZATION);
  }
}
