import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_tacker/firebase_options.dart';
import 'package:task_tacker/model/language_model.dart';
import 'package:task_tacker/model/task_model.dart';
import 'package:task_tacker/model/theme_model.dart';
import 'package:task_tacker/services/hive_boxes.dart';
import 'package:task_tacker/services/service_locator.dart';
import 'package:task_tacker/theme/dark_theme.dart';
import 'package:task_tacker/theme/light_theme.dart';
import 'package:task_tacker/view/splash_view.dart';
import 'package:task_tacker/view_model/add_task/add_task_cubit.dart';
import 'package:task_tacker/view_model/fake_api/fake_api_cubit.dart';
import 'package:task_tacker/view_model/language_cubit.dart';
import 'package:task_tacker/view_model/theme_cubit.dart';
import 'package:task_tacker/view_model/weather/weather_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // GetIt Initialize
  setupLocator();
  // Hive Initialize
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(ThemeModelAdapter());
  Hive.registerAdapter(LanguageModelAdapter());
  // Hive Open Boxes
  await openBoxAll();
  // EasyLocalization Initialize
  await EasyLocalization.ensureInitialized();
  // Firebase Initialize
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  runApp(
    EasyLocalization(
      supportedLocales: <Locale>[
        const Locale('en', 'US'),
        const Locale('tr', 'TR')
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: BlocProvider(
        create: (context) => LanguageCubit(),
        child: TaskTracker(),
      ),
    ),
  );
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
        BlocProvider<LanguageCubit>(
          create: (context) => locator<LanguageCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDarkMode) {
          return BlocConsumer<LanguageCubit, Locale>(
            listener: (context, state) => context.setLocale(state),
            builder: (context, locale) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Task Tracker',
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                home: SplashView(),
              );
            },
          );
        },
      ),
    );
  }
}
