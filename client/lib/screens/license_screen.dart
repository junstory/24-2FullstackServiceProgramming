import 'package:flutter/material.dart';

import '../oss_licenses.dart'; // ossLicenses 데이터 import

class OssLicenseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('오픈소스 라이선스'),
      ),
      body: ListView.builder(
        itemCount: ossLicenses.length,
        itemBuilder: (context, index) {
          final package = ossLicenses[index];
          return ListTile(
            title: Text(package.name),
            subtitle: Text(package.description),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OssLicenseDetailScreen(package: package),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class OssLicenseDetailScreen extends StatelessWidget {
  final Package package;

  OssLicenseDetailScreen({required this.package});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(package.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description: ${package.description}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Version: ${package.version}'),
            SizedBox(height: 8),
            if (package.repository != null) ...[
              Text('Repository:'),
              GestureDetector(
                onTap: () {
                  // Repository URL 열기
                },
                child: Text(
                  package.repository!,
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
            SizedBox(height: 8),
            Text('License:'),
            Expanded(
              child: SingleChildScrollView(
                child: Text(package.license ?? "No license available."),
              ),
            ),
          ],
        ),
      ),
    );
  }
}