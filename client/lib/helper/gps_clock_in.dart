import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';

class GpsClockIn {
  final Dio _dio = Dio();

  Future<void> handleClockIn(BuildContext context, String code) async {
    try {
      // 위치 권한 요청
      bool hasPermission = await _checkPermission();
      if (!hasPermission) {
        _showMessage(context, '위치 권한이 필요합니다.');
        return;
      }

      // 현재 위치 가져오기
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 회사 위치 확인 (예: 위도와 경도를 설정)
      const double companyLatitude = 37.5665; // 예시: 서울 위도
      const double companyLongitude = 126.9780; // 예시: 서울 경도
      const double allowedDistanceInMeters = 100.0; // 허용 반경(미터)

      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        companyLatitude,
        companyLongitude,
      );

      if (distance <= allowedDistanceInMeters) {
        // 서버로 출근 데이터 전송
        await _sendClockInData(context, code);
      } else {
        _showMessage(context, '회사 위치에서 너무 멀리 떨어져 있습니다. (거리: ${distance.toStringAsFixed(1)}m)');
      }
    } catch (e) {
      _showMessage(context, 'GPS 정보를 가져오는 중 오류가 발생했습니다: $e');
    }
  }

  Future<void> _sendClockInData(BuildContext context, String code) async {
   try {
      // 서버로 출근 데이터 전송
      final response = await _dio.post(
        'http://10.0.2.2:3000/api/v1/user/commute/in', // 서버의 출근 엔드포인트
        data: {
          'method': 'qr',
          'userId':  int.parse(code), // QR 코드로 전달된 사용자 ID
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        _showMessage(context,'출근 성공! (${response.data['message']})');
      } else {
        _showMessage(context,'출근 실패: ${response.data['message']}');
      }
    } on DioError catch (e) {
      _showMessage(context,'서버와의 연결에 실패했습니다: ${e.message}');
    }
  }

  Future<bool> _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
