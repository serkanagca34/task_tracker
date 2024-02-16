part of 'add_task_cubit.dart';

@immutable
abstract class AddTaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddTaskInitial extends AddTaskState {}

class AddTaskLoading extends AddTaskState {
  final bool isLoading;
  AddTaskLoading({required this.isLoading});
}

class AddTaskError extends AddTaskState {
  final String errorMessage;
  AddTaskError({required this.errorMessage});
}

class AddTaskLoaded extends AddTaskState {
  final List<TaskModel> tasks;
  AddTaskLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}
