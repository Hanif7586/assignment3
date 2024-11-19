import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../databasehelper/databasehelper.dart';
import '../../model/weather_model.dart';
import '../../weather_controller/weather_controller.dart';


class WeatherHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WeatherController weatherController = Get.put(WeatherController());

    String formattedDate = DateFormat('EEEE d, MMMM yyyy').format(DateTime.now());
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFF676BD0),
      appBar: AppBar(
        title: Text('Weather App'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Save weather data to SQLite when the save icon is clicked
              if (weatherController.weatherInfo.value.name.isNotEmpty) {
                DatabaseHelper.instance.saveWeather(
                  weatherController.weatherInfo.value.name,
                  weatherController.weatherInfo.value.temperature.current,
                );
                Get.snackbar("Saved", "Weather data saved!");
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              // Navigate to the SavedWeatherView screen when the list icon is clicked
              Get.to(SavedWeatherView());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Obx(
                    () => weatherController.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : WeatherDetail(
                  weather: weatherController.weatherInfo.value,
                  formattedDate: formattedDate,
                  formattedTime: formattedTime,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherDetail extends StatelessWidget {
  final WeatherData weather;
  final String formattedDate;
  final String formattedTime;

  const WeatherDetail({
    required this.weather,
    required this.formattedDate,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          weather.name,
          style: const TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "${weather.temperature.current.toStringAsFixed(2)}°C",
          style: const TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (weather.weather.isNotEmpty)
          Text(
            weather.weather[0].main,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        const SizedBox(height: 30),
        Text(
          formattedDate,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          formattedTime,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        // Add weather icon here
        Container(
          height: 100,
          width: 200,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/cloudy.png"),
            ),
          ),
        ),
        const SizedBox(height: 30),
        // More detailed weather information
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _WeatherInfoCard(title: "Wind", value: "${weather.wind.speed} km/h"),
                    _WeatherInfoCard(title: "Max", value: "${weather.maxTemperature.toStringAsFixed(2)}°C"),
                    _WeatherInfoCard(title: "Min", value: "${weather.minTemperature.toStringAsFixed(2)}°C"),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _WeatherInfoCard(title: "Humidity", value: "${weather.humidity}%"),
                    _WeatherInfoCard(title: "Pressure", value: "${weather.pressure} hPa"),
                    _WeatherInfoCard(title: "Sea-Level", value: "${weather.seaLevel} m"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WeatherInfoCard extends StatelessWidget {
  final String title;
  final String value;

  const _WeatherInfoCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

// New Screen to show saved weather data
class SavedWeatherView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Weather Data"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.getSavedWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text("No saved weather data"));
          }

          // Display the list of saved weather data
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var weather = snapshot.data![index];
              return ListTile(
                title: Text(weather['name']),
                subtitle: Text("${weather['temperature']}°C"),
              );
            },
          );
        },
      ),
    );
  }
}
