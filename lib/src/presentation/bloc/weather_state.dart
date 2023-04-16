part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherEmpty extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherError extends WeatherState {
  final String error;

  const WeatherError(this.error);
  @override
  List<Object> get props => [];
}

class WeatherHasData extends WeatherState {
  final Weather result;

  const WeatherHasData(this.result);
  @override
  List<Object> get props => [];
}
