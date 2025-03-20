import 'package:xml/xml.dart';

class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;

  Weather({required this.cityName, required this.temperature, required this.mainCondition});

  // Deserialize from JSON
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }

  // Deserialize from XML
  factory Weather.fromXml(XmlElement xml) {
    // Extract the city name from the city element
    final cityName = xml.findElements('city').single.getAttribute('name') ?? 'Unknown City';

    // Extract the temperature value from the temperature element
    final temperatureValue = xml.findElements('temperature').single.getAttribute('value');
    final temperature = temperatureValue != null ? double.tryParse(temperatureValue) ?? 0.0 : 0.0;

    // Extract the weather condition from the weather element
    final mainCondition = xml.findElements('weather').single.getAttribute('value') ?? 'Unknown Condition';

    return Weather(
      cityName: cityName, 
      temperature: temperature, 
      mainCondition: mainCondition
    );
  }
}