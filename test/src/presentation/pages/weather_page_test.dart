// ignore_for_file: unused_local_variable, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_architecture_app/src/constants/end_point.dart';
import 'package:tdd_clean_architecture_app/src/domain/entities/weather.dart';
import 'package:tdd_clean_architecture_app/src/presentation/bloc/weather_bloc.dart';
import 'package:tdd_clean_architecture_app/src/presentation/pages/weather_page.dart';

class MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherBloc {}

class FakeWeatherEvent extends Fake implements WeatherEvent {}

class FakeWeatherState extends Fake implements WeatherState {}

void main() {
  late MockWeatherBloc mockWeatherBloc;

  setUpAll(() async {
    HttpOverrides.global = null;
    registerFallbackValue(FakeWeatherEvent());
    registerFallbackValue(FakeWeatherState());

    final di = GetIt.instance;
    di.registerFactory(() => mockWeatherBloc);
  });

  setUp(() {
    mockWeatherBloc = MockWeatherBloc();
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

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WeatherBloc>.value(
      value: mockWeatherBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('text field should trigger state to change from empty to loading',
      (tester) async {
    // arrange
    when(() => mockWeatherBloc.state).thenReturn(WeatherEmpty());
    // act
    await tester.pumpWidget(_makeTestableWidget(const WeatherPage()));
    await tester.enterText(find.byType(TextField), 'Jakarta');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    // assert
    verify(() => mockWeatherBloc.add(const OnCityChanged('Jakarta'))).called(1);
    expect(find.byType(TextField), equals(findsOneWidget));
  });

  testWidgets("should show progress indicator when state is loading",
      (tester) async {
    // arrange
    when(() => mockWeatherBloc.state).thenReturn(WeatherLoading());
    // act
    await tester.pumpWidget(_makeTestableWidget(const WeatherPage()));
    // assert
    expect(find.byType(CircularProgressIndicator), equals(findsOneWidget));
  });
  testWidgets("should show widget contain weather data when state is has data",
      (tester) async {
    // arrange
    when(() => mockWeatherBloc.state)
        .thenReturn(const WeatherHasData(tWeather));
    // act
    await tester.pumpWidget(_makeTestableWidget(const WeatherPage()));
    await tester.runAsync(() async {
      final HttpClient client = HttpClient();
      await client.getUrl(Uri.parse(EndPoint.weatherIcon('02d')));
      await tester.pumpAndSettle();
    });
    // assert
    expect(find.byKey(const Key('weather_data')), equals(findsOneWidget));
  });
}
