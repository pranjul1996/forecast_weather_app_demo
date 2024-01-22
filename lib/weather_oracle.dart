import 'dart:async';

import 'forcast_model.dart';

import 'emitters.dart';

class WeatherOracle {
  WeatherOracle._(this._emitter);

  final IForecastEmitter _emitter;

  factory WeatherOracle() {
    return WeatherOracle._(ForecastEmitter());
  }

  factory WeatherOracle.withEmitter(IForecastEmitter emitter) {
    return WeatherOracle._(emitter);
  }

  List<EightHourCityForecast> getCurrentALlCities8HourForecasts() {
    return _emitter.getCurrentALlCities8HourForecasts();
  }

  EightHourCityForecast getCurrent8HourForecast(String city) {
    return _emitter.getCurrent8HourForecast(city);
  }

  void dispose() {
    _emitter.dispose();
  }

  Stream<EightHourCityForecast> get8HourCityForecastStream(String city) {
    return _emitter.getForecastStreamFor(city);
  }

  Stream<List<EightHourCityForecast>> getAllCitiesForecastStream() {
    return _emitter.getAllCitiesForecastStream();
  }
}
