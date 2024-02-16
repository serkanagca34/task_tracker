import 'package:get_it/get_it.dart';
import 'package:task_tacker/services/rest_api.dart';

final locator = GetIt.instance;

void setupGetItLocator() {
  locator.registerFactory<RestApiData>(() => RestApiData());
}
