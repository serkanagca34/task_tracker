import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_tacker/model/fake_api/fake_api_model.dart';
import 'package:task_tacker/model/weather_model.dart';

class RestApiData {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather?';

  static const _baseUrl2 =
      'https://65cfb5a3bdb50d5e5f5bc0eb.mockapi.io/tasktracker/taskDB';

  // Get Weather Data
  Future<WeatherModel> getWeatherData(String city, apiKey) async {
    final response =
        await http.get(Uri.parse('${_baseUrl}q=$city&APPID=$apiKey'));

    if (response.statusCode == 200) {
      print('Weather Response Succes : ${response.body}');
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      print('Weather Response Error : ${response.body}');
      return WeatherModel.fromJson(jsonDecode(response.body));
    }
  }

  // Get Fake Api Data
  Future<List<FakeApiModel>> getFakeApiData() async {
    final response = await http.get(Uri.parse('$_baseUrl2'));

    if (response.statusCode == 200) {
      print('FakeApi Response Success: ${response.body}');
      Iterable l = json.decode(response.body);
      List<FakeApiModel> models = List<FakeApiModel>.from(l.map(
          (model) => FakeApiModel.fromJson(model as Map<String, dynamic>)));
      return models;
    } else {
      print('FakeApi Response Error: ${response.body}');
      throw Exception('Failed to load fake api data');
    }
  }

  // Helper function to create HTTP requests
  http.Request createRequest(String method, String url,
      [Map<String, dynamic>? body]) {
    var request = http.Request(method, Uri.parse(url));
    request.headers.addAll({'Content-Type': 'application/json'});
    if (body != null) {
      request.body = json.encode(body);
    }
    return request;
  }

  // Common response processing for POST, PUT and DELETE
  Future handleResponse(http.StreamedResponse response) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return await response.stream.bytesToString();
    } else {
      throw Exception('Failed: ${response.reasonPhrase}');
    }
  }

  // Post Fake Api Data
  Future postFakeApiData(
      String title, String description, String duedate, String priority) async {
    var request = createRequest('POST', _baseUrl2, {
      "title": title,
      "description": description,
      "duedate": duedate,
      "priority": priority,
    });
    try {
      var response = await request.send();
      print('Fake Api Post Success: ${await handleResponse(response)}');
    } catch (e) {
      print('Fake Api Post Error: $e');
    }
  }

  // Put Fake Api Data
  Future putFakeApiData(String title, String description, String duedate,
      String priority, String ID) async {
    var request = createRequest('PUT', _baseUrl2 + '/' + ID, {
      "title": title,
      "description": description,
      "duedate": duedate,
      "priority": priority,
    });

    try {
      var response = await request.send();
      print('Fake Api Put Success: ${await handleResponse(response)}');
    } catch (e) {
      print('Fake Api Put Error: $e');
    }
  }

  // Delete Fake Api Data
  Future deleteFakeApiData(String ID) async {
    var request = createRequest('DELETE', '$_baseUrl2/$ID');
    try {
      var response = await request.send();
      print('Fake Api Delete Success: ${await handleResponse(response)}');
    } catch (e) {
      print('Fake Api Delete Error: $e');
    }
  }
}
