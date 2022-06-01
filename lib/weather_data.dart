
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WeatherData {
  final int weatherValue;
  final int temperature;

  WeatherData(this.weatherValue, this.temperature);

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    var value = json.values;
    var tempWeatherData;
    var tempTemperature;

    if (value.first['wsymb2'] is int) {
      tempWeatherData = value.first['wsymb2'];
    }
    if (value.first['temp'] is double) {
      tempTemperature = value.first['temp'];
    }

    if (tempWeatherData != null && tempTemperature != null) {
      return WeatherData(tempWeatherData, tempTemperature.round());
    } else {
      return WeatherData(0, 0);
    }
  }

  int getCurrentTemperature() {
    return temperature;
  }

  String getCurrentWeatherStatus() {
    String weatherStatus;
    switch (weatherValue) {
      case 0:
        weatherStatus = 'Undefined';
        break;
      case 1:
        weatherStatus = 'Clear sky';
        break;
      case 2:
        weatherStatus = 'Nearly clear sky';
        break;
      case 3:
        weatherStatus = 'Variable cloudiness';
        break;
      case 4:
        weatherStatus = 'Halfclear sky';
        break;
      case 5:
        weatherStatus = 'Cloudy sky';
        break;
      case 6:
        weatherStatus = 'Overcast';
        break;
      case 7:
        weatherStatus = 'Fog';
        break;
      case 8:
        weatherStatus = 'Light rain showers';
        break;
      case 9:
        weatherStatus = 'Moderate rain showers';
        break;
      case 10:
        weatherStatus = 'Heavy rain showers';
        break;
      case 11:
        weatherStatus = 'Thunderstorm';
        break;
      case 12:
        weatherStatus = 'Light sleet showers';
        break;
      case 13:
        weatherStatus = 'Moderate sleet showers';
        break;
      case 14:
        weatherStatus = 'Heavy sleet showers';
        break;
      case 15:
        weatherStatus = 'Light snow showers';
        break;
      case 16:
        weatherStatus = 'Moderate snow showers';
        break;
      case 17:
        weatherStatus = 'Heavy snow showers';
        break;
      case 18:
        weatherStatus = 'Light rain';
        break;
      case 19:
        weatherStatus = 'Moderate rain';
        break;
      case 20:
        weatherStatus = 'Heavy rain';
        break;
      case 21:
        weatherStatus = 'Thunder';
        break;
      default:
        weatherStatus = 'Undefined';
    }
    return weatherStatus;
  }

  Widget getCurrentWeatherIcon() {
    switch (weatherValue) {
      case 1:
        return const Icon(
          Icons.sunny,
          color: Color.fromARGB(255, 255, 161, 19),
        );
      case 2:
        return const Icon(
          Icons.sunny,
          color: Color.fromARGB(255, 255, 161, 19),
        );
      case 3:
        return const FaIcon(FontAwesomeIcons.cloudSun);
      case 4:
        return const FaIcon(FontAwesomeIcons.cloudSun);
      case 5:
        return const FaIcon(FontAwesomeIcons.cloud);
      case 6:
        return const FaIcon(FontAwesomeIcons.cloud);
      case 7:
        return const FaIcon(FontAwesomeIcons.smog);
      case 8:
        return const FaIcon(FontAwesomeIcons.umbrella);
      case 9:
        return const FaIcon(FontAwesomeIcons.cloudRain);
      case 10:
        return const FaIcon(FontAwesomeIcons.cloudShowersHeavy);
      case 11:
        return const FaIcon(FontAwesomeIcons.cloudflare);
      case 12:
        return const FaIcon(FontAwesomeIcons.cloudRain);
      case 13:
        return const FaIcon(FontAwesomeIcons.cloudShowersHeavy);
      case 14:
        return const FaIcon(FontAwesomeIcons.cloudShowersHeavy);
      case 15:
        return const FaIcon(FontAwesomeIcons.snowflake);
      case 16:
        return const FaIcon(FontAwesomeIcons.snowflake);
      case 17:
        return const FaIcon(FontAwesomeIcons.snowflake);
      case 18:
        return const FaIcon(FontAwesomeIcons.cloudRain);
      case 19:
        return const FaIcon(FontAwesomeIcons.cloudRain);
      case 20:
        return const FaIcon(FontAwesomeIcons.cloudShowersHeavy);
      case 21:
        return const FaIcon(FontAwesomeIcons.bolt);
      default:
        return const FaIcon(FontAwesomeIcons.times);
    }
  }



}