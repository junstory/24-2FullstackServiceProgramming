import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  // 로그인 시 서버로부터 받은 사용자 ID
  final String userID = "user123"; 

  // 스케줄 데이터 저장
  Map<DateTime, List<Schedule>> scheduleData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('스케줄'),
        centerTitle: true,
        actions: [
          // 오늘 날짜로 가는 버튼
          IconButton(
            icon: Icon(Icons.today),
            onPressed: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = DateTime.now();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 캘린더
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.orangeAccent,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.blue, // 일정이 존재하는 날짜는 파란색
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            eventLoader: (day) {
              // 해당 날짜에 스케줄이 있으면 표시
              return scheduleData[day] ?? [];
            },
          ),
          Divider(height: 1),

          // 스케줄 목록
          Expanded(
            child: _buildScheduleList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddScheduleDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  // 스케줄 목록 빌더
  Widget _buildScheduleList() {
    final schedules = scheduleData[_selectedDay] ?? [];
    if (schedules.isEmpty) {
      return Center(
        child: Text(
          'No schedules for this day.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        final schedule = schedules[index];
        return ListTile(
          title: Text(schedule.description),
          subtitle: Text(
            '${_formatDate(schedule.fromDate)} - ${_formatDate(schedule.toDate)}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        );
      },
    );
  }

  // 스케줄 추가 팝업
  void _showAddScheduleDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String description = '';
    DateTime? fromDate = _selectedDay;
    DateTime? toDate = _selectedDay;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('스케줄 추가'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // From Date
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'From Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      final picked = await _selectDate(context, fromDate!);
                      if (picked != null) {
                        setState(() {
                          fromDate = picked;
                        });
                      }
                    },
                    controller: TextEditingController(
                      text: fromDate != null
                          ? _formatDate(fromDate!)
                          : '',
                    ),
                  ),
                  SizedBox(height: 8),

                  // To Date
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'To Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      final picked = await _selectDate(context, toDate!);
                      if (picked != null) {
                        setState(() {
                          toDate = picked;
                        });
                      }
                    },
                    controller: TextEditingController(
                      text: toDate != null
                          ? _formatDate(toDate!)
                          : '',
                    ),
                  ),
                  SizedBox(height: 8),

                  // Description
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    onChanged: (value) {
                      description = value;
                    },
                    validator: (value) =>
                        value!.isEmpty ? '설명을 입력하세요.' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newSchedule = Schedule(
                    userID: userID, // 로그인된 사용자 ID를 사용
                    description: description,
                    fromDate: fromDate!,
                    toDate: toDate!,
                  );
                  setState(() {
                    scheduleData[fromDate!] = [
                      ...scheduleData[fromDate!] ?? [],
                      newSchedule
                    ];
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // 날짜 포맷 함수
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // 날짜 선택 함수
  Future<DateTime?> _selectDate(BuildContext context, DateTime initialDate) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }
}

// 스케줄 클래스
class Schedule {
  final String userID; // 사용자 ID
  final String description; // 일정 설명
  final DateTime fromDate; // 시작 날짜
  final DateTime toDate; // 종료 날짜

  Schedule({
    required this.userID,
    required this.description,
    required this.fromDate,
    required this.toDate,
  });
}