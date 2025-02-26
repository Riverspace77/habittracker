// exclude_date_selector.dart
import 'package:flutter/material.dart';
import 'package:habitui/constant/theme.dart';

class ExcludedDateSelector extends StatelessWidget {
  final List<int>? initialExcludedDates;

  const ExcludedDateSelector({
    super.key,
    this.initialExcludedDates,
  });

  @override
  Widget build(BuildContext context) {
    List<int> dates = (initialExcludedDates ?? [])..sort();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: dates.isEmpty ? Colors.white : routinC,
        border: Border.all(color: routinC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        dates.isEmpty ? "제외된 날짜 없음" : "${dates.length}개의 날짜 제외됨",
        style: TextStyle(
          color: dates.isEmpty ? routinC : Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
