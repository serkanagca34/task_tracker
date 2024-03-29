import 'package:get_it/get_it.dart';
import 'package:task_tacker/services/rest_api.dart';
import 'package:task_tacker/view_model/task/task_cubit.dart';
import 'package:task_tacker/view_model/fake_api/fake_api_cubit.dart';
import 'package:task_tacker/view_model/language_cubit.dart';
import 'package:task_tacker/view_model/theme_cubit.dart';
import 'package:task_tacker/view_model/weather/weather_cubit.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Cubits
  locator.registerFactory(() => TaskCubit());
  locator.registerFactory(() => WeatherCubit());
  locator.registerFactory(() => FakeApiCubit());
  locator.registerFactory(() => ThemeCubit());
  locator.registerFactory(() => LanguageCubit());

  // Rest Api
  locator.registerFactory(() => RestApiData());
}
