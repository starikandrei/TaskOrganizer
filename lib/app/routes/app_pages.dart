import 'package:get/get.dart';
import 'package:taskorganizer/app/modules/authorization_page/auth_binding.dart';
import 'package:taskorganizer/app/modules/authorization_page/auth_view.dart';
import 'package:taskorganizer/app/modules/home_page/home_binding.dart';
import 'package:taskorganizer/app/modules/home_page/home_view.dart';
import 'package:taskorganizer/app/modules/notification_page/notification_binding.dart';
import 'package:taskorganizer/app/modules/notification_page/notification_view.dart';
import 'package:taskorganizer/app/modules/settings_page/settings_binding.dart';
import 'package:taskorganizer/app/modules/settings_page/settings_view.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.AUTHORIZATION;

  static final routes = [
    GetPage(
      name: _Paths.AUTHORIZATION,
      page: () => AuthView(),
      bindings: [AuthBinding()],
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      bindings: [HomeBinding()],
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => NotificationView(),
      bindings: [NotificationBinding()],
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
      bindings: [SettingsBinding()],
    ),
  ];
}