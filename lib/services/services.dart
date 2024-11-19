// lib/Services/services.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/weather_model.dart';


class WeatherServices {
  Future<WeatherData?> fetchWeather() async {
    final response = await http.get(
      Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=28.5175&lon=81.7787&appid=509079b22fae7e954dff8403ef5eba0e"),
    );

    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return WeatherData.fromJson(json);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}