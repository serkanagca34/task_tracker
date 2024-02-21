part of 'task_cubit.dart';

@immutable
abstract class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {
  final bool isLoading;
  TaskLoading({required this.isLoading});
}

class TaskError extends TaskState {
  final String errorMessage;
  TaskError({required this.errorMessage});
}

class TaskLoaded extends TaskState {
  final List<TaskModel> tasks;
  TaskLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}
