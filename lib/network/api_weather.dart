import 'dart:async';
import 'dart:convert';
//import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_data.dart';

class ApiWeather {
  Future<WeatherData?> getWeatherData(
      {required double lat, required double lon}) async {
    Uri url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=1944bad8597f889df19a1404106cf509&lang=es&units=metric");
    //var result = await http.get(url);
    var result = await Future.wait(
        [http.get(url), getWeatherWeekData(lat: lat, lon: lon)]);
    var httpResponse = result[0] as http.Response;

    if (httpResponse.statusCode == 200) {
      var datos = json.decode(httpResponse.body);
      return WeatherData.fromJson(datos, result[1] as Map<String, dynamic>);
    }
    throw Exception('Error al cargar los datos');
  }

  Future<Map<String, dynamic>> getWeatherWeekData(
      {required double lat, required double lon}) async {
    Uri url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=1944bad8597f889df19a1404106cf509&lang=es&units=metric");
    var result = await http.get(url);
    if (result.statusCode == 200) {
      var datos = json.decode(result.body);
      //print(datos);
      return datos;
    }
    throw Exception('Error al cargar los datos');
  }

  Future<WeatherData?> getWeather() async {
    String jsonString = await rootBundle.loadString('assets/response.json');
    Map<String, dynamic> data = json.decode(jsonString);

    String jsonStringWeek =
        await rootBundle.loadString('assets/response_week.json');
    Map<String, dynamic> dataWeek = json.decode(jsonStringWeek);

    return WeatherData.fromJson(data, dataWeek);
  }
}
