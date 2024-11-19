import 'package:flutter/material.dart';

import '../../databasehelper/databasehelper.dart';


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
