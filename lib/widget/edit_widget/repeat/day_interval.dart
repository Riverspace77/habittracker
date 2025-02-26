import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habitui/widget/edit_widget/bottom_sheet.dart';

/// 바텀시트에서 반환할 데이터 (예: "2일마다", "3일마다", ... "30일마다")
class DayIntervalSettingResult {
  final String dayInterval;
  DayIntervalSettingResult(this.dayInterval);
}

/// 몇일마다 설정 BottomSheet
class DayIntervalSettingBottomSheet extends StatefulWidget {
  final String initialDayInterval; // 예: "2일마다"

  const DayIntervalSettingBottomSheet({
    super.key,
    required this.initialDayInterval,
  });

  @override
  _DayIntervalSettingBottomSheetState createState() =>
      _DayIntervalSettingBottomSheetState();
}

class _DayIntervalSettingBottomSheetState
    extends State<DayIntervalSettingBottomSheet> {
  late final List<String> _dayIntervals;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    // 2일부터 30일까지 생성 (총 29개 항목)
    _dayIntervals = List.generate(29, (index) => "${index + 2}일마다");
    _selectedIndex = _dayIntervals.indexOf(widget.initialDayInterval);
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
          final result =
              DayIntervalSettingResult(_dayIntervals[_selectedIndex]);
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
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: _dayIntervals.map((value) {
                return Center(
                  child: Text(
                    value,
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
