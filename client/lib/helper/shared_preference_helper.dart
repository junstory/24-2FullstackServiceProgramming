import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  // 저장
  static Future<void> saveLoginToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
  }

  static Future<void> saveNameId(String name, int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setInt('id', id);
  }

  // 불러오기
  static Future<Map<String, String?>> getLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'accessToken': prefs.getString('accessToken'),
    };
  }

  // 불러오기
  static Future<Map<String, String?>> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name'),
    };
  }

  // 삭제 (로그아웃)
  static Future<void> clearLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('accessToken');
  }
  
  static Future<Map<String, dynamic>> getInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getInt('id'),
      'accessToken': prefs.getString('accessToken'),
      'name': prefs.getString('name'),
    };
  }
}