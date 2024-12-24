import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:taskorganizer/app/date/providers/language_provider.dart';
import 'package:taskorganizer/app/date/services/task_notification_service.dart';
import 'app/date/providers/theme_provider.dart';
import 'app/date/services/auth_service.dart';
import 'app/date/services/tasks_service.dart';
import 'app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/theme/app_themes.dart';
import 'firebase_options.dart';
import 'generated/locales.g.dart';

/// The main entry point for the application.
///
/// This file initializes the app, sets up necessary services, manages localization,
/// handles user authentication, and applies theme configurations.
void main() async {
  await initServices();

  /// Retrieve instances of LanguageProvider and ThemeProvider from GetX dependency injection.
  LanguageProvider languageProvider = Get.find<LanguageProvider>();
  ThemeProvider themeProvider = Get.find<ThemeProvider>();
  bool isAuthorized = Get.find<AuthServices>().isAuth();

  /// Run the app with state management using GetX.
  runApp(
    Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        locale: languageProvider.languageCode.isNotEmpty
            ? Locale(languageProvider.languageCode)
            : Get.deviceLocale,
        fallbackLocale: const Locale('ru', 'RU'),
        translationsKeys: AppTranslation.translations,
        title: 'Flutter Demo',
        initialRoute: isAuthorized ? Routes.HOME : Routes.AUTHORIZATION,
        getPages: AppPages.routes,
        theme: AppThemes.light,
        darkTheme: AppThemes.dark,
        themeMode: themeProvider.themeMode,
      ),
    ),
  );
}

/// Initializes all necessary services for the app.
///
/// This includes Firebase initialization, dependency injection setup,
/// and starting required services like Auth, Theme, Task, and Language.
Future initServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put<AuthServices>(AuthServices(FirebaseAuth.instance), permanent: true)
      .onInit();
  Get.put<ThemeProvider>(ThemeProvider(), permanent: true).onInit();
  Get.put<TaskService>(TaskService(FirebaseFirestore.instance), permanent: true)
      .onInit();
  Get.put<TaskNotificationService>(
          TaskNotificationService(FirebaseFirestore.instance, Get.find()),
          permanent: true)
      .onInit();
  Get.put<LanguageProvider>(LanguageProvider(), permanent: true).onInit();
}
