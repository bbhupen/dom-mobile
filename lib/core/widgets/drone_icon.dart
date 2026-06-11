import 'package:flutter/material.dart';

class DroneIcon extends StatelessWidget {
  const DroneIcon({super.key, this.size = 24, this.color, this.filled = false});

  final double size;
  final Color? color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? IconTheme.of(context).color ?? Colors.black;

    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: DroneIconPainter(color: iconColor, filled: filled),
      ),
    );
  }
}

class DroneIconPainter extends CustomPainter {
  DroneIconPainter({required this.color, required this.filled});

  final Color color;
  final bool filled;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.085;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Offset point(double x, double y) => Offset(size.width * x, size.height * y);

    final center = point(0.5, 0.5);
    final rotorCenters = [
      point(0.2, 0.22),
      point(0.8, 0.22),
      point(0.2, 0.78),
      point(0.8, 0.78),
    ];

    for (final rotorCenter in rotorCenters) {
      canvas.drawLine(center, rotorCenter, stroke);
    }

    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: size.width * 0.3,
        height: size.height * 0.24,
      ),
      Radius.circular(size.width * 0.06),
    );

    if (filled) {
      canvas.drawRRect(body, fill);
    } else {
      canvas.drawRRect(body, stroke);
    }

    for (final rotorCenter in rotorCenters) {
      canvas.drawCircle(rotorCenter, size.width * 0.105, stroke);
      if (filled) {
        canvas.drawCircle(rotorCenter, size.width * 0.035, fill);
      }
      canvas.drawLine(
        rotorCenter.translate(-size.width * 0.13, 0),
        rotorCenter.translate(size.width * 0.13, 0),
        stroke,
      );
      canvas.drawLine(
        rotorCenter.translate(0, -size.height * 0.13),
        rotorCenter.translate(0, size.height * 0.13),
        stroke,
      );
    }

    final centerDot = Paint()
      ..color = filled ? Colors.white : color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.035, centerDot);
  }

  @override
  bool shouldRepaint(covariant DroneIconPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.filled != filled;
  }
}
