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

  TaskModel({
    this.key,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priorityLevels,
  });

  @override
  List<Object> get props => [title, description, dueDate, priorityLevels];
}
