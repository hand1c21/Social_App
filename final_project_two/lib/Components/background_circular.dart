import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    final Gradient gradient = LinearGradient(
      colors: <Color>[
        Color.fromARGB(209, 11, 23, 202),
        Color.fromARGB(132, 35, 137, 168),
        Color.fromARGB(132, 156, 211, 236),
        Color.fromARGB(255, 216, 221, 223), 
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final Paint paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);

    final Path path = Path();
    path.moveTo(0, size.height * 0.5);
    path.lineTo(size.width * 0.25, size.height * 0.5); 
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.605, 
      size.width * 0.75, size.height * 0.5, 
    );
    path.lineTo(size.width, size.height * 0.5); 
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    final Paint whitePaint = Paint()..color = Colors.white;
    canvas.drawPath(path, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
