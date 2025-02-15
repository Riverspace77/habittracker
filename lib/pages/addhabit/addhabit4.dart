import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/controllers/schedule/scheduleCreateController.dart';
import 'package:habitui/models/schedule.dart';
import 'package:habitui/pages/addhabit/scheduleForCheck.dart';

class HabitFrequencyScreen extends StatefulWidget {
  const HabitFrequencyScreen({super.key});

  @override
  _HabitFrequencyScreenState createState() => _HabitFrequencyScreenState();
}

class _HabitFrequencyScreenState extends State<HabitFrequencyScreen> {
  final ScheduleCreateController scheduleCreateController =
      Get.find<ScheduleCreateController>();

  // 선택된 옵션을 저장하는 상태 변수
  String selectedDayOption = '요일 선택';
  String selectedIntervalOption = '매주';
  String selectedDayIntervalOption = '2일마다';
  int multiple = 0;
  int DayInterval = 1;
  int weekCount = 1;
  RepeatType repeatType = RepeatType.intervalDay;
  Period period = Period.weak; // 기간당 한 번
  int count = 1; // 기간당 여러 번의 횟수
  List<String> weekdays = ['월', '화', '수', '목', '금', '토', '일']; // 요일 지정
  int interval = 1; // 몇일마다, 몇주마다 (공용)

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
              selectedDayOption = option;
            });
            Navigator.pop(context); // 모달 닫기
          },
        );
      },
    );
  }

  void openDayIntervalSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DayintervalSelectionSheet(
          onOptionSelected: (option) {
            setState(() {
              selectedDayIntervalOption = option;
            });
            Navigator.pop(context); // 모달 닫기
          },
        );
      },
    );
  }

  void openmultipleWeekSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return MultipleWeekSelectionSheet(
          onOptionSelected: (option) {
            setState(() {
              selectedIntervalOption = option;
            });
            Navigator.pop(context); // 모달 닫기
          },
        );
      },
    );
  }

  void openmultipleSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return multipleSelectionSheet(
          onOptionSelected: (option) {
            setState(() {
              option == '월' ? multiple = 0 : multiple = 1;
            });
            Navigator.pop(context); // 모달 닫기
          },
        );
      },
    );
  }

  void openintervalSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return intervalSelectionSheet(
          onOptionSelected: (option) {
            setState(() {
              selectedIntervalOption = option;
            });
            Navigator.pop(context); // 모달 닫기
          },
        );
      },
    );
  }

  // 선택된 옵션에 따라 표시할 위젯
  Widget _buildOptionWidget() {
    switch (selectedDayOption) {
      case '요일 선택':
        repeatType = RepeatType.weekday;
        return _buildDaySelector();
      case '몇 일마다':
        repeatType = RepeatType.intervalDay;
        return _buildIntervalSelector();
      case '주에 한번':
        repeatType = RepeatType.intervalWeek;
        return _buildWeeklySelector();
      case '주당 횟수':
        repeatType = RepeatType.multipleweek;
        return _buildWeeklyCountSelector();
      case '연, 월당 횟수':
        repeatType = RepeatType.multiple;
        return _buildCountSelector();
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
        Expanded(
          child: Column(
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
                            color: weekdays.contains(day)
                                ? Colors.black
                                : Colors.white,
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
                      child: Text(
                        selectedIntervalOption,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        openintervalSelection();
                      },
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
          ),
        ),
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
            onPressed: () {
              switch (selectedIntervalOption) {
                case '매주':
                  interval = 1;
                case '2주마다':
                  interval = 2;
                case '3주마다':
                  interval = 3;
                case '4주마다':
                  interval = 4;
              }
              scheduleCreateController.updateRepeatType(repeatType);
              scheduleCreateController.updateWeekdays(weekdays);
              scheduleCreateController.updateInterval(interval);
              Get.to(ScheduleDetailPage(
                schedule: scheduleCreateController.tempSchedule,
              ));
            },
            child: const Text(
              "계속",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  // 몇 일마다 반복할지 선택하는 위젯
  Widget _buildIntervalSelector() {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
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
                      child: Text(
                        selectedDayIntervalOption,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        openDayIntervalSelection();
                      },
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
          ),
        ),
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
            onPressed: () {
              DayInterval =
                  int.parse(selectedDayIntervalOption.replaceAll("일마다", ""));
              scheduleCreateController.updateRepeatType(repeatType);
              scheduleCreateController.updateInterval(DayInterval);
              Get.to(ScheduleDetailPage(
                schedule: scheduleCreateController.tempSchedule,
              ));
            },
            child: const Text(
              "계속",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  // 주간 반복 설정 위젯
  Widget _buildWeeklySelector() {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
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
                      child: Text(
                        selectedIntervalOption,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        openintervalSelection();
                      },
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
          ),
        ),
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
            onPressed: () {
              switch (selectedIntervalOption) {
                case '매주':
                  interval = 1;
                case '2주마다':
                  interval = 2;
                case '3주마다':
                  interval = 3;
                case '4주마다':
                  interval = 4;
              }
              scheduleCreateController.updateRepeatType(repeatType);
              scheduleCreateController.updateInterval(interval);
              Get.to(ScheduleDetailPage(
                schedule: scheduleCreateController.tempSchedule,
              ));
            },
            child: const Text(
              "계속",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  // 주당 횟수 선택 위젯
  Widget _buildWeeklyCountSelector() {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
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
                      child: Text(
                        selectedIntervalOption,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        openmultipleWeekSelection();
                      },
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
                      child: Text(
                        selectedIntervalOption,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        openintervalSelection();
                      },
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
          ),
        ),
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
            onPressed: () {
              switch (selectedIntervalOption) {
                case '매주':
                  interval = 1;
                case '2주마다':
                  interval = 2;
                case '3주마다':
                  interval = 3;
                case '4주마다':
                  interval = 4;
              }
              weekCount =
                  int.parse(selectedDayIntervalOption.replaceAll(" 회", ""));
              scheduleCreateController.updateRepeatType(repeatType);
              scheduleCreateController.updateInterval(interval);
              scheduleCreateController.updateCount(weekCount);
              Get.to(ScheduleDetailPage(
                schedule: scheduleCreateController.tempSchedule,
              ));
            },
            child: const Text(
              "계속",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCountSelector() {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
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
                      child: Text(
                        selectedIntervalOption,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        openmultipleWeekSelection();
                      },
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
                      child: Text(
                        multiple == 0 ? '연' : '월',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        openmultipleSelection();
                      },
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
          ),
        ),
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
            onPressed: () {
              weekCount =
                  int.parse(selectedDayIntervalOption.replaceAll(" 회", ""));
              scheduleCreateController.updateInterval(multiple);
              scheduleCreateController.updateRepeatType(repeatType);
              scheduleCreateController.updateCount(weekCount);
              Get.to(ScheduleDetailPage(
                schedule: scheduleCreateController.tempSchedule,
              ));
            },
            child: const Text(
              "계속",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}

class multipleSelectionSheet extends StatelessWidget {
  final Function(String) onOptionSelected;

  multipleSelectionSheet({super.key, required this.onOptionSelected});

  final List<String> options = [
    '연',
    '월',
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
              '시간 설정',
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

class MultipleWeekSelectionSheet extends StatelessWidget {
  final Function(String) onOptionSelected;

  MultipleWeekSelectionSheet({super.key, required this.onOptionSelected});

  final List<String> options = [
    '1 회',
    '2 회',
    '3 회',
    '4 회',
    '5 회',
    '6 회',
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
              '시간 설정',
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

class DayintervalSelectionSheet extends StatelessWidget {
  final Function(String) onOptionSelected;

  DayintervalSelectionSheet({super.key, required this.onOptionSelected});

  final List<String> options = List.generate(29, (index) => '${index + 2}일마다');

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
              '간격 설정',
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

class intervalSelectionSheet extends StatelessWidget {
  final Function(String) onOptionSelected;

  intervalSelectionSheet({super.key, required this.onOptionSelected});

  final List<String> options = [
    '매주',
    '2주마다',
    '3주마다',
    '4주마다',
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
              '간격 설정',
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
