import 'package:flutter/material.dart';
import '../models/daily_record_model.dart';

class DailyTile extends StatelessWidget {
  final DailyRecord record;
  final VoidCallback? onTap;

  const DailyTile({required this.record, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
    record.date.toLocal().toString().split(' ')[0]; // ✅ 날짜 형식화

    return ListTile(
      title: Text(formattedDate),
      subtitle:
      Text('기온: ${record.temperature}°, 체감: ${record.sensation}'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
