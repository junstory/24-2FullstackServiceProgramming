import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../helper/shared_preference_helper.dart';

class MyinfoScreen extends StatefulWidget {
  @override
  _MyinfoScreenState createState() => _MyinfoScreenState();
}

class _MyinfoScreenState extends State<MyinfoScreen> {
  final _formKey = GlobalKey<FormState>();
  String? accessToken;

  // 사용자 정보
  int userId= 00; // 예: userId=1 (실제 userId를 사용)
  String email= "Unknown";
  String userName = "Unknown";
  String phoneNumber = "Unknown";
  String gender = "Unknown";
  String birthday = "Unknown";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    setState(() {
      isLoading = true; // 로딩 시작
    });
    try {
      // SharedPreferences에서 accessToken 가져오기
      final userInfo = await SharedPreferenceHelper.getLoginInfo();
      accessToken = userInfo['accessToken'];

      if (accessToken != null) {
        // 서버에서 유저 정보 가져오기
        await _fetchUserDetails();
      } else {
        print('Access token is null');
      }
    } catch (e) {
      print('Error loading user info: $e');
    }finally {
      print('User info loaded');
      setState(() {
        isLoading = false; // 로딩 종료
      });
    }
  }

  Future<void> _fetchUserDetails() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'http://10.0.2.2:3000/api/v1/user', // 유저 정보 API
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      if (response.statusCode == 200 && response.data['isSuccess'] == true) {
        final result = response.data['result'];
        setState(() {
          userId = result['id'] ?? 82;
          email = result['email'] ?? "";
          userName = result['name'] ?? "Unknown";
          phoneNumber = result['phoneNumber'] ?? "Unknown";
          gender = result['gender'] ?? "Unknown";
          birthday = result['birthday'] ?? "Unknown";
          
          _nameController.text = userName; // 수정 가능한 필드
          _phoneController.text = phoneNumber; // 수정 가능한 필드
        });
        print('$userId, $email, $userName, $phoneNumber, $gender, $birthday');
      } else {
        print('Failed to fetch user details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  Future<void> _updateUserInfo() async {
    if (!_formKey.currentState!.validate()) {
      return; // 폼이 유효하지 않으면 반환
    }

    try {
      final dio = Dio();
      final response = await dio.put(
        'http://10.0.2.2:3000/api/v1/user/$userId', // 예: userId=1 (실제 userId를 사용)
        data: {
          "email": email,
          "name": _nameController.text,
          "gender": gender,
          "phoneNumber": _phoneController.text,
          "birthday": birthday,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        }),
      );

      if (response.statusCode == 200 && response.data['isSuccess'] == true) {
        print("정보 수정 성공!");
        _showMessage(context, response.data['result']['message']);
      } else {
        print("정보 수정 실패: ${response.data['message']}");
        _showMessage(context, response.data['message']);
      }
    } catch (e) {
      print("정보 수정 중 오류 발생: $e");
      _showMessage(context, "정보 수정 중 오류가 발생했습니다.");
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator()); // 로딩 상태 표시
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보 관리'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이메일
                _buildReadOnlyField('Email', email),
                SizedBox(height: 16),

                // 성별
                _buildReadOnlyField('Gender', gender),
                SizedBox(height: 16),

                // 생일
                _buildReadOnlyField('Birthday', birthday),
                SizedBox(height: 16),

                // 이름 수정 필드
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      value!.isEmpty ? '이름을 입력하세요.' : null,
                ),
                SizedBox(height: 16),

                // 전화번호 수정 필드
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) =>
                      value!.isEmpty ? '전화번호를 입력하세요.' : null,
                ),
                SizedBox(height: 32),

                // 저장 버튼
                ElevatedButton(
                  onPressed: _updateUserInfo,
                  child: Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      readOnly: true,
    );
  }
}