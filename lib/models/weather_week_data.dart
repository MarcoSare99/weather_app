import 'package:weather_app/models/data.dart';
import 'package:weather_app/models/weather.dart';

class WeatherWeekData {
  List<Weather> weather;
  Data main;
  String date;

  WeatherWeekData(
      {required this.weather, required this.main, required this.date});

  factory WeatherWeekData.fromJson(Map<String, dynamic> json) {
    return WeatherWeekData(
        weather: (json['weather'] as List)
            .map((item) => Weather.fromJson(item))
            .toList(),
        main: Data.fromJson(json['main']),
        date: json['dt_txt']);
  }
}
