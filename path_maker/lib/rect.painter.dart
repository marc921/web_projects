import 'package:flutter/material.dart';

class RectPainter extends CustomPainter {
  const RectPainter(this.size, this.color);
  final double size;
  final Color color;

  @override
  void paint(Canvas canvas, Size _) {
    // Paint one tile
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size, size),
      Paint()
        ..style = PaintingStyle.fill
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(RectPainter oldDelegate) => color != oldDelegate.color;
}
