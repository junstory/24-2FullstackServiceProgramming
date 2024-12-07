import 'package:flutter/material.dart';
import '../helper/shared_preference_helper.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  Map<String, List<Schedule>> scheduleData = {}; // 스케줄 데이터 저장
  String? companyId; // 회사 ID
  int? userId;
  String? accessToken;
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await SharedPreferenceHelper.getInfo();
    setState(() {
      userId = userInfo['id'];
      companyId = userInfo['companyId'];
      accessToken = userInfo['accessToken'];
      userName = userInfo['name'];
    });
  }

  Future<void> _addSchedule(String description, DateTime startDate, DateTime endDate) async {
    final now = DateTime.now();
    try {
      print("userId: $userId, companyId: $companyId");
      if (userId == null) {
        print("유저 정보가 없습니다.");
        return;
      }

      final dio = Dio();
      final response = await dio.post(
        'http://10.0.2.2:3000/api/v1/plan',
        data: {
          "userId": userId,
          "description": description,
          "startDate": startDate.toIso8601String(),
          "endDate": endDate.toIso8601String(),
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization' : 'Bearer $accessToken',
        }),
      );

      if (response.statusCode == 200 && response.data['isSuccess'] == true) {
        print("일정 추가 성공!");
        setState(() {
          final key = _formatDate(startDate);
          final newSchedule = Schedule(
            userID: userId!,
            userName: userName!,
            description: description,
            fromDate: startDate,
            toDate: endDate,
          );

          scheduleData[key] = [...(scheduleData[key] ?? []), newSchedule];
          
        });
        
        await SharedPreferenceHelper.saveSchedule(now.toIso8601String(),_convertScheduleDataToJson(scheduleData));
        Navigator.pop(context); // 팝업 닫기
      } else {
        print("일정 추가 실패: ${response.data['message']}");
      }
    } catch (e) {
      print("일정 추가 중 오류 발생: $e");
    }
  }


  // 스케줄 데이터를 API로부터 가져오기
  Future<void> _loadSchedules() async {
    // SharedPreferences에서 companyId 가져오기
      final userInfo = await SharedPreferenceHelper.getInfo();
      final lastUpdated = userInfo['lastUpdated'];
      final now = DateTime.now();

      if (lastUpdated != null) {
        final lastUpdateTime = DateTime.parse(lastUpdated);
        if (now.difference(lastUpdateTime).inMinutes < 2) {
          final savedData = userInfo['scheduleData'];
          if (savedData != null) {
            setState(() {
              scheduleData = _parseScheduleData(savedData);
            });
            print("저장된 데이터 사용");
            return;
          }
        }
      }

        // 2분 초과 시 API 호출
      print("새 데이터 로드");
      await _fetchSchedulesFromApi();

      // 저장
      await SharedPreferenceHelper.saveSchedule(now.toIso8601String(),_convertScheduleDataToJson(scheduleData));
      // prefs.setString('lastUpdated', now.toIso8601String());
      // prefs.setString('scheduleData', _convertScheduleDataToJson(scheduleData));
  }
   Future<void> _fetchSchedulesFromApi() async {
    try {
      final userInfo = await SharedPreferenceHelper.getInfo();
      companyId = userInfo['companyId'];
      accessToken = userInfo['accessToken'];

      if (companyId == null) {
        print("Company ID가 없습니다.");
        return;
      }

      final dio = Dio();
      final response = await dio.get(
        'http://10.0.2.2:3000/api/v1/plan/$companyId',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      if (response.statusCode == 200 && response.data['isSuccess'] == true) {
        final List<dynamic> schedules = response.data['result']['data'];
        final parsedData = <String, List<Schedule>>{};

        for (var schedule in schedules) {
          final startDate = _parseDate(schedule['startDate']);
          final endDate = _parseDate(schedule['endDate']);
          final key = _formatDate(startDate);

          final newSchedule = Schedule(
            userID: schedule['userId'],
            userName: schedule['userName'],
            description: schedule['description'],
            fromDate: startDate,
            toDate: endDate,
          );

          if (!parsedData.containsKey(key)) {
            parsedData[key] = [];
          }
          parsedData[key]!.add(newSchedule);
        }

        setState(() {
          scheduleData = parsedData;
        });
      }
    } catch (e) {
      print("스케줄 데이터를 로드하는 중 오류 발생: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('스케줄'),
        centerTitle: true,
        actions: [
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
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            eventLoader: (day) {
              final key = _formatDate(day);
              return scheduleData[key] ?? [];
            },
          ),
          Divider(height: 1),
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

  Widget _buildScheduleList() {
    final key = _formatDate(_selectedDay);
    final schedules = scheduleData[key] ?? [];

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
          title: Text('${schedule.userName}: ${schedule.description}'),
          subtitle: Text(
            '${_formatDate(schedule.fromDate)} - ${_formatDate(schedule.toDate)}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        );
      },
    );
  }
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
                    initialValue: _formatDate(fromDate!),
                  ),
                  SizedBox(height: 8),
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
                    initialValue: _formatDate(toDate!),
                  ),
                  SizedBox(height: 8),
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
                  _addSchedule(description, fromDate!, toDate!);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<DateTime?> _selectDate(BuildContext context, DateTime initialDate) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }
}

// 일정 데이터를 JSON 문자열로 변환
  String _convertScheduleDataToJson(Map<String, List<Schedule>> data) {
    final jsonData = data.map((key, value) {
      return MapEntry(
          key, value.map((schedule) => schedule.toJson()).toList());
    });
    return json.encode(jsonData);
  }

  // JSON 문자열을 일정 데이터로 변환
  Map<String, List<Schedule>> _parseScheduleData(String jsonData) {
    final decoded = json.decode(jsonData) as Map<String, dynamic>;
    return decoded.map((key, value) {
      return MapEntry(
          key,
          (value as List)
              .map((item) => Schedule.fromJson(item as Map<String, dynamic>))
              .toList());
    });
  }

  // 날짜 변환 함수
  DateTime _parseDate(dynamic date) {
    if (date is int) {
      return DateTime.fromMillisecondsSinceEpoch(date);
    } else if (date is String) {
      return DateTime.parse(date);
    } else {
      throw FormatException("Invalid date format");
    }
  }

class Schedule {
  final int userID;
  final String userName;
  final String description;
  final DateTime fromDate;
  final DateTime toDate;

  Schedule({
    required this.userID,
    required this.userName,
    required this.description,
    required this.fromDate,
    required this.toDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'userName': userName,
      'description': description,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
    };
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      userID: json['userID'],
      userName: json['userName'],
      description: json['description'],
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']),
    );
  }
  
}