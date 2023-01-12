import 'package:dio/dio.dart';
import 'package:my_first_getx_project/sliver_example/blocs/weather_model.dart';

class WeatherApiClient {
  WeatherApiClient(this._dioClient);

  final Dio _dioClient;

  //台灣地區氣象測站資料
  //
  // DATA:[
  // {
  //   Station_name(string):測站名稱
  //   Station_ID(string):測站編號
  //   Station_Longitude(number):測站位置經度
  //   CITY(string):縣市
  //   CITY_SN(integer):縣市編號
  //   TOWN(string):鄉鎮
  //   TOWN_SN(integer):鄉鎮編號
  // }
  // ]

  //TaiwanMeteorologicalStationInformationType
  // 台灣地區氣象測站資料
  //curl -X GET "https://data.coa.gov.tw/api/v1/TaiwanMeteorologicalStationInformationType/" -H "accept: application/json"
  //
  //https://data.coa.gov.tw/api/v1/TaiwanMeteorologicalStationInformationType/
  Future<List<WeatherModel>> fetchApi() async {
    Response response = await _dioClient.get(
        'https://data.coa.gov.tw/api/v1/TaiwanMeteorologicalStationInformationType/');
    if (response.statusCode == 200) {
      List<dynamic> data = response.data["Data"];
      List<WeatherModel> weatherModels =
          data.map<WeatherModel>((e) => WeatherModel.fromJson(e)).toList();

      return weatherModels;
    }
    return [];
  }
}
