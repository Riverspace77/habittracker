import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/controllers/schedule/schedule_progress_controller.dart.dart';
import 'package:habitui/models/schedule.dart';

class CheckboxExample extends StatefulWidget {
  final Schedule schedule;
  final DateTime datetime;

  const CheckboxExample({
    super.key,
    required this.schedule,
    required this.datetime,
  });

  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  final ScheduleProgressController progressController =
      Get.find<ScheduleProgressController>();

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<WidgetState> states) => Colors.white;

    bool currentValue = progressController.getProgressByTitle(
            widget.schedule.title, widget.datetime) ??
        false; // 값이 없으면 기본값 `false`

    return Checkbox(
      checkColor: Colors.black,
      fillColor: WidgetStateProperty.resolveWith(getColor),
      value: currentValue,
      onChanged: (bool? value) {
        if (value != null) {
          progressController.updateProgressByTitle(
            widget.schedule.title,
            widget.datetime,
            value, // ✅ 새로운 값 저장
          );

          setState(() {}); // ✅ UI 갱신
        }
      },
    );
  }
}
