// lib/Controllers/weather_controller.dart

import 'package:get/get.dart';

import '../model/weather_model.dart';
import '../services/services.dart';


class WeatherController extends GetxController {
  var weatherInfo = WeatherData(
    name: '',
    temperature: Temperature(current: 0.0),
    humidity: 0,
    wind: Wind(speed: 0.0),
    maxTemperature: 0,
    minTemperature: 0,
    pressure: 0,
    seaLevel: 0,
    weather: [],
  ).obs;

  var isLoading = true.obs;

  void fetchWeather() async {
    isLoading(true);
    try {
      var data = await WeatherServices().fetchWeather();
      if (data != null) {
        weatherInfo.value = data;
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    fetchWeather();
    super.onInit();
  }
}
