import 'package:flutter/material.dart';
import 'package:habitui/widget/edit_widget/bottom_sheet.dart';
import 'package:habitui/widget/edit_widget/repeat/repeat_selector.dart';

/// 반복 옵션 바텀시트 (총 8가지 옵션)
class RepeatOptionBottomSheet extends StatelessWidget {
  final RepeatOption initialOption;

  const RepeatOptionBottomSheet({super.key, required this.initialOption});

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      heightFactor: 0.4,
      title: '반복 옵션 선택',
      child: ListView(
        children: RepeatOption.values.map((option) {
          return ListTile(
            title: Text(_optionLabel(option)),
            onTap: () => Navigator.pop(context, option),
            selected: option == initialOption,
          );
        }).toList(),
      ),
    );
  }

  String _optionLabel(RepeatOption option) {
    switch (option) {
      case RepeatOption.none:
        return '없음';
      case RepeatOption.weekday:
        return '요일 선택';
      case RepeatOption.intervalDay:
        return '몇 일마다';
      case RepeatOption.weekly:
        return '주간';
      case RepeatOption.weeklyCount:
        return '주당 횟수';
      case RepeatOption.monthly:
        return '월당 횟수';
      case RepeatOption.yearly:
        return '연당 횟수';
      case RepeatOption.custom:
        return '날짜 선택';
    }
  }
}
