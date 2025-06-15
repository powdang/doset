
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/daily_record_provider.dart';
import '../screens/daily_detail_screen.dart';
import '../widgets/daily_tile.dart';
import '../models/daily_record_model.dart';

class DailyScreen extends StatefulWidget {
  final String uid;
  const DailyScreen({required this.uid, super.key});

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    Provider.of<DailyRecordProvider>(context, listen: false)
        .fetchRecords(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DailyRecordProvider>(context);
    final records = provider.records.where((record) {
      return record.date.year == _selectedDay.year &&
          record.date.month == _selectedDay.month &&
          record.date.day == _selectedDay.day;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('데일리 착용 기록')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() => _selectedDay = selected);
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: records.isEmpty
                ? const Center(child: Text('해당 날짜에 기록이 없습니다.'))
                : ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return DailyTile(
                  record: record,
                  onTap: () {
                    // TODO: 상세 편집 화면으로 연결 예정
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DailyDetailScreen(uid: widget.uid),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
