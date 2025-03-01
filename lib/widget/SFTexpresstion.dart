import 'package:flutter/material.dart';

class ValueDisplayWidget extends StatelessWidget {
  final double greenValue;
  final double redValue;
  final double grayValue;

  const ValueDisplayWidget({
    super.key,
    required this.greenValue,
    required this.redValue,
    required this.grayValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildValueCard(
          icon: Icons.check_circle,
          color: Colors.green,
          value: greenValue,
          label: "완료됨",
        ),
        _buildValueCard(
          icon: Icons.cancel,
          color: Colors.red,
          value: redValue,
          label: "놓침",
        ),
        _buildValueCard(
          icon: Icons.arrow_forward,
          color: Colors.grey,
          value: grayValue,
          label: "건너뛰기",
        ),
      ],
    );
  }

  Widget _buildValueCard({
    required IconData icon,
    required Color color,
    required double value,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 30,
              ),
              const SizedBox(height: 10),
              Text(
                value.toStringAsFixed(0), // 소수점 없이 정수로 표시
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
