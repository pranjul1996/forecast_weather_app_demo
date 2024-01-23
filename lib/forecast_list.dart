import 'package:flutter/material.dart';
import 'package:testtest/emitters.dart';
import 'package:testtest/forcast_details.dart';
import 'package:testtest/weather_oracle.dart';

import 'forcast_model.dart';
import 'widget_keys.dart';

enum ForecastOrder { temp, city }

class ForecastListScreen extends StatefulWidget {
  final WeatherOracle oracle;

  const ForecastListScreen(this.oracle, {super.key});

  @override
  ForecastListScreenState createState() => ForecastListScreenState();
}

class ForecastListScreenState extends State<ForecastListScreen> {
  late List<EightHourCityForecast> forecasts;
  ForecastOrder order = ForecastOrder.city;

  @override
  void initState() {
    forecasts = widget.oracle.getCurrentALlCities8HourForecasts();
    super.initState();
  }

  Widget getListViewItem(EightHourCityForecast forecast) {
    return InkWell(
      key: ValueKey(forecast.city),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ForecastDetailsScreen(
                  oracle: WeatherOracle(), initialForecast: forecast)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          children: [
            Text(forecast.city),
            const Spacer(),
            Text(forecast.first.getTemperatureDescription()),
            const VerticalDivider(width: 12),
            Icon(forecast.first.weatherType.icon()),
          ],
        ),
      ),
    );
  }

  ListView getListView() {
    return ListView.separated(
      key: WidgetKey.listOfForecasts,
      itemCount: forecasts.length,
      separatorBuilder: (context, index) {
        return Divider(
          height: 1,
          thickness: 1.0,
          color: Colors.grey.shade300,
        );
      },
      itemBuilder: (context, index) {
        EightHourCityForecast f = forecasts[index];
        return getListViewItem(f);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Weather forecast for Poland"),
          actions: [
            IconButton(
              key: WidgetKey.sortBtn,
              icon: const Icon(Icons.swap_vert),
              tooltip: 'Change ordering',
              onPressed: () {
                setState(() {

                });
              },
            ),
          ],
        ),
        body: getListView());
  }
}
