import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/controllers/schedule/scheduleCreateController.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const HabitFrequencyScreen(),
    );
  }
}

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
        return _buildDaySelector();
      case '몇 일마다':
        return _buildIntervalSelector();
      case '주간':
        return _buildWeeklySelector();
      case '주당 횟수':
        return _buildWeeklyCountSelector();
      case '월당 횟수':
        return _buildMonthlyCountSelector();
      case '년당 횟수':
        return _buildYearlyCountSelector();
      case '날짜 선택':
        return _buildDateSelector();
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
            _buildOptionWidget(),
          ],
        ),
      ),
    );
  }

  // 요일 선택 위젯
  Widget _buildDaySelector() {
    return const Text(
      '요일을 선택하세요.',
      style: TextStyle(fontSize: 16, color: Colors.white),
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

  // 날짜 직접 선택 위젯
  Widget _buildDateSelector() {
    return const Text(
      '날짜를 선택하세요.',
      style: TextStyle(fontSize: 16, color: Colors.white),
    );
  }
}

class DaySelectionSheet extends StatelessWidget {
  final Function(String) onOptionSelected;

  DaySelectionSheet({super.key, required this.onOptionSelected});

  final List<String> options = [
    '없음',
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
