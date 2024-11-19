# assignment3

Weather App
A Flutter application that fetches weather data from the OpenWeather API and displays the current weather conditions, including temperature, humidity, wind speed, pressure, and more. The app saves the fetched data offline using SQLite for persistence and allows viewing of the weather even when the app is offline.

![WhatsApp Image 2024-11-19 at 02 31 45_62624983](https://github.com/user-attachments/assets/2893a90a-aae7-4d92-aa19-43fa067d2c8c)
![WhatsApp Image 2024-11-19 at 02 31 45_2e95c6c2](https://github.com/user-attachments/assets/e60b2623-cca7-402d-a62e-a20f06f46abe)


Features
Fetch weather data from the OpenWeather API using latitude and longitude.
Display weather information such as:
City name
Temperature
Humidity
Wind speed
Maximum and minimum temperatures
Atmospheric pressure
Sea level pressure
Save fetched weather data offline using SQLite.
Display saved weather data when the app is offline.
Technologies Used
Flutter
SQLite: Offline data storage
HTTP: For API integration with OpenWeather API
Provider: State management (optional, if used)
API Reference
Base URL: https://api.openweathermap.org/data/2.5/weather?lat=28.5175&lon=81.7787&appid=509079b22fae7e954dff8403ef5eba0e
