import 'package:flutter/material.dart';
import 'package:testtest/forecast_list.dart';

import 'weather_oracle.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  final WeatherOracle oracle = WeatherOracle();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  ForecastListScreen(oracle),
    );
  }
}

