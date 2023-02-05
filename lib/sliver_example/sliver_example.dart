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
    final stations =
        weatherModels.where((element) => element.city == city).toList();
    return SliverList(
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
                CustomAppbar(),
                SliverPersistentHeader(
                  delegate: MyTitleDelegate('臺北市'),
                  pinned: true,
                ),
                _buildStationsList('臺北市'),
                SliverPersistentHeader(
                  delegate: MyTitleDelegate('高雄市'),
                  pinned: true,
                ),
                _buildStationsList('高雄市'),
                SliverPersistentHeader(
                  delegate: MyTitleDelegate('新竹市'),
                  pinned: true,
                ),
                _buildStationsList('新竹市'),
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Text(
                        '已經顯示全台各地的觀測站\n下拉刷新',
                        style: SliverExampleTheme.textTheme.bodyText1
                            ?.copyWith(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: kToolbarHeight + 30 + 40,
      stretch: true,
      pinned: true,
      flexibleSpace: LayoutBuilder(builder: (context, constrains) {
        print(constrains);
        return Align(
          alignment: Alignment.bottomLeft,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: kToolbarHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: CircleAvatar(
                            child: FlutterLogo(),
                          ),
                        ),
                        Expanded(
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Ignacio Zhang",
                                style: SliverExampleTheme.textTheme.bodyText1,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  SliverExampleTheme.kPrimarySwatch.shade200,
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [Icon(Icons.add), Text('回饋')],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + kToolbarHeight,
                left: 8.0,
                right: 8.0,
                child: Column(
                  children: [
                    SizedBox(
                      width: constrains.maxWidth,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '興趣愛好：觀測天象',
                          maxLines: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: constrains.maxWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    SliverExampleTheme.kPrimarySwatch.shade200,
                              ),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.edit),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text('編輯個人檔案')
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    SliverExampleTheme.kPrimarySwatch.shade200,
                              ),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.share),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text('推廣活動')
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
