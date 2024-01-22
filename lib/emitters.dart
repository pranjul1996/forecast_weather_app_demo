import 'dart:async';

import 'forcast_model.dart';

abstract class IForecastEmitter {
  Stream<EightHourCityForecast> getForecastStreamFor(String city);

  EightHourCityForecast getCurrent8HourForecast(String city);

  Stream<List<EightHourCityForecast>> getAllCitiesForecastStream();

  List<EightHourCityForecast> getCurrentALlCities8HourForecasts();

  void dispose();
}

abstract class EightHourForecastStreamer {
  Stream<EightHourCityForecast> get stream;

  void dispose();
}

Forecast nextForecast(Forecast forecast, {bool addHour = true}) {
  final newForecast = Forecast(
      hour: addHour ? forecast.hour.add(Duration(hours: 1)) : forecast.hour,
      weatherType: forecast.weatherType,
      tempCelsius: 15 + ((forecast.tempCelsius - 16) % 20),
      humidityPercent: 30 + ((forecast.humidityPercent - 33) % 70),
      airQualityIndex: 30 + ((forecast.airQualityIndex + 31) % 66));
  return newForecast;
}

EightHourCityForecast next8HoursForecasts(String city, Forecast forecast) {
  final modified = nextForecast(forecast, addHour: false);
  final ret = List.of([modified]);
  var currForecast = modified;
  for (var i = 1; i <= 8; i++) {
    final newForecast = nextForecast(currForecast);
    ret.add(newForecast);
    currForecast = newForecast;
  }
  return EightHourCityForecast(city, ret);
}

class City8HourForecastEmitter implements EightHourForecastStreamer {
  final _controller = StreamController<EightHourCityForecast>.broadcast();

  Stream<EightHourCityForecast> get stream => _controller.stream;

  // initial forecasts
  EightHourCityForecast _eightHourCityForecast;
  late Timer _timer;

  City8HourForecastEmitter(this._eightHourCityForecast) {
    initStream();
  }

  void initStream() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final nextEightHours = next8HoursForecasts(
          _eightHourCityForecast.city, _eightHourCityForecast.forecasts.first);
      _eightHourCityForecast = nextEightHours;
      _controller.sink.add(nextEightHours);
    });
  }

  void dispose() {
    _timer.cancel();
    _controller.close();
  }
}

class ForecastEmitter implements IForecastEmitter {
  late final Map<String, EightHourCityForecast> forecasts;
  final Map<String, EightHourForecastStreamer?> emitters = {};
  final Set<String> citiesUpdated = Set();
  final controller = StreamController<List<EightHourCityForecast>>.broadcast();

  ForecastEmitter() {
    final DateTime now = DateTime.now();
    List<CityForecast> currentForecasts = [
      CityForecast(
          City.ustka,
          Forecast(
            hour: now,
            weatherType: WeatherType.sunny,
            tempCelsius: 24,
            humidityPercent: 58,
            airQualityIndex: 7,
          )),
      CityForecast(
          City.gdansk,
          Forecast(
            hour: now,
            weatherType: WeatherType.sunny,
            tempCelsius: 26,
            humidityPercent: 60,
            airQualityIndex: 36,
          )),
      CityForecast(
          City.warszawa,
          Forecast(
            hour: now,
            weatherType: WeatherType.sunny,
            tempCelsius: 35,
            humidityPercent: 50,
            airQualityIndex: 37,
          )),
      CityForecast(
          City.krakow,
          Forecast(
            hour: now,
            weatherType: WeatherType.cloudy,
            tempCelsius: 33,
            humidityPercent: 54,
            airQualityIndex: 86,
          )),
      CityForecast(
          City.poznan,
          Forecast(
            hour: now,
            weatherType: WeatherType.cloudy,
            tempCelsius: 28,
            humidityPercent: 51,
            airQualityIndex: 51,
          )),
      CityForecast(
          City.zakopane,
          Forecast(
            hour: now,
            weatherType: WeatherType.windy,
            tempCelsius: 25,
            humidityPercent: 59,
            airQualityIndex: 32,
          ))
    ];
    forecasts = Map.fromIterable(currentForecasts,
        key: (cityForecast) => cityForecast.city,
        value: (cityForecast) =>
            next8HoursForecasts(cityForecast.city, cityForecast.forecast));
    initStreams();
  }

  void initStreams() {
    for (var cityForecast in forecasts.values) {
      emitters[cityForecast.city] = City8HourForecastEmitter(cityForecast);
      emitters[cityForecast.city]?.stream.listen((EightHourCityForecast ehf) {
        // update current forecast
        forecasts[cityForecast.city] = ehf;
        citiesUpdated.add(cityForecast.city);

        if (citiesUpdated.length == forecasts.length) {
          // updated all cities so emit 'All cities' forecast
          citiesUpdated.clear();
          controller.sink.add(forecasts.values.toList());
        }
      });
    }
  }

  Stream<List<EightHourCityForecast>> getAllCitiesForecastStream() =>
      controller.stream;

  Stream<EightHourCityForecast> getForecastStreamFor(String city) {
    EightHourForecastStreamer? emitter = emitters[city];
    if (emitter == null) {
      throw Exception("Invalid city $city");
    }
    return emitter.stream;
  }

  EightHourCityForecast getCurrent8HourForecast(String city) {
    EightHourCityForecast? ret = forecasts[city];
    if (ret == null) {
      throw Exception("Invalid city $city");
    }
    return ret;
  }

  List<EightHourCityForecast> getCurrentALlCities8HourForecasts() {
    return forecasts.values.toList();
  }

  void dispose() {
    controller.close();
    for (var emitter in emitters.values) {
      emitter?.dispose();
    }
  }
}
