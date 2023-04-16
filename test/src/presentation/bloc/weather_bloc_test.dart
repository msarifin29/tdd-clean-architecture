import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_clean_architecture_app/src/core/error/failure.dart';
import 'package:tdd_clean_architecture_app/src/domain/entities/weather.dart';
import 'package:tdd_clean_architecture_app/src/domain/usecases/get_current_weather.dart';
import 'package:tdd_clean_architecture_app/src/presentation/bloc/weather_bloc.dart';

import 'weather_bloc_test.mocks.dart';

@GenerateMocks([GetCurrentWeather])
void main() {
  late MockGetCurrentWeather getCurrentWeather;
  late WeatherBloc weatherBloc;

  setUp(() {
    getCurrentWeather = MockGetCurrentWeather();
    weatherBloc = WeatherBloc(getCurrentWeather);
  });

  const tWeather = Weather(
    cityName: 'Jakarta',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 302.28,
    pressure: 1009,
    humidity: 70,
  );

  const tCityName = 'Jakarta';

  test("initial state should be empty", () {
    expect(weatherBloc.state, WeatherEmpty());
  });

  blocTest<WeatherBloc, WeatherState>(
    "should emit [loading, has data] when data is gotten successfully",
    build: () {
      when(getCurrentWeather.execute(tCityName))
          .thenAnswer((_) async => const Right(tWeather));
      return weatherBloc;
    },
    act: (bloc) => bloc.add(const OnCityChanged(tCityName)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WeatherLoading(),
      const WeatherHasData(tWeather),
    ],
    verify: (bloc) {
      verify(getCurrentWeather.execute(tCityName));
    },
  );

  blocTest<WeatherBloc, WeatherState>(
    "should emit [loading, error] when get data is unsuccessful",
    build: () {
      when(getCurrentWeather.execute(tCityName))
          .thenAnswer((_) async => const Left(ServerFailure("Server failure")));
      return weatherBloc;
    },
    act: (bloc) => bloc.add(const OnCityChanged(tCityName)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WeatherLoading(),
      const WeatherError("Server failure"),
    ],
    verify: (bloc) {
      verify(getCurrentWeather.execute(tCityName));
    },
  );
}
