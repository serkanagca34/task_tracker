import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:task_tacker/model/task_model.dart';

part 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  AddTaskCubit() : super(AddTaskInitial());

  final String _boxName = 'tasksBox';

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
    emit(AddTaskLoaded(tasks));
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
    var tasks = (state as AddTaskLoaded).tasks;
    tasks.sort((a, b) => b.dueDate.compareTo(a.dueDate));
    emit(AddTaskLoaded(tasks));
  }

  void sortTasksByCompletion() {
    var tasks = (state as AddTaskLoaded).tasks;
    tasks.sort((a, b) {
      int aVal = a.isCompleted ? 1 : 0;
      int bVal = b.isCompleted ? 1 : 0;
      return bVal.compareTo(aVal);
    });
    emit(AddTaskLoaded(tasks));
  }

  void sortTasksByPriority(String priority) {
    var tasks = (state as AddTaskLoaded).tasks;
    tasks.sort((a, b) {
      if (a.priorityLevels == priority && b.priorityLevels != priority) {
        return -1;
      } else if (a.priorityLevels != priority && b.priorityLevels == priority) {
        return 1;
      } else {
        return 0;
      }
    });
    emit(AddTaskLoaded(tasks));
  }
}
