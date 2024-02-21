import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_tacker/model/fake_api/fake_api_model.dart';
import 'package:task_tacker/services/rest_api.dart';
import 'package:task_tacker/services/service_locator.dart';

part 'fake_api_state.dart';

class FakeApiCubit extends Cubit<FakeApiState> {
  FakeApiCubit() : super(FakeApiInitial()) {
    // Get fake api
    getFakeApiData();
  }

  final _api = locator<RestApiData>();

  bool _isLoading = false;

  // Get Data
  Future<List<FakeApiModel>> getFakeApiData() async {
    changeIsLoading();
    try {
      final List<FakeApiModel> response = await _api.getFakeApiData();
      changeIsLoading();
      emit(FakeApiSuccess(fakeApiData: response));
      return response;
    } catch (e) {
      changeIsLoading();
      emit(FakeApiError(errorMessage: e.toString()));
      return [];
    }
  }

  // Post Data
  Future postFakeApiData(
      String title, String description, String duedate, String priority) async {
    changeIsLoading();
    await _api.postFakeApiData(title, description, duedate, priority);
    changeIsLoading();
    getFakeApiData();
  }

  // Put Data
  Future putFakeApiData(String id, String title, String description,
      String duedate, String priority) async {
    changeIsLoading();
    await _api.putFakeApiData(id, title, description, duedate, priority);
    changeIsLoading();
    getFakeApiData();
  }

  // Delete Data
  Future deleteFakeApiData(String id) async {
    changeIsLoading();
    await _api.deleteFakeApiData(id);
    changeIsLoading();
    getFakeApiData();
  }

  void changeIsLoading() {
    _isLoading = !_isLoading;
    emit(FakeApiLoading(isLoading: _isLoading));
  }
}
