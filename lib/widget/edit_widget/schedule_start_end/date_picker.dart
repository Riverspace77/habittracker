import 'package:flutter/material.dart';
import 'package:habitui/widget/edit_widget/bottom_sheet.dart'; // CustomBottomSheet
import 'package:habitui/constant/theme.dart';

// BottomSheet에서 반환할 데이터 구조
class DatePickerResult {
  final DateTime? selectedDate;
  final bool isAbsoluteNone;

  DatePickerResult({
    this.selectedDate,
    this.isAbsoluteNone = false,
  });
}

/// 단일 날짜 선택 + (옵션) “절대 아님” 버튼
class DatePickerBottomSheet extends StatefulWidget {
  final DateTime initialDate;
  final bool showAbsoluteNone; // 종료 날짜용일 때 true

  const DatePickerBottomSheet({
    super.key,
    required this.initialDate,
    required this.showAbsoluteNone,
  });

  @override
  State<DatePickerBottomSheet> createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  late DateTime _displayedDate; // 현재 표시 중인 달(년/월)
  late int _selectedDay; // 선택된 일

  @override
  void initState() {
    super.initState();
    _displayedDate =
        DateTime(widget.initialDate.year, widget.initialDate.month);
    _selectedDay = widget.initialDate.day;
  }

  @override
  Widget build(BuildContext context) {
    // 예시로 1~31일까지 표시(단순화)
    // 실제 달의 일수를 구하려면 DateTime(year, month + 1, 0).day 를 사용
    final daysInMonth =
        DateTime(_displayedDate.year, _displayedDate.month + 1, 0).day;

    return CustomBottomSheet(
      heightFactor: 0.6,
      title: '', // 상단 타이틀은 별도로 없거나 필요하면 추가
      trailing: IconButton(
        icon: const Icon(Icons.check),
        onPressed: () {
          Navigator.pop(
              context,
              DatePickerResult(
                selectedDate: DateTime(
                    _displayedDate.year, _displayedDate.month, _selectedDay),
              ));
        },
      ),
      onClose: () => Navigator.pop(context),
      child: Column(
        children: [
          // 월 선택(예: 왼쪽 < 2월 > 오른쪽) 등등
          _buildMonthSelector(),
          const SizedBox(height: 16),

          // 날짜 선택 그리드
          Expanded(
            child: GridView.count(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: List.generate(daysInMonth, (index) {
                final day = index + 1;
                final isSelected = (day == _selectedDay);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDay = day;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? routinC : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: routinC),
                    ),
                    child: Text(
                      '$day',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          // “절대 아님” 버튼(종료 날짜용일 때만 표시)
          if (widget.showAbsoluteNone)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              child: GestureDetector(
                onTap: () {
                  // “절대 아님”을 선택 -> selectedDate 없이 isAbsoluteNone = true
                  Navigator.pop(
                      context,
                      DatePickerResult(
                        selectedDate: null,
                        isAbsoluteNone: true,
                      ));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: routinC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "절대 아님",
                    style: TextStyle(
                      color: routinC,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 상단 월 선택 UI
  Widget _buildMonthSelector() {
    final year = _displayedDate.year;
    final month = _displayedDate.month;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              final prevMonth = DateTime(year, month - 1);
              _displayedDate = prevMonth;
              // 선택된 일(day)이 현재 달의 최대 일수를 넘으면 조정
              final daysInPrev =
                  DateTime(prevMonth.year, prevMonth.month + 1, 0).day;
              if (_selectedDay > daysInPrev) {
                _selectedDay = daysInPrev;
              }
            });
          },
        ),
        Text(
          "$month월",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            setState(() {
              final nextMonth = DateTime(year, month + 1);
              _displayedDate = nextMonth;
              // 선택된 일(day)이 현재 달의 최대 일수를 넘으면 조정
              final daysInNext =
                  DateTime(nextMonth.year, nextMonth.month + 1, 0).day;
              if (_selectedDay > daysInNext) {
                _selectedDay = daysInNext;
              }
            });
          },
        ),
      ],
    );
  }
}
