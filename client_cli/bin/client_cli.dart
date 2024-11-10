import 'package:dio/dio.dart';
//import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:dotenv/dotenv.dart';
import 'dart:io';
import 'dart:convert';

void printFormattedJson(Map<String, dynamic> data) {
    final formattedJson = JsonEncoder.withIndent('  ').convert(data);
    print(formattedJson);
  }

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:3000/api/v1')); // 기본 URL을 실제 API URL로 변경

  Future<int> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/user/', data: userData);
      //print('User created: ${response.data}\n');
      printFormattedJson(response.data!);
      //print('User created: ${response.data!['result']!['userId']}');
      return response.data != null ? response.data!['result']!['userId'] as int : throw Exception('User ID not found');
    } catch (e) {
      print('Failed to create user: $e');
      throw Exception('Failed to create user');
    }
  }

  Future<void> getUser(int userId) async {
    try {
      final response = await _dio.get('/user/$userId');
      //print('User details: ${response.data}\n');
      printFormattedJson(response.data!);
    } catch (e) {
      print('Failed to get user: $e');
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      final response = await _dio.delete('/user/$userId');
      //print('User deleted: ${response.data}\n');
      printFormattedJson(response.data!);
    } catch (e) {
      print('Failed to delete user: $e');
    }
  }

  Future<void> updateUser(int userId, Map<String, dynamic> updatedData) async {
    try {
      final response = await _dio.put('/user/$userId', data: updatedData);
      //print('User updated: ${response.data}');
      printFormattedJson(response.data!);
      final userService = ApiService();
      await userService.getUser(userId);
    } catch (e) {
      print('Failed to update user: $e');
    }
  }

  // 출근 등록
  Future<int> registerCommuteIn(int userId) async {
    try {
      final response = await _dio.post('/user/commute/in', data: {'userId': userId});
      //print('Commute in registered: ${response.data}');
      printFormattedJson(response.data!);
      return response.data != null ? response.data!['result']!['commuteId'] as int : throw Exception('Commute ID not found');
    } catch (e) {
      print('Failed to register commute in: $e');
      throw Exception('Failed to register commute in');
    }
  }

  // 퇴근 등록
  Future<void> registerCommuteOut(int userId) async {
    try {
      final response = await _dio.post('/user/commute/out', data: {'userId': userId});
      //print('Commute out registered: ${response.data}');
      printFormattedJson(response.data!);
    } catch (e) {
      print('Failed to register commute out: $e');
    }
  }

  // 회사 신청
  Future<void> applyCompany(int userId, int companyId) async {
    try {
      final response = await _dio.post('/user/company', data: {'userId': userId, 'companyId': companyId});
      //print('Company applied: ${response.data}');
      printFormattedJson(response.data!);
    } catch (e) {
      print('Failed to apply for company: $e');
    }
  }

  // 스케줄 정보 조회
  Future<void> getPlan(int companyId) async {
    try {
      final response = await _dio.get('/plan/$companyId');
      //print('Plan details: ${response.data}');
      printFormattedJson(response.data!);
    } catch (e) {
      print('Failed to get plan: $e');
    }
  }

  // 스케줄 등록
  Future<int> createPlan(Map<String, dynamic> planData) async {
    try {
      final response = await _dio.post('/plan', data: planData);
      //print('Plan created: ${response.data}');
      printFormattedJson(response.data!);
      return response.data != null ? response.data!['result']!['planId'] as int : throw Exception('Plan ID not found');
    } catch (e) {
      print('Failed to create plan: $e');
      throw Exception('Failed to create plan');
    }
  }

  // 스케줄 수정
  Future<void> updatePlan(int planId, Map<String, dynamic> planData, int companyId) async {
    try {
      final response = await _dio.put('/plan/$planId', data: planData);
      //print('Plan updated: ${response.data}');
      printFormattedJson(response.data!);
      await getPlan(companyId);
    } catch (e) {
      print('Failed to update plan: $e');
    }
  }

  // 스케줄 삭제
  Future<void> deletePlan(int planId, int userId) async {
    try {
      final response = await _dio.delete('/plan/$planId', data: {'userId': userId});
      //print('Plan deleted: ${response.data}');
      printFormattedJson(response.data!);
    } catch (e) {
      print('Failed to delete plan: $e');
    }
  }

  // 회사 정보 조회
  Future<void> getCompany(int companyId) async {
    try {
      final response = await _dio.get('/company/$companyId');
      //print('Company details: ${response.data}');
      printFormattedJson(response.data!);
    } catch (e) {
      print('Failed to get company: $e');
    }
  }

  // 회사 등록
  Future<int> createCompany(Map<String, dynamic> companyData) async {
    try {
      final response = await _dio.post('/company', data: companyData);
      //print('Company created: ${response.data}');
      printFormattedJson(response.data!);
      return response.data != null ? response.data!['result']!['companyId'] as int : throw Exception('Company ID not found');
    } catch (e) {
      print('Failed to create company: $e');
      throw Exception('Failed to create company');
    }
  }

  // 회사 정보 수정
  Future<void> updateCompany(int companyId, Map<String, dynamic> companyData) async {
    try {
      dynamic response = await _dio.put('/company/$companyId', data: companyData);
      response = await _dio.get('/company/$companyId');
      //print('Company updated: ${response.data}');
      printFormattedJson(response.data!);
    } catch (e) {
      print('Failed to update company: $e');
    }
  }

  // 회사 삭제
  Future<void> deleteCompany(int companyId) async {
    try {
      final response = await _dio.delete('/company/$companyId');
      //print('Company deleted: ${response.data}');
      printFormattedJson(response.data!);
    } catch (e) {
      print('Failed to delete company: $e');
    }
  }

  // 관리자 - 직원 회사 등록
  Future<void> adminRegisterCompany(int userId, int companyId) async {
    try {
      final response = await _dio.put('/admin/activate/$userId', data: {'companyId': companyId});
      //print('Admin registered company: ${response.data}');
      printFormattedJson(response.data!);
    } catch (e) {
      print('Failed to register company for user: $e');
    }
  }

  // 관리자 - 직원 회사 삭제
  Future<void> adminRemoveUserFromCompany(int userId, int companyId) async {
    try {
      final response = await _dio.put('/admin/deactivate/$userId', data: {'companyId': companyId});
      //print('Admin removed user from company: ${response.data}');
      printFormattedJson(response.data!);
    } catch (e) {
      print('Failed to remove user from company: $e');
    }
  }

  // 관리자 - 직원 출근 시간 변경
  Future<void> adminUpdateCommuteInTime(int userId, Map<String, dynamic> commuteData) async {
    try {
      final response = await _dio.put('/admin/commute/in/$userId', data: commuteData);
      //print('Admin updated commute in time: ${response.data}');
      printFormattedJson(response.data!);
    } catch (e) {
      print('Failed to update commute in time: $e');
    }
  }

  // 관리자 - 직원 퇴근 시간 변경
  Future<void> adminUpdateCommuteOutTime(int userId, Map<String, dynamic> commuteData) async {
    try {
      final response = await _dio.put('/admin/commute/out/$userId', data: commuteData);
      //print('Admin updated commute out time: ${response.data}');
      printFormattedJson(response.data!);
    } catch (e) {
      print('Failed to update commute out time: $e');
    }
  }

  // 관리자 - 직원 출퇴근 조회
  Future<void> adminGetUserCommute(int userId, commuteDate) async {
    try {
      final response = await _dio.get('/admin/commute/$userId', data: commuteDate);
      //print('User commute details: ${response.data}');
      printFormattedJson(response.data!);
    } catch (e) {
      print('Failed to get user commute details: $e');
    }
  }
}


  //카카오
  //카카오 로그인 구현 (유저 생성) 
  // 환경설정: 카카오 API 키와 리디렉션 URI
  var env = DotEnv(includePlatformEnvironment: true)..load();
  final String? kakaoRestApiKey = env['KAKAO_REST_API_KEY'];
  final String? kakaoJavaScriptKey = env['KAKAO_JAVASCRIPT_KEY'];
  const String redirectUri = 'http://localhost:3000/oauth';

  final Dio dio = Dio();

  // 카카오 로그인 요청 (인가 코드 얻기)
  // Future<void> loginWithKakao() async {
  // // 카카오 로그인 URL 생성
  //   final loginUrl = Uri.parse(
  //     'https://kauth.kakao.com/oauth/authorize'
  //     '?client_id=$kakaoRestApiKey'
  //     '&redirect_uri=$redirectUri'
  //     '&response_type=code',
  //   );

  //   dio.get(loginUrl);
  // }

// 카카오 로그인 URL 생성 함수
String getKakaoLoginUrl() {
  return 'https://kauth.kakao.com/oauth/authorize'
      '?client_id=$kakaoRestApiKey'
      '&redirect_uri=$redirectUri'
      '&response_type=code';
}

// URL을 브라우저에서 열기
Future<void> openUrl(String url) async {
  if (Platform.isWindows) {
    await Process.start('start', [url], runInShell: true);
  } else if (Platform.isMacOS) {
    await Process.start('open', [url]);
  } else if (Platform.isLinux) {
    await Process.start('xdg-open', [url]);
  } else {
    throw 'Unsupported platform';
  }
}

// ===================================
// main() 함수 client cli 시작!!!!!!
// ===================================
void main() async {
  
  final api = ApiService();
  int userId, companyId, planId, commuteId;

  //await dotenv.load(fileName: '.env');

  final kakaoLoginUrl = getKakaoLoginUrl();
  print('Opening Kakao login URL...');
  await openUrl("http://127.0.0.1:3000/oauth/kakao");

  String? tmp = stdin.readLineSync();
  // 개인정보로 인해 임시 데이터로 대체.
  // 카카오 로그인으로 회원가입되는 정보는 이름, 이메일, 성별, 생년월일, 전화번호
  //  이름:    홍길동
  //  이메일:   gilldong@hong.com
  //  성별:    M
  //  생년월일: 1990-05-05
  //  전화번호: 010-1234-5678
  // UserId
  // 유저 생성 (POST)
  print('--- 유저 생성 ---');
  userId = await api.createUser({
    'name': '홍길동',
    'email': 'gilldong@hong.com',
    'gender': 'M',
    'birthday': '1990-05-05',
    'phoneNumber': '010-1234-5678',
   });

  tmp = stdin.readLineSync();

  //회사 생성
  print('--- 회사 등록 ---');
  companyId = await api.createCompany({
    'name': 'New Company',
    'address': 'Seoul, South Korea',
  });
  tmp = stdin.readLineSync();

  //회사 등록 신청 (회사 관리자가 승인/철회 가능)
  print('--- 유저 회사 연결 ---');
  await api.applyCompany(userId, companyId);

  tmp = stdin.readLineSync();

  //유저 조회 (GET)
  print('--- 유저 조회 ---');
  await api.getUser(userId);

  tmp = stdin.readLineSync();

  //관리자...
  //유저를 회사에 등록
  print('--- 유저 회사 승인 ---');
  await api.adminRegisterCompany(userId, companyId);

  tmp = stdin.readLineSync();

  //유저 정보 수정 (PUT)
  print('--- 유저 수정 ---');
  await api.updateUser(userId, {
    'name': 'gilldongHong',
    'email': 'gilldong@hong.com',
    'gender': 'M',
    'birthday': '1990-05-05',
    'phoneNumber': '010-1234-5678',
  });

  tmp = stdin.readLineSync();

  //회사 조회
  print('--- 회사 조회 ---');
  await api.getCompany(companyId);

  tmp = stdin.readLineSync();

  //회사 정보 수정
  print('--- 회사 수정 ---');
  await api.updateCompany(companyId, {
    'name': 'Updated Company',
    'address': 'Busan, South Korea',
  });

  tmp = stdin.readLineSync();

  //유저 출근
  print('--- 유저 출근 ---');
  commuteId = await api.registerCommuteIn(userId);

  tmp = stdin.readLineSync();

  //유저 퇴근
  print('--- 유저 퇴근 ---');
  await api.registerCommuteOut(userId);

  tmp = stdin.readLineSync();

  //유저 일정 등록
  print('--- 일정 등록 ---');
  planId = await api.createPlan({
    'userId': userId,
    'description': '회의 참석',
    'startDate': '2024-11-15',
    'endDate': '2024-11-15',
  });

  tmp = stdin.readLineSync();

  //유저 일정 조회 (회사의 일정을 조회하게 됨.)
  print('--- 일정 조회 ---');
  await api.getPlan(companyId);

  tmp = stdin.readLineSync();

  //유저 일정 수정
  print('--- 일정 수정 ---');
  await api.updatePlan(planId, {
    'userId': userId,
    'description': '회의 시간 변경',
    'startDate': '2024-11-15',
    'endDate': '2024-11-15',
  }, companyId);

  tmp = stdin.readLineSync();

  //유저 일정 삭제
  print('--- 일정 삭제 ---');
  await api.deletePlan(planId, userId);

  tmp = stdin.readLineSync();

  //유저 출근 시간 수정
  print('--- 출근 시간 수정 ---');
  await api.adminUpdateCommuteInTime(userId, {
    'commuteId': commuteId,
    'goToWork': '2024-11-10 08:00:00',
  });

  tmp = stdin.readLineSync();

  //유저 퇴근 시간 수정
  print('--- 퇴근 시간 수정 ---');
  await api.adminUpdateCommuteOutTime(userId, {
    'commuteId': commuteId,
    'getOffWork': '2024-11-10 18:00:00',
  });

  tmp = stdin.readLineSync();

  //유저의 출퇴근 조회
  print('--- 출퇴근 조회 ---');
  await api.adminGetUserCommute(userId, {
    'commuteDate': '2024-11-10',
  });
  
  tmp = stdin.readLineSync();

  //관리자
  //유저를 회사에서 삭제 (유저는 다시 신청 상태가 됨)
  print('--- 유저 회사 승인 취소 ---');
  await api.adminRemoveUserFromCompany(userId, companyId);
  
  tmp = stdin.readLineSync();

  //유저 삭제
  print('--- 유저 삭제 ---');
  await api.deleteUser(userId);

  tmp = stdin.readLineSync();

  //회사 삭제
  print('--- 회사 삭제 ---');
  await api.deleteCompany(companyId);

  // // Create a new user
  // userId = await userService.createUser({
  //   'name': 'John Doe',
  //   'email': 'johndoe@example.com',
  // });

  // // Get a user by ID
  // await userService.getUser(userId);

  // // Update user information
  // await userService.updateUser(userId, {
  //   'name': 'Kane Doe',
  //   'email': 'kanedoe@example.co.kr',
  // });

  // // Delete a user by ID
  // await userService.deleteUser(userId); 
}