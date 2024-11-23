import 'package:flutter/material.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  // 더미 사용자 정보
  final String userName = "Junho";
  final String profileImage =
      "https://via.placeholder.com/150"; // 프로필 이미지 URL (임시)

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
              // 알림 기능
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
                      MaterialPageRoute(
                          builder: (context) => PlaceholderScreen(
                              title: "내 정보 관리")), // PlaceholderScreen은 임시 화면
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
                      MaterialPageRoute(
                          builder: (context) =>
                              PlaceholderScreen(title: "회사 변경")),
                    );
                  },
                ),
                _buildListTile(
                  context,
                  icon: Icons.check_circle,
                  title: "승인 내역",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PlaceholderScreen(title: "승인 내역")),
                    );
                  },
                ),
                _buildListTile(
                  context,
                  icon: Icons.help,
                  title: "고객센터",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PlaceholderScreen(title: "고객센터")),
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
              onPressed: () {
                // 로그아웃 처리
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
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

  // 기능 항목을 빌드하는 메서드
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
