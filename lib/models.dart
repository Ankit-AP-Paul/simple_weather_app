/*
{
  "weather": [
    {
      "description": "moderate rain",
      "icon": "10d"
    }
  ],
  "main": {
    "temp": 298.48,
    "feels_like": 298.74,
    "humidity": 64,
  },
  "wind": {
    "speed": 0.62,
  },
  "name": "Zocca",
}
*/

class WindInfo {
  final double wspeed;

  WindInfo({this.wspeed});

  factory WindInfo.fromJson(Map<String, dynamic> json) {
    final wspeed = json['speed'].toDouble();
    return WindInfo(wspeed: wspeed);
  }
}

class WeatherInfo {
  final String description;
  final String icon;

  WeatherInfo({this.description, this.icon});

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    final description = json['description'];
    final icon = json['icon'];
    return WeatherInfo(description: description, icon: icon);
  }
}

class TemperatureInfo {
  final double temperature;
  final double feelsTemp;
  final int humid;

  TemperatureInfo({this.temperature, this.humid, this.feelsTemp});

  factory TemperatureInfo.fromJson(Map<String, dynamic> json) {
    final temperature = json['temp'].toDouble();
    final humid = json['humidity'];
    final feelsTemp = json['feels_like'].toDouble();
    return TemperatureInfo(
        temperature: temperature, humid: humid, feelsTemp: feelsTemp);
  }
}

class WeatherResponse {
  final String cityName;
  final TemperatureInfo tempInfo;
  final WeatherInfo weatherInfo;
  final WindInfo windInfo;

  String get iconUrl {
    return 'https://openweathermap.org/img/wn/${weatherInfo.icon}@2x.png';
  }

  WeatherResponse({
    this.cityName,
    this.tempInfo,
    this.weatherInfo,
    this.windInfo,
  });

  factory WeatherResponse.fromJSON(Map<String, dynamic> json) {
    final cityName = json['name'];

    final tempInfoJson = json["main"];
    final tempInfo = TemperatureInfo.fromJson(tempInfoJson);

    final weatherInfoJson = json['weather'][0];
    final weatherInfo = WeatherInfo.fromJson(weatherInfoJson);

    final windInfoJson = json['wind'];
    final windInfo = WindInfo.fromJson(windInfoJson);

    return WeatherResponse(
      cityName: cityName,
      tempInfo: tempInfo,
      weatherInfo: weatherInfo,
      windInfo: windInfo,
    );
  }
}
