import 'package:flutter/material.dart';
import 'dart:math';

class ProgressIndicatorWidget extends StatelessWidget {
  final int maxValue;
  final int currentValue;
  final String progressText;

  const ProgressIndicatorWidget({
    super.key,
    required this.maxValue,
    required this.currentValue,
    required this.progressText,
  });

  double get progress => (currentValue / maxValue).clamp(0.0, 1.0);

  /// 진행률에 따라 색상을 동적으로 변경
  Color get progressColor {
    if (progress < 0.2) return Colors.red;
    if (progress < 0.5) return Colors.orange;
    if (progress < 0.8) return Colors.blue;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5),
        ],
      ),
      child: Column(
        children: [
          Text("강도",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          CustomPaint(
            size: Size(150, 75),
            painter: ProgressArcPainter(progress, progressColor),
          ),
          SizedBox(height: 10),
          Text("${(progress * 100).toInt()}%",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: progressColor, // 진행률에 따른 배경색 변경
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              progressText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressArcPainter extends CustomPainter {
  final double progress;
  final Color progressColor;

  ProgressArcPainter(this.progress, this.progressColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    Paint progressPaint = Paint()
      ..color = progressColor // 진행률에 따라 색상 변경
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height);
    double radius = size.width / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      backgroundPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
