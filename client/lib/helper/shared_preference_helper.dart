import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  // 저장
  static Future<void> saveLoginInfo(String userId, String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('accessToken', accessToken);
  }

  // 불러오기
  static Future<Map<String, String?>> getLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString('userId'),
      'accessToken': prefs.getString('accessToken'),
    };
  }

  // 삭제 (로그아웃)
  static Future<void> clearLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('accessToken');
  }
}
