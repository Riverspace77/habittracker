import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/constant/theme.dart';
import 'package:habitui/controllers/schedule/scheduleController.dart';
import 'package:habitui/models/schedule.dart';
import 'package:habitui/screen/schedule_data.dart';
import 'package:habitui/widget/edit_widget/routin_title.dart';
import 'package:habitui/widget/edit_widget/note.dart';
import 'package:habitui/widget/edit_widget/goal/goal_select_bar.dart';
import 'package:habitui/widget/edit_widget/repeat/repeat_selector.dart';
import 'package:habitui/widget/edit_widget/schedule_start_end/schedule_selector.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final ScheduleController editController = Get.find<ScheduleController>();

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
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // 기존 위젯들은 tempSchedule를 기준으로 값을 읽고 업데이트합니다.
          RoutinTitle(
            initialTitle: tempSchedule.value.title,
            onTitleChanged: (newTitle) {
              tempSchedule.value = tempSchedule.value.copyWith(title: newTitle);
            },
          ),
          SizedBox(height: 16),
          // IconColorSelector 위젯 내부에서도 선택된 색상을
          // tempSchedule.value.color에 반영하도록 내부 로직을 수정하거나
          // 아래와 같이 별도 처리를 고려할 수 있습니다.
          //IconColorSelector(),
          SizedBox(height: 16),
          _NoteAdder(),
          SizedBox(height: 16),
          _GoalSelector(),
          SizedBox(height: 16),
          RepeatSelector(),
          ScheduleSelector(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: InkWell(
          onTap: () async {
            editController.updateSchedule(
                tempSchedule.value.title, tempSchedule.value);
            Navigator.pop(context);
          },
          child: Container(
            height: 60, // 적절한 높이로 조정 (기존 600은 너무 큽니다)
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

// Note 추가 위젯 (기존 구현과 동일)
class _NoteAdder extends StatelessWidget {
  const _NoteAdder({super.key});

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
              initialNote: tempSchedule.value.description,
            );
          },
        );
        if (updatedNote != null) {
          tempSchedule.value =
              tempSchedule.value.copyWith(description: updatedNote);
        }
      },
      child: Text('노트 추가'),
    );
  }
}

// 목표 선택 위젯 (변경된 목표가 있으면 처리)
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
