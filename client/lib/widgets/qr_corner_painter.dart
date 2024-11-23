import 'package:flutter/material.dart';

class QRCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFFFC4A3)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    double cornerLength = 30.0;

    // 좌상단
    canvas.drawLine(Offset(0, 0), Offset(cornerLength, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, cornerLength), paint);

    // 우상단
    canvas.drawLine(Offset(size.width, 0),
        Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0),
        Offset(size.width, cornerLength), paint);

    // 좌하단
    canvas.drawLine(Offset(0, size.height),
        Offset(cornerLength, size.height), paint);
    canvas.drawLine(Offset(0, size.height),
        Offset(0, size.height - cornerLength), paint);

    // 우하단
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width - cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width, size.height - cornerLength), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}