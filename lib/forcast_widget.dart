import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testtest/forcast_model.dart';

class ForecastWidget extends StatelessWidget {
  late final double? _width;
  late final double? _height;
  late final double _iconSize;
  late final double _tempTextSize;
  late final Size _rowTextSize;
  late final EdgeInsets? _outerPadding;
  late final EdgeInsets _innerPadding;
  late final EdgeInsets _mainInnerPadding;

  ForecastWidget.small(this.forecast) {
    _width = 150;
    _height = 140;
    _iconSize = 40;
    _tempTextSize = 15;
    _rowTextSize = Size(23, 16);
    _outerPadding = const EdgeInsets.all(8.0);
    _innerPadding = const EdgeInsets.all(8.0);
    _mainInnerPadding = const EdgeInsets.only(top: 14.0, bottom: 14.0);
  }

  ForecastWidget.big(this.forecast) {
    _width = null;
    _height = null;
    _iconSize = 150;
    _tempTextSize = 50;
    _rowTextSize = Size(45, 30);
    _outerPadding = null;
    _innerPadding = const EdgeInsets.all(16.0);
    _mainInnerPadding = const EdgeInsets.only(top: 8.0, bottom: 8.0);
  }

  final Forecast forecast;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: _outerPadding,
      child: Container(
        padding: _innerPadding,
        color: Colors.white,
        height: _height,
        width: _width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _SubRow(
                rowTextSize: _rowTextSize,
                leftText: DateFormat("d MMMM").format(forecast.hour),
                rightText: DateFormat("HH:00").format(forecast.hour),
                leftFlex: 5,
                rightFlex: 3),
            _MainRow(
              mainInnerPadding: _mainInnerPadding,
              iconData: forecast.weatherType.icon(),
              iconSize: _iconSize,
              textSize: _tempTextSize,
              rightText: forecast.getTemperatureDescription(),
            ),
            _SubRow(
                rowTextSize: _rowTextSize,
                leftText: "Humidity",
                rightText: forecast.getHumidityDescription(),
                leftFlex: 2,
                rightFlex: 1),
            _SubRow(
                rowTextSize: _rowTextSize,
                leftText: "Air Quality Index",
                rightText: forecast.getAQIDescription(),
                leftFlex: 5,
                rightFlex: 1)
          ],
        ),
      ),
    );
  }
}

class _MainRow extends StatelessWidget {
  final EdgeInsets mainInnerPadding;
  final IconData iconData;
  final double iconSize;
  final double textSize;
  final String rightText;

  _MainRow(
      {required this.mainInnerPadding,
      required this.iconData,
      required this.iconSize,
      required this.textSize,
      required this.rightText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: mainInnerPadding,
      child: Row(
        children: [
          Icon(
            iconData,
            size: iconSize,
          ),
          Spacer(),
          Expanded(
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.centerRight,
              child: Text(
                rightText,
                style: TextStyle(fontSize: textSize),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubRow extends StatelessWidget {
  final Size rowTextSize;
  final String leftText;
  final String rightText;

  final int leftFlex;
  final int rightFlex;

  _SubRow(
      {required this.rowTextSize,
      required this.leftText,
      required this.rightText,
      required this.leftFlex,
      required this.rightFlex});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: leftFlex,
          child: SizedBox(
            height: rowTextSize.height,
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.contain,
              child: Text(leftText),
            ),
          ),
        ),
        Spacer(),
        Expanded(
          flex: rightFlex,
          child: SizedBox(
            height: rowTextSize.height,
            child: FittedBox(
              alignment: Alignment.centerRight,
              fit: BoxFit.contain,
              child: Text(rightText),
            ),
          ),
        ),
      ],
    );
  }
}
