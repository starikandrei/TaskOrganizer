import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskorganizer/app/date/models/task.dart';
import 'package:taskorganizer/generated/locales.g.dart';

/// Service class for managing tasks in the Firestore database.
/// Provides methods for CRUD operations and task queries.
class TaskService {
  /// Firestore instance for accessing the database.
  final FirebaseFirestore firestore;

  /// Firestore collection reference for task objects.
  late CollectionReference<Task> collection;

  /// Constructor to initialize the service with a Firestore instance.
  TaskService(this.firestore);

  /// Initializes the service by setting up the task collection.
  /// Returns an instance of `TaskService` after initialization.
  Future<TaskService> onInit() async {
    collection = firestore.collection('tasks').withConverter<Task>(
          fromFirestore: (snapshot, _) =>
              Task.fromJson(snapshot.data()!)..id = snapshot.id,
          toFirestore: (task, _) => task.toJson(),
        );
    return this;
  }

  /// Adds a new task to the Firestore collection.
  /// Returns the ID of the newly created task document.
  Future<String> addTask(Task task) async {
    var doc = await collection.add(task);
    return doc.id;
  }

  /// Updates an existing task in the Firestore collection.
  /// Performs no operation if the task ID is null.
  Future<void> updateTask(Task task) async {
    if (task.id != null) {
      await collection.doc(task.id).update(task.toJson());
    }
  }

  /// Retrieves all tasks for a specific user from the Firestore collection.
  /// Returns a list of `Task` objects.
  Future<List<Task>> getTasks(String userId) async {
    var querySnapshot =
        await collection.where('userId', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Constructs a query to retrieve tasks with optional sorting and filtering.
  /// Returns a `Query<Task>` object based on the parameters.
  Query<Task> getNotificationsQuery(
    String userId,
    String sortingTask,
    bool? filter,
  ) {
    var query = collection.where('userId', isEqualTo: userId);

    // Apply filter for task completion status.
    switch (filter) {
      case true:
        query = query.where("isCompleted", isEqualTo: true);
      case false:
        query = query.where("isCompleted", isEqualTo: false);
      default:
        break;
    }

    // Apply sorting criteria.
    switch (sortingTask) {
      case LocaleKeys.byCreationDate:
        query = query.orderBy('creationDate', descending: true);
      case LocaleKeys.byCompletionDate:
        query = query.orderBy('endDate', descending: true);
      default:
        break;
    }
    return query;
  }

  /// Deletes a task from the Firestore collection by its document ID.
  Future<void> deleteTask(String taskId) async {
    await collection.doc(taskId).delete();
  }

  /// Deletes all tasks associated with a specific user from the Firestore collection.
  /// Performs a batch delete operation for efficiency.
  Future<void> deleteAllTasksByUserId(String userId) async {
    var querySnapshot =
        await collection.where('userId', isEqualTo: userId).get();
    var batch = firestore.batch();

    // Add delete operations to the batch.
    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }

    // Commit the batch delete.
    await batch.commit();
  }
}
