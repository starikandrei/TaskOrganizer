import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:taskorganizer/app/date/models/task_notification.dart';
import 'package:taskorganizer/app/date/services/auth_service.dart';
import 'package:taskorganizer/app/date/services/task_notification_service.dart';

/// Controller for managing task notifications
class NotificationController extends GetxController {
  /// Dependencies for authentication and notification services
  final AuthServices _authServices;
  final TaskNotificationService _taskNotificationService;

  /// Reactive list of task notifications
  final RxList<TaskNotification> taskNotifications =
      RxList.empty(growable: true);

  /// User ID of the current authenticated user
  late String _uid;

  /// Query for fetching task notifications from the database
  late Rx<Query<TaskNotification>> taskNotificationQuery;

  /// Constructor to initialize the notification and authentication services
  NotificationController(
    this._taskNotificationService,
    this._authServices,
  );

  /// Called when the controller is first initialized
  @override
  void onInit() async {
    _uid = _authServices.uid.value!;

    taskNotificationQuery =
        _taskNotificationService.getNotificationsQuery(_uid).obs;

    super.onInit();
  }

  /// Updates the status of notifications to mark them as shown
  void updateNotification() {
    for (var element in taskNotifications) {
      if (!element.isShown) {
        element.isShown = !element.isShown;
        _taskNotificationService.updateNotification(element);
      }
    }
  }
}
