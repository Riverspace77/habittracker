import 'package:flutter/material.dart';
import 'package:habitui/constant/theme.dart';
import 'package:habitui/widget/edit_widget/schedule_start_end/date_picker.dart';

class ScheduleSelector extends StatefulWidget {
  const ScheduleSelector({super.key});

  @override
  _ScheduleSelectorState createState() => _ScheduleSelectorState();
}

class _ScheduleSelectorState extends State<ScheduleSelector> {
  // 시작 날짜(기본값: 오늘)
  DateTime _startDate = DateTime.now();
  // 종료 날짜(기본값: 오늘), 단 “절대 아님”일 수도 있으므로 null 대신 별도 상태 관리
  bool _isEndDateNone = false;
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 스케줄 타이틀
        const Text(
          '스케줄',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),

        // 시작 날짜 버튼
        _buildScheduleRow(
          label: "시작",
          dateText: _formatDate(_startDate),
          onTap: () => _openDatePicker(
            isEndDate: false, // 시작 날짜
          ),
        ),

        // 종료 날짜 버튼
        _buildScheduleRow(
          label: "종료",
          dateText: _isEndDateNone ? "절대 아님" : _formatDate(_endDate),
          onTap: () => _openDatePicker(
            isEndDate: true, // 종료 날짜
          ),
        ),
      ],
    );
  }

  // "시작", "종료" 버튼 한 줄 구성
  Widget _buildScheduleRow({
    required String label,
    required String dateText,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // 왼쪽 라벨
          SizedBox(
            width: 40,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 16),
          // 오른쪽 버튼
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: routinC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                dateText,
                style: TextStyle(
                  color: routinC,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 날짜 포맷 (예: 1월 5일)
  String _formatDate(DateTime date) {
    return "${date.month}월 ${date.day}일";
  }

  // BottomSheet 열기
  Future<void> _openDatePicker({required bool isEndDate}) async {
    final result = await showModalBottomSheet<DatePickerResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DatePickerBottomSheet(
        initialDate: isEndDate
            ? (_isEndDateNone ? DateTime.now() : _endDate)
            : _startDate,
        showAbsoluteNone: isEndDate, // 종료 날짜일 때만 “절대 아님” 버튼 보이기
      ),
    );

    // 사용자가 날짜를 선택하거나 “절대 아님”을 누른 뒤 닫혔을 때 처리
    if (result != null) {
      setState(() {
        if (result.isAbsoluteNone) {
          // “절대 아님”인 경우
          _isEndDateNone = true;
        } else {
          // 날짜 선택
          _isEndDateNone = false;
          if (isEndDate) {
            _endDate = result.selectedDate!;
          } else {
            _startDate = result.selectedDate!;
          }
        }
      });
    }
  }
}
