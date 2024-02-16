import 'package:hive/hive.dart';
import 'package:task_tacker/model/task_model.dart';

late Box horizontalDesingChangeBox;

void openBoxAll() async {
  await Hive.openBox<TaskModel>('tasksBox');
  horizontalDesingChangeBox = await Hive.openBox('horizontalDesingChangeBox');
}
