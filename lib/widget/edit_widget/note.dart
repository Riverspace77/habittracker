import 'package:flutter/material.dart';
import 'package:habitui/constant/theme.dart';
import 'package:habitui/widget/edit_widget/bottom_sheet.dart';

/// 노트 편집 BottomSheet
class NoteBottomSheet extends StatefulWidget {
  final String initialNote;

  /// 화면 높이 비율 (default: 0.75)
  final double heightFactor;

  const NoteBottomSheet({
    super.key,
    required this.initialNote,
    this.heightFactor = 0.9,
  });

  @override
  _NoteBottomSheetState createState() => _NoteBottomSheetState();
}

class _NoteBottomSheetState extends State<NoteBottomSheet> {
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.initialNote);
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: "노트 추가",
      heightFactor: widget.heightFactor,
      // X 버튼 클릭 시 원래의 노트를 반환
      onClose: () {
        Navigator.pop(context, widget.initialNote);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 노트 입력 TextField
            Expanded(
              child: TextField(
                controller: _noteController,
                maxLines: null,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800],
                  hintText: '노트를 입력하세요...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 완료 버튼
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: routinC,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, _noteController.text);
                },
                child: const Text(
                  "완료",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
