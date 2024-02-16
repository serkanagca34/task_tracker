import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_tacker/model/weather_model.dart';

class RestApiData {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather?';

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
}
