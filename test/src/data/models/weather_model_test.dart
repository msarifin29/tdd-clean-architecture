import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_clean_architecture_app/src/data/models/weather_model.dart';
import 'package:tdd_clean_architecture_app/src/domain/entities/weather.dart';

import '../../helpers/read_json.dart';

void main() {
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

  group("to Entity", () {
    test("should be a subclass of weather entity", () async {
      // act
      final result = tWeatherModel.toEntity();
      // assert
      expect(result, equals(tWeather));
    });
  });
  group("from json", () {
    test("should return a valid model from json", () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(readJson("dummy_weather_response.json"));
      // act
      final result = WeatherModel.fromJson(jsonMap);
      // assert
      expect(result, equals(tWeatherModel));
    });
  });
  group("to json", () {
    test("should return a valid model from json", () async {
      // act
      final result = tWeatherModel.toJson();
      // assert
      final expectedJsonMap = {
        'weather': [
          {
            'main': 'Clouds',
            'description': 'few clouds',
            'icon': '02d',
          }
        ],
        'main': {
          'temp': 302.28,
          'pressure': 1009,
          'humidity': 70,
        },
        'name': 'Jakarta',
      };
      expect(result, equals(expectedJsonMap));
    });
  });
}
