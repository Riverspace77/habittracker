import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habitui/widget/edit_widget/bottom_sheet.dart';

/// BottomSheet에서 반환할 데이터 (예: "1회", "2회", ... 또는 "1일", "2일", ...)
class CountSettingResult {
  final String count;
  CountSettingResult(this.count);
}

/// 횟수 설정 BottomSheet를 위젯화한 예시
/// 기본값은 기존 주당 횟수용으로 maxCount: 6, unit: "회"로 설정되어 있습니다.
class CountSettingBottomSheet extends StatefulWidget {
  final String initialCount; // 예: "1회" 또는 "1일"
  final int maxCount; // 기본: 6 (기존 기능 유지), 새 기능은 31 등으로 설정
  final String unit; // 기본: "회", 새 기능은 "일" 등으로 사용

  const CountSettingBottomSheet({
    super.key,
    required this.initialCount,
    this.maxCount = 6,
    this.unit = "회",
  });

  @override
  _CountSettingBottomSheetState createState() =>
      _CountSettingBottomSheetState();
}

class _CountSettingBottomSheetState extends State<CountSettingBottomSheet> {
  late final List<String> _counts;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    // maxCount에 따라 옵션 생성 (예: 1회~6회 또는 1일~31일)
    _counts =
        List.generate(widget.maxCount, (index) => '${index + 1}${widget.unit}');
    _selectedIndex = _counts.indexOf(widget.initialCount);
    if (_selectedIndex < 0) {
      _selectedIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      heightFactor: 0.4,
      title: '시간 설정',
      trailing: IconButton(
        icon: const Icon(Icons.check),
        onPressed: () {
          final result = CountSettingResult(_counts[_selectedIndex]);
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
              children: _counts
                  .map((value) => Center(
                        child: Text(
                          value,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "횟수를 선택하세요",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
