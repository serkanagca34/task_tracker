import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:task_tacker/model/theme_model.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit()
      : super(Hive.box<ThemeModel>('theme')
            .get('isDarkMode', defaultValue: ThemeModel(isDarkMode: false))!
            .isDarkMode);

  void toggleTheme() {
    final box = Hive.box<ThemeModel>('theme');
    final currentTheme =
        box.get('isDarkMode', defaultValue: ThemeModel(isDarkMode: false));
    final isDarkMode = !currentTheme!.isDarkMode;
    box.put('isDarkMode', ThemeModel(isDarkMode: isDarkMode));
    emit(isDarkMode);
  }
}
