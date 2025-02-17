import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:habitui/controllers/schedule/scheduleProgressController.dart';
import 'package:habitui/models/schedule.dart';
import 'package:habitui/widget/habitdetail/habitProgressIndecator.dart';

class HabitDetailPageTimer extends StatefulWidget {
  final String title;
  final DateTime datetime;

  const HabitDetailPageTimer({
    super.key,
    required this.title,
    required this.datetime,
  });

  @override
  _HabitDetailPageTimerState createState() => _HabitDetailPageTimerState();
}

class _HabitDetailPageTimerState extends State<HabitDetailPageTimer> {
  final ScheduleProgressController progressController =
      Get.find<ScheduleProgressController>();

  late int currentTime;
  late int maxTime;
  late int maxValue;
  late int currentValue;
  late IconData icon;
  late Color backgroundColor;
  Timer? _timer;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    _loadScheduleData();
  }

  // 스케줄 데이터 로드 (title 기반)
  void _loadScheduleData() {
    Schedule? schedule = progressController.getScheduleByTitle(widget.title);

    if (schedule != null) {
      maxTime =
          (schedule.time.hour * 3600) + (schedule.time.minute * 60); // 목표 시간(초)
      maxValue = schedule.getOccurrences().length; // 전체 수행 날짜 개수
      currentTime = (schedule.timeProgress?[widget.datetime] ?? 0)
          .toInt(); // 특정 날짜의 진행된 시간
      currentValue =
          schedule.completionStatus?.values.where((v) => v == true).length ??
              0; // 완료된 날짜 개수
      icon = schedule.icon.icon!;
      backgroundColor = schedule.color;
    } else {
      maxTime = 3600; // 기본 1시간
      maxValue = 1;
      currentTime = 0;
      currentValue = 0;
      icon = Icons.error;
      backgroundColor = Colors.grey;
    }
  }

  // 진행률 계산
  double get timeProgress => (currentTime / maxTime).clamp(0.0, 1.0);
  double get progress => (currentValue / maxValue).clamp(0.0, 1.0);

  // 진행도 상태 메시지
  String get progressText {
    if (progress < 0.2) return '일부 도전에 직면한 것 같습니다.\n습관을 조정하여 시작하기 쉽게 만드세요.';
    if (progress < 0.5) return '50% 미만';
    if (progress < 0.8) return '80% 미만';
    if (progress < 1.0) return '100% 미만';
    return '완료';
  }

  // 초를 "분:초" 형식으로 변환
  String formatTime(int totalSeconds) {
    int minutesPart = totalSeconds ~/ 60;
    int secondsPart = totalSeconds % 60;
    return '${minutesPart.toString().padLeft(2, '0')}:${secondsPart.toString().padLeft(2, '0')}';
  }

  // 타이머 시작
  void startTimer() {
    if (!isRunning) {
      setState(() => isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (currentTime < maxTime) {
          setState(() => currentTime += 1);
        } else {
          stopTimer(increaseValue: true);
        }
      });
    }
  }

  // 타이머 일시 정지
  void pauseTimer() {
    if (isRunning) {
      _timer?.cancel();
      setState(() => isRunning = false);
      _saveProgress(); // 🛠️ 타이머 정지 시 진행도 저장
    }
  }

  // 타이머 종료
  void stopTimer({bool increaseValue = false}) {
    _timer?.cancel();
    setState(() {
      isRunning = false;
      if (increaseValue) {
        currentValue++;
      }
    });
    _saveProgress(); // 🛠️ 타이머 정지 시 진행도 저장
  }

  // 진행도 및 완료 여부 저장 (타이머가 멈췄을 때만 실행)
  void _saveProgress() async {
    await progressController.updateProgressByTitle(
        widget.title, widget.datetime, currentTime);
    _updateCompletionStatus();
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
              const SizedBox(height: 20),
              Text("시간: ${formatTime(currentTime)} / ${formatTime(maxTime)}"),
              _buildTimerControls(),
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

  //타이머 컨트롤 버튼 UI
  Widget _buildTimerControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.play_arrow, size: 40, color: Colors.green),
          onPressed: startTimer,
        ),
        IconButton(
          icon: const Icon(Icons.pause, size: 40, color: Colors.orange),
          onPressed: pauseTimer,
        ),
        IconButton(
          icon: const Icon(Icons.stop, size: 40, color: Colors.red),
          onPressed: () => stopTimer(increaseValue: false),
        ),
      ],
    );
  }
}
