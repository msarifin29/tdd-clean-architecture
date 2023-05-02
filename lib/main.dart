// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/injection.dart' as di;

import 'src/presentation/bloc/weather_bloc.dart';
import 'src/presentation/pages/weather_page.dart';

void main() async {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.locator<WeatherBloc>(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: const WeatherPage(),
      ),
    );
  }
}
