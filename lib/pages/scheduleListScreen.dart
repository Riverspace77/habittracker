import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habitui/controllers/schedule/scheduleController.dart';
import 'package:habitui/constant/theme.dart';
import 'package:habitui/pages/DetailStatusScreen.dart';

class ScheduleListScreen extends StatelessWidget {
  ScheduleListScreen({super.key});

  final ScheduleController scheduleController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("스케줄 목록"),
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        final schedules = scheduleController.schedules;

        if (schedules.isEmpty) {
          return const Center(
            child: Text("저장된 일정이 없습니다."),
          );
        }

        return ListView.builder(
          itemCount: schedules.length,
          itemBuilder: (context, index) {
            final schedule = schedules[index];

            return Slidable(
              key: ValueKey(schedule.title),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      scheduleController.updateSchedule(
                          schedule.title, schedule);
                      Get.to(() => SummaryPage(schedule: schedule));
                    },
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    icon: Icons.info,
                    label: '상세보기',
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      scheduleController.deleteSchedule(schedule.title);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${schedule.title} 삭제됨")),
                      );
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: '삭제',
                  ),
                ],
              ),
              child: Card(
                color: tileC,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: schedule.color,
                    child: schedule.icon,
                  ),
                  title: Text(
                    schedule.title,
                    style: TextStyle(color: basicCB, fontSize: basicFS),
                  ),
                  subtitle: Text(
                    "${schedule.scheduleStart.toLocal()} ~ ${schedule.scheduleEnd.toLocal()}",
                    style: TextStyle(color: basicCB, fontSize: smallFS),
                  ),
                  onTap: () {
                    Get.to(() => SummaryPage(schedule: schedule));
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
