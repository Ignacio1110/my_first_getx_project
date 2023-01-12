import 'package:dio/dio.dart';
import 'package:my_first_getx_project/sliver_example/blocs/weather_api_client.dart';

import 'weather_model.dart';

class WeatherRepository {
  final WeatherApiClient _weatherApiClient = WeatherApiClient(Dio());

  //台灣地區氣象測站資料
  Future<List<WeatherModel>>
      loadTaiwanMeteorologicalStationInformationType() async {
    return await _weatherApiClient.fetchApi();
  }

  //台灣地區雨量測站資料
  loadTaiwanRainfallStationInformationType() {}

  //自動氣象站
  loadAutoWeatherStationType() {}

  //自動雨量站
  loadAutoRainfallStationType() {}
}
