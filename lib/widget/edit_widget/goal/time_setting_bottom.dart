import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habitui/constant/theme.dart';
import '../bottom_sheet.dart'; // CustomBottomSheet가 정의된 파일

class TimeSettingResult {
  final int hour;
  final int minute;
  final int second;

  TimeSettingResult({
    required this.hour,
    required this.minute,
    required this.second,
  });
}

class TimeSettingBottomSheet extends StatefulWidget {
  /// 초기 시/분/초
  final int initialHour;
  final int initialMinute;
  final int initialSecond;

  /// 시/분/초가 선택 완료되었을 때 외부로 전달할 콜백
  final ValueChanged<TimeSettingResult>? onTimeChanged;

  const TimeSettingBottomSheet({
    super.key,
    this.initialHour = 0,
    this.initialMinute = 0,
    this.initialSecond = 0,
    this.onTimeChanged,
  });

  @override
  State<TimeSettingBottomSheet> createState() => _TimeSettingBottomSheetState();
}

class _TimeSettingBottomSheetState extends State<TimeSettingBottomSheet> {
  late int _selectedHour;
  late int _selectedMinute;
  late int _selectedSecond;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialHour;
    _selectedMinute = widget.initialMinute;
    _selectedSecond = widget.initialSecond;
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      heightFactor: 0.5,
      title: '시간 설정',
      onClose: () {
        Navigator.pop(context);
      },
      // 우측 상단 체크 아이콘
      trailing: IconButton(
        icon: const Icon(Icons.check),
        onPressed: () {
          final result = TimeSettingResult(
            hour: _selectedHour,
            minute: _selectedMinute,
            second: _selectedSecond,
          );
          widget.onTimeChanged?.call(result);
          Navigator.pop(context, result);
        },
      ),
      child: Column(
        children: [
          // 3개의 CupertinoPicker(시, 분, 초)를 가로로 배치
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 시 (0~23)
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: _selectedHour,
                    ),
                    itemExtent: 40.0,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _selectedHour = index;
                      });
                    },
                    children: List<Widget>.generate(24, (index) {
                      final display = index.toString().padLeft(2, '0');
                      return Center(
                        child: Text(
                          display,
                          style: TextStyle(color: basicCB, fontSize: 16),
                        ),
                      );
                    }),
                  ),
                ),
                // 구분 기호
                const Text(
                  ' : ',
                  style: TextStyle(fontSize: 20),
                ),
                // 분 (0~59)
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: _selectedMinute,
                    ),
                    itemExtent: 40.0,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _selectedMinute = index;
                      });
                    },
                    children: List<Widget>.generate(60, (index) {
                      final display = index.toString().padLeft(2, '0');
                      return Center(
                        child: Text(
                          display,
                          style: TextStyle(color: basicCB, fontSize: 16),
                        ),
                      );
                    }),
                  ),
                ),
                // 구분 기호
                const Text(
                  ' : ',
                  style: TextStyle(fontSize: 20),
                ),
                // 초 (0~59)
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: _selectedSecond,
                    ),
                    itemExtent: 40.0,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _selectedSecond = index;
                      });
                    },
                    children: List<Widget>.generate(60, (index) {
                      final display = index.toString().padLeft(2, '0');
                      return Center(
                        child: Text(
                          display,
                          style: TextStyle(color: basicCB, fontSize: 16),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
