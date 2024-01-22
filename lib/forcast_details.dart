import 'package:flutter/material.dart';

import 'forcast_model.dart';
import 'forcast_widget.dart';
import 'weather_oracle.dart';



class ForecastDetailsScreen extends StatelessWidget {
  final WeatherOracle oracle;

  // initial forecast
  final EightHourCityForecast initialForecast;

  ForecastDetailsScreen(
      {Key? key, required this.oracle, required this.initialForecast})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(initialForecast.city),
        ),
       body:  ForecastWidget.big(initialForecast.first),
    );
  }
}
