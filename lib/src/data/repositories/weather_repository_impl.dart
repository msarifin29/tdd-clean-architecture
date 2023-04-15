import 'dart:io';

import 'package:tdd_clean_architecture_app/src/data/data_sources/remote_data_source.dart';
import 'package:tdd_clean_architecture_app/src/domain/entities/weather.dart';
import 'package:tdd_clean_architecture_app/src/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tdd_clean_architecture_app/src/domain/repositories/weather_reporitory.dart';

import '../../core/error/exceptions.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  final RemoteDataSource dataSource;

  WeatherRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, Weather>> getCurrentWeather(String cityName) async {
    try {
      final result = await dataSource.getCurrentWeather(cityName);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure('Server failure'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}
