import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // 로그인 상태 확인 후 화면 전환
  void _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 3), () {});

    bool isLoggedIn = false; // 실제 로그인 상태는 로컬 저장소나 서버에서 확인
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/main'); // 홈 화면으로 이동
    } else {
      Navigator.pushReplacementNamed(context, '/login'); // 로그인 화면으로 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png', // 앱 로고
              height: 100,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.orange),
          ],
        ),
      ),
    );
  }
}