import 'package:flutter/material.dart';
import '../models/weather_notice_model.dart';
import '../models/umbrella_recommendation_model.dart';

class UmbrellaNotice extends StatelessWidget {
  final WeatherNotice weather;
  final UmbrellaRecommendation umbrella;

  const UmbrellaNotice({
    required this.weather,
    required this.umbrella,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🌧 비 예보 있음',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('예상 강수량: ${weather.precipitationLevel}mm'),
            Text('추천 우산: ${umbrella.recommendationType}'),
          ],
        ),
      ),
    );
  }
}
