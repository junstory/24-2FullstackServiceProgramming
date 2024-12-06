import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:dio/dio.dart';
import '../helper/shared_preference_helper.dart';

class WifiClockIn {
   final Dio _dio = Dio();
   final info = NetworkInfo();
  // WiFi 출근 로직
  Future<void> handleClockIn(BuildContext context) async {
    try {
      final userInfo = await SharedPreferenceHelper.getInfo();
      final int? userId = userInfo['id'];
      final String? accessToken = userInfo['accessToken'];

      if (userId == null || accessToken == null) {
        _showMessage(context, '로그인 정보가 없습니다. 다시 로그인해주세요.');
        return;
      }

      String? ssid = await info.getWifiName();
      String? sanitizedSsid = ssid?.replaceAll('"', '').trim();
      print(ssid);
      if (sanitizedSsid == null) {
        _showMessage(context, 'WiFi에 연결되어 있지 않습니다.');
      } else if (sanitizedSsid == "AndroidWifi") {
        // 서버로 출근 데이터 전송
        print("wifi일치! (WiFi: $sanitizedSsid)");
         await _sendClockInData(context, userId, accessToken);
      } else {
        print("등록되지 않은 WiFi입니다. (현재: $sanitizedSsid)");
        _showMessage(context, '등록되지 않은 WiFi입니다. (현재: $ssid)');
      }
    } catch (e) {
      _showMessage(context, 'WiFi 정보를 가져오는 중 오류가 발생했습니다: $e');
    }
  }

   Future<void> _sendClockInData(BuildContext context, int userId, String accessToken) async {
    try {
      print('userId: $userId, accessToken: $accessToken');
      final response = await _dio.post(
        'http://10.0.2.2:3000/api/v1/user/commute/in', // 서버의 출근 엔드포인트
        data: {
          'method': 'wifi',
          //'wifiSsid': ssid,
          'userId':  userId, // QR 코드로 전달된 사용자 ID
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // 인증 토큰
        }),
      );

      if (response.statusCode == 200 && response.data['isSuccess'] == true) {
        _showMessage(context, '출근 성공! (${response.data['message']})');
      } else {
        _showMessage(context, '출근 실패: ${response.data['result']['data']}');
      }
    } on DioError catch (e) {
      _showMessage(context, '서버와의 연결에 실패했습니다: ${e}');
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}


