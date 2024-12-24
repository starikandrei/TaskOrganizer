import 'package:get_storage/get_storage.dart';

/// A service class to manage local storage operations using GetStorage.
class StorageProvider {
  /// Instance of GetStorage to interact with local storage.
  final GetStorage _storage = GetStorage();

  /// The key used to store and retrieve the theme mode in the storage.
  final String _themeKey = 'themeMode';
  /// The key used to store and retrieve the language preference from the storage.
  final String _languageKey = 'languagePreference';

  /// Writes the theme mode value to local storage.
  ///
  /// - `value`: The theme mode to be saved, typically as a string (e.g., "light", "dark").
  void writeThemeMode(String value) {
    _storage.write(_themeKey, value);
  }

  /// Reads the theme mode value from local storage.
  ///
  /// Returns the saved theme mode as a string, or `null` if no value is stored.
  String? readThemeMode() {
    return _storage.read<String>(_themeKey);
  }



  /// Writes the language preference to local storage.
  ///
  /// - `value`: The language code to be saved, typically as a string (e.g., "en", "ru",).
  void writeLanguageCode(String value) {
    _storage.write(_languageKey, value);
  }

  /// Reads the language preference from local storage.
  ///
  /// Returns the saved language code as a string, or `null` if no value is stored.
  String? readLanguageCode() {
    return _storage.read<String>(_languageKey);
  }
}
