// {
// "Station_name": "string",
// "Station_ID": "string",
// "Station_Longitude": 0,
// "CITY": "string",
// "CITY_SN": 0,
// "TOWN": "string",
// "TOWN_SN": 0
// }

class WeatherModel {
  final String stationName;
  final String stationId;
  final String stationLatitude;
  final String stationLongitude;
  final String city;
  final String citySn;
  final String town;
  final String townSn;

  WeatherModel(this.stationName, this.stationId, this.stationLatitude,
      this.stationLongitude, this.city, this.citySn, this.town, this.townSn);

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      json["Station_name"], // "社子",
      json["Station_ID"], // "C0A980",
      json["Station_Latitude"], // "25.11138900000000",
      json["Station_Longitude"], // "121.46138900000000",
      json["CITY"], // "臺北市",
      json["CITY_SN"], // "1",
      json["TOWN"], // "士林區",
      json["TOWN_SN"], // "7"
    );
  }
}
