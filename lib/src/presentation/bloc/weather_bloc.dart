// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/weather.dart';
import '../../domain/usecases/get_current_weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeather getCurrentWeather;
  WeatherBloc(this.getCurrentWeather) : super(WeatherEmpty()) {
    on<OnCityChanged>(
      (event, emit) async {
        final cityName = event.cityName;
        emit(WeatherLoading());
        final result = await getCurrentWeather.execute(cityName);
        result.fold((failure) => emit(WeatherError(failure.message)),
            (data) => emit(WeatherHasData(data)));
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }
  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
