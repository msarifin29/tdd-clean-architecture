import 'package:get_it/get_it.dart';
import 'package:tdd_clean_architecture_app/src/data/data_sources/remote_data_source.dart';
import 'package:tdd_clean_architecture_app/src/data/repositories/weather_repository_impl.dart';
import 'package:tdd_clean_architecture_app/src/domain/repositories/weather_reporitory.dart';
import 'package:tdd_clean_architecture_app/src/domain/usecases/get_current_weather.dart';
import 'package:tdd_clean_architecture_app/src/presentation/bloc/weather_bloc.dart';
import 'package:http/http.dart' as http;

final locator = GetIt.instance;
void init() {
  locator.registerFactory(() => WeatherBloc(locator()));
  locator.registerLazySingleton(() => GetCurrentWeather(locator()));
  locator.registerLazySingleton<WeatherRepository>(
      () => WeatherRepositoryImpl(dataSource: locator()));
  locator.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton(() => http.Client());
}
