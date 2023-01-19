import 'package:flutter/material.dart';
import 'package:my_first_getx_project/sliver_example/blocs/weather_model.dart';
import 'package:my_first_getx_project/sliver_example/sliver_example_theme.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({Key? key, required this.weatherModel}) : super(key: key);

  final WeatherModel weatherModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: SliverExampleTheme.kPrimary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  weatherModel.city,
                ),
                Text(
                  weatherModel.stationName,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "緯度 ${weatherModel.stationLatitude}",
                ),
                Text(
                  '經度 ${weatherModel.stationLongitude}',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
