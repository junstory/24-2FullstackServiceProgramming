import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/main_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/main': (context) => MainScreen(),
      },
    );
  }
}