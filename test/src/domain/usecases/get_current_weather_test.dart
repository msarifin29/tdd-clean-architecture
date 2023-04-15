// ignore_for_file: unused_local_variable

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_clean_architecture_app/src/domain/entities/weather.dart';
import 'package:tdd_clean_architecture_app/src/domain/repositories/weather_reporitory.dart';
import 'package:tdd_clean_architecture_app/src/domain/usecases/get_current_weather.dart';

@GenerateMocks([WeatherRepository])
// import 'tdd_clean_architecture_app/test/src/domain/usecases/get_current_weather_test.mocks.dart';

import 'get_current_weather_test.mocks.dart';

void main() {
  late MockWeatherRepository mockRepository;
  late GetCurrentWeather usecases;
  setUp(() {
    mockRepository = MockWeatherRepository();
    usecases = GetCurrentWeather(mockRepository);
  });

  const weatherDeatail = Weather(
    cityName: 'Jakarta',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 302.28,
    pressure: 1009,
    humidity: 70,
  );

  const cityName = 'Jakarta';

  test("should get current weather detail from the repository", () async {
    // arrange
    when(mockRepository.getCurrentWeather(cityName))
        .thenAnswer((realInvocation) async => const Right(weatherDeatail));
    // act
    final result = await usecases.execute(cityName);
    // assert
    expect(result, equals(const Right(weatherDeatail)));
  });
}
