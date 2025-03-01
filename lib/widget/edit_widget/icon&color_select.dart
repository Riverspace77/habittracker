import 'package:flutter/material.dart';
import 'package:habitui/widget/edit_widget/bottom_sheet.dart';

/// 아이콘 & 색상 선택 BottomSheet
class IconColorPickerBottomSheet extends StatefulWidget {
  final Color initialColor;

  /// 화면 높이 비율 (default: 0.75)
  final double heightFactor;

  const IconColorPickerBottomSheet({
    super.key,
    required this.initialColor,
    this.heightFactor = 0.75,
  });

  @override
  _IconColorPickerBottomSheetState createState() =>
      _IconColorPickerBottomSheetState();
}

class _IconColorPickerBottomSheetState
    extends State<IconColorPickerBottomSheet> {
  late Color selectedColor;
  final List<Color> colorOptions = [
    Colors.orange[200]!,
    Colors.green[400]!,
    Colors.blue[400]!,
    Colors.purple[400]!,
    Colors.red[300]!,
    Colors.brown[600]!,
  ];

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: "아이콘 & 색상",
      heightFactor: widget.heightFactor,
      // X 버튼 클릭 시 선택된 색상을 반환
      onClose: () {
        Navigator.pop(context, selectedColor);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 색상 선택 옵션
            Wrap(
              spacing: 10,
              children: colorOptions.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: color,
                    radius: 20,
                    child: selectedColor == color
                        ? const Icon(Icons.check, color: Colors.black)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // 선택 완료 버튼
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, selectedColor);
                },
                child: const Text(
                  "선택 완료",
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
