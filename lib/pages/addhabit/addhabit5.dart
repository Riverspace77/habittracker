import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/constant/theme.dart';
import 'package:habitui/controllers/schedule/scheduleController.dart';
import 'package:habitui/controllers/schedule/scheduleCreateController.dart';
import 'package:habitui/models/schedule.dart';
import 'package:habitui/widget/edit_widget/routin_title.dart';
import 'package:habitui/widget/edit_widget/note.dart';
import 'package:habitui/widget/edit_widget/goal/goal_select_bar.dart';
import 'package:habitui/widget/edit_widget/repeat/repeat_selector.dart';
import 'package:habitui/widget/edit_widget/schedule_start_end/schedule_selector.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final ScheduleController editController = Get.find<ScheduleController>();
  final ScheduleCreateController createController =
      Get.find<ScheduleCreateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundC,
      appBar: AppBar(
        title: Text(
          '습관 추가 / 편집',
          style: TextStyle(
            color: basicCB,
            fontSize: basicFS,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ✅ 제목 편집 (개별적으로 Obx 적용)
          Obx(() => RoutinTitle(
                initialTitle: createController.tempSchedule.value.title,
                onTitleChanged: (newTitle) {
                  createController.updateTitle(newTitle);
                },
              )),
          const SizedBox(height: 16),

          // ✅ 노트 추가 (설명 편집)
          const _NoteAdder(),

          const SizedBox(height: 16),

          // ✅ 목표 선택 (Scheduleset 업데이트)
          const _GoalSelector(),

          const SizedBox(height: 16),

          // ✅ 반복 유형 선택
          const RepeatSelector(),

          // ✅ 일정 시작 및 종료 선택
          const ScheduleSelector(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: InkWell(
          onTap: () async {
            // ✅ 저장 시, tempSchedule을 Schedule로 변환 후 저장
            await editController
                .saveSchedule(createController.tempSchedule.value.toSchedule());
            Navigator.pop(context);
          },
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: routinC,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                '저장',
                style: TextStyle(
                  color: basicCB,
                  fontSize: basicFS,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ✅ 노트 추가 위젯 (설명 변경)
class _NoteAdder extends StatelessWidget {
  const _NoteAdder({super.key});

  @override
  Widget build(BuildContext context) {
    final ScheduleCreateController createController =
        Get.find<ScheduleCreateController>();

    return ElevatedButton(
      onPressed: () async {
        final updatedNote = await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return NoteBottomSheet(
              initialNote: createController.tempSchedule.value.description,
            );
          },
        );

        if (updatedNote != null) {
          createController.updateDescription(updatedNote);
        }
      },
      child: const Text('노트 추가'),
    );
  }
}

// ✅ 목표 선택 위젯 (Scheduleset 업데이트)
class _GoalSelector extends StatelessWidget {
  const _GoalSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final ScheduleCreateController createController =
        Get.find<ScheduleCreateController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '목표',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Obx(() {
          final selectedGoal = createController.tempSchedule.value.setting;
          return GoalSelectorBar(
            onChanged: (Scheduleset selected) {
              // ✅ UI 빌드가 완료된 후 상태 변경하도록 조정
              WidgetsBinding.instance.addPostFrameCallback((_) {
                createController.updateSetting(selected);
              });
            },
          );
        }),
      ],
    );
  }
}
