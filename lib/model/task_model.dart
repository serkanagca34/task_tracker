// ignore_for_file: must_be_immutable

import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends Equatable {
  int? key;

  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String dueDate;

  @HiveField(3)
  final String priorityLevels;

  @HiveField(4)
  bool isCompleted;

  TaskModel({
    this.key,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priorityLevels,
    this.isCompleted = false,
  });

  @override
  List<Object?> get props =>
      [key, title, description, dueDate, priorityLevels, isCompleted];
}
