import 'package:testtest/forcast_model.dart';
import 'package:flutter/widgets.dart';

class WidgetKey {
  static ValueKey<String> listOfForecasts = const ValueKey('listOfForecasts');
  static ValueKey<String> sortBtn = const ValueKey('sortBtn');

  static ValueKey<String> warszawa = ValueKey(City.warszawa);
  static ValueKey<String> zakopane = ValueKey(City.zakopane);
  static ValueKey<String> gdansk = ValueKey(City.gdansk);
  static ValueKey<String> poznan = ValueKey(City.poznan);
  static ValueKey<String> krakow = ValueKey(City.krakow);
  static ValueKey<String> ustka = ValueKey(City.ustka);
}
