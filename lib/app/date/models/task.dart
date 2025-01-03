import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

/// Represents a task in the task organizer system.
@JsonSerializable()
class Task {
  /// Unique identifier of the task, generated by Firestore.
  String? id;

  /// Identifier of the user who owns the task.
  String userId;

  /// Name of the task.
  String name;

  /// Description or additional details about the task.
  String description;

  /// Indicates whether the task is completed.
  bool isCompleted;

  /// The deadline or end date of the task.
  /// This field is stored in Firestore as a Timestamp.
  @JsonKey(fromJson: _fromTimestamp, toJson: _toTimestamp)
  DateTime endDate;

  /// The date and time when the task was created.
  /// This field is stored in Firestore as a Timestamp.
  @JsonKey(fromJson: _fromTimestamp, toJson: _toTimestamp)
  DateTime creationDate;

  /// Constructs a new Task instance.
  Task({
    this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.isCompleted,
    required this.endDate,
    required this.creationDate,
  });

  /// Creates a Task object from a JSON map.
  /// This method is automatically generated by the `json_serializable` package.
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  /// Converts a Task object to a JSON map.
  /// This method is automatically generated by the `json_serializable` package.
  Map<String, dynamic> toJson() => _$TaskToJson(this);

  /// Converts a Firestore Timestamp to a Dart DateTime object.
  static DateTime _fromTimestamp(dynamic timestamp) =>
      (timestamp as Timestamp).toDate();

  /// Converts a Dart DateTime object to a Firestore Timestamp.
  static dynamic _toTimestamp(DateTime dateTime) =>
      Timestamp.fromDate(dateTime);
}
