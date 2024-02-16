import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_tacker/model/weather_model.dart';
import 'package:task_tacker/services/geolocator.dart';
import 'package:task_tacker/services/rest_api.dart';
import '../../services/service_locator.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final RestApiData _api = locator<RestApiData>();

  bool _isLoading = false;

  String _apiKey = 'd45dd178758024cbfe32f05673a41ad8';

  WeatherCubit() : super(WeatherInitial()) {
    getWeatherData();
  }

  Future getWeatherData() async {
    String _city = await getCurrentCity();
    changeIsLoading();
    final WeatherModel response = await _api.getWeatherData(_city, _apiKey);
    changeIsLoading();

    if (response.cod == 200) {
      emit(WeatherSuccess(weatherData: response));
    } else {
      emit(WeatherError(errorMessage: 'Error'));
    }
  }

  void changeIsLoading() {
    _isLoading = !_isLoading;
    emit(WeatherLoading(isLoading: _isLoading));
  }
}
