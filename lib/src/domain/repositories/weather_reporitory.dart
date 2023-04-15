import 'package:dartz/dartz.dart';
import 'package:tdd_clean_architecture_app/src/core/failure.dart';
import 'package:tdd_clean_architecture_app/src/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<Either<Failure, Weather>> getCurrentWeather(String cityName);
}
