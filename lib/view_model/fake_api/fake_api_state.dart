part of 'fake_api_cubit.dart';

sealed class FakeApiState extends Equatable {
  const FakeApiState();

  @override
  List<Object> get props => [];
}

final class FakeApiInitial extends FakeApiState {}

final class FakeApiLoading extends FakeApiState {
  final bool isLoading;
  FakeApiLoading({required this.isLoading});
}

final class FakeApiError extends FakeApiState {
  final String errorMessage;
  FakeApiError({required this.errorMessage});
}

final class FakeApiSuccess extends FakeApiState {
  final List<FakeApiModel> fakeApiData;
  FakeApiSuccess({required this.fakeApiData});

  @override
  List<Object> get props => [fakeApiData];
}
