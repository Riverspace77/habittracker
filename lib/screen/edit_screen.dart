import 'package:flutter/material.dart';
import 'package:habitui/constant/theme.dart';
import 'package:habitui/models/schedule.dart';
import 'package:habitui/screen/schedule_data.dart';
import 'package:habitui/widget/edit_widget/routin_title.dart';
import 'package:habitui/widget/edit_widget/icon&color_select.dart';
import 'package:habitui/widget/edit_widget/note.dart';
import 'package:habitui/widget/edit_widget/goal/goal_select_bar.dart';
import 'package:habitui/widget/edit_widget/repeat/repeat_selector.dart';
import 'package:habitui/widget/edit_widget/schedule_start_end/schedule_selector.dart'; // 새로운 반복 선택 위젯

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
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
          icon: Icon(Icons.close), // 'X' 아이콘을 표시
          onPressed: () {
            // 버튼 클릭 시 수행할 동작
            Navigator.of(context).pop(); // 현재 화면을 닫고 이전 화면으로 이동
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          RoutinTitle(
            initialTitle: tempSchedule.value.title, // 초기 제목 설정
            onTitleChanged: (newTitle) {
              tempSchedule.value = tempSchedule.value.copyWith(title: newTitle);
            },
          ), // 제목 입력 필드
          SizedBox(height: 16),
          IconColorSelector(), // 아이콘 및 색상 선택
          SizedBox(height: 16),
          _NoteAdder(), // 노트 추가 버튼
          SizedBox(height: 16),
          _GoalSelector(), // 목표 설정
          SizedBox(height: 16),
          RepeatSelector(), // 반복 요일 설정
          ScheduleSelector(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 600,
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            color: routinC,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Align(
            alignment: Alignment.center,
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
    );
  }
}

class IconColorSelector extends StatefulWidget {
  const IconColorSelector({super.key});

  @override
  _IconColorSelectorState createState() => _IconColorSelectorState();
}

class _IconColorSelectorState extends State<IconColorSelector> {
  // 초기 아이콘 색상 (기본적으로 검정색)
  Color iconColor = routinC;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: basicCW,
        child: Icon(Icons.star, color: iconColor),
      ),
      title: Text("아이콘 & 색상", style: TextStyle(color: basicCB)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: () async {
        final Color? selectedColor = await showModalBottomSheet<Color>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) =>
              IconColorPickerBottomSheet(initialColor: iconColor),
        );
        if (selectedColor != null) {
          setState(() {
            iconColor = selectedColor;
          });
        }
      },
    );
  }
}

class _NoteAdder extends StatelessWidget {
  const _NoteAdder({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // BottomSheet를 띄우고, 완료 버튼을 누르면 사용자가 입력한 내용을 받아온다.
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

        // updatedNote가 null이 아니면, 입력값으로 tempSchedule의 description을 업데이트
        if (updatedNote != null) {
          tempSchedule.value =
              tempSchedule.value.copyWith(description: updatedNote);
        }
      },
      child: const Text('노트 추가'),
    );
  }
}

class _GoalSelector extends StatelessWidget {
  const _GoalSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '목표',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GoalSelectorBar(
          onChanged: (Scheduleset selected) {
            // 선택된 값에 따라 스케줄 컨트롤러 업데이트 등 처리
            print('선택된 목표: $selected');
          },
        ),
      ],
    );
  }
}
