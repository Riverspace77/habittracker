import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/controllers/schedule/scheduleCreateController.dart';
import 'package:habitui/models/schedule.dart';

class HabitFrequencyScreen extends StatefulWidget {
  const HabitFrequencyScreen({super.key});

  @override
  _HabitFrequencyScreenState createState() => _HabitFrequencyScreenState();
}

class _HabitFrequencyScreenState extends State<HabitFrequencyScreen> {
  final ScheduleCreateController scheduleCreateController =
      Get.find<ScheduleCreateController>();

  // 선택된 옵션을 저장하는 상태 변수
  String selectedOption = '';

  RepeatType repeatType = RepeatType.intervalDay;
  Period period = Period.weak; // 기간당 한 번
  int count = 1; // 기간당 여러 번의 횟수
  List<String> weekdays = ['월', '화', '수', '목', '금', '토', '일']; // 요일 지정
  int interval = 1; // 몇일마다, 몇주마다 (공용)

  void onComplete() {
    Get.to(HabitFrequencyScreen());
  }

  void openDaySelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DaySelectionSheet(
          onOptionSelected: (option) {
            setState(() {
              selectedOption = option;
            });
            Navigator.pop(context); // 모달 닫기
          },
        );
      },
    );
  }

  // 선택된 옵션에 따라 표시할 위젯
  Widget _buildOptionWidget() {
    switch (selectedOption) {
      case '요일 선택':
        repeatType = RepeatType.weekday;
        return _buildDaySelector();
      case '몇 일마다':
        repeatType = RepeatType.intervalDay;
        return _buildIntervalSelector();
      case '주간':
        repeatType = RepeatType.intervalWeek;
        return _buildWeeklySelector();
      case '주당 횟수':
        repeatType = RepeatType.multiple;
        return _buildWeeklyCountSelector();
      case '월당 횟수':
        repeatType = RepeatType.multiple;
        return _buildMonthlyCountSelector();
      case '년당 횟수':
        repeatType = RepeatType.multiple;
        return _buildYearlyCountSelector();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LinearProgressIndicator(
              value: 0.4,
              backgroundColor: Colors.grey[800],
              color: Colors.orange[300],
              minHeight: 6,
            ),
            SizedBox(
              height: 110,
              child: Center(
                  child: Text(
                '이 습관을 얼마나 자주 할래요?',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              )),
            ),
            GestureDetector(
              onTap: openDaySelection,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    '요일 선택',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 선택된 옵션에 따라 동적으로 위젯을 표시
            Expanded(child: _buildOptionWidget()),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: onComplete,
                child: const Text(
                  "계속",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // 요일 선택 위젯
  Widget _buildDaySelector() {
    return Column(
      children: [
        Wrap(
          spacing: 10,
          children: [
            for (var day in ['일', '월', '화', '수', '목', '금', '토'])
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (weekdays.contains(day)) {
                      weekdays.remove(day);
                    } else {
                      weekdays.add(day);
                    }
                  });
                },
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: weekdays.contains(day)
                      ? Colors.orange[300]
                      : Colors.grey[800],
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          weekdays.contains(day) ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "매주",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "변경",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 몇 일마다 반복할지 선택하는 위젯
  Widget _buildIntervalSelector() {
    return const Text(
      '반복 간격을 선택하세요.',
      style: TextStyle(fontSize: 16, color: Colors.white),
    );
  }

  // 주간 반복 설정 위젯
  Widget _buildWeeklySelector() {
    return const Text(
      '주간 반복을 설정하세요.',
      style: TextStyle(fontSize: 16, color: Colors.white),
    );
  }

  // 주당 횟수 선택 위젯
  Widget _buildWeeklyCountSelector() {
    return const Text(
      '주당 횟수를 선택하세요.',
      style: TextStyle(fontSize: 16, color: Colors.white),
    );
  }

  // 월당 횟수 선택 위젯
  Widget _buildMonthlyCountSelector() {
    return const Text(
      '월당 횟수를 선택하세요.',
      style: TextStyle(fontSize: 16, color: Colors.white),
    );
  }

  // 년당 횟수 선택 위젯
  Widget _buildYearlyCountSelector() {
    return const Text(
      '년당 횟수를 선택하세요.',
      style: TextStyle(fontSize: 16, color: Colors.white),
    );
  }
}

class DaySelectionSheet extends StatelessWidget {
  final Function(String) onOptionSelected;

  DaySelectionSheet({super.key, required this.onOptionSelected});

  final List<String> options = [
    '요일 선택',
    '몇 일마다',
    '주간',
    '주당 횟수',
    '월당 횟수',
    '년당 횟수',
    '날짜 선택'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '반복',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            Column(
              children: options
                  .map(
                    (text) => GestureDetector(
                      onTap: () {
                        onOptionSelected(text);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            text,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
