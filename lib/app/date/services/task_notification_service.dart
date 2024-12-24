import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:taskorganizer/app/date/models/task_notification.dart';
import 'package:taskorganizer/app/date/services/auth_service.dart';

/// Service class for managing task notifications in the Firestore database.
/// This class handles CRUD operations, unread notifications, and real-time updates.
class TaskNotificationService {
  /// Firestore instance for accessing the database.
  final FirebaseFirestore firestore;

  /// Firestore collection reference for task notifications.
  late CollectionReference<TaskNotification> collection;

  /// Observable count of unread notifications.
  final RxInt unreadCount = 0.obs;

  /// Authentication service instance for managing user sessions.
  final AuthServices authServices;

  /// Subscription to track changes in unread notifications.
  StreamSubscription<QuerySnapshot<TaskNotification>>? _unreadCountSubscription;

  /// Subscription to listen to user ID changes.
  StreamSubscription<String?>? _userIdSubscription;

  /// Constructor to initialize the service with Firestore and AuthServices.
  TaskNotificationService(this.firestore, this.authServices);

  /// Initializes the service by setting up the collection and listeners.
  Future<TaskNotificationService> onInit() async {
    collection = firestore
        .collection('taskNotifications')
        .withConverter<TaskNotification>(
      fromFirestore: (snapshot, _) =>
      TaskNotification.fromJson(snapshot.data()!)..id = snapshot.id,
      toFirestore: (notification, _) => notification.toJson(),
    );
    await setUserNotificationListener();

    _userIdSubscription =
        authServices.uid.listen((_) => setUserNotificationListener());

    return this;
  }

  /// Sets up a real-time listener for unread notifications for the current user.
  Future<void> setUserNotificationListener() async {
    Query<TaskNotification> unreadQuery = collection
        .where('userId', isEqualTo: authServices.uid.value)
        .where('isShown', isEqualTo: false)
        .where('timeReceipt', isLessThan: DateTime.now());

    AggregateQuerySnapshot snapshot = await unreadQuery.count().get();
    unreadCount.value = snapshot.count ?? 0;

    _unreadCountSubscription =
        unreadQuery.snapshots().listen((QuerySnapshot<TaskNotification> event) {
          unreadCount.value = event.docs.length;
        });
  }

  /// Adds a new notification to the database.
  /// Returns a reference to the newly created document.
  Future<DocumentReference<TaskNotification>> addNotification(
      TaskNotification notification) async {
    return await collection.add(notification);
  }

  /// Retrieves all notifications for a specific user.
  /// Returns a list of notifications for the user.
  Future<List<TaskNotification>> getNotificationsByUserId(String userId) async {
    var querySnapshot =
    await collection.where('userId', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Retrieves a notification by its associated task ID.
  /// Returns the corresponding notification or `null` if not found.
  Future<TaskNotification?> getNotificationByTaskId(String taskId) async {
    var querySnapshot =
    await collection.where('taskId', isEqualTo: taskId).limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    }
    return null;
  }

  /// Deletes a notification by its ID.
  Future<void> deleteNotification(String notificationId) async {
    await collection.doc(notificationId).delete();
  }

  /// Deletes all notifications for a specific user.
  Future<void> deleteAllNotificationsByUserId(String userId) async {
    var querySnapshot =
    await collection.where('userId', isEqualTo: userId).get();
    var batch = firestore.batch();

    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  /// Constructs a query to fetch notifications for a specific user.
  /// Returns a query for retrieving the user's notifications.
  Query<TaskNotification> getNotificationsQuery(String userId) {
    var query = collection
        .where('userId', isEqualTo: userId)
        .where('timeReceipt', isLessThan: DateTime.now())
        .orderBy('isShown')
        .orderBy('timeReceipt', descending: true);
    return query;
  }

  /// Updates an existing notification in the database.
  /// Throws an exception if the notification ID is null.
  Future<void> updateNotification(TaskNotification notification) async {
    if (notification.id != null) {
      await collection.doc(notification.id).update(notification.toJson());
    } else {
      throw Exception('Notification ID cannot be null for update.');
    }
  }
}
