import 'package:flutter/material.dart';

import 'forcast_model.dart';
import 'forcast_widget.dart';
import 'weather_oracle.dart';

class ForecastDetailsScreen extends StatelessWidget {
  final WeatherOracle oracle;

  // initial forecast
  final EightHourCityForecast initialForecast;

  const ForecastDetailsScreen(
      {Key? key, required this.oracle, required this.initialForecast})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(initialForecast.city),
        ),
        body: Column(children: [
          ForecastWidget.big(initialForecast.first),
          StreamBuilder(
              stream: oracle.get8HourCityForecastStream(initialForecast.city),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Text("Wait for the forecast");
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  case ConnectionState.active:
                    return Flexible(
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: snapshot.data?.forecasts.length ?? 0,
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 1,
                            thickness: 1.0,
                            color: Colors.grey.shade300,
                          );
                        },
                        itemBuilder: (context, index) {
                          var forecast = snapshot.data?.forecasts[index];
                          Forecast f = forecast!;
                          return ForecastWidget.small(f);
                        },
                      ),
                    );
                  case ConnectionState.done:
                    return Container();
                }
              })
        ]));
  }
}
