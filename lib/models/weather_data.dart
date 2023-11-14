import 'package:weather_app/models/coord.dart';
import 'package:weather_app/models/data.dart';
import 'package:weather_app/models/sys.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/weather_week_data.dart';
import 'package:weather_app/models/wind.dart';

class WeatherData {
  Coord coord;
  List<Weather> weather;
  String base;
  Data main;
  int visibility;
  Wind wind;
  Map<String, dynamic> clouds;
  int dt;
  Sys sys;
  int timezone;
  int id;
  String name;
  int cod;
  List<WeatherWeekData> listWeek;

  WeatherData({
    required this.coord,
    required this.weather,
    required this.base,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.clouds,
    required this.dt,
    required this.sys,
    required this.timezone,
    required this.id,
    required this.name,
    required this.cod,
    required this.listWeek,
  });

  factory WeatherData.fromJson(
      Map<String, dynamic> json, Map<String, dynamic> dataWeek) {
    return WeatherData(
        coord: Coord.fromJson(json['coord']),
        weather: (json['weather'] as List)
            .map((item) => Weather.fromJson(item))
            .toList(),
        base: json['base'],
        main: Data.fromJson(json['main']),
        visibility: json['visibility'],
        wind: Wind.fromJson(json['wind']),
        clouds: json['clouds'],
        dt: json['dt'],
        sys: Sys.fromJson(json['sys']),
        timezone: json['timezone'],
        id: json['id'],
        name: json['name'],
        cod: json['cod'],
        listWeek: (dataWeek['list'] as List)
            .map((item) => WeatherWeekData.fromJson(item))
            .toList());
  }
}
