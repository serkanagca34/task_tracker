import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_tacker/model/task_model.dart';
import 'package:task_tacker/services/hiveBoxes.dart';
import 'package:task_tacker/services/locator.dart';
import 'package:task_tacker/view/splash_view.dart';
import 'package:task_tacker/view_model/add_task/add_task_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // GetIt Initialize
  setupGetItLocator();
  // Hive Initialize
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(TaskModelAdapter());
  openBoxAll();
  runApp(TaskTracker());
}

class TaskTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddTaskCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Tracker',
        home: SplashView(),
      ),
    );
  }
}
