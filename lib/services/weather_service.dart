import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:weatherapp_exam/models/weather_model.dart';
import 'package:xml/xml.dart';

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  //fetch weather data in json format
  Future<Weather> getWeather(String city) async {
    final response = await http.get(Uri.parse('$BASE_URL?q=$city&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather (JSON)');
    }
  }

  //fetch weather data in xml format
  Future<Weather> getWeatherXml(String city) async {
    final response = await http.get(Uri.parse('$BASE_URL?q=$city&appid=$apiKey&units=metric&mode=xml'));
    if (response.statusCode == 200) {
      Logger().d(response.body);
      return Weather.fromXml(XmlDocument.parse(response.body).rootElement);
    } else {
      throw Exception('Failed to load weather (XML)');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();

    //get permission from the user device
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //fetch current location
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,  // Set the desired accuracy level
      ),
    );

    //convert the location into a list of placemark objects
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    //extract the city name from first placemark
    String? city = "Calumpit";

    return city ?? "";
  }
}