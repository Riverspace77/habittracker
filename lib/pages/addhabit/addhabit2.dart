import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/controllers/schedule/scheduleCreateController.dart';
import 'package:habitui/models/schedule.dart';
import 'package:habitui/pages/addhabit/addhabit3.dart';

class HabitTypeScreen extends StatefulWidget {
  const HabitTypeScreen({super.key});

  @override
  State<HabitTypeScreen> createState() => _HabitTypeScreenState();
}

class _HabitTypeScreenState extends State<HabitTypeScreen> {
  final ScheduleCreateController scheduleCreateController =
      Get.find<ScheduleCreateController>();
  bool isMakingHabit = true; // 기본 선택값: 만들기

  @override
  Widget build(BuildContext context) {
    void onComplete() {
      scheduleCreateController
          .updateType(isMakingHabit ? ScheduleType.make : ScheduleType.off);
      Get.to(GoalSettingScreen());
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
              value: 0.2,
              backgroundColor: Colors.grey[800],
              color: Colors.orange[300],
              minHeight: 6,
            ),
            const SizedBox(height: 40),

            const Text(
              "이 습관의 유형은 무엇입니까?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // 습관 유형 선택 버튼
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  // 만들기 버튼
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isMakingHabit = true;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isMakingHabit ? Colors.orange[300] : Colors.black,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text(
                            "만들기",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 끊기 버튼
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isMakingHabit = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: !isMakingHabit
                              ? Colors.orange[300]
                              : Colors.black,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text(
                            "끊기",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 설명 텍스트
            Text(
              isMakingHabit
                  ? "운동이나 책 읽기 같은 좋은 습관을 만듭니다."
                  : "흡연이나 과식 같은 나쁜 습관을 끊습니다.",
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
                onPressed: () {
                  onComplete();
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
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
