import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/controllers/schedule/scheduleCreateController.dart';
import 'package:habitui/models/schedule.dart';
import 'package:habitui/pages/addhabit/addhabit_dayselector.dart';

class GoalSettingScreen extends StatefulWidget {
  const GoalSettingScreen({super.key});

  @override
  State<GoalSettingScreen> createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends State<GoalSettingScreen> {
  final ScheduleCreateController scheduleCreateController =
      Get.find<ScheduleCreateController>();

  Scheduleset currentsetting = Scheduleset.check;

  @override
  Widget build(BuildContext context) {
    // 토글 버튼 위젯
    Widget buildToggleButton(String title, Scheduleset type) {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              currentsetting = type;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: currentsetting == type ? Colors.orange[300] : Colors.black,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        currentsetting == type ? Colors.black : Colors.white),
              ),
            ),
          ),
        ),
      );
    }

    // 설정 저장 후 다음 페이지 이동
    void onComplete() {
      scheduleCreateController.updateSetting(currentsetting);
      Get.to(
        HabitFrequencySelectScreen(),
        transition: Transition.cupertino,
        duration: const Duration(milliseconds: 300),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 진행 바
            LinearProgressIndicator(
              value: 0.6,
              backgroundColor: Colors.grey[800],
              color: Colors.orange[300],
              minHeight: 6,
            ),
            const SizedBox(height: 40),

            // 제목
            const Text(
              "목표 설정",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // 탭 선택 버튼
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  buildToggleButton("작업", Scheduleset.check),
                  buildToggleButton("계산", Scheduleset.count),
                  buildToggleButton("시간", Scheduleset.time),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 설명 텍스트
            Text(
              currentsetting == Scheduleset.check
                  ? "체크 오프할 수 있는 간단한 작업."
                  : currentsetting == Scheduleset.count
                      ? "하루에 여러 번 수행하는 습관."
                      : "설정된 시간 동안 지속해야 하는 작업.",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const Spacer(),

            // 계속 버튼
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
}
