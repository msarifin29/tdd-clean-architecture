class EndPoint {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String apiKey = '0fe6098036e0c6b4b06e34d4ccbeca2c';
  static String currentWeatherByName(String city) =>
      '$baseUrl/weather?q=$city&appid=$apiKey';
  static String weatherIcon(String iconCode) =>
      'http://openweathermap.org/img/wn/$iconCode@2x.png';
}
