import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habitui/constant/theme.dart';
import '../bottom_sheet.dart'; // 위에서 업데이트한 CustomBottomSheet 파일

/// 숫자와 단위를 함께 반환하기 위한 결과 클래스
class CountSettingResult {
  final int count;
  final String unit;

  CountSettingResult({required this.count, required this.unit});
}

/// '횟수 설정' BottomSheet 위젯
class CountSettingBottomSheet extends StatefulWidget {
  final int initialCount;
  final String initialUnit;
  final ValueChanged<CountSettingResult>? onCountChanged;

  const CountSettingBottomSheet({
    super.key,
    required this.initialCount,
    required this.initialUnit,
    this.onCountChanged,
  });

  @override
  State<CountSettingBottomSheet> createState() =>
      _CountSettingBottomSheetState();
}

class _CountSettingBottomSheetState extends State<CountSettingBottomSheet> {
  int _selectedCount = 0;
  late TextEditingController _unitController;

  @override
  void initState() {
    super.initState();
    _selectedCount = widget.initialCount;
    _unitController = TextEditingController(text: widget.initialUnit);
  }

  @override
  void dispose() {
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      heightFactor: 0.5,
      title: '횟수 설정',
      // 우측에 체크 아이콘을 trailing 위젯으로 전달
      trailing: IconButton(
        icon: const Icon(Icons.check),
        onPressed: () {
          final result = CountSettingResult(
            count: _selectedCount,
            unit: _unitController.text,
          );
          if (widget.onCountChanged != null) {
            widget.onCountChanged!(result);
          }
          Navigator.pop(context, result);
        },
      ),
      onClose: () {
        Navigator.pop(context);
      },
      child: Column(
        children: [
          // 숫자 선택을 위한 CupertinoPicker
          Expanded(
            child: CupertinoPicker(
              scrollController:
                  FixedExtentScrollController(initialItem: _selectedCount),
              itemExtent: 40.0,
              onSelectedItemChanged: (int index) {
                setState(() {
                  _selectedCount = index;
                });
              },
              children: List<Widget>.generate(31, (index) {
                return Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                      color: basicCB,
                      fontSize: 16,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          // 단위 입력을 위한 TextField (초기값: '잔')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _unitController,
              style: TextStyle(color: basicCB, fontSize: 16),
              decoration: InputDecoration(
                hintText: '단위',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
