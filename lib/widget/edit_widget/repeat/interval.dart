import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habitui/widget/edit_widget/bottom_sheet.dart'; // CustomBottomSheet가 정의된 파일

/// 바텀시트에서 반환할 데이터 (예: "매주", "2주마다" 등)
class IntervalSettingResult {
  final String interval;
  IntervalSettingResult(this.interval);
}

/// 간격 설정 BottomSheet
class IntervalSettingBottomSheet extends StatefulWidget {
  final String initialInterval; // 초기값 ("매주", "2주마다" 등)

  const IntervalSettingBottomSheet({
    super.key,
    required this.initialInterval,
  });

  @override
  State<IntervalSettingBottomSheet> createState() =>
      _IntervalSettingBottomSheetState();
}

class _IntervalSettingBottomSheetState
    extends State<IntervalSettingBottomSheet> {
  // 간격 후보
  final List<String> _intervals = [
    "매주",
    "2주마다",
    "3주마다",
    "4주마다",
  ];

  // 선택된 인덱스
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    // 초기 인덱스 설정 (만약 widget.initialInterval이 목록에 없으면 0으로)
    _selectedIndex = _intervals.indexOf(widget.initialInterval);
    if (_selectedIndex < 0) {
      _selectedIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      heightFactor: 0.4,
      title: '간격 설정',
      trailing: IconButton(
        icon: const Icon(Icons.check),
        onPressed: () {
          // 선택된 인덱스의 문자열을 반환
          final result = IntervalSettingResult(_intervals[_selectedIndex]);
          Navigator.pop(context, result);
        },
      ),
      onClose: () => Navigator.pop(context),
      child: Column(
        children: [
          Expanded(
            child: CupertinoPicker(
              scrollController:
                  FixedExtentScrollController(initialItem: _selectedIndex),
              itemExtent: 40.0,
              onSelectedItemChanged: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: _intervals.map((interval) {
                return Center(
                  child: Text(
                    interval,
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "간격을 선택하세요",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
