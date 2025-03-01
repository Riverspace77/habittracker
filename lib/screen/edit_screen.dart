// edit_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/constant/theme.dart';
import 'package:habitui/controllers/schedule/scheduleController.dart';
import 'package:habitui/models/schedule.dart';
import 'package:habitui/screen/home_screen.dart';
import 'package:habitui/widget/edit_widget/routin_title.dart';
import 'package:habitui/widget/edit_widget/note.dart';
import 'package:habitui/widget/edit_widget/goal/goal_select_bar.dart';
import 'package:habitui/widget/edit_widget/repeat/repeat_selector.dart';
import 'package:habitui/widget/edit_widget/schedule_start_end/schedule_selector.dart';
import 'package:habitui/controllers/Hive/hive_schedule_adapter.dart';

class EditScreen extends StatefulWidget {
  final Schedule schedule; // 홈스크린에서 전달받은 스케줄
  const EditScreen({super.key, required this.schedule});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final ScheduleController scheduleController = Get.find<ScheduleController>();
  // 전달받은 Schedule을 HiveSchedule으로 변환해 Rx 변수로 관리
  late Rx<HiveSchedule> editingSchedule;

  @override
  void initState() {
    super.initState();
    editingSchedule =
        Rx<HiveSchedule>(HiveSchedule.fromSchedule(widget.schedule));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundC,
      appBar: AppBar(
        title: Text(
          '편집',
          style: TextStyle(
            color: basicCB,
            fontSize: basicFS,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Obx(() => ListView(
            padding: EdgeInsets.all(16),
            children: [
              // 제목 위젯
              RoutinTitle(
                initialTitle: editingSchedule.value.title,
                onTitleChanged: (newTitle) {
                  editingSchedule.update((val) {
                    if (val != null) {
                      val.title = newTitle;
                    }
                  });
                },
              ),
              SizedBox(height: 16),
              // 노트 추가 위젯
              _NoteAdder(editingSchedule: editingSchedule),
              SizedBox(height: 16),
              // 목표 선택 위젯
              _GoalSelector(),
              SizedBox(height: 16),
              // 반복 선택 위젯
              RepeatSelector(),
              SizedBox(height: 16),
              // 시작일과 마감일 선택 위젯 (편집 시 editingSchedule과 동기화)
              ScheduleSelector(
                initialStart: editingSchedule.value.scheduleStart,
                initialEnd: editingSchedule.value.scheduleEnd,
                onDateChanged: (start, end) {
                  editingSchedule.update((val) {
                    if (val != null) {
                      val.scheduleStart = start;
                      val.scheduleEnd = end;
                    }
                  });
                },
              ),
            ],
          )),
      bottomNavigationBar: BottomAppBar(
        child: InkWell(
          onTap: () async {
            // 기존 제목(widget.schedule.title)을 oldTitle으로 사용
            final oldTitle = widget.schedule.title;
            await scheduleController.updateSchedule(
              oldTitle,
              editingSchedule.value.toSchedule(),
            );
            // Get.off를 사용하여 HomeScreen으로 전환
            Get.off(() => HomeScreen());
          },
          child: Container(
            height: 60,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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

// 노트 추가 위젯 (변경 없음)
class _NoteAdder extends StatelessWidget {
  final Rx<HiveSchedule> editingSchedule;
  const _NoteAdder({super.key, required this.editingSchedule});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final updatedNote = await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return NoteBottomSheet(
              initialNote: editingSchedule.value.description,
            );
          },
        );
        if (updatedNote != null) {
          editingSchedule.update((val) {
            if (val != null) {
              val.description = updatedNote;
            }
          });
        }
      },
      child: Text('노트 추가'),
    );
  }
}

// 목표 선택 위젯 (변경 없음)
class _GoalSelector extends StatelessWidget {
  const _GoalSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '목표',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        GoalSelectorBar(
          onChanged: (Scheduleset selected) {
            print('선택된 목표: $selected');
          },
        ),
      ],
    );
  }
}
