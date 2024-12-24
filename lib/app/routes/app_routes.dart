part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const AUTHORIZATION = _Paths.AUTHORIZATION;
  static const HOME = _Paths.HOME;
  static const NOTIFICATION = _Paths.NOTIFICATION;
  static const SETTINGS = _Paths.SETTINGS;
}

abstract class _Paths {
  _Paths._();
  static const AUTHORIZATION = '/authorization';
  static const HOME = '/home';
  static const NOTIFICATION = '/notification';
  static const SETTINGS = '/settings';
}