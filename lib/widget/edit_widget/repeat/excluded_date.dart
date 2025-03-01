import 'package:flutter/material.dart';
import 'package:habitui/widget/edit_widget/bottom_sheet.dart';

/// 제외된 날짜 선택 결과 클래스
class ExcludedDateResult {
  final List<int> selectedDays; // 예: [2, 5, 12] 등
  ExcludedDateResult(this.selectedDays);
}

/// 특정 달의 날짜를 선택/해제하는 BottomSheet
class ExcludedDateBottomSheet extends StatefulWidget {
  final int year;
  final int month;
  final List<int>? initialSelectedDays; // 초기 선택된 날짜 목록

  const ExcludedDateBottomSheet({
    super.key,
    required this.year,
    required this.month,
    this.initialSelectedDays,
  });

  @override
  State<ExcludedDateBottomSheet> createState() =>
      _ExcludedDateBottomSheetState();
}

class _ExcludedDateBottomSheetState extends State<ExcludedDateBottomSheet> {
  final int _daysInMonth = 30; // 단순화를 위해 1~30일로 가정
  late Set<int> _selectedDays;

  @override
  void initState() {
    super.initState();
    _selectedDays = widget.initialSelectedDays != null
        ? widget.initialSelectedDays!.toSet()
        : <int>{};
  }

  @override
  Widget build(BuildContext context) {
    List<int> sortedDays = _selectedDays.toList()..sort();

    return CustomBottomSheet(
      heightFactor: 0.6,
      title: '제외',
      trailing: IconButton(
        icon: const Icon(Icons.check),
        onPressed: () {
          Navigator.pop(context, ExcludedDateResult(sortedDays));
        },
      ),
      onClose: () => Navigator.pop(context),
      child: Column(
        children: [
          // 상단에 월/연도 표시
          Text(
            '${widget.month}월',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // 날짜 선택 그리드 (달력)
          Expanded(
            child: GridView.count(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: List.generate(_daysInMonth, (index) {
                final day = index + 1;
                final isSelected = _selectedDays.contains(day);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedDays.remove(day);
                      } else {
                        _selectedDays.add(day);
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue),
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
          // 선택된 날짜 박스들을 달력 바로 아래에 Wrap으로 표시
          if (sortedDays.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: sortedDays
                    .map((day) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '$day일',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                        ))
                    .toList(),
              ),
            ),
          const SizedBox(height: 16),
          const Text(
            "제외할 날짜를 선택하세요",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
