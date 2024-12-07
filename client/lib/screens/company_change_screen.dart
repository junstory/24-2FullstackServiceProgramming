import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../helper/shared_preference_helper.dart';

class CompanyChangeScreen extends StatefulWidget {
  @override
  _CompanyChangeScreenState createState() => _CompanyChangeScreenState();
}

class _CompanyChangeScreenState extends State<CompanyChangeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyController = TextEditingController();

  String? accessToken;
  int? userId;
  String? currentCompanyId;
  String? errorMessage; // 실패 메시지 저장

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final userInfo = await SharedPreferenceHelper.getInfo();
      setState(() {
        userId = userInfo['id'];
        currentCompanyId = userInfo['companyId'];
        accessToken = userInfo['accessToken'];
        _companyController.text = currentCompanyId ?? "";
      });
    } catch (e) {
      print('Error loading user info: $e');
    }
  }

  Future<void> _changeCompany() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final dio = Dio();
      final response = await dio.put(
        'http://10.0.2.2:3000/api/v1/user/company',
        data: {
          "userId": userId,
          "companyId": int.tryParse(_companyController.text),
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        }),
      );

      if (response.statusCode == 200 && response.data['isSuccess'] == true) {
        setState(() {
          errorMessage = null; // 에러 메시지 초기화
          currentCompanyId = _companyController.text;
        });
        _showMessage(context, response.data['message']);
      } else {
        setState(() {
          errorMessage = response.data['result'];
        });
        print('Failed to change company: ${response.data['result']}');
      }
    } catch (e) {
      print("Error changing company: $e");
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회사 변경'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '현재 회사 ID',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _companyController,
                decoration: InputDecoration(
                  labelText: 'Company ID',
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? '회사 ID를 입력하세요.' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _changeCompany,
                child: Text('회사 변경'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 16),
              if (errorMessage != null)
                Text(
                  '오류: $errorMessage',
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
            ],
          ),
        ),
      ),
    );
  }
}