import 'package:flutter/material.dart';
import 'package:habitui/constant/theme.dart';
import 'package:habitui/models/schedule.dart';

// 계산(Count) BottomSheet
import 'package:habitui/widget/edit_widget/goal/count_setting_bottom.dart';
// 시간(Time) BottomSheet
import 'package:habitui/widget/edit_widget/goal/time_setting_bottom.dart';

class GoalSelectorBar extends StatefulWidget {
  /// 선택이 변경되었을 때 외부로 전달할 콜백 (선택된 Scheduleset 반환)
  final ValueChanged<Scheduleset>? onChanged;

  const GoalSelectorBar({super.key, this.onChanged});

  @override
  _GoalSelectorBarState createState() => _GoalSelectorBarState();
}

class _GoalSelectorBarState extends State<GoalSelectorBar> {
  // 초기 선택: 작업 (Scheduleset.check)
  Scheduleset _selected = Scheduleset.check;

  // 원하는 순서: 작업(check), 계산(count), 시간(time)
  final List<Scheduleset> _order = [
    Scheduleset.check,
    Scheduleset.count,
    Scheduleset.time,
  ];

  final Map<Scheduleset, String> _labelMap = {
    Scheduleset.check: '작업',
    Scheduleset.count: '계산',
    Scheduleset.time: '시간',
  };

  // ========== [1] 계산(Count) 관련 변수 ==========
  // 현재 설정된 횟수와 단위 (초기값: 8잔)
  int currentCount = 8;
  String currentUnit = '잔';

  // ========== [2] 시간(Time) 관련 변수 ==========
  // 초기 시/분/초 (예: 0시 1분 0초 => "00:01:00")
  int currentHour = 0;
  int currentMinute = 1;
  int currentSecond = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSegmentBar(),
        const SizedBox(height: 16),
        _buildAdditionalButtons(),
      ],
    );
  }

  /// 상단 탭(작업/계산/시간) UI
  Widget _buildSegmentBar() {
    return LayoutBuilder(builder: (context, constraints) {
      final segmentWidth = constraints.maxWidth / _order.length;
      final selectedIndex = _order.indexOf(_selected);

      return Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: routinC, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: selectedIndex * segmentWidth,
              width: segmentWidth,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: routinC,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Row(
              children: _order.map((s) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selected = s;
                      });
                      widget.onChanged?.call(s);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        _labelMap[s]!,
                        style: TextStyle(
                          fontSize: 14,
                          color: _selected == s ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }

  /// 탭에 따라 다른 버튼(또는 위젯)을 보여주는 메서드
  Widget _buildAdditionalButtons() {
    switch (_selected) {
      // "작업" 선택 시
      case Scheduleset.check:
        return const SizedBox.shrink();

      // "계산" 선택 시
      case Scheduleset.count:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 왼쪽 버튼: 예) "8잔" (현재 count, unit)
            _buildCountButton("$currentCount$currentUnit"),
            const SizedBox(width: 16),
            // 오른쪽 버튼: "변경"
            _buildCountButton("변경"),
          ],
        );

      // "시간" 선택 시
      case Scheduleset.time:
        // 예시: "00:01:00" / "변경"
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 왼쪽 버튼: 현재 시간
            _buildTimeButton(
                _formatTime(currentHour, currentMinute, currentSecond)),
            const SizedBox(width: 16),
            // 오른쪽 버튼: "변경"
            _buildTimeButton("변경"),
          ],
        );
    }
  }

  // ========== [1] 계산(Count) 버튼 빌드 ==========
  Widget _buildCountButton(String label) {
    return GestureDetector(
      onTap: () async {
        // BottomSheet 띄우기
        final result = await showModalBottomSheet<CountSettingResult>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => CountSettingBottomSheet(
            initialCount: currentCount,
            initialUnit: currentUnit,
          ),
        );
        // 반환값이 있으면 UI 갱신
        if (result != null) {
          setState(() {
            currentCount = result.count;
            currentUnit = result.unit;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: label == "$currentCount$currentUnit" ? routinC : Colors.white,
          border: label == "$currentCount$currentUnit"
              ? null
              : Border.all(color: routinC),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                label == "$currentCount$currentUnit" ? Colors.white : routinC,
          ),
        ),
      ),
    );
  }

  // ========== [2] 시간(Time) 버튼 빌드 ==========
  Widget _buildTimeButton(String label) {
    return GestureDetector(
      onTap: () async {
        // BottomSheet 띄우기
        final timeResult = await showModalBottomSheet<TimeSettingResult>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => TimeSettingBottomSheet(
            initialHour: currentHour,
            initialMinute: currentMinute,
            initialSecond: currentSecond,
          ),
        );
        // 반환값이 있으면 UI 갱신
        if (timeResult != null) {
          setState(() {
            currentHour = timeResult.hour;
            currentMinute = timeResult.minute;
            currentSecond = timeResult.second;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: label == _formatTime(currentHour, currentMinute, currentSecond)
              ? routinC
              : Colors.white,
          border:
              label == _formatTime(currentHour, currentMinute, currentSecond)
                  ? null
                  : Border.all(color: routinC),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                label == _formatTime(currentHour, currentMinute, currentSecond)
                    ? Colors.white
                    : routinC,
          ),
        ),
      ),
    );
  }

  // 시/분/초를 "HH:MM:SS" 형태로 포맷팅
  String _formatTime(int hour, int minute, int second) {
    final hh = hour.toString().padLeft(2, '0');
    final mm = minute.toString().padLeft(2, '0');
    final ss = second.toString().padLeft(2, '0');
    return "$hh:$mm:$ss";
  }
}
