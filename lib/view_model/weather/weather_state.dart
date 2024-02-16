part of 'weather_cubit.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

final class WeatherInitial extends WeatherState {}

final class WeatherLoading extends WeatherState {
  final bool isLoading;
  WeatherLoading({required this.isLoading});
}

final class WeatherError extends WeatherState {
  final String errorMessage;
  WeatherError({required this.errorMessage});
}

final class WeatherSuccess extends WeatherState {
  final WeatherModel weatherData;
  WeatherSuccess({required this.weatherData});

  @override
  List<Object> get props => [weatherData];
}
