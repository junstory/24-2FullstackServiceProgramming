import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Dio _dio = Dio();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkServerHealth();
    });
    
  }

  // 서버 상태 확인
  Future<void> _checkServerHealth() async {
    try {
      final response = await _dio.get('http://10.0.2.2:3000/health');
      if (response.statusCode == 200 && response.data['success'] == true) {
        // 서버 연결 성공 -> 로그인 화면으로 이동
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        // 서버 연결 실패
        _showError('서버 상태가 불안정합니다.');
      }
    } on DioError catch (error) {
      // 서버 연결 오류 처리
      print("서버 연결 실패: ${error.message}");
      print("에러 응답 데이터: ${error.response?.data}");
      _showError('서버와의 연결에 실패했습니다: ${error.message}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 오류 메시지 표시
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    // 일정 시간 후 앱 종료 (또는 다시 시도 버튼 제공 가능)
    Future.delayed(Duration(seconds: 5), () {
      // 앱 종료 또는 사용자 재시도 로직 추가 가능
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/assets/logo.png', height: 100),
                  SizedBox(height: 20),
                  CircularProgressIndicator(color: Colors.orange),
                ],
              )
            : Text('오류 발생. 다시 시도하세요.'),
      ),
    );
  }
}