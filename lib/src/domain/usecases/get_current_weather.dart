import 'package:dartz/dartz.dart';
import 'package:tdd_clean_architecture_app/src/domain/entities/weather.dart';
import 'package:tdd_clean_architecture_app/src/domain/repositories/weather_reporitory.dart';

import '../../core/error/failure.dart';

class GetCurrentWeather {
  final WeatherRepository repository;

  GetCurrentWeather(this.repository);

  Future<Either<Failure, Weather>> execute(String cityName) async {
    final getCurrent = await repository.getCurrentWeather(cityName);
    return getCurrent;
  }
}
