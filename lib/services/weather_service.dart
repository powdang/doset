import '../models/weather_notice_model.dart';

class WeatherService {
  Future<WeatherNotice> fetchWeatherForecast() async {
    // 실제 구현 시 OpenWeatherMap 등 API 사용
    await Future.delayed(Duration(seconds: 1)); // 네트워크 대기 시뮬레이션
    return WeatherNotice(
      forecastDate: DateTime.now(),
      precipitationLevel: 6.0,
      rainExpected: true,
    );
  }
}
