import 'package:client/screens/company_change_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/shared_preference_helper.dart';
import 'login_screen.dart';
import 'license_screen.dart';
import 'myinfo_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Loading..."; // 사용자 이름 초기값
  String companyName = "Loading..."; // 회사 이름 초기값
  final String profileImage =
      "https://avatars.githubusercontent.com/u/67246681?v=4"; // 프로필 이미지 URL (임시)

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // 사용자 이름과 회사 정보 불러오기
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await SharedPreferenceHelper.getInfo();
    setState(() {
      userName = userInfo["name"] ?? "Unknown User";
      companyName = userInfo['companyName'] ?? "Unknown Company";
    });
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    bool confirmed = await _showConfirmationDialog(context);
    if (confirmed) {
      await prefs.clear(); // SharedPreferences 데이터 삭제
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  Future<bool> _showConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('로그아웃'),
      content: Text('정말 로그아웃 하시겠습니까?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false), // 명시적으로 false 반환
          child: Text('취소'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true), // 명시적으로 true 반환
          child: Text('확인'),
        ),
      ],
    ),
  ).then((value) => value ?? false); // null 처리 (사용자가 팝업 외부 클릭으로 닫을 경우)
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원정보'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // 알림 화면으로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaceholderScreen(title: "알림"),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 프로필 섹션
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(profileImage),
                ),
                SizedBox(height: 8),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  companyName,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Divider(),

          // 기능 목록
          Expanded(
            child: ListView(
              children: [
                _buildListTile(
                  context,
                  icon: Icons.person,
                  title: "내 정보 관리",
                  onTap: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyinfoScreen()),
                    );
                  },
                ),
                _buildListTile(
                  context,
                  icon: Icons.business,
                  title: "회사 변경",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CompanyChangeScreen()),
                    );
                  },
                ),
                // _buildListTile(
                //   context,
                //   icon: Icons.check_circle,
                //   title: "승인 내역",
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) =>
                //             PlaceholderScreen(title: "승인 내역"),
                //       ),
                //     );
                //   },
                // ),
                _buildListTile(
                  context,
                  icon: Icons.help,
                  title: "오픈소스",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OssLicenseScreen()),
                    );
                  },
                ),
              ],
            ),
          ),

          // 로그아웃 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: Icon(Icons.power_settings_new),
              label: Text("로그아웃"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildListTile(BuildContext context,
      {required IconData icon, required String title, required Function() onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

// 임시 화면 (Placeholder)
class PlaceholderScreen extends StatelessWidget {
  final String title;

  PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          "$title 화면입니다.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}