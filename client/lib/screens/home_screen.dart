import 'package:flutter/material.dart';
import "../helper/wifi_clock_in.dart";
//import  '../helper/qr_clock_in.dart';
import '../helper/shared_preference_helper.dart';
import '../helper/gps_clock_in.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState  extends State<HomeScreen> {
 bool isLoading = true;

  final GpsClockIn _gpsClockIn = GpsClockIn();
  String formattedDate = ''; // 현재 날짜
  int? userId; // 유저 ID
  String? accessToken;
  String userName = "Loading..."; // 유저 이름 기본값
  String email = "Loading..."; // 이메일 기본값

  String? planedToGo; // 출근 예정 시간
  String? goToWork; // 실제 출근 시간
  String? planedToLeave; // 퇴근 예정 시간
  String? goOffWork; // 실제 퇴근 시간
  String? nextPlanedToGo; // 다음날 출근 예정 시간
  String? nextPlanedToLeave; // 다음날 퇴근 예정 시간

  String workStatus = "출근";
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _initializeLocale();
    
  }
  Future<void> _initializeLocale() async {
    await initializeDateFormatting('ko'); // 한국어 로케일 초기화
    _getCurrentDate();
  }

  void _getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy.MM.dd (E)', 'ko'); // 한국어 요일
    setState(() {
      formattedDate = formatter.format(now); // 예: 2024.10.08 (화)
    });
  }

  Future<void> _loadUserInfo() async {
    try {
      // SharedPreferences에서 accessToken 가져오기
      final userInfo = await SharedPreferenceHelper.getLoginInfo();
      accessToken = userInfo['accessToken'];

      if (accessToken != null) {
        // 서버에서 유저 정보 가져오기
        await _fetchUserDetails();
      } else {
        print('Access token is null');
      }
    } catch (e) {
      print('Error loading user info: $e');
    }
  }

  Future<void> _fetchUserDetails() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'http://10.0.2.2:3000/api/v1/user', // 유저 정보 API
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );
      print(response.data['result']['today']['planedToGo']);
      if (response.statusCode == 200) {
        final result = response.data['result'];
         await SharedPreferenceHelper.saveNameIdCompany(response.data['result']['name'], response.data['result']['id'], response.data['result']['companyId'], response.data['result']['companyName'], response.data['result']['phoneNumber']);
         
        setState(() {
          userName = result['name'] ?? "Unknown";
          email = result['email'] ?? "Unknown";
          planedToGo = result['today']['planedToGo']?? "--:--";
          goToWork = result['today']['goToWork'] ?? "--:--";
          planedToLeave = result['today']['planedToLeave'] ?? "--:--";
          goOffWork = result['today']['getOffWork'] ?? "--:--";
          nextPlanedToGo = result['next']['planedToGo']?? "--:--";
          nextPlanedToLeave = result['next']['planedToLeave']?? "--:--";
        });
        planedToGo =formatTimeForClock(planedToGo);
        planedToLeave =formatTimeForClock(planedToLeave);
        goToWork = formatTimeForClock(goToWork);
        goOffWork = formatTimeForClock(goOffWork);
      } else {
        print('Failed to fetch user details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }finally {
      print('User info loaded');
      setState(() {
        isLoading = false; // 로딩 종료
      });
    }
  }
// 시간을 변환하는 헬퍼 함수 (hh:mm 형식)
  String formatTimeForClock(String? time) {
  if (time == null) return "--:--";
  
  try {
    if (time.contains(' ')) {
      // "2024-12-06 12:24:59" 형식
      time = time.split(' ')[1]; // 시간 부분만 추출
    }
    
    if (time.contains(':')) {
      // "12:24:59" 또는 "18:00" 형식
      return time.substring(0, 5); // 앞의 HH:mm 부분만 반환
    } else if (time.length == 4) {
      // "1800" 형식
      return '${time.substring(0, 2)}:${time.substring(2)}';
    }
  } catch (e) {
    print('Error formatting time: $e');
  }
  
  return "--:--";
}

  @override
  Widget build(BuildContext context) {
     if (isLoading) {
      return Center(child: CircularProgressIndicator()); // 로딩 상태 표시
    }
    bool isClockIn = goToWork != "--:--";
    isClockIn ? workStatus = "퇴근" : workStatus = "출근";
    print('$isClockIn $planedToLeave $goOffWork $planedToGo $goToWork');

    return Scaffold(
      body: Stack(
        children: [
          // 배경 색상
          Column(
            children: [
              Expanded(
                flex: 6,
                child: Container(color: Color(0xFFF2F2F2)),
              ),
              Expanded(
                flex: 4,
                child: Container(color: Color(0xFFF59A7E)),
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 상단 날짜
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      
                    ],
                  ),
                  SizedBox(height: 24),

                  // 중앙 출근 버튼
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // 버튼 클릭 이벤트 처리
                        print("출근 버튼 클릭");
                        isClockIn? _showClockOutDialog(context) :_showClockInDialog(context);
                      },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFFF8E42), // 96%
                                Color(0xFFE3B595), // 47%
                                Color(0xFFEED765), // 9%
                              ],
                              stops: [0.0, 0.5, 1.0],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  workStatus, //출티근 상태
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  isClockIn? planedToLeave.toString():planedToGo.toString(),// 출근 예정 시간
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                  
                                ), 
                                SizedBox(height: 3),
                                Text(
                                  isClockIn? goOffWork.toString(): goToWork.toString(), // 실제 출근 시간
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  
                                ),
                              ],
                            ),
                          ),
                        ),
                        // QR코드 스타일 모서리 선
                        Positioned.fill(
                          child: CustomPaint(
                            painter: QRCornerPainter(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                  SizedBox(height: 100),

                  // 근로시간 정보
                  Align(
                    alignment: Alignment.center,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildWorkInfoColumn('총 근로시간', '09h00m'),
                            VerticalDivider(width: 1, thickness: 1),
                            _buildWorkInfoColumn('근로인정', '00h00m'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  // 다음날 근로시간 정보
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 타이틀
                          Text(
                            '내일 근무 정보',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          // 출근/퇴근 시간
                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildWorkInfoColumn('출근 예정 시간', formatTimeForClock(nextPlanedToGo)),
                            VerticalDivider(width: 1, thickness: 1),
                            _buildWorkInfoColumn('퇴근 예정 시간', formatTimeForClock(nextPlanedToLeave)),
                          ],
                        ),
                        ],
                      ),
                    ),
                  ),
                ],
                
              ),
            ),
          ),
        ],
      ),
    );
  }

 // 출근 옵션 다이얼로그
  void _showClockInDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.wifi),
              title: Text('WiFi로 출근하기'),
              onTap: () {
                Navigator.pop(context);
                WifiClockIn().handleClockIn(context);
                print("WiFi로 출근하기 클릭");
                _loadUserInfo();
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.qr_code),
            //   title: Text('QR코드로 출근하기'),
            //   onTap: () {
            // //     Navigator.push(
            // //   context,
            // //   MaterialPageRoute(builder: (context) => QrClockInScreen()),
            // // );
            //     Navigator.pop(context);
            //     print("QR코드로 출근하기 클릭");
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.gps_fixed),
              title: Text('GPS로 출근하기'),
              onTap: () {
                Navigator.pop(context);
                GpsClockIn().handleClockIn(context);
                print("GPS로 출근하기 클릭");
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleClockOut() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        'http://10.0.2.2:3000/api/v1/user/commute/out',
        data: {
          "userId": userId,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("퇴근이 성공적으로 처리되었습니다!")),
        );
        _loadUserInfo();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("퇴근 처리 실패: ${response.data['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("서버와의 연결 중 오류가 발생했습니다: $e")),
      );
    }
  }

  void _showClockOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("퇴근 확인"),
          content: Text("퇴근하시는게 맞나요?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("아니요"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // 팝업 닫기
                await _handleClockOut(); // 퇴근 처리
              },
              child: Text("네"),
            ),
          ],
        );
      },
    );
  }

  // 근로시간 정보 열 생성
  Widget _buildWorkInfoColumn(String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

// QR코드 스타일 모서리 선 그리기
class QRCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    // 모서리 선 길이
    const cornerLength = 30.0;

    // 상단 왼쪽
    canvas.drawLine(Offset(0, 0), Offset(cornerLength, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, cornerLength), paint);

    // 상단 오른쪽
    canvas.drawLine(Offset(size.width, 0),
        Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0),
        Offset(size.width, cornerLength), paint);

    // 하단 왼쪽
    canvas.drawLine(Offset(0, size.height),
        Offset(cornerLength, size.height), paint);
    canvas.drawLine(Offset(0, size.height),
        Offset(0, size.height - cornerLength), paint);

    // 하단 오른쪽
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width - cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width, size.height - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
