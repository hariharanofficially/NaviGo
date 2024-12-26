import 'package:flutter/material.dart';

class DrawTriangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    //path.moveTo(size.width / 2, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, Paint()..color = const Color(0xFF8B48DF));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DrawTriangleForMap extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    //path.moveTo(size.width / 2, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}