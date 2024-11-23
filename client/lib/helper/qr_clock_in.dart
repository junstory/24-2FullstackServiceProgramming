// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:dio/dio.dart';
// import './shared_preference_helper.dart';
// class QrClockInScreen extends StatefulWidget {
//   @override
//   _QrClockInScreenState createState() => _QrClockInScreenState();
// }

// class _QrClockInScreenState extends State<QrClockInScreen> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//   bool isProcessing = false; // 중복 처리 방지
//   final Dio _dio = Dio(); // 서버 요청을 위한 Dio 인스턴스

//   @override
//   void reassemble() {
//     super.reassemble();
//     if (controller != null) {
//       controller!.pauseCamera();
//       controller!.resumeCamera();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QR 코드로 출근하기'),
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: [
//           QRView(
//             key: qrKey,
//             onQRViewCreated: _onQRViewCreated,
//           ),
//           Positioned(
//             bottom: 20,
//             left: 20,
//             right: 20,
//             child: ElevatedButton(
//               onPressed: () {
//                 controller?.pauseCamera();
//                 Navigator.pop(context);
//               },
//               child: Text('취소'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController qrController) {
//     this.controller = qrController;
//     qrController.scannedDataStream.listen((scanData) async {
//       if (isProcessing) return; // 중복 처리를 방지

//       setState(() {
//         isProcessing = true;
//       });

//       // QR 코드 데이터 처리
//       await _processQrCode(scanData.code);

//       setState(() {
//         isProcessing = false;
//       });
//     });
//   }

//   Future<void> _processQrCode(String? code) async {
//     if (code == null) {
//       _showMessage('유효하지 않은 QR 코드입니다.');
//       return;
//     }
//     final userInfo = await SharedPreferenceHelper.getLoginInfo();
//     try {
//       // 서버로 출근 데이터 전송
//       final response = await _dio.post(
//         'http://10.0.2.2:3000/api/v1/user/commute/in', // 서버의 출근 엔드포인트
//         data: {
//           'method': 'qr',
//           'userId':  int.parse(userInfo['userId'].toString()), // QR 코드로 전달된 사용자 ID
//         },
//         options: Options(headers: {
//           'Content-Type': 'application/json',
//         }),
//       );

//       if (response.statusCode == 200 && response.data['success'] == true) {
//         _showMessage('출근 성공! (${response.data['message']})');
//         controller?.pauseCamera(); // 성공 시 카메라 중지
//       } else {
//         _showMessage('출근 실패: ${response.data['message']}');
//       }
//     } on DioError catch (e) {
//       _showMessage('서버와의 연결에 실패했습니다: ${e.message}');
//     }
//   }

//   void _showMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }
