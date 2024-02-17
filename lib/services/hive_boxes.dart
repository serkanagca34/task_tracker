import 'package:hive/hive.dart';
import 'package:task_tacker/model/task_model.dart';
import 'package:task_tacker/model/theme_model.dart';

late Box gridDesingChangeBox;

Future<void> openBoxAll() async {
  await Hive.openBox<ThemeModel>('theme');
  await Hive.openBox<TaskModel>('tasksBox');
  gridDesingChangeBox = await Hive.openBox('gridDesingChangeBox');
}
