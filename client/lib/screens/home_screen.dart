import 'package:flutter/material.dart';
import "../helper/wifi_clock_in.dart";
import  '../helper/qr_clock_in.dart';
import '../helper/shared_preference_helper.dart';
import '../helper/gps_clock_in.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState  extends State<HomeScreen> {
  final GpsClockIn _gpsClockIn = GpsClockIn();
  String? userId;
  String? accessToken;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    // SharedPreferences에서 유저 정보 가져오기
    final userInfo = await SharedPreferenceHelper.getLoginInfo();
    setState(() {
      userId = userInfo['userId'];
      accessToken = userInfo['accessToken'];
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        '2024.10.08(화)',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {
                          // 설정 이동
                        },
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
                        _showClockInDialog(context);
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
                                  '출근',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '09:00', // 출근 시간
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                  
                                ), 
                                SizedBox(height: 3),
                                Text(
                                  '--:--', // 실제 출근 시간
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
                            _buildWorkInfoColumn('출근 예정 시간', '09h00m'),
                            VerticalDivider(width: 1, thickness: 1),
                            _buildWorkInfoColumn('퇴근 예정 시간', '18h00m'),
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
                WifiClockIn().handleClockIn(context, userId.toString());
                print("WiFi로 출근하기 클릭");
              },
            ),
            ListTile(
              leading: Icon(Icons.qr_code),
              title: Text('QR코드로 출근하기'),
              onTap: () {
            //     Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => QrClockInScreen()),
            // );
                Navigator.pop(context);
                print("QR코드로 출근하기 클릭");
              },
            ),
            ListTile(
              leading: Icon(Icons.gps_fixed),
              title: Text('GPS로 출근하기'),
              onTap: () {
                Navigator.pop(context);
                _gpsClockIn.handleClockIn(context, userId.toString());
                print("GPS로 출근하기 클릭");
              },
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
