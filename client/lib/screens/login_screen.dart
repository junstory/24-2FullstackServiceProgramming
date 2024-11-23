import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/shared_preference_helper.dart';


void main() async {
  await dotenv.load(fileName: ".env");
  runApp(LoginScreen());
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // 로딩 상태 표시
  final Dio _dio = Dio(); // Dio 인스턴스 생성

  // 로그인 처리 함수
  Future<void> _handleLogin() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일과 비밀번호를 입력하세요')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      //나중에 수정 예정
      final response = await _dio.get(
        'http://10.0.2.2:3000/health', // 로그인 API 엔드포인트
        data: {
          "email": email,
          "password": password,
        },
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        // final userId = response.data['userId']; // 서버에서 반환된 사용자 ID
        // final accessToken = response.data['accessToken']; // 서버에서 반환된 액세스 토큰

        final userId ="9"; // 서버에서 반환된 사용자 ID
        final accessToken = "test"; // 서버에서 반환된 액세스 토큰
        await SharedPreferenceHelper.saveLoginInfo(userId, accessToken);

        // 메인 화면으로 이동
        Navigator.pushReplacementNamed(context, '/main');
        // 로그인 성공
      } else {
        // 로그인 실패
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 실패: 잘못된 정보')),
        );
      }
    } on DioError catch (error) {
      // 서버 연결 실패 또는 네트워크 오류
      String errorMessage = '서버와의 연결에 실패했습니다.';
      if (error.response != null) {
        errorMessage = '서버 오류: 상태 코드 ${error.response?.statusCode}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 이메일 입력
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: '이메일',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // 비밀번호 입력
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32),

            // 로딩 상태에 따른 버튼 표시
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _handleLogin,
                    child: Text('로그인'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
