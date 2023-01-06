import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:simple_weather_app/models.dart';

class DataService {
  Future<WeatherResponse> getWeather(String city) async {
    const Map<String, String> headers = {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36'
    };
    final queryParameters = {
      'q': city,
      'appid': '3b8e6e2d4fd4c5622bfd8c48c9dacd09',
      'units': 'metric'
    };

    final uri = Uri.https(
        'api.openweathermap.org', 'data/2.5/weather', queryParameters);

    final response = await http.get(uri, headers: headers);

    // print(response.body);
    final json = jsonDecode(response.body);
    return WeatherResponse.fromJSON(json);
  }
}
