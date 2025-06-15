class WeatherNotice {
  final DateTime forecastDate;
  final double precipitationLevel;
  final bool rainExpected;

  WeatherNotice({
    required this.forecastDate,
    required this.precipitationLevel,
    required this.rainExpected,
  });

  factory WeatherNotice.fromMap(Map<String, dynamic> map) {
    return WeatherNotice(
      forecastDate: DateTime.parse(map['forecastDate']),
      precipitationLevel: map['precipitationLevel']?.toDouble() ?? 0.0,
      rainExpected: map['rainExpected'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'forecastDate': forecastDate.toIso8601String(),
      'precipitationLevel': precipitationLevel,
      'rainExpected': rainExpected,
    };
  }
}
