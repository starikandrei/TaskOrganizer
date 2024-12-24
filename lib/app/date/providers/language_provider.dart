import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskorganizer/app/date/providers/storage_provider.dart';

/// A provider class for managing the application's language preferences.
/// This class uses GetX for state management and interacts with `StorageProvider`
/// to persist the user's language selection.
class LanguageProvider extends GetxController {
  /// An instance of `StorageProvider` to handle language persistence in local storage.
  final StorageProvider _storageService = StorageProvider();

  /// Reactive variable to hold the current language code (e.g., "en", "ru").
  final RxString _languageCode = 'en'.obs;

  /// Getter for the current language code.
  String get languageCode => _languageCode.value;

  /// Called during the initialization phase of the controller.
  /// Loads the user's preferred language from storage.
  @override
  void onInit() {
    super.onInit();
    _loadLanguageFromStorage();
  }

  /// Updates the current language and persists it to local storage.
  ///
  /// - `languageCode`: The new language code to be set (e.g., "en", "ru").
  void setLanguage(String languageCode) {
    _languageCode.value = languageCode;
    _storageService.writeLanguageCode(languageCode); // Save the language code as a string.
    Get.updateLocale(Locale(languageCode)); // Update the app's locale.
    update(); // Notify listeners about the change.
  }

  /// Loads the saved language code from local storage and updates the reactive variable.
  /// Defaults to "en" (English) if no value is found.
  void _loadLanguageFromStorage() {
    String? savedLanguage = _storageService.readLanguageCode();
    if (savedLanguage != null) {
      _languageCode.value = savedLanguage;
      Get.updateLocale(Locale(savedLanguage)); // Apply the saved locale.
    } else {
      _languageCode.value = 'en';
    }
  }
}
