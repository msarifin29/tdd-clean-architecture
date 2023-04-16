import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_clean_architecture_app/src/core/error/exceptions.dart';
import 'package:tdd_clean_architecture_app/src/core/error/failure.dart';
import 'package:tdd_clean_architecture_app/src/data/data_sources/remote_data_source.dart';
import 'package:tdd_clean_architecture_app/src/data/models/weather_model.dart';
import 'package:tdd_clean_architecture_app/src/data/repositories/weather_repository_impl.dart';
import 'package:tdd_clean_architecture_app/src/domain/entities/weather.dart';
import 'package:http/http.dart' as http;

import 'weather_repository_impl_test.mocks.dart';

@GenerateMocks([
  RemoteDataSource,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {
  late MockRemoteDataSource remoteData;
  late WeatherRepositoryImpl repository;

  setUp(() {
    remoteData = MockRemoteDataSource();
    repository = WeatherRepositoryImpl(dataSource: remoteData);
  });

  const tWeatherModel = WeatherModel(
    cityName: 'Jakarta',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 302.28,
    pressure: 1009,
    humidity: 70,
  );

  const tWeather = Weather(
    cityName: 'Jakarta',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 302.28,
    pressure: 1009,
    humidity: 70,
  );

  group("get curret weather", () {
    const cityName = 'Jakarta';

    test(
        "should return current weather when a call to data source is successful ",
        () async {
      // arrange
      when(remoteData.getCurrentWeather(cityName))
          .thenAnswer((_) async => tWeatherModel);
      // act
      final result = await repository.getCurrentWeather(cityName);
      // assert
      verify(remoteData.getCurrentWeather(cityName));
      expect(result, equals(const Right(tWeather)));
    });

    test(
        "should return server failure when a call to data source is unsuccessful ",
        () async {
      // arrange
      when(remoteData.getCurrentWeather(cityName))
          .thenThrow(ServerException()); // act
      final result = await repository.getCurrentWeather(cityName);
      // assert
      verify(remoteData.getCurrentWeather(cityName));
      expect(result, equals(const Left(ServerFailure(""))));
    });

    test("should return connection failure when the device has no internet ",
        () async {
      // arrange
      when(remoteData.getCurrentWeather(cityName)).thenThrow(
          const SocketException("Failed to connect to the network")); // act
      final result = await repository.getCurrentWeather(cityName);
      // assert
      verify(remoteData.getCurrentWeather(cityName));
      expect(result, equals(const Left(ConnectionFailure("message"))));
    });
  });
}
