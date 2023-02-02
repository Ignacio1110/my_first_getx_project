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

class MyTitleDelegate extends SliverPersistentHeaderDelegate {
  MyTitleDelegate(this.title);
  final String title;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 40,
      color: SliverExampleTheme.kColor3,
      child: Center(
        child: Text(title),
      ),
    );
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
