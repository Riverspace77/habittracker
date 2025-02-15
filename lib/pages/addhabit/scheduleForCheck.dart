import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/models/schedule.dart';

class ScheduleDetailPage extends StatelessWidget {
  final Rx<Schedule> schedule;

  const ScheduleDetailPage({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('일정 상세 정보')),
      body: Obx(() => ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              _buildInfoTile('설정 유형', schedule.value.setting.toString()),
              _buildInfoTile('제목', schedule.value.title),
              _buildInfoTile('아이콘', '', leading: schedule.value.icon),
              _buildInfoTile('설명', schedule.value.description),
              _buildInfoTile('일정 유형', schedule.value.type.toString()),
              _buildInfoTile('시간', schedule.value.time.format(context)),
              _buildInfoTile('색상', '',
                  leading: _buildColorBox(schedule.value.color)),
              _buildInfoTile('알림', schedule.value.reminders.join(', ')),
              _buildInfoTile('시작 날짜', schedule.value.scheduleStart.toString()),
              _buildInfoTile('종료 날짜', schedule.value.scheduleEnd.toString()),
              _buildInfoTile('반복 유형', schedule.value.repeatType.toString()),
              if (schedule.value.period != null)
                _buildInfoTile('기간', schedule.value.period.toString()),
              if (schedule.value.count != null)
                _buildInfoTile('반복 횟수', schedule.value.count.toString()),
              if (schedule.value.weekdays != null)
                _buildInfoTile('요일', schedule.value.weekdays!.join(', ')),
              if (schedule.value.interval != null)
                _buildInfoTile('반복 간격', '${schedule.value.interval}일'),
            ],
          )),
    );
  }

  Widget _buildInfoTile(String title, String value, {Widget? leading}) {
    return ListTile(
      leading: leading,
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }

  Widget _buildColorBox(Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 1.5),
      ),
    );
  }
}
