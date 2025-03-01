import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/controllers/schedule/schedule_progress_controller.dart.dart';
import 'package:habitui/models/schedule.dart';
import 'package:habitui/widget/habitdetail/habitProgressIndecator.dart';

class HabitDetailPageBool extends StatefulWidget {
  final String title;
  final DateTime datetime;

  const HabitDetailPageBool({
    super.key,
    required this.title,
    required this.datetime,
  });

  @override
  _HabitDetailPageBoolState createState() => _HabitDetailPageBoolState();
}

class _HabitDetailPageBoolState extends State<HabitDetailPageBool> {
  final ScheduleProgressController progressController =
      Get.find<ScheduleProgressController>();

  late bool complete;
  late int currentValue;
  late int maxValue;
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
      maxValue = schedule.getOccurrences().length; // 전체 수행해야 하는 날짜 개수
      currentValue =
          schedule.checkProgress?.values.where((v) => v == true).length ??
              0; // 완료된 날짜 개수
      complete = progressController.getProgressByTitle(
              widget.title, widget.datetime) ??
          false;
      icon = schedule.icon.icon!;
      backgroundColor = schedule.color;
    } else {
      maxValue = 1;
      currentValue = 0;
      complete = false;
      icon = Icons.error; // 스케줄 없을 경우 기본 아이콘
      backgroundColor = Colors.grey; // 기본 배경색
    }
  }

  // 진행도 업데이트 & Hive 저장
  void toggleComplete() async {
    setState(() {
      if (!complete) {
        if (currentValue < maxValue) currentValue += 1;
      } else {
        if (currentValue > 0) currentValue -= 1;
      }
      complete = !complete;
    });

    // Hive에 반영
    await progressController.updateProgressByTitle(
        widget.title, widget.datetime, complete);
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
      appBar: AppBar(),
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
              const SizedBox(height: 20),
              _buildCheckBox(),
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

  // 체크박스 UI
  Widget _buildCheckBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: complete,
          onChanged: (bool? value) {
            if (value != null) toggleComplete();
          },
        ),
        Text(
          complete ? "완료됨" : "진행 중",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
