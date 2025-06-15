class UmbrellaRecommendation {
  final String recommendationType; // '장우산' 또는 '3단우산'
  final double thresholdRainAmount;

  UmbrellaRecommendation({
    required this.recommendationType,
    required this.thresholdRainAmount,
  });

  factory UmbrellaRecommendation.fromMap(Map<String, dynamic> map) {
    return UmbrellaRecommendation(
      recommendationType: map['recommendationType'] ?? '장우산',
      thresholdRainAmount: map['thresholdRainAmount']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recommendationType': recommendationType,
      'thresholdRainAmount': thresholdRainAmount,
    };
  }
}
