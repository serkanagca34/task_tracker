import 'package:get_it/get_it.dart';
import 'package:task_tacker/services/rest_api.dart';
import 'package:task_tacker/view_model/add_task/add_task_cubit.dart';
import 'package:task_tacker/view_model/weather/weather_cubit.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Cubits
  locator.registerFactory(() => AddTaskCubit());
  locator.registerFactory(() => WeatherCubit());

  // Rest Api
  locator.registerFactory(() => RestApiData());
}