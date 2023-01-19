import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_first_getx_project/sliver_example/blocs/weather_model.dart';
import 'package:my_first_getx_project/sliver_example/blocs/weather_repository.dart';
import 'package:my_first_getx_project/sliver_example/components.dart';
import 'package:my_first_getx_project/sliver_example/sliver_example_theme.dart';

class SliverExample extends StatefulWidget {
  const SliverExample({Key? key}) : super(key: key);

  @override
  State<SliverExample> createState() => _SliverExampleState();
}

class _SliverExampleState extends State<SliverExample> {
  final WeatherRepository weatherRepository = WeatherRepository();

  List<WeatherModel> weatherModels = [];

  SliverList _buildStationsList(String city) {
    final stations = weatherModels.where((element) => element.city == city).toList();
    return   SliverList(
      delegate: SliverChildBuilderDelegate((ctx, index) {
        return WeatherCard(
          weatherModel: stations[index],
        );
      }, childCount: stations.length),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          weatherModels = await weatherRepository
              .loadTaiwanMeteorologicalStationInformationType();
          setState(() {});
        },
        child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: Scrollbar(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 140,
                    stretch: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text('全台觀測站資訊'),
                      background: FlutterLogo(),
                      collapseMode: CollapseMode.parallax,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        '用於顯示全台各地的觀測站',
                        style: SliverExampleTheme.textTheme.bodyText1
                            ?.copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                  _buildStationsList('臺北市')
                ],
              ),
            )),
      ),
    );
  }
}
