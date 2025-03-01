import 'package:flutter/material.dart';

class CircularGraph extends StatelessWidget {
  final double greenValue;
  final double redValue;
  final double grayValue;
  final double size;

  const CircularGraph({
    super.key,
    required this.greenValue,
    required this.redValue,
    required this.grayValue,
    this.size = 200, // 기본 크기
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: CircularGraphPainter(
          greenValue: greenValue,
          redValue: redValue,
          grayValue: grayValue,
        ),
      ),
    );
  }
}

class CircularGraphPainter extends CustomPainter {
  final double greenValue;
  final double redValue;
  final double grayValue;

  CircularGraphPainter({
    required this.greenValue,
    required this.redValue,
    required this.grayValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = greenValue + redValue + grayValue;
    final greenAngle = (greenValue / total) * 360;
    final redAngle = (redValue / total) * 360;
    final grayAngle = (grayValue / total) * 360;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    double startAngle = -90;

    // Draw green arc
    paint.color = Colors.green;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      radians(startAngle),
      radians(greenAngle),
      false,
      paint,
    );

    startAngle += greenAngle;

    // Draw red arc
    paint.color = Colors.red;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      radians(startAngle),
      radians(redAngle),
      false,
      paint,
    );

    startAngle += redAngle;

    // Draw gray arc
    paint.color = Colors.grey;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      radians(startAngle),
      radians(grayAngle),
      false,
      paint,
    );
  }

  double radians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
