import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_tacker/model/task_model.dart';
import 'package:task_tacker/model/theme_model.dart';
import 'package:task_tacker/services/hive_boxes.dart';
import 'package:task_tacker/services/service_locator.dart';
import 'package:task_tacker/theme/dark_theme.dart';
import 'package:task_tacker/theme/light_theme.dart';
import 'package:task_tacker/view/splash_view.dart';
import 'package:task_tacker/view_model/add_task/add_task_cubit.dart';
import 'package:task_tacker/view_model/fake_api/fake_api_cubit.dart';
import 'package:task_tacker/view_model/theme_cubit.dart';
import 'package:task_tacker/view_model/weather/weather_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // GetIt Initialize
  setupLocator();
  // Hive Initialize
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(ThemeModelAdapter());
  await openBoxAll();
  runApp(TaskTracker());
}

class TaskTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddTaskCubit>(
          create: (context) => locator<AddTaskCubit>(),
        ),
        BlocProvider<WeatherCubit>(
          create: (context) => locator<WeatherCubit>(),
        ),
        BlocProvider<FakeApiCubit>(
          create: (context) => locator<FakeApiCubit>(),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => locator<ThemeCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDarkMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Task Tracker',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: SplashView(),
          );
        },
      ),
    );
  }
}
