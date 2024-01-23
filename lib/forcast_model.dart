import 'package:flutter/material.dart';

extension WeatherIcon on WeatherType {
  IconData icon() {
    switch (this) {
      case WeatherType.sunny:
        return Icons.wb_sunny_outlined;
      case WeatherType.cloudy:
        return Icons.wb_cloudy_outlined;
      case WeatherType.windy:
        return Icons.air;
    }
  }
}

class City {
  static const String ustka = "Ustka";
  static const String warszawa = "Warszawa";
  static const String gdansk = "Gdańsk";
  static const String krakow = "Kraków";
  static const String poznan = "Poznań";
  static const String zakopane = "Zakopane";
}

enum WeatherType {
  sunny,
  cloudy,
  windy,
}

class Forecast {
  final WeatherType weatherType;
  final int tempCelsius;
  final int humidityPercent;
  final int airQualityIndex;
  final DateTime hour;

  Forecast({
    required this.hour,
    required this.weatherType,
    required this.tempCelsius,
    required this.humidityPercent,
    required this.airQualityIndex,
  });

  String getTemperatureDescription() {
    return "$tempCelsius°";
  }

  String getHumidityDescription() {
    return "$humidityPercent%";
  }

  String getAQIDescription() {
    return "$airQualityIndex";
  }
}

class CityForecast {
  CityForecast(this.city, this.forecast);

  final String city;
  final Forecast forecast;

  int get tempCelsius {
    return forecast.tempCelsius;
  }

  int get airQualityIndex {
    return forecast.airQualityIndex;
  }

  WeatherType get weatherType {
    return forecast.weatherType;
  }

  String getTemperatureDescription() {
    return "${forecast.tempCelsius}°";
  }

  String getHumidityDescription() {
    return "${forecast.humidityPercent}%";
  }

  String getAQIDescription() {
    return "${forecast.airQualityIndex}";
  }
}

/// @param forecasts contains 9 items
/// 1 forecast for the current time and 8 for the next 8 hours
class EightHourCityForecast {
  final String city;
  final List<Forecast> forecasts;

  Forecast get first => forecasts.first;

  EightHourCityForecast(this.city, this.forecasts) {
    assert(forecasts.length == 9);
  }
}
