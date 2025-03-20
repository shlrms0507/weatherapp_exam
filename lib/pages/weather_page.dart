import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp_exam/models/weather_model.dart';
import '../services/weather_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  // api key
  final _weatherService = WeatherService('b5b75026b896a08548eb83d49b80624f');
  Weather? _weather;
  bool _useJson = true; // To toggle between JSON and XML

  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();
    try {
      if (_useJson) {
        final weather = await _weatherService.getWeather(cityName);
        setState(() {
          _weather = weather;
        });
      } else {
        final weather = await _weatherService.getWeatherXml(cityName);
        setState(() {
          _weather = weather;
        });
      }
    } catch (e) {
      Logger().e('Error occurred: $e');
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'cloud':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default: 
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    // fetch weather data when the page is initialized
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: Icon(_useJson ? FontAwesomeIcons.fileCode : FontAwesomeIcons.file),
            onPressed: () {
              setState(() {
                _useJson = !_useJson;
              });
              _fetchWeather(); // Re-fetch weather when the format changes
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName ?? 'loading city..'),
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            Text('${_weather?.temperature.round()}°C'),
            Text(_weather?.mainCondition ?? ''),
          ],
        ),
      ),
    );
  }
}