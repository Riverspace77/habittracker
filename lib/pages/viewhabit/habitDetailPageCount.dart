import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/controllers/schedule/scheduleProgressController.dart';
import 'package:habitui/models/schedule.dart';
import 'package:habitui/widget/habitdetail/habitProgressIndecator.dart';

class HabitDetailPageCount extends StatefulWidget {
  final String title;
  final DateTime datetime;

  const HabitDetailPageCount({
    super.key,
    required this.title,
    required this.datetime,
  });

  @override
  _HabitDetailPageCountState createState() => _HabitDetailPageCountState();
}

class _HabitDetailPageCountState extends State<HabitDetailPageCount> {
  final ScheduleProgressController progressController =
      Get.find<ScheduleProgressController>();

  late int currentCount;
  late int maxCount;
  late int maxValue;
  late int currentValue;
  late IconData icon;
  late Color backgroundColor;

  @override
  void initState() {
    super.initState();
    _loadScheduleData();
  }

  // 스케줄 데이터 로드 (title 기반)
  void _loadScheduleData() {
    Schedule? schedule = progressController.getScheduleByTitle(widget.title);

    if (schedule != null) {
      maxCount = schedule.count ?? 1; // 목표 횟수
      maxValue = schedule.getOccurrences().length; // 전체 수행해야 하는 날짜 개수
      currentCount =
          schedule.countProgress?[widget.datetime] ?? 0; // 특정 날짜의 진행도
      currentValue =
          schedule.completionStatus?.values.where((v) => v == true).length ??
              0; // 완료된 날짜 개수
      icon = schedule.icon.icon!;
      backgroundColor = schedule.color;
    } else {
      maxCount = 1;
      maxValue = 1;
      currentCount = 0;
      currentValue = 0;
      icon = Icons.error;
      backgroundColor = Colors.grey;
    }
  }

  // 진행도 증가
  void increaseValue() async {
    if (currentCount < maxCount) {
      setState(() {
        currentCount++;
      });

      await progressController.updateProgressByTitle(
          widget.title, widget.datetime, currentCount);
      _updateCompletionStatus();
    }
  }

  // 진행도 감소
  void decreaseValue() async {
    if (currentCount > 0) {
      setState(() {
        currentCount--;
      });

      await progressController.updateProgressByTitle(
          widget.title, widget.datetime, currentCount);
      _updateCompletionStatus();
    }
  }

  // 목표치 비교 후 완료 여부 업데이트
  void _updateCompletionStatus() {
    setState(() {
      Schedule? schedule = progressController.getScheduleByTitle(widget.title);
      if (schedule != null) {
        currentValue =
            schedule.completionStatus?.values.where((v) => v == true).length ??
                0;
      }
    });
  }

  // 진행률 계산
  double get progress => (currentValue / maxValue).clamp(0.0, 1.0);

  // 진행도 상태 메시지
  String get progressText {
    if (progress < 0.2) return '일부 도전에 직면한 것 같습니다.\n습관을 조정하여 시작하기 쉽게 만드세요.';
    if (progress < 0.5) return '50% 미만';
    if (progress < 0.8) return '80% 미만';
    if (progress < 1.0) return '100% 미만';
    return '완료';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Icon(icon, size: 80, color: Colors.black),
              const SizedBox(height: 10),
              Text(
                widget.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text("$maxCount 횟수", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton("-", decreaseValue),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "$currentCount",
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildButton("+", increaseValue),
                ],
              ),
              const SizedBox(height: 30),
              ProgressIndicatorWidget(
                maxValue: maxValue,
                currentValue: currentValue,
                progressText: progressText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 증가/감소 버튼 UI
  Widget _buildButton(String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5)
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
