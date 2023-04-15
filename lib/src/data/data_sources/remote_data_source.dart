// ignore_for_file: unused_import

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tdd_clean_architecture_app/src/constants/end_point.dart';
import 'package:tdd_clean_architecture_app/src/core/error/exceptions.dart';
import 'package:tdd_clean_architecture_app/src/data/models/weather_model.dart';
import 'package:tdd_clean_architecture_app/src/domain/entities/weather.dart';

abstract class RemoteDataSource {
  Future<WeatherModel> getCurrentWeather(String cityName);
}

class RemoteDataSourceImpl extends RemoteDataSource {
  final http.Client client;
  RemoteDataSourceImpl({required this.client});
  @override
  Future<WeatherModel> getCurrentWeather(String cityName) async {
    final response =
        await client.get(Uri.parse(EndPoint.currentWeatherByName(cityName)));
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }
}
