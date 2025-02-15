import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/controllers/schedule/scheduleCreateController.dart';

class TempScheduleDisplayPage extends StatelessWidget {
  TempScheduleDisplayPage({super.key});

  final ScheduleCreateController scheduleCreateController =
      Get.find<ScheduleCreateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("임시 일정 미리보기"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () {
            final schedule = scheduleCreateController.tempSchedule.value;
            return ListView(
              children: [
                _buildInfoRow("제목", schedule.title),
                _buildInfoRow("설명", schedule.description),
                _buildInfoRow("설정 타입", schedule.setting.toString()),
                _buildInfoRow("유형", schedule.type.toString()),
                _buildInfoRow(
                    "시간", "${schedule.time.hour}:${schedule.time.minute}"),
                _buildInfoRow("색상", schedule.color.toString()),
                _buildInfoRow("반복", schedule.repeat.join(", ")),
                _buildInfoRow("리마인더", schedule.reminders.join(", ")),
                _buildInfoRow("시작 날짜", schedule.schedule_start.toString()),
                _buildInfoRow("종료 날짜", schedule.schedule_end.toString()),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    "닫기",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : "(없음)",
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
