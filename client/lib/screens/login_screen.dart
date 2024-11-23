import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 로그인 처리
  void _handleLogin() {
    String email = _emailController.text;
    String password = _passwordController.text;

    // 간단한 유효성 검사
    if (email.isNotEmpty && password.isNotEmpty) {
      // 서버 인증 요청 (실제 로직에서는 API 호출 필요)
      bool loginSuccess = true; // 임시 성공 플래그

      if (loginSuccess) {
        Navigator.pushReplacementNamed(context, '/main'); // 메인 화면으로 이동
      } else {
        // 로그인 실패 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 실패: 잘못된 이메일 또는 비밀번호')),
        );
      }
    } else {
      // 입력 필드가 비어 있는 경우
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일과 비밀번호를 입력하세요')),
      );
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

            // 로그인 버튼
            ElevatedButton(
              onPressed: _handleLogin,
              child: Text('로그인'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}