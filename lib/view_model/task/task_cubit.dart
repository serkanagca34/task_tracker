import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:task_tacker/model/task_model.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial()) {
    getTasks();
  }

  List<String> priorityLevels = ['High', 'Medium', 'Low'];

  final String _boxName = 'tasksBox';

  List<TaskModel> displayTask = [];

  void getTasks() async {
    final box = await Hive.openBox<TaskModel>(_boxName);
    List<TaskModel> tasks = [];
    var keys = box.keys;
    int index = 0;
    for (var task in box.values) {
      task.key = keys.elementAt(index) as int?;
      tasks.add(task);
      index++;
    }
    displayTask = tasks;
    emit(TaskLoaded(tasks));
  }

  void addTask(TaskModel task) async {
    final box = await Hive.openBox<TaskModel>(_boxName);
    int key = await box.add(task);
    task.key = key;
    getTasks();
  }

  void updateTask(int key, TaskModel updatedTask) async {
    final box = await Hive.openBox<TaskModel>(_boxName);
    await box.put(key, updatedTask);
    getTasks();
  }

  void deleteTask(int key) async {
    final box = await Hive.openBox<TaskModel>(_boxName);
    await box.delete(key);
    getTasks();
  }

  void toggleTaskCompletion(int key) async {
    final box = await Hive.openBox<TaskModel>(_boxName);
    final TaskModel? task = box.get(key);
    if (task != null) {
      task.isCompleted = !task.isCompleted;
      await box.put(key, task);
      getTasks();
    }
  }

  // List Sorts
  void sortTasksByLastDate() {
    displayTask.sort((a, b) => b.dueDate.compareTo(a.dueDate));
    emit(TaskLoaded(displayTask));
  }

  void sortTasksByCompletion() {
    displayTask.sort((a, b) {
      int aVal = a.isCompleted ? 1 : 0;
      int bVal = b.isCompleted ? 1 : 0;
      return bVal.compareTo(aVal);
    });
    emit(TaskLoaded(displayTask));
  }

  void sortTasksByPriority(String priority) {
    displayTask.sort((a, b) {
      if (a.priorityLevels == priority && b.priorityLevels != priority) {
        return -1;
      } else if (a.priorityLevels != priority && b.priorityLevels == priority) {
        return 1;
      } else {
        return 0;
      }
    });
    emit(TaskLoaded(displayTask));
  }

  // List Filter
  void filterTasks(Set<String> filters) {
    if (filters.isEmpty) {
      emit(TaskLoaded(displayTask));
      return;
    }

    List<TaskModel> filteredTasks = displayTask;

    // 'completed'
    if (filters.contains('completed'.tr())) {
      filteredTasks = filteredTasks.where((task) => task.isCompleted).toList();
    }

    // 'high', 'medium', 'low'
    if (filters.contains('high'.tr()) ||
        filters.contains('medium'.tr()) ||
        filters.contains('low'.tr())) {
      filteredTasks = filteredTasks.where((task) {
        if (filters.contains('high'.tr()) && task.priorityLevels == 'High') {
          return true;
        }
        if (filters.contains('medium'.tr()) &&
            task.priorityLevels == 'Medium') {
          return true;
        }
        if (filters.contains('low'.tr()) && task.priorityLevels == 'Low') {
          return true;
        }
        return false;
      }).toList();
    }

    emit(TaskLoaded(filteredTasks));
  }
}
