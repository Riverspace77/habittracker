import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/controllers/schedule/scheduleCreateController.dart';
import 'package:habitui/models/schedule.dart';
import 'package:habitui/pages/addhabit/addhabit5.dart';
import 'package:habitui/widget/addhabit/customselector.dart';

class HabitFrequencySelectScreen extends StatefulWidget {
  const HabitFrequencySelectScreen({super.key});

  @override
  _HabitFrequencySelectScreenState createState() =>
      _HabitFrequencySelectScreenState();
}

class _HabitFrequencySelectScreenState
    extends State<HabitFrequencySelectScreen> {
  final ScheduleCreateController scheduleCreateController =
      Get.find<ScheduleCreateController>();
  // 선택된 옵션을 저장하는 상태 변수
  String selectedDayselectionOption = '매주'; //요일선택 옵션 저장
  String selectedDayintervalselectionOption = '1일마다'; //몇일마다 옵션 저장
  String selectedweeklyselectionOption = '매주'; //몇일마다 옵션 저장
  String selectedweeklycountselectionOption_1 = '1회'; //주당 횟수 옵션 저장 - 횟수
  String selectedweeklycountselectionOption_2 = '1회'; //주당 횟수 옵션 저장 - 주 간격
  String selectedmultipleselectionOption_1 = '1회'; //연,월당 횟수 옵션 저장 - 횟수
  String selectedmultipleselectionOption_2 = '1회'; //연,월당 횟수 옵션 저장 - 연,월
  String selectedDayOption = '요일 선택';

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

  // 선택된 옵션에 따라 표시할 위젯
  Widget _buildOptionWidget() {
    switch (selectedDayOption) {
      case '요일 선택':
        repeatType = RepeatType.weekday;
        setState(() {});
        return _buildDaySelector();
      case '몇 일마다':
        repeatType = RepeatType.intervalDay;
        setState(() {});
        return _buildIntervalSelector();
      case '주에 한번':
        repeatType = RepeatType.intervalWeek;
        setState(() {});
        return _buildWeeklySelector();
      case '주당 횟수':
        repeatType = RepeatType.multipleweek;
        setState(() {});
        return _buildWeeklyCountSelector();
      case '연, 월당 횟수':
        repeatType = RepeatType.multiple;
        setState(() {});
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
              value: 0.8,
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
                child: Center(
                  child: Text(
                    selectedDayOption,
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
              Customselector(
                selectedOption: '매주',
                options: [
                  '매주',
                  '2주마다',
                  '3주마다',
                  '4주마다',
                ],
                onOptionSelected: (String option) {
                  setState(() {
                    selectedDayselectionOption = option;
                  });
                },
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
              switch (selectedDayselectionOption) {
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
              Get.to(
                AddScreen(),
                transition: Transition.cupertino,
                duration: const Duration(milliseconds: 300),
              );
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

  // 몇 일마다 위젯
  Widget _buildIntervalSelector() {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Customselector(
                selectedOption: '2일마다',
                options: List.generate(29, (index) => '${index + 2}일마다'),
                onOptionSelected: (String option) {
                  setState(() {
                    selectedDayintervalselectionOption = option;
                  });
                },
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
              DayInterval = int.parse(
                  selectedDayintervalselectionOption.replaceAll("일마다", ""));
              scheduleCreateController.updateRepeatType(repeatType);
              scheduleCreateController.updateInterval(DayInterval);
              Get.to(
                AddScreen(),
                transition: Transition.cupertino,
                duration: const Duration(milliseconds: 300),
              );
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

  // 주에 한번 위젯
  Widget _buildWeeklySelector() {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Customselector(
                selectedOption: '매주',
                options: [
                  '매주',
                  '2주마다',
                  '3주마다',
                  '4주마다',
                ],
                onOptionSelected: (String option) {
                  setState(() {
                    selectedweeklyselectionOption = option;
                  });
                },
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
              switch (selectedweeklyselectionOption) {
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
              Get.to(
                AddScreen(),
                transition: Transition.cupertino,
                duration: const Duration(milliseconds: 300),
              );
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
              Customselector(
                selectedOption: '1회',
                options: List.generate(6, (index) => '${index + 1}회'),
                onOptionSelected: (String option) {
                  setState(() {
                    selectedweeklycountselectionOption_1 = option;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              Customselector(
                selectedOption: '매주',
                options: [
                  '매주',
                  '2주마다',
                  '3주마다',
                  '4주마다',
                ],
                onOptionSelected: (String option) {
                  setState(() {
                    selectedweeklycountselectionOption_2 = option;
                  });
                },
              )
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
              switch (selectedweeklycountselectionOption_2) {
                case '매주':
                  interval = 1;
                case '2주마다':
                  interval = 2;
                case '3주마다':
                  interval = 3;
                case '4주마다':
                  interval = 4;
              }
              weekCount = int.parse(
                  selectedweeklycountselectionOption_1.replaceAll("회", ""));
              scheduleCreateController.updateRepeatType(repeatType);
              scheduleCreateController.updateInterval(interval);
              scheduleCreateController.updateCount(weekCount);
              Get.to(
                AddScreen(),
                transition: Transition.cupertino,
                duration: const Duration(milliseconds: 300),
              );
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
              Customselector(
                selectedOption: '1회',
                options: List.generate(29, (index) => '${index + 1}회'),
                onOptionSelected: (String option) {
                  setState(() {
                    selectedmultipleselectionOption_1 = option;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              Customselector(
                selectedOption: '월',
                options: [
                  '연',
                  '월',
                ],
                onOptionSelected: (String option) {
                  setState(() {
                    selectedmultipleselectionOption_2 = option;
                  });
                },
              )
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
              weekCount = int.parse(
                  selectedmultipleselectionOption_1.replaceAll("회", ""));
              multiple = selectedmultipleselectionOption_1 == '월' ? 0 : 1;
              scheduleCreateController.updateInterval(multiple);
              scheduleCreateController.updateRepeatType(repeatType);
              scheduleCreateController.updateCount(weekCount);
              Get.to(
                AddScreen(),
                transition: Transition.cupertino,
                duration: const Duration(milliseconds: 300),
              );
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

class DaySelectionSheet extends StatelessWidget {
  final Function(String) onOptionSelected;

  DaySelectionSheet({super.key, required this.onOptionSelected});

  final List<String> options = ['요일 선택', '몇 일마다', '주에 한번', '주당 횟수', '연, 월당 횟수'];

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
