// schedule_selector.dart
import 'package:flutter/material.dart';
import 'package:habitui/constant/theme.dart';
import 'package:habitui/widget/edit_widget/schedule_start_end/date_picker.dart';

class ScheduleSelector extends StatefulWidget {
  final DateTime initialStart;
  final DateTime initialEnd;
  // 날짜 변경 시 { 'start': DateTime, 'end': DateTime } 형태로 전달
  final void Function(DateTime start, DateTime end) onDateChanged;

  const ScheduleSelector({
    super.key,
    required this.initialStart,
    required this.initialEnd,
    required this.onDateChanged,
  });

  @override
  _ScheduleSelectorState createState() => _ScheduleSelectorState();
}

class _ScheduleSelectorState extends State<ScheduleSelector> {
  late DateTime _startDate;
  late DateTime _endDate;
  bool _isEndDateNone = false;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStart;
    _endDate = widget.initialEnd;
  }

  // 호출 시 onDateChanged 콜백으로 변경된 값을 전달
  void _notifyChange() {
    widget.onDateChanged(_startDate, _isEndDateNone ? _startDate : _endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '스케줄',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        _buildScheduleRow(
          label: "시작",
          dateText: _formatDate(_startDate),
          onTap: () async {
            final result = await _openDatePicker(isEndDate: false);
            if (result != null && !result.isAbsoluteNone) {
              setState(() {
                _startDate = result.selectedDate!;
                _notifyChange();
              });
            }
          },
        ),
        _buildScheduleRow(
          label: "종료",
          dateText: _isEndDateNone ? "절대 아님" : _formatDate(_endDate),
          onTap: () async {
            final result = await _openDatePicker(isEndDate: true);
            if (result != null) {
              setState(() {
                if (result.isAbsoluteNone) {
                  _isEndDateNone = true;
                } else {
                  _isEndDateNone = false;
                  _endDate = result.selectedDate!;
                }
                _notifyChange();
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildScheduleRow({
    required String label,
    required String dateText,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 16),
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

  String _formatDate(DateTime date) {
    return "${date.month}월 ${date.day}일";
  }

  Future<DatePickerResult?> _openDatePicker({required bool isEndDate}) async {
    return await showModalBottomSheet<DatePickerResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DatePickerBottomSheet(
        initialDate: isEndDate
            ? (_isEndDateNone ? DateTime.now() : _endDate)
            : _startDate,
        showAbsoluteNone: isEndDate,
      ),
    );
  }
}
