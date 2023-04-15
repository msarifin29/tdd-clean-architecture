// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:tdd_clean_architecture_app/src/constants/end_point.dart';
import 'package:tdd_clean_architecture_app/src/core/error/exceptions.dart';
import 'package:tdd_clean_architecture_app/src/data/data_sources/remote_data_source.dart';
import 'package:tdd_clean_architecture_app/src/data/models/weather_model.dart';

import '../../helpers/read_json.dart';
import '../repositories/weather_repository_impl_test.mocks.dart';

void main() {
  late MockHttpClient httpClient;
  late RemoteDataSourceImpl dataSource;

  setUp(() {
    httpClient = MockHttpClient();
    dataSource = RemoteDataSourceImpl(client: httpClient);
  });

  group("get current weather", () {
    const tCityName = "Jakarta";
    final tWeatherModel = WeatherModel.fromJson(
        jsonDecode(readJson('dummy_weather_response.json')));

    test("should return weather model when the response code is 200", () async {
      // arrange
      when(httpClient.get(Uri.parse(EndPoint.currentWeatherByName(tCityName))))
          .thenAnswer((_) async =>
              http.Response(readJson("dummy_weather_response.json"), 200));
      // act
      final result = await dataSource.getCurrentWeather(tCityName);
      // assert
      expect(result, equals(tWeatherModel));
    });

    test(
        "should throw a server exception when the response code is 404 or other",
        () async {
      // arrange
      when(httpClient.get(Uri.parse(EndPoint.currentWeatherByName(tCityName))))
          .thenAnswer((_) async => http.Response("Not Response", 404));
      // act
      final result = dataSource.getCurrentWeather(tCityName);
      // assert
      expect(() => result, throwsA(isA<ServerException>()));
    });
  });
}
