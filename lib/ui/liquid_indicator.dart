import 'package:flutter/material.dart';
import 'package:habitui/constant/theme.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class LiquidCustomProgressIndicatorPage extends StatelessWidget {
  const LiquidCustomProgressIndicatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _AnimatedLiquidCustomProgressIndicator(),
        ],
      ),
    );
  }
}

class _AnimatedLiquidCustomProgressIndicator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      _AnimatedLiquidCustomProgressIndicatorState();
}

class _AnimatedLiquidCustomProgressIndicatorState
    extends State<_AnimatedLiquidCustomProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _animationController.addListener(() => setState(() {}));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = _animationController.value * 100;
    return Center(
      child: LiquidCustomProgressIndicator(
        value: _animationController.value,
        direction: Axis.vertical,
        backgroundColor: backgroundLC,
        valueColor: AlwaysStoppedAnimation(routinC),
        shapePath: _buildHeartPath(), // 사각형 Path로 변경됨
        center: Text(
          "${percentage.toStringAsFixed(0)}%",
          style: TextStyle(
            color: ruoutinCD,
            fontSize: basicFS,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Path _buildHeartPath() {
    return Path()..addRect(const Rect.fromLTWH(0, 0, 50, 50)); // 사각형
  }
}
