import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:simple_weather_app/models.dart';

class DataService {
  Future<WeatherResponse> getWeather(String city) async {
    final queryParameters = {
      'q': city,
      'appid': '3b8e6e2d4fd4c5622bfd8c48c9dacd09',
      'units': 'metric'
    };

    final uri = Uri.https(
        'api.openweathermap.org', 'data/2.5/weather', queryParameters);

    final response = await http.get(uri);

    print(response.body);
    final json = jsonDecode(response.body);
    return WeatherResponse.fromJSON(json);
  }
}
