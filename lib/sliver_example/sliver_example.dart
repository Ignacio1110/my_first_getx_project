import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_first_getx_project/sliver_example/blocs/weather_model.dart';
import 'package:my_first_getx_project/sliver_example/blocs/weather_repository.dart';

class SliverExample extends StatefulWidget {
  const SliverExample({Key? key}) : super(key: key);

  @override
  State<SliverExample> createState() => _SliverExampleState();
}

class _SliverExampleState extends State<SliverExample> {
  final WeatherRepository weatherRepository = WeatherRepository();

  List<WeatherModel> weatherModels = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                  SliverToBoxAdapter(
                    child: Text('simple box'),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((ctx, index) {
                      return Text("${weatherModels[index]}");
                    }, childCount: weatherModels.length),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
