import 'package:flutter/material.dart';
import 'package:habitui/constant/theme.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class LiquidCustomProgressIndicatorPage extends StatelessWidget {
  final int total;
  final int now;
  final Color color; // ✅ 색상 추가

  const LiquidCustomProgressIndicatorPage({
    super.key,
    required this.total,
    required this.now,
    required this.color, // ✅ 색상 추가
  });

  @override
  Widget build(BuildContext context) {
    double progress =
        (total == 0) ? 0.0 : (now / total).clamp(0.0, 1.0); // 진행률 계산 (0~1 범위)

    return Center(
      child: SizedBox(
        width: 80,
        height: 80,
        child: LiquidCustomProgressIndicator(
          value: progress,
          direction: Axis.vertical,
          backgroundColor: backgroundLC,
          valueColor: AlwaysStoppedAnimation(color), // ✅ 입력받은 색상 적용
          shapePath: _buildRectPath(), // 사각형 모양 유지
          center: Text(
            "${(progress * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              color: ruoutinCD,
              fontSize: basicFS,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // 진행 바의 모양 (현재는 사각형)
  Path _buildRectPath() {
    return Path()..addRect(const Rect.fromLTWH(0, 0, 50, 50));
  }
}
