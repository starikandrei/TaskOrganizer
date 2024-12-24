import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:taskorganizer/app/date/models/task.dart';
import 'package:taskorganizer/app/date/models/task_notification.dart';
import 'package:taskorganizer/app/date/services/auth_service.dart';
import 'package:taskorganizer/app/date/services/task_notification_service.dart';
import 'package:taskorganizer/app/date/services/tasks_service.dart';
import 'package:taskorganizer/generated/locales.g.dart';

class HomeController extends GetxController {
  /// Services for managing tasks, notifications, and authentication
  final TaskService taskService;
  final TaskNotificationService taskNotificationService;
  final AuthServices authServices;

  /// User ID of the currently authenticated user
  late String _uid;

  /// Reactive list of tasks and filtered tasks
  RxList<Task> tasks = RxList.empty(growable: true);
  RxList<Task> filteredTasks = RxList.empty(growable: true);

  /// Query for fetching tasks from the database
  late Rx<Query<Task>> tasksQuery;

  /// Reactive integer for unread notification count
  late RxInt unreadCount;

  /// Filter and sorting options for tasks
  RxnBool filterTaskWithStatusTag = RxnBool();
  RxString sortingTaskTag = LocaleKeys.byCompletionDate.obs;

  /// Flag to track if there are notifications that have not been read
  RxBool notificationsWereNotRead = false.obs;

  /// Constructor to initialize required services
  HomeController(
    this.taskService,
    this.authServices,
    this.taskNotificationService,
  );

  /// Called when the controller is first initialized
  @override
  void onInit() async {
    _uid = authServices.uid.value!;

    tasksQuery = taskService
        .getNotificationsQuery(
          _uid,
          sortingTaskTag.value,
          filterTaskWithStatusTag.value,
        )
        .obs;

    updateTasks();
    unreadCount = taskNotificationService.unreadCount;
    super.onInit();
  }

  /// Updates the tasks query and refreshes the tasks
  void updateTasks() async {
    tasksQuery.value = taskService.getNotificationsQuery(
      _uid,
      sortingTaskTag.value,
      filterTaskWithStatusTag.value,
    );
    tasksQuery.refresh();
    refresh();
  }

  /// Adds a new task and its corresponding notification
  void addTaskAndNotification(
      Task task, TaskNotification taskNotification) async {
    // Set the user ID for the task and notification
    task.userId = _uid;
    taskNotification.userId = _uid;

    // Add the task to the database and set the notification's task ID
    taskNotification.taskId = await taskService.addTask(task);

    // Add the notification to the database
    taskNotificationService.addNotification(taskNotification);

    // Refresh the tasks list
    updateTasks();
  }

  /// Toggles the completion state of a task
  void changeStateTask(Task task) async {
    // Toggle the completed state of the task
    task.isCompleted = !task.isCompleted;

    // Get the notification associated with the task
    var notification =
        await taskNotificationService.getNotificationByTaskId(task.id!);

    // Update the notification's state based on the task's completion status
    if (notification != null) {
      if (!task.isCompleted) {
        notification.isShown = false;
        taskNotificationService.updateNotification(notification);
      } else {
        notification.isShown = true;
        taskNotificationService.updateNotification(notification);
      }
    }

    // Update the task in the database
    taskService.updateTask(task);

    // Refresh the tasks list
    updateTasks();
  }

  /// Deletes a task and its corresponding notification
  void deleteTask(Task task) async {
    // Delete the task from the database
    taskService.deleteTask(task.id!);

    // Get and delete the associated notification
    var taskNotification =
        await taskNotificationService.getNotificationByTaskId(task.id!);
    taskNotificationService.deleteNotification(taskNotification!.id!);

    // Refresh the tasks list
    updateTasks();
  }
}
